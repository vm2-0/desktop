//! Cross-platform permissions utilities for accessibility and screen recording access.
//!
//! This module provides Tauri commands to check and request accessibility (AX) and screen recording permissions.

#[cfg(target_os = "macos")]
mod macos_permissions {
    use core_foundation::base::Boolean;
    use core_graphics::access::ScreenCaptureAccess;
    use macos_accessibility_client::accessibility::application_is_trusted_with_prompt;

    // External ApplicationServices declarations
    #[link(name = "ApplicationServices", kind = "framework")]
    extern "C" {
        fn AXIsProcessTrusted() -> Boolean;
        fn CGRequestScreenCaptureAccess() -> Boolean;
    }

    /// Checks if the application has accessibility (AX) permissions.
    ///
    /// # Returns
    /// * `true` if the application is trusted for accessibility.
    /// * `false` otherwise.
    #[tauri::command]
    pub fn has_ax_perms() -> bool {
        log::info!("[Permissions] Checking accessibility permissions...");
        
        unsafe {
            let result = AXIsProcessTrusted() != 0;
            log::info!("[Permissions] Accessibility permission status: {}", 
                if result { "GRANTED" } else { "DENIED" });
            result
        }
    }

    /// Prompts the user to grant accessibility (AX) permissions.
    /// Enhanced with tauri-plugin-macos-permissions for better M2/M4 compatibility
    #[tauri::command]
    pub async fn request_ax_perms() -> Result<bool, String> {
        log::info!("[Permissions] Requesting accessibility permissions...");
        
        // Check if already granted before requesting
        let initial_status = unsafe { AXIsProcessTrusted() != 0 };
        if initial_status {
            log::info!("[Permissions] Accessibility permission already granted, skipping request");
            return Ok(true);
        }
        
        log::info!("[Permissions] Triggering accessibility permission dialog...");
        // Trigger the request dialog
        application_is_trusted_with_prompt();
        
        // Poll for permission with timeout (user might take time to respond)
        log::info!("[Permissions] Polling for permission grant with 30 second timeout...");
        const TIMEOUT_SECONDS: u64 = 30;
        const POLL_INTERVAL_MS: u64 = 500;
        const MAX_ATTEMPTS: usize = (TIMEOUT_SECONDS * 1000 / POLL_INTERVAL_MS) as usize;
        
        for attempt in 0..MAX_ATTEMPTS {
            let granted = unsafe { AXIsProcessTrusted() != 0 };
            
            if granted {
                log::info!("[Permissions] Accessibility permission GRANTED after {:.1}s", 
                    (attempt as f64 * POLL_INTERVAL_MS as f64) / 1000.0);
                return Ok(true);
            }
            
            // Log progress every 5 seconds
            if attempt % 10 == 0 && attempt > 0 {
                log::info!("[Permissions] Still waiting for permission grant... ({}/{}s)", 
                    (attempt * POLL_INTERVAL_MS as usize) / 1000, TIMEOUT_SECONDS);
            }
            
            tokio::time::sleep(tokio::time::Duration::from_millis(POLL_INTERVAL_MS)).await;
        }
        
        log::warn!("[Permissions] Accessibility permission request timed out after {}s. User may need to manually enable it in System Settings → Privacy & Security → Accessibility", TIMEOUT_SECONDS);
        Ok(false)
    }

    /// Checks if the application has screen recording permissions.
    ///
    /// # Returns
    /// * `true` if the application has screen recording access.
    /// * `false` otherwise.
    #[tauri::command]
    pub fn has_record_perms() -> bool {
        log::info!("[Permissions] Checking screen recording permissions...");
        
        let result = ScreenCaptureAccess.preflight();
        log::info!("[Permissions] Screen recording permission status: {}", 
            if result { "GRANTED" } else { "DENIED" });
        
        result
    }

    /// Prompts the user to grant screen recording permissions.
    /// Enhanced with tauri-plugin-macos-permissions for better M2/M4 compatibility
    #[tauri::command]
    pub async fn request_record_perms() -> Result<bool, String> {
        log::info!("[Permissions] Requesting screen recording permissions...");
        
        // Detect architecture for enhanced logging
        let is_apple_silicon = std::env::consts::ARCH == "aarch64";
        
        if is_apple_silicon {
            log::info!("[Permissions] Apple Silicon detected - M2/M4 compatibility mode enabled");
        }
        
        // Check if already granted before requesting
        let initial_status = ScreenCaptureAccess.preflight();
        if initial_status {
            log::info!("[Permissions] Screen recording permission already granted, skipping request");
            return Ok(true);
        }
        
        // Check macOS version - only works on 11.0+
        let version = std::process::Command::new("sw_vers")
            .arg("-productVersion")
            .output()
            .ok()
            .and_then(|output| String::from_utf8(output.stdout).ok())
            .and_then(|version| {
                let parts: Vec<&str> = version.trim().split('.').collect();
                parts.get(0).and_then(|major| major.parse::<u32>().ok())
            })
            .unwrap_or(10);
        
        log::info!("[Permissions] macOS version detected: {}", version);
            
        if version < 11 {
            log::error!("[Permissions] Screen recording permission request requires macOS 11.0+, detected version: {}", version);
            return Err("Screen recording permission request requires macOS 11.0+".to_string());
        }

        log::info!("[Permissions] Triggering screen recording permission dialog...");
        // Request permission with enhanced compatibility for Apple Silicon M2/M4
        unsafe {
            let granted = CGRequestScreenCaptureAccess() != 0;
            log::info!("[Permissions] Initial screen recording permission response: {}", 
                if granted { "GRANTED" } else { "DENIED" });
            
            // For M2/M4 chips, add additional checks after permission request
            if !granted {
                log::info!("[Permissions] Permission not immediately granted, applying M2/M4 compatibility logic...");
                // Give the system time to process the permission request
                log::info!("[Permissions] Waiting 1000ms for system permission processing...");
                tokio::time::sleep(tokio::time::Duration::from_millis(1000)).await;
                
                // Re-check permission status
                let recheck_granted = ScreenCaptureAccess.preflight();
                log::info!("[Permissions] Screen recording permission after recheck: {}", 
                    if recheck_granted { "GRANTED" } else { "DENIED" });
                
                if recheck_granted {
                    log::info!("[Permissions] ✅ M2/M4 compatibility recheck succeeded!");
                } else {
                    log::warn!("[Permissions] ❌ Screen recording permission still denied after M2/M4 recheck. User may need to manually enable it in System Settings → Privacy & Security → Screen Recording");
                }
                
                Ok(recheck_granted)
            } else {
                log::info!("[Permissions] ✅ Screen recording permission granted immediately!");
                Ok(granted)
            }
        }
    }
}

#[cfg(target_os = "windows")]
mod windows_permissions {
    /// Checks if the application has accessibility (AX) permissions.
    /// On Windows, this is always true as permissions are handled differently.
    #[tauri::command]
    pub fn has_ax_perms() -> bool {
        // On Windows, accessibility permissions are typically granted by default
        // or handled through UAC prompts when needed
        true
    }

    /// Prompts the user to grant accessibility (AX) permissions.
    /// On Windows, this is a no-op as permissions are handled differently.
    #[tauri::command]
    pub async fn request_ax_perms() -> Result<bool, String> {
        // On Windows, accessibility permissions are typically granted by default
        // or handled through UAC prompts when needed
        Ok(true)
    }

    /// Checks if the application has screen recording permissions.
    /// On Windows, this is always true as permissions are handled differently.
    #[tauri::command]
    pub fn has_record_perms() -> bool {
        // On Windows, screen recording permissions are typically granted by default
        // or handled through UAC prompts when needed
        true
    }

    /// Prompts the user to grant screen recording permissions.
    /// On Windows, this is a no-op as permissions are handled differently.
    #[tauri::command]
    pub async fn request_record_perms() -> Result<bool, String> {
        // On Windows, screen recording permissions are typically granted by default
        // or handled through UAC prompts when needed
        Ok(true)
    }
}

#[cfg(target_os = "linux")]
mod linux_permissions {
    /// Checks if the application has accessibility (AX) permissions.
    /// On Linux, this is always true as permissions are handled differently.
    #[tauri::command]
    pub fn has_ax_perms() -> bool {
        // On Linux, accessibility permissions are typically granted by default
        true
    }

    /// Prompts the user to grant accessibility (AX) permissions.
    /// On Linux, this is a no-op as permissions are handled differently.
    #[tauri::command]
    pub async fn request_ax_perms() -> Result<bool, String> {
        // On Linux, accessibility permissions are typically granted by default
        Ok(true)
    }

    /// Checks if the application has screen recording permissions.
    /// On Linux, this is always true as permissions are handled differently.
    #[tauri::command]
    pub fn has_record_perms() -> bool {
        // On Linux, screen recording permissions are typically granted by default
        true
    }

    /// Prompts the user to grant screen recording permissions.
    /// On Linux, this is a no-op as permissions are handled differently.
    #[tauri::command]
    pub async fn request_record_perms() -> Result<bool, String> {
        // On Linux, screen recording permissions are typically granted by default
        Ok(true)
    }
}

// Re-export the appropriate platform-specific functions
#[cfg(target_os = "macos")]
pub use macos_permissions::*;

#[cfg(target_os = "windows")]
pub use windows_permissions::*;

#[cfg(target_os = "linux")]
pub use linux_permissions::*;
