use crate::utils::settings::get_custom_app_local_data_dir;
use anyhow::{Context, Result};
use axum::{routing::get_service, Router};
use once_cell::sync::OnceCell;
use std::{net::SocketAddr, path::PathBuf};
use tauri::AppHandle;
use tower_http::services::ServeDir;

static SERVER_ADDR: OnceCell<SocketAddr> = OnceCell::new();

/// Validates recording ID to prevent path traversal attacks
fn validate_recording_id(recording_id: &str) -> Result<(), String> {
    if recording_id.is_empty() {
        return Err("Recording ID cannot be empty".to_string());
    }

    if recording_id.len() > 100 {
        return Err("Recording ID too long".to_string());
    }

    // Prevent path traversal attacks
    if recording_id.contains("..")
        || recording_id.contains("/")
        || recording_id.contains("\\")
        || recording_id.contains('\0')
    {
        return Err("Invalid characters in recording ID".to_string());
    }

    // Only allow alphanumeric, underscore, hyphen
    if !recording_id
        .chars()
        .all(|c| c.is_alphanumeric() || c == '_' || c == '-')
    {
        return Err("Recording ID contains invalid characters".to_string());
    }

    Ok(())
}

/// Verifies that the recording file actually exists
fn verify_recording_exists(app_handle: &AppHandle, recording_id: &str) -> Result<PathBuf, String> {
    let recordings_dir = get_custom_app_local_data_dir(app_handle)?.join("recordings");

    let recording_dir = recordings_dir.join(recording_id);
    let video_file = recording_dir.join("recording.mp4");

    if !recording_dir.exists() {
        return Err(format!("Recording directory not found: {}", recording_id));
    }

    if !video_file.exists() {
        return Err(format!(
            "Video file not found for recording: {}",
            recording_id
        ));
    }

    Ok(video_file)
}

async fn start_server(app_handle: AppHandle) -> Result<SocketAddr> {
    // 1. Get recordings dir path safely using the app_handle with environment suffix
    let recordings_dir = get_custom_app_local_data_dir(&app_handle)
        .map_err(|e| anyhow::anyhow!("Failed to get custom app data dir: {}", e))?
        .join("recordings");

    if !recordings_dir.exists() {
        std::fs::create_dir_all(&recordings_dir).context("Failed to create recordings dir")?;
    }

    // 2. Create the service to serve files
    let service =
        get_service(ServeDir::new(recordings_dir).append_index_html_on_directories(false));

    // 3. Setup router
    let app = Router::new().nest_service("/", service);

    // 4. Bind to any available port using tokio directly
    let addr = SocketAddr::from(([127, 0, 0, 1], 0));
    let tokio_listener = tokio::net::TcpListener::bind(addr)
        .await
        .context("Failed to bind to a free port")?;
    let local_addr = tokio_listener
        .local_addr()
        .context("Failed to get local address")?;

    // 5. Spawn the server in a Tokio thread
    tokio::spawn(async move {
        if let Err(e) = axum::serve(tokio_listener, app).await {
            log::error!("Video server error: {}", e);
        }
    });

    log::info!("Video server started at http://{}", local_addr);
    Ok(local_addr)
}

async fn ensure_server_is_running(
    app_handle: AppHandle,
) -> Result<&'static SocketAddr, String> {
    // Try to get existing address first
    if let Some(addr) = SERVER_ADDR.get() {
        return Ok(addr);
    }

    // If not set, start server and set address
    match start_server(app_handle).await {
        Ok(addr) => {
            // Try to set the address, but if another thread beat us, use theirs
            match SERVER_ADDR.set(addr) {
                Ok(_) => Ok(SERVER_ADDR.get().unwrap()),
                Err(_) => {
                    // Another thread set it first, use that one
                    Ok(SERVER_ADDR.get().unwrap())
                }
            }
        }
        Err(e) => Err(format!("Failed to start video server: {}", e)),
    }
}

/// Builds the full URL to access a specific recording's video.
/// Returns an error if the recording doesn't exist or if security validation fails.
pub async fn get_video_url(app_handle: AppHandle, recording_id: &str) -> Result<String, String> {
    // Step 1: Validate recording ID for security
    validate_recording_id(recording_id)?;

    // Step 2: Verify the recording file actually exists
    verify_recording_exists(&app_handle, recording_id)?;

    // Step 3: Ensure server is running
    let addr = ensure_server_is_running(app_handle).await?;

    // Step 4: Build URL (no need for encoding since validation ensures safe chars)
    Ok(format!("http://{}/{}/recording.mp4", addr, recording_id))
}
