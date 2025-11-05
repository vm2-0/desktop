//! Tauri commands for checking external tool binaries (FFmpeg).
//!
//! This module provides commands to check tool availability.
//! Tools are pre-embedded at build time, so no initialization is needed.

use crate::tools::ffmpeg;
use serde_json;

/// Checks the availability of all required tool binaries.
///
/// # Returns
/// * `Ok(serde_json::Value)` with a map of tool names to their status (true/false).
#[tauri::command]
pub async fn check_tools() -> Result<serde_json::Value, String> {
    // Check if tools are initialized in memory or available on system
    let ffmpeg_available = ffmpeg::FFMPEG_PATH.get().is_some() || !ffmpeg::get_ffmpeg_dir().as_os_str().is_empty();
    let ffprobe_available = ffmpeg::FFPROBE_PATH.get().is_some() || !ffmpeg::get_ffprobe_dir().as_os_str().is_empty();
    
    Ok(serde_json::json!({
        "ffmpeg": ffmpeg_available,
        "ffprobe": ffprobe_available
    }))
}

