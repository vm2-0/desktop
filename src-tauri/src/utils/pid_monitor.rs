//! OS-level process monitoring for robust parent process death detection.
//!
//! This module provides native OS mechanisms to detect when the parent process
//! dies, offering much faster and more reliable detection than file-based heartbeats.

use std::time::Duration;

#[cfg(target_os = "macos")]
use nix::sys::event::{EventFilter, EventFlag, KEvent, FilterFlag, Kqueue};

/// Start monitoring the parent process using OS-level mechanisms
pub async fn start_parent_process_monitor(parent_pid: u32, app: tauri::AppHandle) {
    log::info!("[PID Monitor] Starting OS-level parent process monitor for PID: {}", parent_pid);
    
    #[cfg(target_os = "macos")]
    {
        monitor_parent_macos(parent_pid, app).await;
    }
    
    #[cfg(target_os = "windows")]
    {
        monitor_parent_windows(parent_pid, app).await;
    }
    
    #[cfg(target_os = "linux")]
    {
        monitor_parent_linux(parent_pid, app).await;
    }
    
    #[cfg(not(any(target_os = "macos", target_os = "windows", target_os = "linux")))]
    {
        log::warn!("[PID Monitor] Unsupported platform - falling back to polling");
        monitor_parent_fallback(parent_pid, app).await;
    }
}

/// macOS implementation using kqueue EVFILT_PROC
#[cfg(target_os = "macos")]
async fn monitor_parent_macos(parent_pid: u32, app: tauri::AppHandle) {
    tauri::async_runtime::spawn_blocking(move || {
        match Kqueue::new() {
            Ok(kq) => {
                log::info!("[PID Monitor] Created kqueue for parent PID: {}", parent_pid);
                
                // Phase 1: Register event to monitor process exit
                let event = KEvent::new(
                    parent_pid as usize,  // Process ID to monitor
                    EventFilter::EVFILT_PROC,  // Process events
                    EventFlag::EV_ADD | EventFlag::EV_ONESHOT,  // Add event, fire once
                    FilterFlag::NOTE_EXIT,  // Monitor process exit
                    0,
                    0
                );
                
                // Register the event (no wait)
                match kq.kevent(&[event], &mut [], None) {
                    Ok(_) => {
                        log::info!("[PID Monitor] Successfully registered kqueue for PID {}", parent_pid);
                        
                        // Phase 2: Block waiting for events
                        let mut events = [KEvent::new(0, EventFilter::EVFILT_PROC, EventFlag::empty(), FilterFlag::empty(), 0, 0)];
                        
                        loop {
                            match kq.kevent(&[], &mut events, None) {
                                Ok(n) if n > 0 => {
                                    log::info!("[PID Monitor] Parent process {} exited - shutting down agent", parent_pid);
                                    
                                    // Cleanup any active recording
                                    crate::core::record::force_kill_active_recorder(&app);
                                    
                                    // Force exit immediately
                                    std::process::exit(0);
                                }
                                Ok(_) => {
                                    // No events, continue waiting
                                    continue;
                                }
                                Err(e) => {
                                    log::error!("[PID Monitor] kevent wait failed: {} - falling back to polling", e);
                                    tokio_fallback_monitor(parent_pid, app);
                                    break;
                                }
                            }
                        }
                    }
                    Err(e) => {
                        log::error!("[PID Monitor] kevent registration failed: {} - falling back to polling", e);
                        tokio_fallback_monitor(parent_pid, app);
                    }
                }
            }
            Err(e) => {
                log::error!("[PID Monitor] Failed to create kqueue: {} - falling back to polling", e);
                tokio_fallback_monitor(parent_pid, app);
            }
        }
    });
}

/// Windows implementation using Job Objects or process handles
#[cfg(target_os = "windows")]
async fn monitor_parent_windows(parent_pid: u32, app: tauri::AppHandle) {
    // For now, use polling - can be enhanced with Job Objects later
    log::info!("[PID Monitor] Windows process monitoring - using polling for now");
    monitor_parent_fallback(parent_pid, app).await;
}

/// Linux implementation using pidfd or /proc monitoring
#[cfg(target_os = "linux")]
async fn monitor_parent_linux(parent_pid: u32, app: tauri::AppHandle) {
    // For now, use polling - can be enhanced with pidfd later
    log::info!("[PID Monitor] Linux process monitoring - using polling for now");
    monitor_parent_fallback(parent_pid, app).await;
}

/// Fallback polling implementation for unsupported platforms
async fn monitor_parent_fallback(parent_pid: u32, app: tauri::AppHandle) {
    tauri::async_runtime::spawn_blocking(move || {
        loop {
            std::thread::sleep(Duration::from_secs(1));
            
            if !check_process_exists(parent_pid) {
                log::info!("[PID Monitor] Parent process {} no longer exists - shutting down agent", parent_pid);
                
                // Cleanup any active recording
                crate::core::record::force_kill_active_recorder(&app);
                
                // Force exit
                std::process::exit(0);
            }
        }
    });
}

/// Thread-based fallback for when blocking kqueue fails
fn tokio_fallback_monitor(parent_pid: u32, app: tauri::AppHandle) {
    tauri::async_runtime::spawn_blocking(move || {
        loop {
            std::thread::sleep(Duration::from_secs(1));
            
            if !check_process_exists(parent_pid) {
                log::info!("[PID Monitor] Parent process {} no longer exists (fallback) - shutting down agent", parent_pid);
                
                // Cleanup any active recording
                crate::core::record::force_kill_active_recorder(&app);
                
                // Force exit
                std::process::exit(0);
            }
        }
    });
}

/// Cross-platform process existence check
fn check_process_exists(pid: u32) -> bool {
    #[cfg(target_os = "macos")]
    {
        use std::process::Command;
        match Command::new("kill")
            .args(["-0", &pid.to_string()])
            .output() {
            Ok(output) => {
                let exists = output.status.success();
                log::debug!("[PID Monitor] Process {} exists: {}", pid, exists);
                exists
            }
            Err(e) => {
                log::warn!("[PID Monitor] Error checking process {}: {}", pid, e);
                false
            }
        }
    }
    
    #[cfg(target_os = "windows")]
    {
        use windows::Win32::Foundation::{CloseHandle, BOOL};
        use windows::Win32::System::Threading::{GetExitCodeProcess, OpenProcess, PROCESS_QUERY_LIMITED_INFORMATION};

        // SAFETY: We only request query access and immediately close the handle.
        let handle = unsafe { OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, BOOL(0), pid) };
        let handle = match handle {
            Ok(h) => h,
            Err(e) => {
                log::debug!("[PID Monitor] OpenProcess failed for PID {}: {}", pid, e);
                return false;
            }
        };

        let mut exit_code: u32 = 0;
        let result = unsafe { GetExitCodeProcess(handle, &mut exit_code as *mut u32) };
        // Close handle regardless of GetExitCodeProcess result
        unsafe { CloseHandle(handle) };

        if let Err(e) = result {
            log::warn!("[PID Monitor] GetExitCodeProcess failed for PID {}: {}", pid, e);
            return false;
        }

        // STILL_ACTIVE == 259
        let still_active = exit_code == 259;
        log::debug!(
            "[PID Monitor] Process {} exists: {} (exit_code={})",
            pid,
            still_active,
            exit_code
        );
        still_active
    }
    
    #[cfg(target_os = "linux")]
    {
        let exists = std::fs::metadata(format!("/proc/{}", pid)).is_ok();
        log::debug!("[PID Monitor] Process {} exists: {}", pid, exists);
        exists
    }
}