//! Robust heartbeat monitoring for process lifecycle.
//!
//! Monitors a single shared heartbeat file. If Flutter stops writing,
//! all processes (agent, ffmpeg) auto-kill within 5 seconds.

use std::fs;
use std::path::PathBuf;
use std::sync::{
    atomic::{AtomicBool, Ordering},
    Arc,
};
use std::thread::{self, JoinHandle};
use std::time::Duration;
use tokio::time::interval;

const HEARTBEAT_FILE: &str = "clones-desktop-heartbeat";
const HEARTBEAT_TIMEOUT_SECS: u64 = 5;
const MONITOR_INTERVAL_SECS: u64 = 2; // Check every 2s for deterministic timing

/// Shared heartbeat checker with proper error handling
pub struct HeartbeatChecker;

impl HeartbeatChecker {
    pub fn new() -> Self {
        Self
    }

    /// Check if heartbeat file is fresh (< 5 seconds old)
    /// Uses system time with proper error handling for clock skew
    pub fn check_heartbeat(&self, path: &PathBuf) -> bool {
        match fs::read_to_string(path) {
            Ok(content) => {
                match content.trim().parse::<u64>() {
                    Ok(timestamp_ms) => {
                        // Get current time with fallback for clock issues
                        let now_ms = match std::time::SystemTime::now()
                            .duration_since(std::time::UNIX_EPOCH)
                        {
                            Ok(duration) => duration.as_millis() as u64,
                            Err(_) => {
                                log::warn!("[Heartbeat] System clock went backwards - assuming heartbeat failed");
                                return false;
                            }
                        };

                        // Handle both forward and backward time skew
                        let age_ms = if now_ms >= timestamp_ms {
                            now_ms - timestamp_ms
                        } else {
                            // Clock went backwards, file is "in the future"
                            log::warn!(
                                "[Heartbeat] Clock skew detected - file timestamp in future"
                            );
                            return false;
                        };

                        let age_secs = age_ms / 1000;

                        if age_secs > HEARTBEAT_TIMEOUT_SECS {
                            log::warn!("[Heartbeat] Heartbeat too old: {}s", age_secs);
                            false
                        } else {
                            log::debug!("[Heartbeat] Heartbeat OK (age: {}s)", age_secs);
                            true
                        }
                    }
                    Err(e) => {
                        log::warn!("[Heartbeat] Invalid timestamp format: {}", e);
                        false
                    }
                }
            }
            Err(_) => {
                log::warn!("[Heartbeat] Heartbeat file missing: {}", path.display());
                false
            }
        }
    }
}

/// Get the shared heartbeat file path with consistent logic
pub fn get_heartbeat_path() -> PathBuf {
    #[cfg(target_os = "windows")]
    {
        let temp_dir = std::env::var("TEMP")
            .or_else(|_| std::env::var("TMP"))
            .unwrap_or_else(|_| "C:\\temp".to_string());
        PathBuf::from(format!("{}\\{}", temp_dir, HEARTBEAT_FILE))
    }

    #[cfg(not(target_os = "windows"))]
    {
        PathBuf::from(format!("/tmp/{}", HEARTBEAT_FILE))
    }
}

/// Start monitoring the shared heartbeat file (Agent version)
pub async fn start_heartbeat_monitor(app: tauri::AppHandle) {
    let heartbeat_path = get_heartbeat_path();
    let checker = HeartbeatChecker::new();

    log::info!(
        "[Heartbeat] Starting agent heartbeat monitor at: {}",
        heartbeat_path.display()
    );

    let mut check_interval = interval(Duration::from_secs(MONITOR_INTERVAL_SECS));

    loop {
        check_interval.tick().await;

        if !checker.check_heartbeat(&heartbeat_path) {
            log::info!("[Heartbeat] Flutter heartbeat failed - force killing agent");

            // Force cleanup any active recording
            crate::core::record::force_kill_active_recorder(&app);

            // Force exit immediately
            std::process::exit(1);
        }
    }
}

/// Heartbeat monitor for threads with proper lifecycle management
pub struct ThreadHeartbeatMonitor {
    handle: Option<JoinHandle<()>>,
    should_stop: Arc<AtomicBool>,
}

impl ThreadHeartbeatMonitor {
    pub fn new(process_name: &str) -> Self {
        let heartbeat_path = get_heartbeat_path();
        let checker = HeartbeatChecker::new();
        let should_stop = Arc::new(AtomicBool::new(false));
        let should_stop_clone = should_stop.clone();
        let process_name = process_name.to_string();

        log::info!(
            "[Heartbeat] Starting {} heartbeat monitor at: {}",
            process_name,
            heartbeat_path.display()
        );

        let handle = thread::spawn(move || {
            while !should_stop_clone.load(Ordering::Relaxed) {
                thread::sleep(Duration::from_secs(MONITOR_INTERVAL_SECS));

                if !checker.check_heartbeat(&heartbeat_path) {
                    log::warn!(
                        "[Heartbeat] Flutter heartbeat failed - force killing {}",
                        process_name
                    );
                    std::process::exit(1);
                }
            }
            log::debug!("[Heartbeat] {} monitor thread stopping", process_name);
        });

        Self {
            handle: Some(handle),
            should_stop,
        }
    }

    pub fn stop(&mut self) {
        if let Some(handle) = self.handle.take() {
            self.should_stop.store(true, Ordering::Relaxed);
            if let Err(e) = handle.join() {
                log::warn!("[Heartbeat] Failed to join monitor thread: {:?}", e);
            }
        }
    }
}

impl Drop for ThreadHeartbeatMonitor {
    fn drop(&mut self) {
        self.stop();
    }
}
