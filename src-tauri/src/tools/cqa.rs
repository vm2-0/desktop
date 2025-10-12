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
use tauri::{AppHandle, Url};
use wait_timeout::ChildExt;

/// Path to the Clones Quality Agent binary, initialized once per session.
pub static CQA_PATH: OnceLock<PathBuf> = OnceLock::new();

const CQA_TIMEOUT_SECS: u64 = 300; // 5 minutes

#[cfg(target_os = "windows")]
fn get_cqa_url() -> String {
    std::env::var("CQA_URL_WIN").unwrap_or_else(|_| {
        "https://github.com/clones-ai/clones-quality-agent/releases/download/v2.0.10/clones-quality-agent-win-x64.exe"
            .to_string()
    })
}

#[cfg(target_os = "linux")]
fn get_cqa_url() -> String {
    std::env::var("CQA_URL_LINUX").unwrap_or_else(|_| {
        "https://github.com/clones-ai/clones-quality-agent/releases/download/v2.0.10/clones-quality-agent-linux-x64"
            .to_string()
    })
}

#[cfg(target_os = "macos")]
fn get_cqa_url() -> String {
    std::env::var("CQA_URL_MACOS").unwrap_or_else(|_| {
        "https://github.com/clones-ai/clones-quality-agent/releases/download/v2.0.10/clones-quality-agent-macos-arm64"
            .to_string()
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

    // Extract repo owner and name from the URL
    let url_parser =
        Url::parse(&get_cqa_url()).map_err(|e| format!("Failed to parse URL: {}", e))?;
    let path_segments: Vec<&str> = url_parser.path_segments().unwrap().collect();
    let repo_owner = path_segments[0];
    let repo_name = path_segments[1];
    let temp_dir = get_temp_dir();
    let asset_url = get_cqa_url();
    let asset_split: Vec<&str> = asset_url.split('/').collect();
    let asset_filename = asset_split[asset_url.split('/').count() - 1];
    let asset_path = temp_dir.join(asset_filename);
    let metadata_path = temp_dir.join(format!("{}.metadata.json", asset_filename));

    // Try to load local metadata
    let local_metadata = crate::utils::github_release::load_metadata(&metadata_path)?;
    // Fetch latest metadata from GitHub
    let latest_metadata =
        crate::utils::github_release::fetch_latest_release_metadata(repo_owner, repo_name)?;

    let needs_download = match &local_metadata {
        Some(meta) => {
            if meta.version != latest_metadata.version {
                info!(
                    "[Clones Quality Agent] Local version {} is outdated (latest: {}), will update",
                    meta.version, latest_metadata.version
                );
                true
            } else {
                info!(
                    "[Clones Quality Agent] Local version {} is up to date",
                    meta.version
                );
                false
            }
        }
        None => {
            info!("[Clones Quality Agent] No local Clones Quality Agent binary or metadata, will download");
            true
        }
    };

    if needs_download || !asset_path.exists() {
        // Use the github_release module to get the latest release
        let cqa_path = crate::utils::github_release::get_latest_release(
            repo_owner, repo_name, &asset_url, &temp_dir,
            true, // Make executable on Linux/macOS
        )?;
        info!(
            "[Clones Quality Agent] Downloaded and using Clones Quality Agent at {}",
            cqa_path.display()
        );
        CQA_PATH.set(cqa_path).unwrap();
    } else {
        info!(
            "[Clones Quality Agent] Using cached Clones Quality Agent at {}",
            asset_path.display()
        );
        CQA_PATH.set(asset_path).unwrap();
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
