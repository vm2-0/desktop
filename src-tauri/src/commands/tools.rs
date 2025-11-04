//! Tauri commands for initializing and checking external tool binaries (FFmpeg, Clones Quality Agent).
//!
//! This module provides commands to initialize required binaries in parallel and check their status.
//! AXTree functionality uses local Python scripts and doesn't require initialization.

use crate::tools::ffmpeg;
use crate::tools::helpers::lock_with_timeout;
use log::error;
use once_cell::sync::Lazy;
use serde::{Deserialize, Serialize};
use serde_json;
use std::sync::{Arc, Mutex};
use std::thread;
use tauri::Emitter;

/// Tool initialization progress state
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ToolInitProgress {
    pub status: String,
    pub message: String,
    pub progress: i32,
}

impl Default for ToolInitProgress {
    fn default() -> Self {
        Self {
            status: "idle".to_string(),
            message: "Tools not initialized".to_string(),
            progress: 0,
        }
    }
}

/// Global state for tool initialization progress
pub static TOOL_INIT_PROGRESS: Lazy<Arc<Mutex<ToolInitProgress>>> =
    Lazy::new(|| Arc::new(Mutex::new(ToolInitProgress::default())));

/// Helper function to update progress state
fn update_progress(status: &str, message: &str, progress: i32) {
    if let Ok(mut state) = TOOL_INIT_PROGRESS.lock() {
        state.status = status.to_string();
        state.message = message.to_string();
        state.progress = progress;
        log::debug!("[Tool Progress] {} - {} ({}%)", status, message, progress);
    } else {
        log::error!("[Tool Progress] Failed to acquire lock to update progress");
    }
}

/// Initializes all required tool binaries (FFmpeg, Clones Quality Agent) in parallel threads.
///
/// # Arguments
/// * `app` - The Tauri `AppHandle` for emitting errors to the frontend.
///
/// # Returns
/// * `Ok(())` if all tools were initialized (errors are emitted as events).
#[tauri::command]
pub async fn init_tools(app: tauri::AppHandle) -> Result<(), String> {
    log::info!("[Init Tools] Starting tool initialization");

    // Check if tools are already initialized
    if ffmpeg::FFMPEG_PATH.get().is_some() && ffmpeg::FFPROBE_PATH.get().is_some() {
        log::info!("[Init Tools] All tools already initialized, updating state");
        update_progress("completed", "All tools ready", 100);
        return Ok(());
    }

    // Start initialization in background and return immediately
    let app_clone = app.clone();
    tokio::spawn(async move {
        init_tools_background(app_clone).await;
    });

    log::info!("[Init Tools] Background initialization started");
    Ok(())
}

async fn init_tools_background(app: tauri::AppHandle) {
    // Create a vector to store thread handles
    let mut handles = Vec::new();

    // Create shared error storage
    let errors = Arc::new(Mutex::new(Vec::new()));

    // Update progress state - starting
    update_progress("starting", "Initializing tools...", 0);

    // Spawn thread for FFmpeg initialization
    if ffmpeg::FFMPEG_PATH.get().is_none() || ffmpeg::FFPROBE_PATH.get().is_none() {
        let errors = Arc::clone(&errors);
        let handle = thread::spawn(move || {
            log::info!("[Init Tools] Initializing FFmpeg/FFprobe");

            // Update progress state - downloading
            update_progress("downloading", "Downloading FFmpeg binaries...", 25);

            if let Err(e) = ffmpeg::init_ffmpeg_and_ffprobe() {
                let lock = lock_with_timeout(&errors, std::time::Duration::from_secs(2));
                if let Some(mut errors) = lock {
                    errors.push(format!("Failed to initialize FFmpeg/FFprobe: {}", e));
                } else {
                    log::error!("[Init Tools] Could not acquire error lock for FFmpeg/FFprobe");
                }

                // Update progress state - error
                let error_msg = format!("Failed to download FFmpeg: {}", e);
                update_progress("error", &error_msg, 0);
            } else {
                log::info!("[Init Tools] FFmpeg/FFprobe initialized successfully");

                // Update progress state - completed
                update_progress("completed", "FFmpeg binaries ready", 100);
            }
        });
        handles.push(handle);
    } else {
        // Tools already initialized
        update_progress("completed", "All tools ready", 100);
    }

    // Wait for all threads to complete with timeout
    log::info!(
        "[Init Tools] Waiting for {} initialization threads",
        handles.len()
    );
    for (i, handle) in handles.into_iter().enumerate() {
        match handle.join() {
            Ok(_) => log::info!("[Init Tools] Thread {} completed successfully", i),
            Err(e) => {
                log::error!("[Init Tools] Thread {} panicked: {:?}", i, e);
                error!("Thread panicked: {:?}", e);
            }
        }
    }

    // Check if there were any errors
    let errors = match lock_with_timeout(&errors, std::time::Duration::from_secs(2)) {
        Some(errors) => errors,
        None => {
            log::error!("[Init Tools] Could not acquire error lock for final check");
            return;
        }
    };
    if !errors.is_empty() {
        for err in errors.iter() {
            log::error!("[Init Tools] Error: {}", err);
        }
        let _ = app.emit(
            "init_tools_errors",
            serde_json::json!({
                "errors": errors.to_vec()
            }),
        );
    } else {
        log::info!("[Init Tools] Tool initialization completed successfully");
    }
}

/// Checks the initialization status of all required tool binaries.
///
/// # Returns
/// * `Ok(serde_json::Value)` with a map of tool names to their status (true/false).
#[tauri::command]
pub async fn check_tools() -> Result<serde_json::Value, String> {
    // Return the status of each tool
    Ok(serde_json::json!({
        "ffmpeg": ffmpeg::FFMPEG_PATH.get().is_some(),
        "ffprobe": ffmpeg::FFPROBE_PATH.get().is_some()
    }))
}

/// Gets the current tool initialization progress.
///
/// # Returns
/// * `Ok(ToolInitProgress)` with the current progress state.
#[tauri::command]
pub async fn get_tool_init_progress() -> Result<ToolInitProgress, String> {
    // Check if tools are already initialized and update state if needed
    if ffmpeg::FFMPEG_PATH.get().is_some() && ffmpeg::FFPROBE_PATH.get().is_some() {
        update_progress("completed", "All tools ready", 100);
    }
    
    TOOL_INIT_PROGRESS
        .lock()
        .map(|state| state.clone())
        .map_err(|e| format!("Failed to get tool init progress: {}", e))
}
