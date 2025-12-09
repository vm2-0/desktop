//! Tauri commands for recording management: start, stop, list, and file operations.
//!
//! This module provides commands for managing recording sessions, files, and metadata from the frontend.

use crate::{
    core::record::{self, Demonstration, RecordingMeta},
    core::video_server,
    utils::settings::get_custom_app_local_data_dir,
};
use tauri::AppHandle;

/// Starts a new recording session.
///
/// # Arguments
/// * `app` - The Tauri `AppHandle`.
/// * `demonstration` - Optional demonstration information.
/// * `fps` - Frame rate for recording.
///
/// # Returns
/// * `Ok(())` if recording started successfully.
/// * `Err` if starting failed.
#[tauri::command]
pub async fn start_recording(
    app: AppHandle,
    demonstration: Option<Demonstration>,
    fps: u32,
) -> Result<(), String> {
    record::start_recording(app, demonstration, fps).await
}

/// Stops the current recording session.
///
/// # Arguments
/// * `app` - The Tauri `AppHandle`.
/// * `reason` - Optional reason for stopping.
///
/// # Returns
/// * `Ok(String)` with stop info if successful.
/// * `Err` if stopping failed.
#[tauri::command]
pub async fn stop_recording(
    app: AppHandle,
    reason: Option<String>,
) -> Result<String, String> {
    record::stop_recording(app, reason).await
}

/// Gets the current recording state as a string.
///
/// # Returns
/// * `Ok(String)` with the state.
/// * `Err` if retrieval failed.
#[tauri::command]
pub async fn get_recording_state() -> Result<String, String> {
    record::get_recording_state().await
}

/// Lists all recordings' metadata.
///
/// # Arguments
/// * `app` - The Tauri `AppHandle`.
///
/// # Returns
/// * `Ok(Vec<RecordingMeta>)` if successful.
/// * `Err` if listing failed.
#[tauri::command]
pub async fn list_recordings(app: AppHandle) -> Result<Vec<RecordingMeta>, String> {
    record::list_recordings(app).await
}

/// Gets a file from a recording, optionally as base64 or as a path.
///
/// # Arguments
/// * `app` - The Tauri `AppHandle`.
/// * `recording_id` - The recording ID.
/// * `filename` - The file name.
/// * `as_base64` - Whether to return as base64.
/// * `as_path` - Whether to return as a file path.
///
/// # Returns
/// * `Ok(String)` with file data or path.
/// * `Err` if retrieval failed.
#[tauri::command]
pub async fn get_recording_file(
    app: AppHandle,
    recording_id: String,
    filename: String,
    as_base64: Option<bool>,
    as_path: Option<bool>,
) -> Result<String, String> {
    validate_id(&recording_id)?;
    validate_filename(&filename)?;
    record::get_recording_file(app, recording_id, filename, as_base64, as_path).await
}

/// Processes a recording (post-processing step).
///
/// # Arguments
/// * `app` - The Tauri `AppHandle`.
/// * `recording_id` - The recording ID.
///
/// # Returns
/// * `Ok(())` if processing succeeded.
/// * `Err` if processing failed.
#[tauri::command]
pub async fn process_recording(app: AppHandle, recording_id: String, connect_token: Option<String>, backend_url: String) -> Result<(), String> {
    validate_id(&recording_id)?;
    record::process_recording(app, recording_id, connect_token, backend_url).await
}

/// Writes content to a file at the given path.
///
/// # Arguments
/// * `app` - The Tauri `AppHandle`.
/// * `path` - The file path.
/// * `content` - The content to write.
///
/// # Returns
/// * `Ok(())` if writing succeeded.
/// * `Err` if writing failed.
#[tauri::command]
pub async fn write_file(app: AppHandle, path: String, content: String) -> Result<(), String> {
    validate_path(&path)?;
    validate_content(&content)?;
    record::write_file(app, path, content).await
}

/// Writes content to a file in a recording's directory.
///
/// # Arguments
/// * `app` - The Tauri `AppHandle`.
/// * `recording_id` - The recording ID.
/// * `filename` - The file name.
/// * `content` - The content to write.
///
/// # Returns
/// * `Ok(())` if writing succeeded.
/// * `Err` if writing failed.
#[tauri::command]
pub async fn write_recording_file(
    app: AppHandle,
    recording_id: String,
    filename: String,
    content: String,
) -> Result<(), String> {
    validate_id(&recording_id)?;
    validate_filename(&filename)?;
    validate_content(&content)?;
    record::write_recording_file(app, recording_id, filename, content).await
}

/// Deletes a recording and its files.
///
/// # Arguments
/// * `app` - The Tauri `AppHandle`.
/// * `recording_id` - The recording ID.
///
/// # Returns
/// * `Ok(())` if deletion succeeded.
/// * `Err` if deletion failed.
#[tauri::command]
pub async fn delete_recording(app: AppHandle, recording_id: String) -> Result<(), String> {
    validate_id(&recording_id)?;
    record::delete_recording(app, recording_id).await
}

/// Creates a zip archive of a recording's files.
///
/// # Arguments
/// * `app` - The Tauri `AppHandle`.
/// * `recording_id` - The recording ID.
///
/// # Returns
/// * `Ok(Vec<u8>)` with the zip data.
/// * `Err` if zipping failed.
#[tauri::command]
pub async fn create_recording_zip(app: AppHandle, recording_id: String) -> Result<Vec<u8>, String> {
    validate_id(&recording_id)?;
    record::create_recording_zip(app, recording_id).await
}

/// Gets the video URL for a recording.
///
/// # Arguments
/// * `app` - The Tauri `AppHandle`.
/// * `recording_id` - The recording ID.
///
/// # Returns
/// * `Ok(String)` with the video URL, or `Err(String)` if failed.
#[tauri::command]
pub async fn get_video_url(app: AppHandle, recording_id: String) -> Result<String, String> {
    video_server::get_video_url(app, &recording_id).await
}

/// Gets the application data directory path.
///
/// # Arguments
/// * `app` - The Tauri `AppHandle`.
///
/// # Returns
/// * `Ok(String)` with the directory path.
/// * `Err` if retrieval failed.
#[tauri::command]
pub async fn get_app_data_dir(app: AppHandle) -> Result<String, String> {
    let dir = get_custom_app_local_data_dir(&app)
        .map_err(|e| format!("Failed to get app data dir: {}", e))?;
    Ok(dir.to_string_lossy().to_string())
}

/// Gets the current demonstration from the demonstration state.
///
/// # Returns
/// * `Ok(Some(Demonstration))` if a demonstration is active.
/// * `Ok(None)` if no demonstration is active.
/// * `Err` if retrieval failed.
#[tauri::command]
pub async fn get_current_demonstration() -> Result<Option<Demonstration>, String> {
    record::get_current_demonstration().await
}

fn validate_id(id: &str) -> Result<(), String> {
    let trimmed = id.trim();
    
    if trimmed.is_empty() {
        return Err("Recording ID cannot be empty".to_string());
    }
    
    // Enforce reasonable length limits
    if trimmed.len() > 100 {
        return Err("Recording ID too long (max 100 characters)".to_string());
    }
    
    // Whitelist approach: only allow safe characters
    // Allow: alphanumeric, hyphens, underscores, and periods (but not consecutive periods)
    for c in trimmed.chars() {
        if !c.is_ascii_alphanumeric() && c != '-' && c != '_' && c != '.' {
            return Err(format!("Recording ID contains invalid character: '{}'", c));
        }
    }
    
    // Prevent consecutive periods (could be used for path traversal)
    if trimmed.contains("..") {
        return Err("Recording ID cannot contain consecutive periods".to_string());
    }
    
    // Prevent starting or ending with periods (potential filesystem issues)
    if trimmed.starts_with('.') || trimmed.ends_with('.') {
        return Err("Recording ID cannot start or end with a period".to_string());
    }
    
    Ok(())
}

fn validate_filename(filename: &str) -> Result<(), String> {
    let trimmed = filename.trim();
    
    if trimmed.is_empty() {
        return Err("Filename cannot be empty".to_string());
    }
    
    // Enforce reasonable length limits
    if trimmed.len() > 255 {
        return Err("Filename too long (max 255 characters)".to_string());
    }
    
    // Whitelist approach: only allow safe characters for filenames
    // Allow: alphanumeric, hyphens, underscores, periods, and spaces
    for c in trimmed.chars() {
        if !c.is_ascii_alphanumeric() && c != '-' && c != '_' && c != '.' && c != ' ' {
            return Err(format!("Filename contains invalid character: '{}'", c));
        }
    }
    
    // Prevent consecutive periods (could be used for path traversal)
    if trimmed.contains("..") {
        return Err("Filename cannot contain consecutive periods".to_string());
    }
    
    // Prevent starting or ending with periods or spaces (filesystem issues)
    if trimmed.starts_with('.') || trimmed.ends_with('.') || 
       trimmed.starts_with(' ') || trimmed.ends_with(' ') {
        return Err("Filename cannot start or end with periods or spaces".to_string());
    }
    
    Ok(())
}

fn validate_path(path: &str) -> Result<(), String> {
    if path.trim().is_empty() {
        return Err("Path cannot be empty".to_string());
    }
    if path.contains("..") {
        return Err("Invalid path (path traversal detected)".to_string());
    }
    Ok(())
}

fn validate_content(content: &str) -> Result<(), String> {
    if content.len() > 100 * 1024 * 1024 {
        // 100 MB max content size
        return Err("Content is too large".to_string());
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_validate_id_empty() {
        let result = validate_id("");
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Recording ID cannot be empty");
    }

    #[test]
    fn test_validate_id_path_traversal() {
        for bad in ["..", "foo/../bar", "foo\\bar", "foo/bar"] {
            let result = validate_id(bad);
            assert!(result.is_err());
            assert_eq!(
                result.unwrap_err(),
                "Invalid recording ID (path traversal detected)"
            );
        }
    }

    #[test]
    fn test_validate_id_valid() {
        let result = validate_id("rec_123-OK");
        assert!(result.is_ok());
    }

    #[test]
    fn test_validate_filename_empty() {
        let result = validate_filename("");
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Filename cannot be empty");
    }

    #[test]
    fn test_validate_filename_path_traversal() {
        for bad in ["..", "foo/../bar", "foo\\bar", "foo/bar"] {
            let result = validate_filename(bad);
            assert!(result.is_err());
            assert_eq!(
                result.unwrap_err(),
                "Invalid filename (path traversal detected)"
            );
        }
    }

    #[test]
    fn test_validate_filename_valid() {
        let result = validate_filename("file.txt");
        assert!(result.is_ok());
    }

    #[test]
    fn test_validate_path_empty() {
        let result = validate_path("");
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Path cannot be empty");
    }

    #[test]
    fn test_validate_path_path_traversal() {
        for bad in ["..", "foo/../bar"] {
            let result = validate_path(bad);
            assert!(result.is_err());
            assert_eq!(
                result.unwrap_err(),
                "Invalid path (path traversal detected)"
            );
        }
    }

    #[test]
    fn test_validate_path_valid() {
        let result = validate_path("/tmp/recordings/file.txt");
        assert!(result.is_ok());
    }

    #[test]
    fn test_validate_content_too_large() {
        let big = "a".repeat(100 * 1024 * 1024 + 1);
        let result = validate_content(&big);
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Content is too large");
    }

    #[test]
    fn test_validate_content_valid() {
        let small = "a".repeat(1024);
        let result = validate_content(&small);
        assert!(result.is_ok());
    }
}
