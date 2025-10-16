use log::info;
use serde_json::{json, Value};

#[cfg(target_os = "macos")]
mod macos {
    use super::*;
    use core_foundation::array::{CFArray, CFArrayRef};
    use core_foundation::base::{Boolean, CFRelease, TCFType};
    use core_foundation::dictionary::{CFDictionary, CFDictionaryRef};
    use core_foundation::number::CFNumber;
    use core_foundation::string::{CFString, CFStringRef};
    use core_graphics::display::{CGPoint, CGRect, CGSize};
    use core_graphics::window::{kCGNullWindowID, kCGWindowListOptionOnScreenOnly};
    use std::collections::HashMap;
    use std::ffi::c_void;
    // removed unused: std::mem

    // ----- AX / CG externs -----
    #[repr(C)]
    struct __AXUIElement(c_void);
    type AXUIElementRef = *const __AXUIElement;

    #[repr(C)]
    struct __AXValue(c_void);
    type AXValueRef = *const __AXValue;

    type AXError = i32;
    type AXValueType = i32;
    type CGError = i32;
    type CGDirectDisplayID = u32;

    const K_AX_ERROR_SUCCESS: AXError = 0;
    const K_AX_VALUE_CGPOINT: AXValueType = 1;
    const K_AX_VALUE_CGSIZE: AXValueType = 2;

    #[link(name = "ApplicationServices", kind = "framework")]
    extern "C" {
        fn AXUIElementCreateSystemWide() -> AXUIElementRef;
        fn AXUIElementCopyAttributeValue(
            element: AXUIElementRef,
            attribute: CFStringRef,
            value_out: *mut *const c_void,
        ) -> AXError;
        // removed unused: AXUIElementCopyAttributeNames
        fn AXValueGetValue(
            value: AXValueRef,
            value_type: AXValueType,
            value_ptr: *mut c_void,
        ) -> bool;
        fn AXIsProcessTrusted() -> Boolean;
        // removed unused: AXIsProcessTrustedWithOptions
    }

    #[link(name = "CoreGraphics", kind = "framework")]
    extern "C" {
        fn CGWindowListCopyWindowInfo(option: u32, relative_to_window: u32) -> *const c_void; // CFArrayRef
        fn CGGetOnlineDisplayList(
            max_displays: u32,
            active_displays: *mut CGDirectDisplayID,
            display_count: *mut u32,
        ) -> CGError;
        fn CGDisplayBounds(display_id: CGDirectDisplayID) -> CGRect;
    }

    #[link(name = "CoreFoundation", kind = "framework")]
    extern "C" {
        fn CFDictionaryGetValue(dict: *const c_void, key: *const c_void) -> *const c_void;
    }

    // CGWindow dictionary keys (from CGWindow.h)
    const K_CG_WINDOW_OWNER_NAME: &str = "kCGWindowOwnerName";
    const K_CG_WINDOW_BOUNDS: &str = "kCGWindowBounds";

    // AX attribute constants
    const K_AX_CHILDREN: &str = "AXChildren";
    const K_AX_TITLE: &str = "AXTitle";
    // removed unused: K_AX_ROLE
    const K_AX_POSITION: &str = "AXPosition";
    const K_AX_SIZE: &str = "AXSize";
    // removed unused: K_AX_VALUE
    // removed unused: K_AX_DESCRIPTION
    const K_AX_WINDOWS: &str = "AXWindows";
    const K_AX_FOCUSED_APP: &str = "AXFocusedApplication";

    // -------- Public entrypoint --------
    pub fn extract_accessibility_tree(display_index: Option<u32>) -> Result<Value, String> {
        println!(
            "[DEBUG NATIVE MACOS] extract_accessibility_tree(display_index={:?})",
            display_index
        );
        info!("[AxTree Native] Starting native macOS accessibility extraction");

        unsafe {
            if AXIsProcessTrusted() == 0 {
                return Err("Process not trusted for accessibility. Grant permissions in System Settings → Privacy & Security → Accessibility."
                    .to_string());
            }
        }

        let start_time = std::time::Instant::now();

        unsafe {
            let system_element = AXUIElementCreateSystemWide();
            if system_element.is_null() {
                return Err("Failed to create system-wide AX element".to_string());
            }

            let focused_app = get_focused_app_info(system_element);

            // Get all applications via AX (preferred)
            let mut apps_value: *const c_void = std::ptr::null();
            let ax_err = AXUIElementCopyAttributeValue(
                system_element,
                CFString::new(K_AX_CHILDREN).as_concrete_TypeRef(),
                &mut apps_value,
            );

            // Fallback to CGWindowList if AXChildren isn't available
            if ax_err != K_AX_ERROR_SUCCESS || apps_value.is_null() {
                CFRelease(system_element as *const c_void);
                let tree = extract_via_cgwindowlist(display_index);

                if tree.is_empty() {
                    return Err("No windows found via CGWindowList".to_string());
                }
                let duration = start_time.elapsed().as_millis();
                info!(
                    "[AxTree Native] Completed in {}ms with CGWindowList fallback, {} apps",
                    duration,
                    tree.len()
                );
                return Ok(json!({
                    "time": chrono::Local::now().timestamp_millis(),
                    "data": {
                        "duration": duration,
                        "tree": tree,
                        "focused_app": focused_app
                    }
                }));
            }

            // NOTE: Do NOT release `apps_value` until we've finished iterating its items.
            let apps_array: CFArray = CFArray::wrap_under_get_rule(apps_value as CFArrayRef);

            let mut tree = Vec::new();
            for i in 0..apps_array.len() {
                if let Some(item_ptr) = apps_array.get(i) {
                    if item_ptr.is_null() {
                        continue;
                    }
                    let app_ref = *item_ptr as AXUIElementRef;
                    if let Some(app_data) = extract_app_data(app_ref, display_index) {
                        tree.push(app_data);
                    }
                }
            }

            // Now safe to release the array and the system element
            CFRelease(apps_value);
            CFRelease(system_element as *const c_void);

            let duration = start_time.elapsed().as_millis();
            info!(
                "[AxTree Native] Completed in {}ms via AX, {} apps",
                duration,
                tree.len()
            );

            Ok(json!({
                "time": chrono::Local::now().timestamp_millis(),
                "data": {
                    "duration": duration,
                    "tree": tree,
                    "focused_app": focused_app
                }
            }))
        }
    }

    // -------- Focused app (best-effort with fallback) --------
    unsafe fn get_focused_app_info(system_element: AXUIElementRef) -> Option<Value> {
        // First, try the native API
        let mut focused_app_value: *const c_void = std::ptr::null();
        let err = AXUIElementCopyAttributeValue(
            system_element,
            CFString::new(K_AX_FOCUSED_APP).as_concrete_TypeRef(),
            &mut focused_app_value,
        );
        
        if err == K_AX_ERROR_SUCCESS && !focused_app_value.is_null() {
            // Native API succeeded
            let title = get_string_attribute(focused_app_value as AXUIElementRef, K_AX_TITLE);
            CFRelease(focused_app_value);
            return Some(json!({
                "name": title.unwrap_or_else(|| "Focused Application".to_string()),
                "bundle_id": null,
                "path": null,
                "pid": null
            }));
        }

        // Native API failed - use heuristic fallback
        info!("[AxTree Native] Native focused app API failed, using heuristic fallback");
        get_focused_app_via_heuristics()
    }

    // -------- Heuristic focus detection fallback --------
    unsafe fn get_focused_app_via_heuristics() -> Option<Value> {
        // Use CGWindowList to find the frontmost window
        let window_list = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
        if window_list.is_null() {
            return None;
        }

        let windows_array: CFArray = CFArray::wrap_under_get_rule(window_list as CFArrayRef);
        
        // System apps to exclude (language-independent patterns)
        let system_app_patterns = [
            "Window Server", "Dock", "Spotlight", "SystemUIServer", 
            "ControlCenter", "NotificationCenter", "clones", 
            "clones_desktop", "clones-desktop",
        ];
        
        // Screenshot app patterns (language-independent detection)
        let screenshot_patterns = [
            "capture", "screenshot", "screen shot", "screencapture",
            "écran", "pantalla", "schermo", "画面", "스크린", "экран"
        ];

        // Look for the first valid app window (frontmost in the list)
        info!("[AxTree Native] Scanning {} windows for focused app", windows_array.len());
        
        for i in 0..windows_array.len() {
            if let Some(item_ptr) = windows_array.get(i) {
                if item_ptr.is_null() {
                    continue;
                }
                let window_dict = *item_ptr as CFDictionaryRef;
                let dict: CFDictionary<*const c_void, *const c_void> =
                    CFDictionary::wrap_under_get_rule(window_dict);

                let app_name = get_dict_string_value(
                    dict.as_concrete_TypeRef() as *const c_void,
                    K_CG_WINDOW_OWNER_NAME,
                ).unwrap_or_else(|| "Unknown".to_string());

                info!("[AxTree Native] Window {}: app='{}', checking validity", i, app_name);

                if app_name.is_empty() {
                    info!("[AxTree Native] Skipping empty app name");
                    continue;
                }

                // Check against system app patterns
                let app_lower = app_name.to_lowercase();
                let is_system_app = system_app_patterns.iter().any(|pattern| {
                    app_lower.contains(&pattern.to_lowercase())
                });
                
                // Check against screenshot app patterns
                let is_screenshot_app = screenshot_patterns.iter().any(|pattern| {
                    app_lower.contains(&pattern.to_lowercase())
                });

                if is_system_app {
                    info!("[AxTree Native] Skipping '{}' - system app", app_name);
                    continue;
                }

                if is_screenshot_app {
                    info!("[AxTree Native] Skipping '{}' - screenshot app", app_name);
                    continue;
                }

                // Valid user app found
                {
                    // Get window bounds to verify it's a substantial window
                    let bounds_ptr = CFDictionaryGetValue(
                        dict.as_concrete_TypeRef() as *const c_void,
                        CFString::new(K_CG_WINDOW_BOUNDS).as_concrete_TypeRef() as *const c_void,
                    );
                    
                    if !bounds_ptr.is_null() {
                        let bounds_dict: CFDictionary<*const c_void, *const c_void> =
                            CFDictionary::wrap_under_get_rule(bounds_ptr as CFDictionaryRef);
                        
                        let w = get_number_from_dict(bounds_dict.as_concrete_TypeRef() as *const c_void, "Width").unwrap_or(0);
                        let h = get_number_from_dict(bounds_dict.as_concrete_TypeRef() as *const c_void, "Height").unwrap_or(0);
                        
                        // Only consider substantial windows (not tiny ones)
                        info!("[AxTree Native] Window '{}' size: {}x{}", app_name, w, h);
                        if w >= 200 && h >= 200 {
                            CFRelease(window_list);
                            info!("[AxTree Native] ✅ Heuristic detected focused app: '{}' ({}x{})", app_name, w, h);
                            return Some(json!({
                                "name": app_name,
                                "bundle_id": null,
                                "path": null,
                                "pid": null
                            }));
                        } else {
                            info!("[AxTree Native] ❌ Window '{}' too small ({}x{}), skipping", app_name, w, h);
                        }
                    }
                }
            }
        }

        CFRelease(window_list);
        None
    }

    // -------- App / Window extraction via AX --------
    unsafe fn extract_app_data(
        app_element: AXUIElementRef,
        display_filter: Option<u32>,
    ) -> Option<Value> {
        // App name (may be empty)
        let app_name = get_string_attribute(app_element, K_AX_TITLE).unwrap_or_default();

        // Filter out known system-ish apps using language-independent patterns
        let system_app_patterns = [
            "Window Server", "Dock", "Spotlight", "SystemUIServer",
            "ControlCenter", "NotificationCenter", "clones", 
            "clones_desktop", "clones-desktop",
        ];
        
        let screenshot_patterns = [
            "capture", "screenshot", "screen shot", "screencapture",
            "écran", "pantalla", "schermo", "画面", "스크린", "экран"
        ];

        let app_lower = app_name.to_lowercase();
        
        // Check for system apps
        let is_system_app = system_app_patterns.iter().any(|pattern| {
            app_lower.contains(&pattern.to_lowercase())
        });
        
        // Check for screenshot apps
        let is_screenshot_app = screenshot_patterns.iter().any(|pattern| {
            app_lower.contains(&pattern.to_lowercase())
        });

        if is_system_app || is_screenshot_app {
            return None;
        }

        // Fetch windows array
        let mut windows_value: *const c_void = std::ptr::null();
        let win_err = AXUIElementCopyAttributeValue(
            app_element,
            CFString::new(K_AX_WINDOWS).as_concrete_TypeRef(),
            &mut windows_value,
        );
        if win_err != K_AX_ERROR_SUCCESS || windows_value.is_null() {
            return None;
        }

        let windows_array: CFArray = CFArray::wrap_under_get_rule(windows_value as CFArrayRef);

        let displays = get_online_displays();
        let mut window_children = Vec::new();

        for i in 0..windows_array.len() {
            if let Some(item_ptr) = windows_array.get(i) {
                if item_ptr.is_null() {
                    continue;
                }
                let window_ref = *item_ptr as AXUIElementRef;
                if let Some(window_data) =
                    extract_window_data(window_ref, display_filter, &displays)
                {
                    window_children.push(window_data);
                }
            }
        }

        // It's now safe to release the windows array
        CFRelease(windows_value);

        if window_children.is_empty() {
            return None;
        }

        Some(json!({
            "name": if app_name.is_empty() { "Application".to_string() } else { app_name },
            "role": "application",
            "description": display_filter.map(|d| format!("Display {d}")).unwrap_or_default(),
            "value": "",
            "bbox": {"x": 0, "y": 0, "width": 0, "height": 0},
            "children": window_children
        }))
    }

    unsafe fn extract_window_data(
        window_element: AXUIElementRef,
        display_filter: Option<u32>,
        displays: &[(usize, CGRect)],
    ) -> Option<Value> {
        let position = get_position_attribute(window_element)?;
        let size = get_size_attribute(window_element)?;

        // Filter tiny windows
        if size.width < 100.0 || size.height < 100.0 {
            return None;
        }

        let (x, y, w, h) = (
            position.x as f64,
            position.y as f64,
            size.width as f64,
            size.height as f64,
        );
        let display_index = display_index_for_rect(x, y, w, h, displays).unwrap_or(0);

        if let Some(filter) = display_filter {
            if display_index as u32 != filter {
                return None;
            }
        }

        Some(json!({
            "name": format!("Window on display {}", display_index),
            "role": "window",
            "description": format!("Display {}", display_index),
            "value": "",
            "bbox": {
                "x": x as i64, "y": y as i64, "width": w as i64, "height": h as i64
            },
            "display_index": display_index,
            "children": []
        }))
    }

    // -------- CGWindowList fallback (now with real bounds) --------
    unsafe fn extract_via_cgwindowlist(display_filter: Option<u32>) -> Vec<Value> {
        println!("[DEBUG NATIVE MACOS] Using CGWindowListCopyWindowInfo");
        let window_list =
            CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
        if window_list.is_null() {
            println!("[DEBUG NATIVE MACOS] CGWindowListCopyWindowInfo returned null");
            return Vec::new();
        }

        // Keep the CFArray alive during iteration; release after.
        let windows_array: CFArray = CFArray::wrap_under_get_rule(window_list as CFArrayRef);

        let displays = get_online_displays();
        let mut apps_map: HashMap<String, Vec<Value>> = HashMap::new();

        let system_app_patterns = [
            "Window Server", "Dock", "Spotlight", "SystemUIServer",
            "ControlCenter", "NotificationCenter", "clones", 
            "clones_desktop", "clones-desktop",
        ];
        
        let screenshot_patterns = [
            "capture", "screenshot", "screen shot", "screencapture",
            "écran", "pantalla", "schermo", "画面", "스크린", "экран"
        ];

        for i in 0..windows_array.len() {
            // Each item is a CFDictionaryRef describing a window
            let Some(item_ptr) = windows_array.get(i) else {
                continue;
            };
            if item_ptr.is_null() {
                continue;
            }
            let window_dict = *item_ptr as CFDictionaryRef;
            let dict: CFDictionary<*const c_void, *const c_void> =
                CFDictionary::wrap_under_get_rule(window_dict);

            // Owner / app name
            let app_name = get_dict_string_value(
                dict.as_concrete_TypeRef() as *const c_void,
                K_CG_WINDOW_OWNER_NAME,
            )
            .unwrap_or_else(|| "Unknown".to_string());
            
            // Language-independent filtering
            let app_lower = app_name.to_lowercase();
            let is_system_app = system_app_patterns.iter().any(|pattern| {
                app_lower.contains(&pattern.to_lowercase())
            });
            let is_screenshot_app = screenshot_patterns.iter().any(|pattern| {
                app_lower.contains(&pattern.to_lowercase())
            });
            
            if is_system_app || is_screenshot_app {
                continue;
            }

            // Bounds dictionary
            let bounds_ptr = CFDictionaryGetValue(
                dict.as_concrete_TypeRef() as *const c_void,
                CFString::new(K_CG_WINDOW_BOUNDS).as_concrete_TypeRef() as *const c_void,
            );
            if bounds_ptr.is_null() {
                continue;
            }
            let bounds_dict: CFDictionary<*const c_void, *const c_void> =
                CFDictionary::wrap_under_get_rule(bounds_ptr as CFDictionaryRef);

            // Extract X/Y/Width/Height as numbers
            let x = get_number_from_dict(bounds_dict.as_concrete_TypeRef() as *const c_void, "X")
                .unwrap_or(0) as i64;
            let y = get_number_from_dict(bounds_dict.as_concrete_TypeRef() as *const c_void, "Y")
                .unwrap_or(0) as i64;
            let w =
                get_number_from_dict(bounds_dict.as_concrete_TypeRef() as *const c_void, "Width")
                    .unwrap_or(0) as i64;
            let h =
                get_number_from_dict(bounds_dict.as_concrete_TypeRef() as *const c_void, "Height")
                    .unwrap_or(0) as i64;

            if w < 100 || h < 100 {
                continue;
            }

            let disp_idx =
                display_index_for_rect(x as f64, y as f64, w as f64, h as f64, &displays)
                    .unwrap_or(0);

            if let Some(filter) = display_filter {
                if disp_idx as u32 != filter {
                    continue;
                }
            }

            let window_data = json!({
                "name": format!("Window on display {}", disp_idx),
                "role": "window",
                "description": format!("Display {}", disp_idx),
                "value": "",
                "bbox": {"x": x, "y": y, "width": w, "height": h},
                "display_index": disp_idx,
                "children": []
            });

            apps_map.entry(app_name).or_default().push(window_data);
        }

        // Now it's safe to release the windows list array
        CFRelease(window_list);

        // Build final tree
        let mut tree = Vec::new();
        for (app_name, windows) in apps_map {
            tree.push(json!({
                "name": app_name,
                "role": "application",
                "description": display_filter.map(|d| format!("Display {d}")).unwrap_or_default(),
                "value": "",
                "bbox": {"x": 0, "y": 0, "width": 0, "height": 0},
                "children": windows
            }));
        }
        tree
    }

    // -------- Helpers: AX attributes --------
    unsafe fn get_string_attribute(element: AXUIElementRef, attribute: &str) -> Option<String> {
        let mut value: *const c_void = std::ptr::null();
        let err = AXUIElementCopyAttributeValue(
            element,
            CFString::new(attribute).as_concrete_TypeRef(),
            &mut value,
        );
        if err != K_AX_ERROR_SUCCESS || value.is_null() {
            return None;
        }
        // "Copy" rule → we own it; wrap_under_create_rule arranges CFRelease on drop
        let cf_string = CFString::wrap_under_create_rule(value as CFStringRef);
        Some(cf_string.to_string())
    }

    unsafe fn get_position_attribute(element: AXUIElementRef) -> Option<CGPoint> {
        let mut value: *const c_void = std::ptr::null();
        let err = AXUIElementCopyAttributeValue(
            element,
            CFString::new(K_AX_POSITION).as_concrete_TypeRef(),
            &mut value,
        );
        if err != K_AX_ERROR_SUCCESS || value.is_null() {
            return None;
        }
        let mut point = CGPoint::new(0.0, 0.0);
        let ok = AXValueGetValue(
            value as AXValueRef,
            K_AX_VALUE_CGPOINT,
            &mut point as *mut _ as *mut c_void,
        );
        CFRelease(value);
        if ok {
            Some(point)
        } else {
            None
        }
    }

    unsafe fn get_size_attribute(element: AXUIElementRef) -> Option<CGSize> {
        let mut value: *const c_void = std::ptr::null();
        let err = AXUIElementCopyAttributeValue(
            element,
            CFString::new(K_AX_SIZE).as_concrete_TypeRef(),
            &mut value,
        );
        if err != K_AX_ERROR_SUCCESS || value.is_null() {
            return None;
        }
        let mut size = CGSize::new(0.0, 0.0);
        let ok = AXValueGetValue(
            value as AXValueRef,
            K_AX_VALUE_CGSIZE,
            &mut size as *mut _ as *mut c_void,
        );
        CFRelease(value);
        if ok {
            Some(size)
        } else {
            None
        }
    }

    // -------- Helpers: CFDictionary / numbers / strings --------
    unsafe fn get_dict_string_value(dict: *const c_void, key: &str) -> Option<String> {
        let key_cf = CFString::new(key);
        let value_ptr = CFDictionaryGetValue(dict, key_cf.as_concrete_TypeRef() as *const c_void);
        if value_ptr.is_null() {
            return None;
        }
        let cf_string = CFString::wrap_under_get_rule(value_ptr as CFStringRef);
        Some(cf_string.to_string())
    }

    unsafe fn get_number_from_dict(dict: *const c_void, key: &str) -> Option<i64> {
        let key_cf = CFString::new(key);
        let value_ptr = CFDictionaryGetValue(dict, key_cf.as_concrete_TypeRef() as *const c_void);
        if value_ptr.is_null() {
            return None;
        }
        let number = CFNumber::wrap_under_get_rule(value_ptr as *const _);
        number.to_i64()
    }

    // -------- Displays & geometry --------
    fn get_online_displays() -> Vec<(usize, CGRect)> {
        unsafe {
            // First, get count
            let mut count: u32 = 0;
            let _ = CGGetOnlineDisplayList(0, std::ptr::null_mut(), &mut count);
            if count == 0 {
                return vec![];
            }

            let mut ids: Vec<CGDirectDisplayID> = vec![0; count as usize];
            let _ = CGGetOnlineDisplayList(count, ids.as_mut_ptr(), &mut count);

            let mut out = Vec::with_capacity(count as usize);
            for (i, id) in ids.iter().enumerate() {
                let rect = CGDisplayBounds(*id);
                out.push((i, rect));
            }
            out
        }
    }

    fn display_index_for_rect(
        x: f64,
        y: f64,
        w: f64,
        h: f64,
        displays: &[(usize, CGRect)],
    ) -> Option<usize> {
        let cx = x + w / 2.0;
        let cy = y + h / 2.0;
        for (idx, rect) in displays {
            if point_in_rect(cx, cy, rect) {
                return Some(*idx);
            }
        }
        None
    }

    fn point_in_rect(px: f64, py: f64, r: &CGRect) -> bool {
        let min_x = r.origin.x as f64;
        let min_y = r.origin.y as f64;
        let max_x = min_x + r.size.width as f64;
        let max_y = min_y + r.size.height as f64;
        px >= min_x && px < max_x && py >= min_y && py < max_y
    }
}

#[cfg(target_os = "windows")]
mod windows {
    use super::*;
    pub fn extract_accessibility_tree(_display_index: Option<u32>) -> Result<Value, String> {
        info!("[AxTree Native] Starting native Windows UI Automation extraction");
        Err("Windows native extraction not yet implemented".to_string())
    }
}

/// Extract accessibility tree using native APIs
pub fn extract_native_tree(display_index: Option<u32>) -> Result<Value, String> {
    println!(
        "[DEBUG NATIVE] extract_native_tree called with display_index: {:?}",
        display_index
    );

    #[cfg(target_os = "macos")]
    {
        return macos::extract_accessibility_tree(display_index);
    }

    #[cfg(target_os = "windows")]
    {
        return windows::extract_accessibility_tree(display_index);
    }

    #[cfg(not(any(target_os = "macos", target_os = "windows")))]
    {
        Err("Platform not supported".to_string())
    }
}
