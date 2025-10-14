//! Cross-platform keyboard layout detection utilities.
//!
//! This module provides platform-specific implementations for detecting the current
//! active keyboard layout on Windows and macOS systems.
//!
//! ## Layout Change Monitoring
//!
//! For applications that need to monitor keyboard layout changes, the following
//! system APIs can be used:
//!
//! ### Windows
//! - `WM_INPUTLANGCHANGE` window message: Sent when the input language changes
//! - `WM_INPUTLANGCHANGEREQUEST` window message: Sent before language change (can be prevented)
//! - Register window message handler and call `get_current_keyboard_layout()` on change
//!
//! ### macOS  
//! - `kTISNotifySelectedKeyboardInputSourceChanged` notification via Carbon
//! - Use `CFNotificationCenterAddObserver` to register for changes
//! - Notification callback can call `get_current_keyboard_layout()` to get new layout
//!
//! ## Usage Notes
//!
//! - Windows: Detection uses current thread's layout via `GetKeyboardLayout(0)`
//! - macOS: Detection differentiates between keyboard layouts and input methods (IMEs)
//! - Registry access on Windows requires appropriate permissions
//! - TIS APIs on macOS may return null in headless/sandbox environments

use serde::{Deserialize, Serialize};
use thiserror::Error;

#[cfg(target_os = "windows")]
use std::collections::HashMap;
#[cfg(target_os = "windows")]
use std::sync::Mutex;
#[cfg(target_os = "windows")]
use once_cell::sync::Lazy;

// Windows registry cache for keyboard layout information
#[cfg(target_os = "windows")]
static LAYOUT_CACHE: Lazy<Mutex<HashMap<String, (String, String)>>> = Lazy::new(|| {
    Mutex::new(HashMap::new())
});

/// Errors that can occur during keyboard layout detection
#[derive(Debug, Error)]
pub enum LayoutError {
    #[error("Failed to get current keyboard layout: {0}")]
    LayoutDetectionFailed(String),
    #[error("Registry access error: {0}")]
    RegistryError(String),
    #[error("Invalid layout data: {0}")]
    InvalidLayoutData(String),
    #[error("Platform API error: {0}")]
    PlatformApiError(String),
    #[error("Unsupported platform")]
    UnsupportedPlatform,
}

/// Type of keyboard input source
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum LayoutKind {
    /// Standard keyboard layout
    KeyboardLayout,
    /// Input method editor (IME) or input mode
    InputMethod,
    /// Unknown or unclassified
    Unknown,
}

/// Information about the current keyboard layout or input method
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct KeyboardLayoutInfo {
    /// Normalized layout identifier (e.g., "us-qwerty", "fr-azerty", "de-qwertz")
    pub layout_id: String,
    /// Human-readable layout name (e.g., "US QWERTY", "French AZERTY")
    pub layout_name: String,
    /// Detection method used
    pub detection_method: String,
    /// Raw system identifier for diagnostics
    /// - Windows: KLID (e.g., "00000409")
    /// - macOS: TIS InputSourceID (e.g., "com.apple.keylayout.US")
    pub raw_id: Option<String>,
    /// Type of input source
    pub kind: LayoutKind,
}

/// Detect the current active keyboard layout
pub fn get_current_keyboard_layout() -> Result<KeyboardLayoutInfo, LayoutError> {
    #[cfg(target_os = "windows")]
    {
        get_windows_keyboard_layout()
    }
    #[cfg(target_os = "macos")]
    {
        get_macos_keyboard_layout()
    }
    #[cfg(not(any(target_os = "windows", target_os = "macos")))]
    {
        Err(LayoutError::UnsupportedPlatform)
    }
}

#[cfg(target_os = "windows")]
fn get_windows_keyboard_layout() -> Result<KeyboardLayoutInfo, LayoutError> {
    use windows::Win32::UI::Input::KeyboardAndMouse::GetKeyboardLayoutNameW;

    // Get the KLID (Keyboard Layout Identifier) which uniquely identifies the layout
    let mut klid_buffer = [0u16; 9]; // KLID is 8 chars + null terminator

    let success = unsafe { GetKeyboardLayoutNameW(&mut klid_buffer) };
    if success.is_err() {
        return Err(LayoutError::PlatformApiError("GetKeyboardLayoutNameW failed".to_string()));
    }

    // Convert to String - find null terminator to avoid garbage
    let len = klid_buffer
        .iter()
        .position(|&c| c == 0)
        .unwrap_or(klid_buffer.len());
    let klid = String::from_utf16_lossy(&klid_buffer[..len]);

    // Try to get the real layout name from registry, fallback to KLID parsing
    let (layout_id, layout_name) =
        get_layout_info_from_registry(&klid).unwrap_or_else(|| parse_klid_fallback(&klid));

    // Infer the kind (IME vs keyboard layout) from the layout name
    let kind = infer_kind_from_name(&layout_name);

    Ok(KeyboardLayoutInfo {
        layout_id,
        layout_name,
        detection_method: "windows_klid_registry".to_string(),
        raw_id: Some(klid.clone()),
        kind,
    })
}

#[cfg(target_os = "windows")]
fn get_layout_info_from_registry(klid: &str) -> Option<(String, String)> {
    // Check cache first
    if let Ok(cache) = LAYOUT_CACHE.lock() {
        if let Some(cached_result) = cache.get(klid) {
            return Some(cached_result.clone());
        }
    }

    use windows::core::HSTRING;
    use windows::Win32::System::Registry::{
        RegCloseKey, RegOpenKeyExW, HKEY, HKEY_LOCAL_MACHINE, KEY_READ, KEY_WOW64_64KEY,
    };

    let registry_path = format!(
        "SYSTEM\\CurrentControlSet\\Control\\Keyboard Layouts\\{}",
        klid
    );
    let registry_path_wide = HSTRING::from(&registry_path);

    unsafe {
        let mut hkey = HKEY::default();
        let result = RegOpenKeyExW(
            HKEY_LOCAL_MACHINE,
            &registry_path_wide,
            0,
            KEY_READ | KEY_WOW64_64KEY, // Access 64-bit registry from 32-bit process
            &mut hkey,
        );

        if result.is_err() {
            return None;
        }

        // Try Layout Display Name first (modern), then Layout Text (legacy)
        let layout_name = read_registry_string_value(hkey, "Layout Display Name")
            .and_then(resolve_indirect_or_expand)
            .or_else(|| read_registry_string_value(hkey, "Layout Text"));

        let _ = RegCloseKey(hkey);

        if let Some(name) = layout_name {
            let layout_id = generate_layout_id_from_klid_and_name(klid, &name);
            let result = (layout_id, name);
            
            // Cache the result for future lookups
            if let Ok(mut cache) = LAYOUT_CACHE.lock() {
                cache.insert(klid.to_string(), result.clone());
            }
            
            return Some(result);
        }
    }

    None
}

#[cfg(target_os = "windows")]
fn read_registry_string_value(hkey: windows::Win32::System::Registry::HKEY, value_name: &str) -> Option<String> {
    use windows::core::HSTRING;
    use windows::Win32::System::Registry::{RegQueryValueExW, REG_SZ, REG_EXPAND_SZ, REG_VALUE_TYPE};

    unsafe {
        let value_name_wide = HSTRING::from(value_name);
        
        // First pass: get the required buffer size
        let mut buffer_size = 0u32;
        let mut reg_type = REG_VALUE_TYPE::default();
        
        let result = RegQueryValueExW(
            hkey,
            &value_name_wide,
            None,
            Some(&mut reg_type),
            None,
            Some(&mut buffer_size),
        );

        if result.is_err() || buffer_size == 0 {
            return None;
        }

        // Check if it's a string type
        if reg_type != REG_SZ && reg_type != REG_EXPAND_SZ {
            return None;
        }

        // Second pass: read the actual data
        let buffer_len = (buffer_size as usize + 1) / 2; // Convert bytes to u16, with safety margin
        let mut buffer = vec![0u16; buffer_len];
        
        let result = RegQueryValueExW(
            hkey,
            &value_name_wide,
            None,
            None,
            Some(buffer.as_mut_ptr() as *mut u8),
            Some(&mut buffer_size),
        );

        if result.is_ok() {
            let actual_len = (buffer_size as usize / 2).min(buffer.len());
            let len = buffer[..actual_len].iter().position(|&c| c == 0).unwrap_or(actual_len);
            
            if len > 0 {
                let value = String::from_utf16_lossy(&buffer[..len]);
                return Some(value);
            }
        }
    }

    None
}

#[cfg(target_os = "windows")]
static IME_KEYWORDS: &[&str] = &[
    "ime", "pinyin", "wubi", "zhuyin", "kana", "hangul", 
    "input method", "phonetic", "changjie", "quick", 
    "microsoft ime", "bopomofo", "jyutping"
];

#[cfg(target_os = "windows")]
fn infer_kind_from_name(name: &str) -> LayoutKind {
    let n = name.to_lowercase();
    
    if IME_KEYWORDS.iter().any(|keyword| n.contains(keyword)) {
        LayoutKind::InputMethod
    } else {
        LayoutKind::KeyboardLayout
    }
}

#[cfg(target_os = "windows")]
fn resolve_indirect_or_expand(s: String) -> Option<String> {
    if s.is_empty() {
        return None;
    }
    
    // Handle indirect strings (e.g., "@%SystemRoot%\system32\input.dll,-1234")
    if s.starts_with('@') {
        if let Some(mut resolved) = resolve_indirect_string(&s) {
            // Guard: SHLoadIndirectString might still return strings with %VARS%
            if resolved.contains('%') {
                if let Some(expanded) = expand_environment_variables(&resolved) {
                    resolved = expanded;
                }
            }
            return Some(resolved);
        }
    }
    
    // Expand environment variables (e.g., "%SystemRoot%\...")
    if s.contains('%') {
        if let Some(expanded) = expand_environment_variables(&s) {
            return Some(expanded);
        }
    }
    
    Some(s)
}

#[cfg(target_os = "windows")]
fn resolve_indirect_string(indirect: &str) -> Option<String> {
    use windows::core::HSTRING;
    use windows::Win32::UI::Shell::SHLoadIndirectString;
    
    let indirect_wide = HSTRING::from(indirect);
    let mut buffer = vec![0u16; 512]; // Reasonable buffer size for display names
    
    unsafe {
        let result = SHLoadIndirectString(
            &indirect_wide,
            &mut buffer,
            None,
        );
        
        if result.is_ok() {
            let len = buffer.iter().position(|&c| c == 0).unwrap_or(buffer.len());
            if len > 0 {
                return Some(String::from_utf16_lossy(&buffer[..len]));
            }
        }
    }
    
    None
}

#[cfg(target_os = "windows")]
fn expand_environment_variables(s: &str) -> Option<String> {
    use windows::core::HSTRING;
    use windows::Win32::System::Environment::ExpandEnvironmentStringsW;
    
    let source = HSTRING::from(s);
    
    unsafe {
        // First pass: get required buffer size
        let needed = ExpandEnvironmentStringsW(&source, None);
        if needed == 0 {
            return None;
        }
        
        // Second pass: expand the string
        let mut buffer = vec![0u16; needed as usize];
        let result = ExpandEnvironmentStringsW(
            &source,
            Some(&mut buffer),
        );
        
        if result != 0 {
            let len = buffer.iter().position(|&c| c == 0).unwrap_or(buffer.len());
            if len > 0 {
                return Some(String::from_utf16_lossy(&buffer[..len]));
            }
        }
    }
    
    None
}

#[cfg(target_os = "windows")]
fn generate_layout_id_from_klid_and_name(klid: &str, layout_name: &str) -> String {
    // Normalize common patterns
    let name_lower = layout_name.to_lowercase();

    // Extract language from KLID (last 4 digits)
    let lang_part = &klid[klid.len().saturating_sub(4)..];
    let lang_prefix = match lang_part {
        "0409" => "us",
        "040c" => "fr",
        "0407" => "de",
        "0410" => "it",
        "040a" => "es",
        "0413" => "nl",
        "0416" => "pt-br",
        "0816" => "pt",
        "0419" => "ru",
        "0411" => "ja",
        "0412" => "ko",
        "0804" => "zh-cn",
        "0404" => "zh-tw",
        "0809" => "gb",
        _ => "unknown",
    };

    // Identify layout type from name
    if name_lower.contains("dvorak") {
        if name_lower.contains("left") {
            format!("{}-dvorak-lh", lang_prefix)
        } else if name_lower.contains("right") {
            format!("{}-dvorak-rh", lang_prefix)
        } else {
            format!("{}-dvorak", lang_prefix)
        }
    } else if name_lower.contains("azerty") {
        format!("{}-azerty", lang_prefix)
    } else if name_lower.contains("qwertz") {
        format!("{}-qwertz", lang_prefix)
    } else if name_lower.contains("colemak") {
        format!("{}-colemak", lang_prefix)
    } else {
        // Default to qwerty for most layouts
        format!("{}-qwerty", lang_prefix)
    }
}

#[cfg(target_os = "windows")]
fn parse_klid_fallback(klid: &str) -> (String, String) {
    // KLID format: 8 hex digits like "00000409", "A0000409", etc.
    // First 4 digits = device identifier, last 4 = language/layout

    match klid {
        // US layouts
        "00000409" => ("us-qwerty".to_string(), "US QWERTY".to_string()),
        "A0000409" => ("us-dvorak".to_string(), "US Dvorak".to_string()),
        "00010409" => (
            "us-dvorak-lh".to_string(),
            "US Dvorak Left Hand".to_string(),
        ),
        "00020409" => (
            "us-dvorak-rh".to_string(),
            "US Dvorak Right Hand".to_string(),
        ),
        "00000809" => ("gb-qwerty".to_string(), "UK QWERTY".to_string()),

        // French layouts
        "0000040C" => ("fr-azerty".to_string(), "French AZERTY".to_string()),
        "00000C0C" => ("fr-ca".to_string(), "French Canadian".to_string()),
        "0000080C" => ("fr-be".to_string(), "French Belgian".to_string()),
        "0001080C" => (
            "fr-be-period".to_string(),
            "French Belgian (Period)".to_string(),
        ),

        // German layouts
        "00000407" => ("de-qwertz".to_string(), "German QWERTZ".to_string()),
        "00000807" => ("de-ch".to_string(), "Swiss German".to_string()),
        "00000C07" => ("de-at".to_string(), "Austrian German".to_string()),

        // Other common layouts
        "00000410" => ("it-qwerty".to_string(), "Italian QWERTY".to_string()),
        "0000040A" => ("es-qwerty".to_string(), "Spanish QWERTY".to_string()),
        "00000413" => ("nl-qwerty".to_string(), "Dutch QWERTY".to_string()),
        "00000416" => (
            "pt-br-qwerty".to_string(),
            "Portuguese Brazilian QWERTY".to_string(),
        ),
        "00000816" => ("pt-qwerty".to_string(), "Portuguese QWERTY".to_string()),
        "00000419" => ("ru-qwerty".to_string(), "Russian QWERTY".to_string()),
        "00000411" => ("ja-qwerty".to_string(), "Japanese QWERTY".to_string()),
        "00000412" => ("ko-qwerty".to_string(), "Korean QWERTY".to_string()),
        "00000804" => (
            "zh-cn-qwerty".to_string(),
            "Chinese Simplified QWERTY".to_string(),
        ),
        "00000404" => (
            "zh-tw-qwerty".to_string(),
            "Chinese Traditional QWERTY".to_string(),
        ),

        // Fallback: preserve KLID for unknown layouts
        _ => (
            format!("klid-{}", klid.to_lowercase()),
            format!("Windows Layout {}", klid),
        ),
    }
}

#[cfg(target_os = "macos")]
fn get_macos_keyboard_layout() -> Result<KeyboardLayoutInfo, LayoutError> {
    use core_foundation::base::TCFType;
    use core_foundation::string::{CFString, CFStringRef};

    extern "C" {
        fn TISCopyCurrentKeyboardInputSource() -> *const std::ffi::c_void;
        fn TISGetInputSourceProperty(inputSource: *const std::ffi::c_void, propertyKey: CFStringRef) -> *const std::ffi::c_void;
        static kTISPropertyInputSourceID: CFStringRef;
        static kTISPropertyLocalizedName: CFStringRef;
        static kTISPropertyInputSourceCategory: CFStringRef;
        static kTISCategoryKeyboardInputSource: CFStringRef;
    }

    unsafe {
        let input_source = TISCopyCurrentKeyboardInputSource();
        if input_source.is_null() {
            return Err(LayoutError::PlatformApiError("TISCopyCurrentKeyboardInputSource returned null".to_string()));
        }

        // Get the input source ID
        let id_key = CFString::wrap_under_get_rule(kTISPropertyInputSourceID);
        let id_ref = TISGetInputSourceProperty(input_source, id_key.as_concrete_TypeRef());
        
        // Get the localized name
        let name_key = CFString::wrap_under_get_rule(kTISPropertyLocalizedName);
        let name_ref = TISGetInputSourceProperty(input_source, name_key.as_concrete_TypeRef());

        // Get the category to determine if it's a keyboard layout or input method
        let category_key = CFString::wrap_under_get_rule(kTISPropertyInputSourceCategory);
        let category_ref = TISGetInputSourceProperty(input_source, category_key.as_concrete_TypeRef());

        let raw_id = if !id_ref.is_null() {
            let cf_string = CFString::wrap_under_get_rule(id_ref as CFStringRef);
            Some(cf_string.to_string())
        } else {
            None
        };

        let layout_name = if !name_ref.is_null() {
            let cf_string = CFString::wrap_under_get_rule(name_ref as CFStringRef);
            cf_string.to_string()
        } else {
            "Unknown Layout".to_string()
        };

        // Determine if this is a keyboard layout or input method
        let kind = if !category_ref.is_null() {
            let cf_string = CFString::wrap_under_get_rule(category_ref as CFStringRef);
            let category = cf_string.to_string();
            let keyboard_category = CFString::wrap_under_get_rule(kTISCategoryKeyboardInputSource).to_string();
            
            if category == keyboard_category {
                LayoutKind::KeyboardLayout
            } else {
                LayoutKind::InputMethod
            }
        } else {
            LayoutKind::Unknown
        };

        let layout_id = generate_layout_id_from_macos_source(&raw_id, &layout_name);

        Ok(KeyboardLayoutInfo {
            layout_id,
            layout_name,
            detection_method: "macos_tis_api".to_string(),
            raw_id,
            kind,
        })
    }
}

#[cfg(target_os = "macos")]
fn generate_layout_id_from_macos_source(source_id: &Option<String>, layout_name: &str) -> String {
    let name_lower = layout_name.to_lowercase();
    
    // Handle known source IDs
    if let Some(id) = source_id {
        match id.as_str() {
            "com.apple.keylayout.US" => return "us-qwerty".to_string(),
            "com.apple.keylayout.French" | "com.apple.keylayout.French-numerical" => return "fr-azerty".to_string(),
            "com.apple.keylayout.German" => return "de-qwertz".to_string(),
            "com.apple.keylayout.Spanish" => return "es-qwerty".to_string(),
            "com.apple.keylayout.Italian" => return "it-qwerty".to_string(),
            "com.apple.keylayout.Dutch" => return "nl-qwerty".to_string(),
            "com.apple.keylayout.Portuguese" => return "pt-qwerty".to_string(),
            "com.apple.keylayout.Russian" => return "ru-qwerty".to_string(),
            "com.apple.keylayout.British" => return "gb-qwerty".to_string(),
            "com.apple.keylayout.Dvorak" => return "us-dvorak".to_string(),
            "com.apple.keylayout.Dvorak-Left" => return "us-dvorak-lh".to_string(),
            "com.apple.keylayout.Dvorak-Right" => return "us-dvorak-rh".to_string(),
            "com.apple.keylayout.Colemak" => return "us-colemak".to_string(),
            "com.apple.keylayout.SwissGerman" => return "de-ch".to_string(),
            "com.apple.keylayout.SwissFrench" => return "fr-ch".to_string(),
            "com.apple.keylayout.Canadian" => return "en-ca".to_string(),
            "com.apple.keylayout.CanadianFrench" => return "fr-ca".to_string(),
            _ => {}
        }
        
        // Extract language from source ID if it contains language hints
        if id.contains("French") {
            return "fr-azerty".to_string();
        } else if id.contains("German") {
            return "de-qwertz".to_string();
        } else if id.contains("Spanish") {
            return "es-qwerty".to_string();
        } else if id.contains("Italian") {
            return "it-qwerty".to_string();
        } else if id.contains("Russian") {
            return "ru-qwerty".to_string();
        } else if id.contains("British") {
            return "gb-qwerty".to_string();
        }
    }
    
    // Fallback to name-based detection
    if name_lower.contains("french") || name_lower.contains("français") || name_lower.contains("azerty") {
        "fr-azerty".to_string()
    } else if name_lower.contains("german") || name_lower.contains("deutsch") || name_lower.contains("qwertz") {
        "de-qwertz".to_string()
    } else if name_lower.contains("spanish") || name_lower.contains("español") {
        "es-qwerty".to_string()
    } else if name_lower.contains("italian") || name_lower.contains("italiano") {
        "it-qwerty".to_string()
    } else if name_lower.contains("dutch") || name_lower.contains("nederlands") {
        "nl-qwerty".to_string()
    } else if name_lower.contains("portuguese") || name_lower.contains("português") {
        "pt-qwerty".to_string()
    } else if name_lower.contains("russian") || name_lower.contains("русский") {
        "ru-qwerty".to_string()
    } else if name_lower.contains("british") || name_lower.contains("uk") {
        "gb-qwerty".to_string()
    } else if name_lower.contains("dvorak") {
        if name_lower.contains("left") {
            "us-dvorak-lh".to_string()
        } else if name_lower.contains("right") {
            "us-dvorak-rh".to_string()
        } else {
            "us-dvorak".to_string()
        }
    } else if name_lower.contains("colemak") {
        "us-colemak".to_string()
    } else {
        // Default fallback
        "us-qwerty".to_string()
    }
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_keyboard_layout_detection() {
        // This test will only work on Windows or macOS
        #[cfg(any(target_os = "windows", target_os = "macos"))]
        {
            let result = get_current_keyboard_layout();
            assert!(result.is_ok(), "Should be able to detect keyboard layout");

            let layout_info = result.unwrap();
            assert!(
                !layout_info.layout_id.is_empty(),
                "Layout ID should not be empty"
            );
            assert!(
                !layout_info.layout_name.is_empty(),
                "Layout name should not be empty"
            );
            assert!(
                !layout_info.detection_method.is_empty(),
                "Detection method should not be empty"
            );

            println!(
                "Detected layout: {} ({})",
                layout_info.layout_name, layout_info.layout_id
            );
        }
    }
}
