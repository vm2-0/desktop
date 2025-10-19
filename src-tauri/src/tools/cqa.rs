//! Clones Quality Agent tool integration for post-processing recordings.
//!
//! This module manages the download, initialization, and execution of the Clones Quality Agent binary for processing recorded data.

use crate::tools::ffmpeg::{get_ffmpeg_dir, get_ffprobe_dir};
use crate::utils::settings::get_custom_app_local_data_dir;
use log::info;
use std::path::PathBuf;
use std::process::Command;
use std::sync::OnceLock;
use std::time::Duration;
use tauri::AppHandle;
use wait_timeout::ChildExt;

/// Path to the Clones Quality Agent binary, initialized once per session.
pub static CQA_PATH: OnceLock<PathBuf> = OnceLock::new();

const CQA_TIMEOUT_SECS: u64 = 300; // 5 minutes

#[cfg(target_os = "windows")]
fn get_cqa_url() -> String {
    std::env::var("CQA_URL_WIN").unwrap_or_else(|_| {
        "https://releases.clones-ai.com/cqa/clones-quality-agent-win-x64-v2.0.15.exe".to_string()
    })
}

#[cfg(target_os = "linux")]
fn get_cqa_url() -> String {
    std::env::var("CQA_URL_LINUX").unwrap_or_else(|_| {
        "https://releases.clones-ai.com/cqa/clones-quality-agent-linux-x64-v2.0.15".to_string()
    })
}

#[cfg(target_os = "macos")]
fn get_cqa_url() -> String {
    std::env::var("CQA_URL_MACOS").unwrap_or_else(|_| {
        "https://releases.clones-ai.com/cqa/clones-quality-agent-macos-arm64-v2.0.15".to_string()
    })
}

fn get_temp_dir() -> PathBuf {
    let mut temp = std::env::temp_dir();
    temp.push("clones-desktop");
    temp
}

/// Initializes the Clones Quality Agent binary by downloading the latest release if needed.
///
/// # Returns
/// * `Ok(())` if initialization succeeded.
/// * `Err` if the binary could not be downloaded or set up.
pub fn init_cqa() -> Result<(), String> {
    if CQA_PATH.get().is_some() {
        info!("[Clones Quality Agent] Already initialized");
        return Ok(());
    }

    info!("[Clones Quality Agent] Initializing Clones Quality Agent");

    let temp_dir = get_temp_dir();
    let asset_url = get_cqa_url();
    let asset_split: Vec<&str> = asset_url.split('/').collect();
    let asset_filename = asset_split[asset_url.split('/').count() - 1];
    let asset_path = temp_dir.join(asset_filename);

    info!(
        "[Clones Quality Agent] Checking for CQA at {}",
        asset_path.display()
    );

    // Create temp directory if it doesn't exist
    std::fs::create_dir_all(&temp_dir)
        .map_err(|e| format!("Failed to create temp directory: {}", e))?;

    // For Tigris-hosted binaries, we always download if file doesn't exist
    // Since we don't have version metadata from Tigris, we rely on file presence
    if !asset_path.exists() {
        info!(
            "[Clones Quality Agent] Binary not found, downloading from {}",
            asset_url
        );
        
        // Download the file directly
        crate::utils::downloader::download_file(&asset_url, &asset_path)?;

        // Set executable permissions on Linux/macOS
        #[cfg(any(target_os = "linux", target_os = "macos"))]
        {
            use std::os::unix::fs::PermissionsExt;
            std::fs::set_permissions(&asset_path, std::fs::Permissions::from_mode(0o755))
                .map_err(|e| format!("Failed to set executable permissions: {}", e))?;
            info!(
                "[Clones Quality Agent] Set executable permissions for {}",
                asset_path.display()
            );
        }

        info!(
            "[Clones Quality Agent] Downloaded CQA to {}",
            asset_path.display()
        );
    } else {
        info!(
            "[Clones Quality Agent] Using existing CQA at {}",
            asset_path.display()
        );
    }

    // Set the global path
    if let Err(_) = CQA_PATH.set(asset_path.clone()) {
        log::warn!("[CQA] CQA_PATH already set, skipping");
    }

    Ok(())
}

fn validate_recording_id(id: &str) -> Result<(), String> {
    if id.trim().is_empty() {
        return Err("Recording ID cannot be empty".to_string());
    }
    if id.contains("..") || id.contains('/') || id.contains("\\") {
        return Err("Invalid recording ID (path traversal detected)".to_string());
    }
    if id.len() > 256 {
        return Err("Recording ID is too long".to_string());
    }
    Ok(())
}

/// Processes a recording using the Clones Quality Agent binary.
///
/// # Arguments
/// * `app` - The Tauri `AppHandle` used to locate the recordings directory.
/// * `recording_id` - The ID of the recording to process.
///
/// # Returns
/// * `Ok(())` if processing succeeded.
/// * `Err` if the Clones Quality Agent failed or was not initialized.
pub fn process_recording(app: &AppHandle, recording_id: &str) -> Result<(), String> {
    validate_recording_id(recording_id)?;
    let cqa = CQA_PATH
        .get()
        .ok_or_else(|| "Clones Quality Agent not initialized".to_string())?;

    // Get the recording folder path using app.path() like record.rs
    let recordings_dir = get_custom_app_local_data_dir(app)
        .map_err(|e| format!("Failed to get app data directory: {}", e))?
        .join("recordings")
        .join(recording_id);

    info!(
        "[Clones Quality Agent] Processing recording at {}",
        recordings_dir.display()
    );

    // Run the pipeline command from the temp directory so it can find ffmpeg/ffprobe
    let temp_dir = get_temp_dir();

    let mut command = Command::new(cqa);
    #[cfg(windows)]
    {
        use std::os::windows::process::CommandExt;
        command.creation_flags(0x08000000); // CREATE_NO_WINDOW constant
    }

    //todo: check if ffmpeg and ffprobe exist in the path before getting the custom dir.
    let ffmpeg_dir = get_ffmpeg_dir();
    let ffprobe_dir = get_ffprobe_dir();
    let mut child = command
        .current_dir(temp_dir)
        .arg("-f")
        .arg("desktop")
        .arg("-i")
        .arg(&recordings_dir)
        .arg("--ffmpeg")
        .arg(ffmpeg_dir)
        .arg("--ffprobe")
        .arg(ffprobe_dir)
        .spawn()
        .map_err(|e| format!("Failed to execute Clones Quality Agent: {}", e))?;
    let timeout = Duration::from_secs(CQA_TIMEOUT_SECS);
    match child
        .wait_timeout(timeout)
        .map_err(|e| format!("Failed to wait for Clones Quality Agent: {}", e))?
    {
        Some(status) => {
            if !status.success() {
                let output = child.wait_with_output().unwrap();
                let error = String::from_utf8_lossy(&output.stderr);
                return Err(format!("Clones Quality Agent failed: {}", error));
            }
        }
        None => {
            // Timeout: kill the process
            child.kill().ok();
            return Err(format!(
                "Clones Quality Agent process timed out after {} seconds",
                CQA_TIMEOUT_SECS
            ));
        }
    }
    info!("[Clones Quality Agent] Successfully processed recording");
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_validate_recording_id_empty() {
        let result = validate_recording_id("");
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Recording ID cannot be empty");
    }

    #[test]
    fn test_validate_recording_id_path_traversal() {
        let result = validate_recording_id("..//etc/passwd");
        assert!(result.is_err());
        assert_eq!(
            result.unwrap_err(),
            "Invalid recording ID (path traversal detected)"
        );

        let result = validate_recording_id("foo/../bar");
        assert!(result.is_err());
        assert_eq!(
            result.unwrap_err(),
            "Invalid recording ID (path traversal detected)"
        );

        let result = validate_recording_id("foo\\bar");
        assert!(result.is_err());
        assert_eq!(
            result.unwrap_err(),
            "Invalid recording ID (path traversal detected)"
        );
    }

    #[test]
    fn test_validate_recording_id_too_long() {
        let long_id = "a".repeat(257);
        let result = validate_recording_id(&long_id);
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Recording ID is too long");
    }

    #[test]
    fn test_validate_recording_id_valid() {
        let result = validate_recording_id("rec_123-OK");
        assert!(result.is_ok());
    }
}
