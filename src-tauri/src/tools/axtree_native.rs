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
    //! Windows UI Automation implementation for accessibility tree extraction.
    //! 
    //! This module uses the Windows UI Automation (UIA) API to extract the accessibility
    //! tree of all visible applications and windows on the system. It provides similar
    //! functionality to the macOS implementation but uses Windows-specific APIs.
    //! 
    //! Key features:
    //! - Multi-monitor support with display index detection
    //! - Focused application detection with heuristic fallback
    //! - System app and screenshot tool filtering
    //! - Process name resolution for better app identification
    
    use super::*;
    use std::collections::HashMap;
    use ::windows::Win32::Foundation::{BOOL, HWND, LPARAM, RECT};
    use ::windows::Win32::Graphics::Gdi::{EnumDisplayMonitors, HDC, HMONITOR};
    use ::windows::Win32::UI::Accessibility::{
        CUIAutomation, IUIAutomation, IUIAutomationElement, UIA_PROPERTY_ID,
        UIA_IsOffscreenPropertyId, UIA_NamePropertyId,
    };
    use ::windows::Win32::UI::WindowsAndMessaging::{
        GetForegroundWindow, GetWindowRect, GetWindowTextW, GetWindowThreadProcessId,
        IsWindowVisible,
    };
    use ::windows::Win32::System::Com::{
        CoCreateInstance, CoInitializeEx, CoUninitialize, CLSCTX_ALL, COINIT_MULTITHREADED,
    };

    /// Monitor information structure
    #[derive(Clone)]
    struct MonitorInfo {
        index: usize,
        rect: RECT,
    }

    /// External callback for EnumDisplayMonitors
    unsafe extern "system" fn monitor_enum_proc(
        hmonitor: HMONITOR,
        _hdc: HDC,
        _lprect: *mut RECT,
        lparam: LPARAM,
    ) -> BOOL {
        let monitors = &mut *(lparam.0 as *mut Vec<MonitorInfo>);
        let mut info = ::windows::Win32::Graphics::Gdi::MONITORINFO {
            cbSize: std::mem::size_of::<::windows::Win32::Graphics::Gdi::MONITORINFO>() as u32,
            ..Default::default()
        };

        if ::windows::Win32::Graphics::Gdi::GetMonitorInfoW(hmonitor, &mut info).as_bool() {
            monitors.push(MonitorInfo {
                index: monitors.len(),
                rect: info.rcMonitor,
            });
        }
        BOOL::from(true)
    }

    /// Get all monitors
    unsafe fn get_monitors() -> Vec<MonitorInfo> {
        let mut monitors: Vec<MonitorInfo> = Vec::new();
        let monitors_ptr = &mut monitors as *mut Vec<MonitorInfo>;
        let _ = EnumDisplayMonitors(
            HDC::default(),
            None,
            Some(monitor_enum_proc),
            LPARAM(monitors_ptr as isize),
        );
        monitors
    }

    /// Determine which monitor contains the center of a rectangle
    fn get_display_index_for_rect(rect: &RECT, monitors: &[MonitorInfo]) -> usize {
        let center_x = (rect.left + rect.right) / 2;
        let center_y = (rect.top + rect.bottom) / 2;

        for monitor in monitors {
            if center_x >= monitor.rect.left
                && center_x < monitor.rect.right
                && center_y >= monitor.rect.top
                && center_y < monitor.rect.bottom
            {
                return monitor.index;
            }
        }
        0 // Default to first monitor
    }

    /// Get the name of a window by HWND
    unsafe fn get_window_title(hwnd: HWND) -> String {
        let mut buffer = [0u16; 512];
        let len = GetWindowTextW(hwnd, &mut buffer);
        if len > 0 {
            String::from_utf16_lossy(&buffer[..len as usize])
        } else {
            String::new()
        }
    }

    /// Get process name from PID
    unsafe fn get_process_name(pid: u32) -> String {
        use ::windows::Win32::System::Threading::{
            OpenProcess, QueryFullProcessImageNameW, PROCESS_NAME_WIN32,
            PROCESS_QUERY_LIMITED_INFORMATION,
        };

        let handle = match OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, false, pid) {
            Ok(h) => h,
            Err(_) => return String::new(),
        };

        let mut buffer = [0u16; 512];
        let mut size = buffer.len() as u32;
        let result = QueryFullProcessImageNameW(handle, PROCESS_NAME_WIN32, ::windows::core::PWSTR(buffer.as_mut_ptr()), &mut size);

        let _ = ::windows::Win32::Foundation::CloseHandle(handle);

        if result.is_ok() && size > 0 {
            let path = String::from_utf16_lossy(&buffer[..size as usize]);
            // Extract just the filename
            path.split('\\').last().unwrap_or("Unknown").to_string()
        } else {
            String::new()
        }
    }

    /// Check if an app name should be filtered out
    fn should_filter_app(name: &str) -> bool {
        let name_lower = name.to_lowercase();
        
        // System apps to filter
        let system_patterns = [
            "dwm.exe",
            "explorer.exe",
            "searchhost.exe",
            "startmenuexperiencehost.exe",
            "shellexperiencehost.exe",
            "textinputhost.exe",
            "applicationframehost.exe",
            "systemsettings.exe",
            "lockapp.exe",
            "clones",
            "clones_desktop",
            "clones-desktop",
        ];

        // Screenshot/capture apps
        let screenshot_patterns = [
            "snippingtool",
            "snip",
            "screenshot",
            "capture",
            "screencapture",
        ];

        system_patterns.iter().any(|p| name_lower.contains(p))
            || screenshot_patterns.iter().any(|p| name_lower.contains(p))
    }

    /// Get property value as string from UI Automation element
    unsafe fn get_element_string_property(
        element: &IUIAutomationElement,
        property_id: UIA_PROPERTY_ID,
    ) -> Option<String> {
        match element.GetCurrentPropertyValue(property_id) {
            Ok(variant) => {
                let bstr = variant.Anonymous.Anonymous.Anonymous.bstrVal.clone();
                Some(bstr.to_string())
            }
            Err(_) => None,
        }
    }

    /// Get property value as i32 from UI Automation element
    unsafe fn get_element_i32_property(
        element: &IUIAutomationElement,
        property_id: UIA_PROPERTY_ID,
    ) -> Option<i32> {
        match element.GetCurrentPropertyValue(property_id) {
            Ok(variant) => Some(variant.Anonymous.Anonymous.Anonymous.lVal),
            Err(_) => None,
        }
    }

    /// Get property value as bool from UI Automation element
    unsafe fn get_element_bool_property(
        element: &IUIAutomationElement,
        property_id: UIA_PROPERTY_ID,
    ) -> Option<bool> {
        match element.GetCurrentPropertyValue(property_id) {
            Ok(variant) => Some(variant.Anonymous.Anonymous.Anonymous.boolVal.as_bool()),
            Err(_) => None,
        }
    }

    /// Get bounding rectangle from UI Automation element
    unsafe fn get_element_rect(element: &IUIAutomationElement) -> Option<RECT> {
        // CurrentBoundingRectangle returns a RECT with left, top, right, bottom
        element.CurrentBoundingRectangle().ok()
    }

    /// Extract window data from a UI Automation element
    unsafe fn extract_window_from_element(
        element: &IUIAutomationElement,
        monitors: &[MonitorInfo],
        display_filter: Option<u32>,
    ) -> Option<Value> {
        // Get bounding rectangle
        let rect = get_element_rect(element)?;

        // Filter tiny windows
        let width = rect.right - rect.left;
        let height = rect.bottom - rect.top;
        if width < 100 || height < 100 {
            return None;
        }

        // Check if offscreen
        if let Some(true) = get_element_bool_property(element, UIA_IsOffscreenPropertyId) {
            return None;
        }

        let display_index = get_display_index_for_rect(&rect, monitors);

        // Filter by display if specified
        if let Some(filter) = display_filter {
            if display_index as u32 != filter {
                return None;
            }
        }

        let name = get_element_string_property(element, UIA_NamePropertyId)
            .unwrap_or_else(|| format!("Window on display {}", display_index));

        Some(json!({
            "name": name,
            "role": "window",
            "description": format!("Display {}", display_index),
            "value": "",
            "bbox": {
                "x": rect.left,
                "y": rect.top,
                "width": width,
                "height": height
            },
            "display_index": display_index,
            "children": []
        }))
    }

    /// Get focused application info
    unsafe fn get_focused_app_info() -> Option<Value> {
        let hwnd = GetForegroundWindow();
        if hwnd.0 == 0 {
            return None;
        }

        if !IsWindowVisible(hwnd).as_bool() {
            return None;
        }

        let title = get_window_title(hwnd);
        let mut pid: u32 = 0;
        GetWindowThreadProcessId(hwnd, Some(&mut pid));
        let process_name = get_process_name(pid);

        // Filter out our own app and system apps
        if should_filter_app(&process_name) || should_filter_app(&title) {
            info!("[AxTree Native] Skipping focused app: {} ({})", title, process_name);
            
            // Try heuristic fallback
            return get_focused_app_via_heuristics();
        }

        info!("[AxTree Native] Detected focused app: {} ({})", title, process_name);

        Some(json!({
            "name": if title.is_empty() { process_name } else { title },
            "bundle_id": null,
            "path": null,
            "pid": pid
        }))
    }

    /// Fallback heuristic to find focused app by enumerating visible windows
    unsafe fn get_focused_app_via_heuristics() -> Option<Value> {
        use ::windows::Win32::UI::WindowsAndMessaging::{
            EnumWindows, GetWindow, GW_OWNER,
        };

        struct EnumData {
            best_window: HWND,
            best_area: i32,
        }

        unsafe extern "system" fn enum_windows_proc(hwnd: HWND, lparam: LPARAM) -> BOOL {
            let data = &mut *(lparam.0 as *mut EnumData);

            if !IsWindowVisible(hwnd).as_bool() {
                return BOOL::from(true);
            }

            // Skip windows with owners (likely dialogs/popups)
            if GetWindow(hwnd, GW_OWNER).0 != 0 {
                return BOOL::from(true);
            }

            let mut rect = RECT::default();
            if GetWindowRect(hwnd, &mut rect).is_err() {
                return BOOL::from(true);
            }

            let width = rect.right - rect.left;
            let height = rect.bottom - rect.top;

            // Skip tiny windows
            if width < 200 || height < 200 {
                return BOOL::from(true);
            }

            let mut pid: u32 = 0;
            GetWindowThreadProcessId(hwnd, Some(&mut pid));
            let process_name = get_process_name(pid);

            // Skip system apps
            if should_filter_app(&process_name) {
                return BOOL::from(true);
            }

            // Find the largest window
            let area = width * height;
            if area > data.best_area {
                data.best_area = area;
                data.best_window = hwnd;
            }

            BOOL::from(true)
        }

        let mut data = EnumData {
            best_window: HWND(0),
            best_area: 0,
        };

        let data_ptr = &mut data as *mut EnumData;
        let _ = EnumWindows(Some(enum_windows_proc), LPARAM(data_ptr as isize));

        if data.best_window.0 != 0 {
            let title = get_window_title(data.best_window);
            let mut pid: u32 = 0;
            GetWindowThreadProcessId(data.best_window, Some(&mut pid));
            let process_name = get_process_name(pid);

            info!(
                "[AxTree Native] ✅ Heuristic detected focused app: {} ({})",
                title, process_name
            );

            Some(json!({
                "name": if title.is_empty() { process_name } else { title },
                "bundle_id": null,
                "path": null,
                "pid": pid
            }))
        } else {
            None
        }
    }

    /// Main extraction function
    pub fn extract_accessibility_tree(display_index: Option<u32>) -> Result<Value, String> {
        println!(
            "[DEBUG NATIVE WINDOWS] extract_accessibility_tree(display_index={:?})",
            display_index
        );
        info!("[AxTree Native] Starting native Windows UI Automation extraction");

        unsafe {
            // Initialize COM
            if let Err(e) = CoInitializeEx(None, COINIT_MULTITHREADED) {
                // S_FALSE means already initialized, which is OK
                if e.code().0 != 0x00000001 {
                    return Err(format!("Failed to initialize COM: {:?}", e));
                }
            }

            let start_time = std::time::Instant::now();

            // Create UI Automation instance
            let automation: IUIAutomation = match CoCreateInstance(&CUIAutomation, None, CLSCTX_ALL)
            {
                Ok(a) => a,
                Err(e) => {
                    CoUninitialize();
                    return Err(format!("Failed to create UI Automation instance: {:?}", e));
                }
            };

            // Get monitors
            let monitors = get_monitors();
            info!("[AxTree Native] Found {} monitors", monitors.len());

            // Get focused app
            let focused_app = get_focused_app_info();

            // Collect all applications and their windows using direct window enumeration
            use ::windows::Win32::UI::WindowsAndMessaging::{EnumWindows, GetWindow, GW_OWNER};
            
            struct EnumWindowsData {
                apps_map: HashMap<String, Vec<Value>>,
                monitors: Vec<MonitorInfo>,
                display_filter: Option<u32>,
            }

            unsafe extern "system" fn enum_windows_for_tree(hwnd: HWND, lparam: LPARAM) -> BOOL {
                let data = &mut *(lparam.0 as *mut EnumWindowsData);

                if !IsWindowVisible(hwnd).as_bool() {
                    return BOOL::from(true);
                }

                // Skip windows with owners (dialogs/popups)
                if GetWindow(hwnd, GW_OWNER).0 != 0 {
                    return BOOL::from(true);
                }

                // Get window rect to filter tiny windows
                let mut rect = RECT::default();
                if GetWindowRect(hwnd, &mut rect).is_err() {
                    return BOOL::from(true);
                }

                let width = rect.right - rect.left;
                let height = rect.bottom - rect.top;

                if width < 100 || height < 100 {
                    return BOOL::from(true);
                }

                // Get process info
                let mut pid: u32 = 0;
                GetWindowThreadProcessId(hwnd, Some(&mut pid));
                let process_name = get_process_name(pid);
                let window_title = get_window_title(hwnd);

                // Filter system apps
                if should_filter_app(&process_name) || should_filter_app(&window_title) {
                    return BOOL::from(true);
                }

                // Get display index
                let display_index = get_display_index_for_rect(&rect, &data.monitors);

                // Filter by display if specified
                if let Some(filter) = data.display_filter {
                    if display_index as u32 != filter {
                        return BOOL::from(true);
                    }
                }

                // Create window data
                let window_name = if !window_title.is_empty() {
                    window_title
                } else {
                    format!("Window on display {}", display_index)
                };

                let window_data = json!({
                    "name": window_name,
                    "role": "window",
                    "description": format!("Display {}", display_index),
                    "value": "",
                    "bbox": {
                        "x": rect.left,
                        "y": rect.top,
                        "width": width,
                        "height": height
                    },
                    "display_index": display_index,
                    "children": []
                });

                // Group by process name
                let app_name = if !process_name.is_empty() {
                    process_name
                } else {
                    "Unknown".to_string()
                };

                data.apps_map
                    .entry(app_name)
                    .or_default()
                    .push(window_data);

                BOOL::from(true)
            }

            let mut enum_data = EnumWindowsData {
                apps_map: HashMap::new(),
                monitors: monitors.clone(),
                display_filter: display_index,
            };

            let data_ptr = &mut enum_data as *mut EnumWindowsData;
            let _ = EnumWindows(Some(enum_windows_for_tree), LPARAM(data_ptr as isize));

            let apps_map = enum_data.apps_map;
            
            // We don't need the automation object anymore, release it
            drop(automation);

            // Build final tree
            let mut tree = Vec::new();
            for (app_name, windows) in apps_map {
                if !windows.is_empty() {
                    tree.push(json!({
                        "name": app_name,
                        "role": "application",
                        "description": display_index.map(|d| format!("Display {}", d)).unwrap_or_default(),
                        "value": "",
                        "bbox": {"x": 0, "y": 0, "width": 0, "height": 0},
                        "children": windows
                    }));
                }
            }

            CoUninitialize();

            let duration = start_time.elapsed().as_millis();
            info!(
                "[AxTree Native] Completed in {}ms via UI Automation, {} apps",
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
