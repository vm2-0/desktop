//! Tauri commands for initializing and checking external tool binaries (FFmpeg, Clones Quality Agent).
//!
//! This module provides commands to initialize required binaries in parallel and check their status.
//! AXTree functionality uses local Python scripts and doesn't require initialization.

use crate::tools::helpers::lock_with_timeout;
use crate::tools::ffmpeg;
use log::error;
use serde_json;
use std::sync::{Arc, Mutex};
use std::thread;
use tauri::Emitter;

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
    if ffmpeg::FFMPEG_PATH.get().is_some() && 
       ffmpeg::FFPROBE_PATH.get().is_some() {
        log::info!("[Init Tools] All tools already initialized, skipping");
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

    // Spawn thread for FFmpeg initialization
    if ffmpeg::FFMPEG_PATH.get().is_none() || ffmpeg::FFPROBE_PATH.get().is_none() {
        let errors = Arc::clone(&errors);
        let handle = thread::spawn(move || {
            log::info!("[Init Tools] Initializing FFmpeg/FFprobe");
            if let Err(e) = ffmpeg::init_ffmpeg_and_ffprobe() {
                let lock = lock_with_timeout(&errors, std::time::Duration::from_secs(2));
                if let Some(mut errors) = lock {
                    errors.push(format!("Failed to initialize FFmpeg/FFprobe: {}", e));
                } else {
                    log::error!("[Init Tools] Could not acquire error lock for FFmpeg/FFprobe");
                }
            } else {
                log::info!("[Init Tools] FFmpeg/FFprobe initialized successfully");
            }
        });
        handles.push(handle);
    }
    

    // Wait for all threads to complete with timeout
    log::info!("[Init Tools] Waiting for {} initialization threads", handles.len());
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
