//! Heartbeat file management for process lifecycle monitoring.
//!
//! This module monitors Flutter's heartbeat file. If Flutter stops writing
//! its heartbeat (because it died or was closed), the agent detects this
//! and shuts down gracefully.

use std::fs;
use std::path::PathBuf;
use std::time::{Duration, SystemTime};
use tokio::time::{interval, sleep};


/// Get the Flutter heartbeat file path that we should monitor
pub fn get_flutter_heartbeat_path(flutter_pid: u32) -> PathBuf {
    #[cfg(target_os = "windows")]
    {
        let temp_dir = std::env::temp_dir();
        temp_dir.join(format!("clones-flutter-{}.heartbeat", flutter_pid))
    }
    
    #[cfg(not(target_os = "windows"))]
    {
        PathBuf::from(format!("/tmp/clones-flutter-{}.heartbeat", flutter_pid))
    }
}

/// Start monitoring Flutter's heartbeat file
pub async fn start_flutter_heartbeat_monitor(flutter_pid: u32, app: tauri::AppHandle) {
    let flutter_heartbeat_path = get_flutter_heartbeat_path(flutter_pid);
    
    log::info!("[Heartbeat] Starting Flutter heartbeat monitor at: {}", flutter_heartbeat_path.display());

    tauri::async_runtime::spawn(async move {
        let mut check_interval = interval(Duration::from_secs(2));
        
        // Wait a bit for Flutter to create its heartbeat file
        sleep(Duration::from_secs(3)).await;
        
        loop {
            check_interval.tick().await;
            
            if !check_flutter_heartbeat(&flutter_heartbeat_path) {
                log::info!("[Heartbeat] Flutter heartbeat failed - shutting down agent");
                
                // Cleanup any active recording
                crate::core::record::force_kill_active_recorder(&app);
                
                // Force exit - guaranteed kill
                std::process::exit(0);
            }
        }
    });
}


/// Check if Flutter's heartbeat file exists and is recent
fn check_flutter_heartbeat(path: &PathBuf) -> bool {
    match fs::metadata(path) {
        Ok(metadata) => {
            match metadata.modified() {
                Ok(modified_time) => {
                    let now = SystemTime::now();
                    match now.duration_since(modified_time) {
                        Ok(age) => {
                            // Consider Flutter dead if heartbeat is older than 5 seconds
                            if age.as_secs() > 5 {
                                log::warn!("[Heartbeat] Flutter heartbeat too old: {:?}", age);
                                false
                            } else {
                                log::debug!("[Heartbeat] Flutter heartbeat OK (age: {:?})", age);
                                true
                            }
                        }
                        Err(e) => {
                            log::warn!("[Heartbeat] Time calculation error: {}", e);
                            false
                        }
                    }
                }
                Err(e) => {
                    log::warn!("[Heartbeat] Cannot get heartbeat file modification time: {}", e);
                    false
                }
            }
        }
        Err(_) => {
            log::warn!("[Heartbeat] Flutter heartbeat file missing: {}", path.display());
            false
        }
    }
}

/// Auto-detect Flutter PID and start monitoring
pub async fn auto_detect_and_monitor_flutter(app: tauri::AppHandle) {
    // Try to detect Flutter process by looking for common patterns
    // For now, we'll use a simple approach - check for environment variables or parent process
    
    if let Ok(ppid_str) = std::env::var("FLUTTER_PARENT_PID") {
        if let Ok(flutter_pid) = ppid_str.parse::<u32>() {
            log::info!("[Heartbeat] Using Flutter PID from environment: {}", flutter_pid);
            start_flutter_heartbeat_monitor(flutter_pid, app).await;
            return;
        }
    }
    
    // Fallback: try to detect Flutter by process hierarchy
    log::info!("[Heartbeat] No Flutter PID provided, looking for heartbeat files in /tmp");
    
    // Look for any flutter heartbeat files
    tauri::async_runtime::spawn(async move {
        let mut check_interval = interval(Duration::from_secs(5));
        
        loop {
            check_interval.tick().await;
            
            // Scan for flutter heartbeat files
            let mut found_active_flutter = false;
            if let Ok(entries) = fs::read_dir("/tmp") {
                for entry in entries.flatten() {
                    if let Some(filename) = entry.file_name().to_str() {
                        if filename.starts_with("clones-flutter-") && filename.ends_with(".heartbeat") {
                            let path = entry.path();
                            if check_flutter_heartbeat(&path) {
                                log::debug!("[Heartbeat] Found active Flutter heartbeat: {}", path.display());
                                found_active_flutter = true;
                                break; // Found one active, that's enough
                            } else {
                                log::warn!("[Heartbeat] Found stale Flutter heartbeat: {}", path.display());
                            }
                        }
                    }
                }
            }
            
            // If no active Flutter heartbeat found, we are orphaned
            if !found_active_flutter {
                log::warn!("[Heartbeat] No active Flutter heartbeat detected - agent is orphaned, shutting down");
                
                // Cleanup any active recording
                crate::core::record::force_kill_active_recorder(&app);
                
                // Force exit - guaranteed kill
                std::process::exit(0);
            }
        }
    });
}