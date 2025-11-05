//! Simple heartbeat file monitoring for Flutter lifecycle.
//!
//! This module provides a simple function to check if Flutter's heartbeat
//! file exists and has been updated recently.

use std::fs;
use std::path::PathBuf;
use std::time::SystemTime;

// Constants for heartbeat monitoring configuration
const HEARTBEAT_MAX_AGE_SECONDS: u64 = 5;
#[cfg(target_os = "windows")]
const WINDOWS_TEMP_FALLBACK: &str = r"C:\\Windows\\Temp";

/// Clean up old heartbeat files from previous sessions
/// This prevents the agent from reading stale heartbeat data
pub fn cleanup_old_heartbeat_files(heartbeat_path: &PathBuf) {
    // Remove old heartbeat file if it exists
    if heartbeat_path.exists() {
        match fs::remove_file(heartbeat_path) {
            Ok(_) => log::info!(
                "[Heartbeat] Cleaned up old heartbeat file: {}",
                heartbeat_path.display()
            ),
            Err(e) => log::warn!(
                "[Heartbeat] Failed to remove old heartbeat file: {}",
                e
            ),
        }
    }

    // Remove old ready signal file if it exists
    let ready_path = PathBuf::from(format!("{}.ready", heartbeat_path.display()));
    if ready_path.exists() {
        match fs::remove_file(&ready_path) {
            Ok(_) => log::info!(
                "[Heartbeat] Cleaned up old ready signal file: {}",
                ready_path.display()
            ),
            Err(e) => log::warn!(
                "[Heartbeat] Failed to remove old ready signal file: {}",
                e
            ),
        }
    }
}

/// Get the Flutter heartbeat file path using EXACT same logic as Flutter
/// This must be kept in sync with heartbeat_writer.dart _getHeartbeatPath()
pub fn get_flutter_heartbeat_path_stable() -> PathBuf {
    // Check if Flutter provided a specific heartbeat path
    if let Ok(heartbeat_path) = std::env::var("FLUTTER_HEARTBEAT_PATH") {
        log::info!(
            "[Heartbeat] Using Flutter-provided heartbeat path: {}",
            heartbeat_path
        );
        return PathBuf::from(heartbeat_path);
    }

    #[cfg(target_os = "windows")]
    {
        // EXACT same logic as Flutter: TEMP -> TMP -> fallback
        let temp_dir = std::env::var("TEMP")
            .or_else(|_| std::env::var("TMP"))
            .unwrap_or_else(|_| WINDOWS_TEMP_FALLBACK.to_string());
        PathBuf::from(format!(r"{}\clones-flutter.heartbeat", temp_dir))
    }

    #[cfg(not(target_os = "windows"))]
    {
        // EXACT same logic as Flutter: check /tmp exists, fallback to system temp
        let tmp_dir = std::path::Path::new("/tmp");
        let temp_dir = if tmp_dir.exists() {
            "/tmp".to_string()
        } else {
            std::env::temp_dir().to_string_lossy().to_string()
        };
        PathBuf::from(format!("{}/clones-flutter.heartbeat", temp_dir))
    }
}

/// Check if Flutter has written its ready signal
pub fn check_flutter_ready_signal(heartbeat_path: &PathBuf) -> bool {
    let ready_path = PathBuf::from(format!("{}.ready", heartbeat_path.display()));
    ready_path.exists()
}

/// Check if Flutter's heartbeat file exists and is recent (within 5 seconds)
pub fn check_flutter_heartbeat_simple(heartbeat_path: &PathBuf) -> bool {
    match fs::metadata(heartbeat_path) {
        Ok(metadata) => match metadata.modified() {
            Ok(modified_time) => {
                let now = SystemTime::now();
                match now.duration_since(modified_time) {
                    Ok(age) => {
                        let age_seconds = age.as_secs();
                        if age_seconds > HEARTBEAT_MAX_AGE_SECONDS {
                            log::warn!(
                                "[Heartbeat] Flutter heartbeat too old: {}s (max: {}s)",
                                age_seconds,
                                HEARTBEAT_MAX_AGE_SECONDS
                            );
                            false
                        } else {
                            log::debug!("[Heartbeat] Flutter heartbeat OK (age: {}s)", age_seconds);
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
                log::warn!(
                    "[Heartbeat] Cannot get heartbeat file modification time: {}",
                    e
                );
                false
            }
        },
        Err(_) => {
            log::debug!(
                "[Heartbeat] Flutter heartbeat file missing: {}",
                heartbeat_path.display()
            );
            false
        }
    }
}
