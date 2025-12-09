use axum::{
    extract::{Json, Query, State},
    http::{Method, StatusCode},
    response::IntoResponse,
    routing::{get, post},
    Router,
};
use http::header::{ACCEPT, CONTENT_TYPE};
#[cfg(target_os = "macos")]
use nix::errno::Errno;
#[cfg(windows)]
use windows::Win32::Foundation::{CloseHandle, HANDLE};
#[cfg(windows)]
use windows::Win32::System::Threading::{
    OpenProcess, WaitForSingleObject, INFINITE, PROCESS_SYNCHRONIZE,
};

use serde::{Deserialize, Serialize};
use std::net::SocketAddr;
use std::time::Duration;
use tauri::{AppHandle, Manager};
use tower_http::cors::{Any, CorsLayer};

// Constants for heartbeat monitoring configuration
const HEARTBEAT_CHECK_INTERVAL_SECONDS: u64 = 5;
const READY_SIGNAL_TIMEOUT_SECONDS: u64 = 30;

// Import heartbeat utilities
use crate::utils::heartbeat::{
    check_flutter_heartbeat_simple, check_flutter_ready_signal, cleanup_old_heartbeat_files,
    get_flutter_heartbeat_path_stable,
};

// Import business logic from the local `core` module
use crate::core::record::{self, Demonstration};
use crate::core::video_server;
// Import functions from `commands/general`
use crate::commands::general::{list_apps, open_logs_folder, take_screenshot};
// Import function from `commands/settings`
use crate::commands::settings::{get_upload_data_allowed, set_upload_data_allowed};
// Import function from `utils/permissions`
use crate::utils::permissions::has_ax_perms;
// Import functions from `commands/tools`
use crate::commands::tools::check_tools;
// Import functions from `core/record`
use crate::core::record::process_recording;
// Import functions from `utils/permissions`
use crate::utils::permissions::{has_record_perms, request_ax_perms, request_record_perms};
// Import functions from `commands/transaction`
use crate::commands::transaction::{
    cleanup_old_transactions, generate_session_token, generate_transaction_deep_link,
    get_transaction_request, handle_transaction_callback, list_pending_transactions,
    prepare_transaction_request, update_transaction_status, TransactionRequest, TransactionStatus,
};
// Import functions from `utils/platform`
use crate::utils::platform::get_platform;
// Import functions from `utils/url`
use crate::utils::url::{open_external_url, OpenUrlPayload};
// Import our new DeepLinkState
use crate::DeepLinkState;

// Helper to wrap AppHandle in the server state
#[derive(Clone)]
pub struct AppState {
    pub app_handle: AppHandle,
}

// Structure for the write_recording_file request
#[derive(Deserialize)]
pub struct WriteFilePayload {
    filename: String,
    content: String,
}

// Structure for the get_recording_file query
#[derive(Deserialize)]
pub struct GetFileQuery {
    filename: String,
    #[serde(rename = "asPath")]
    as_path: Option<bool>,
    #[serde(rename = "asBase64")]
    as_base64: Option<bool>,
}

// Structure for the start_recording request
#[derive(Deserialize)]
pub struct StartRecordingPayload {
    demonstration: Option<Demonstration>,
    fps: u32,
}

// Structure for the stop_recording request
#[derive(Deserialize)]
pub struct StopRecordingPayload {
    status: String,
}

#[derive(Deserialize)]
pub struct FilteredZipPayload {
    deleted_ranges: Vec<DeletedRange>,
}

#[derive(Deserialize)]
pub struct DeletedRange {
    start: f64,
    end: f64,
}

// Structure for the `set_upload_data_allowed` payload
#[derive(Deserialize)]
pub struct SetUploadAllowedPayload {
    allowed: bool,
}

// Structure for the has_ax_perms response
#[derive(Serialize)]
pub struct PermissionStatus {
    has_permission: bool,
}

// Structures for transaction endpoints
#[derive(Deserialize)]
pub struct PrepareTransactionPayload {
    transaction_type: String,
    session_token: String,
    creator: Option<String>,
    token: Option<String>,
    amount: Option<String>,
    pool_address: Option<String>,
}

#[derive(Deserialize)]
pub struct GenerateDeepLinkPayload {
    request: serde_json::Value,
    website_base_url: Option<String>,
}

#[derive(Deserialize)]
pub struct UpdateTransactionStatusPayload {
    #[allow(dead_code)]
    request_id: String,
    status: String,
    gas_estimate: Option<serde_json::Value>,
}

#[derive(Deserialize)]
pub struct TransactionCallbackPayload {
    status: String,
    tx_hash: Option<String>,
    message: Option<String>,
    transaction_type: String,
}

// Structure for the process_recording query parameters
#[derive(Deserialize)]
pub struct ProcessRecordingQuery {
    backend_url: String,
}

// Main function to start the server
pub async fn init(app_handle: AppHandle) {
    let state = AppState {
        app_handle: app_handle.clone(),
    };

    let cors = CorsLayer::new()
        .allow_methods([Method::GET, Method::POST, Method::DELETE])
        .allow_origin(Any)
        .allow_headers([ACCEPT, CONTENT_TYPE]);

    let app = Router::new()
        // GET /recordings: Retrieve a list of all recordings.
        // Used for fetching read-only data, so GET is appropriate.
        .route("/recordings", get(list_recordings_handler))
        // POST /recordings/:id/files: Create a new file within a specific recording.
        // This is a create operation on a sub-resource, making POST suitable.
        .route(
            "/recordings/:id/files",
            post(write_recording_file_handler).get(get_recording_file_handler),
        )
        // Add our new route for streaming video
        .route(
            "/recordings/:id/video_url",
            get(get_recording_video_url_handler),
        )
        // POST /recordings/start: Initiate a new recording session.
        // This is an action that changes server state, so POST is used.
        .route("/recordings/start", post(start_recording_handler))
        // POST /recordings/stop: Stop the current recording session.
        // This is an action that changes server state, so POST is used.
        .route("/recordings/stop", post(stop_recording_handler))
        // DELETE /recordings/:id: Remove a specific recording.
        // Standard RESTful method for resource deletion.
        .route(
            "/recordings/:id",
            axum::routing::delete(delete_recording_handler),
        )
        // GET /recordings/:id/zip: Retrieve a zip archive of a specific recording.
        // Though it involves creation, the primary action is data retrieval, so GET is acceptable.
        .route("/recordings/:id/zip", get(create_recording_zip_handler))
        // POST /recordings/:id/filtered-zip: Create a filtered zip excluding deleted segments
        .route(
            "/recordings/:id/filtered-zip",
            post(create_filtered_recording_zip_handler),
        )
        // GET /apps: Retrieve a list of installed applications.
        // Read-only data retrieval.
        .route("/apps", get(list_apps_handler))
        // GET /screenshot: Capture and retrieve a screenshot.
        // Idempotent action for data retrieval.
        .route("/screenshot", get(take_screenshot_handler))
        // GET & POST /settings/upload-allowed: GET to read, POST to update the setting.
        // Follows standard practice for resource state management.
        .route(
            "/settings/upload-allowed",
            get(get_upload_data_allowed_handler).post(set_upload_data_allowed_handler),
        )
        // GET /permissions/ax: Check accessibility permissions status.
        .route("/permissions/ax", get(has_ax_perms_handler))
        // GET /permissions/record: Check screen recording permissions status.
        .route("/permissions/record", get(has_record_perms_handler))
        // POST /permissions/record/request: Trigger a request for screen recording permissions.
        .route(
            "/permissions/record/request",
            post(request_record_perms_handler),
        )
        // POST /permissions/ax/request: Trigger a request for accessibility permissions.
        .route("/permissions/ax/request", post(request_ax_perms_handler))
        // GET /tools/check: Check the status of external tools.
        .route("/tools/check", get(check_tools_handler))
        // POST /recordings/:id/process: Trigger post-processing for a specific recording.
        .route("/recordings/:id/process", post(process_recording_handler))
        // GET /deeplink: Retrieve the latest deep link URL received by the application.
        .route("/deeplink", get(get_deeplink_handler))
        // POST /open-url: Open an external URL.
        .route("/open-url", post(open_external_url_handler))
        // GET /platform: Get the platform of the current system.
        .route("/platform", get(get_platform_handler))
        // Transaction endpoints
        // GET /transaction/session: Generate a new session token
        .route("/transaction/session", get(generate_session_token_handler))
        // POST /transaction/prepare: Prepare a transaction request
        .route(
            "/transaction/prepare",
            post(prepare_transaction_request_handler),
        )
        // POST /transaction/deeplink: Generate deep link URL
        .route("/transaction/deeplink", post(generate_deep_link_handler))
        // GET /transaction/:id: Get transaction request by ID
        .route("/transaction/:id", get(get_transaction_request_handler))
        // POST /transaction/:id/status: Update transaction status
        .route(
            "/transaction/:id/status",
            post(update_transaction_status_handler),
        )
        // GET /transaction/pending: List pending transactions
        .route(
            "/transaction/pending",
            get(list_pending_transactions_handler),
        )
        // POST /transaction/cleanup: Clean up old transactions
        .route(
            "/transaction/cleanup",
            post(cleanup_old_transactions_handler),
        )
        // POST /transaction/callback: Handle transaction callback
        .route(
            "/transaction/callback",
            post(handle_transaction_callback_handler),
        )
        // POST /logs/open: Open the logs folder
        .route("/logs/open", post(open_logs_folder_handler))
        .with_state(state)
        .layer(cors);

    let addr = SocketAddr::from(([127, 0, 0, 1], 19847));
    println!("[IPC Server] Listening on {}", addr);

    // We launch the server in a Tokio task so as not to block the main Tauri thread
    tokio::spawn(async move {
        match tokio::net::TcpListener::bind(addr).await {
            Ok(listener) => {
                log::info!("[IPC Server] Successfully bound to {}", addr);

                // Start simple heartbeat monitoring
                start_heartbeat_monitoring(app_handle.clone());
                // Start parent lifecycle guard to exit when Flutter dies
                start_parent_lifecycle_guard(app_handle.clone());

                if let Err(e) = axum::serve(listener, app.into_make_service()).await {
                    log::error!("[IPC Server] Server error: {}", e);
                }
            }
            Err(e) => {
                log::error!("[IPC Server] Failed to bind to {}: {}", addr, e);
            }
        }
    });
}

/// Start simple heartbeat monitoring in background
fn start_heartbeat_monitoring(app_handle: AppHandle) {
    // Check if development mode is enabled
    let is_dev_mode = std::env::var("CLONES_DEV_MODE")
        .map(|v| v == "true" || v == "1")
        .unwrap_or(false);

    if is_dev_mode {
        log::info!("[Heartbeat] Development mode - skipping heartbeat monitoring");
        return;
    }

    // Use stable heartbeat path independent of Flutter PID
    let heartbeat_path = get_flutter_heartbeat_path_stable();

    // Clean up old heartbeat files from previous sessions before starting monitoring
    // This prevents the agent from reading stale heartbeat data (e.g., from a crash)
    cleanup_old_heartbeat_files(&heartbeat_path);

    log::info!(
        "[Heartbeat] Starting heartbeat monitoring at: {}",
        heartbeat_path.display()
    );
    // Start supervised heartbeat monitoring that restarts on panic
    start_supervised_heartbeat_monitoring(app_handle.clone(), heartbeat_path);
}

/// Start supervised heartbeat monitoring that automatically restarts on panic
fn start_supervised_heartbeat_monitoring(
    app_handle: AppHandle,
    heartbeat_path: std::path::PathBuf,
) {
    tokio::spawn(async move {
        loop {
            log::info!("[Heartbeat] Starting heartbeat monitoring task");

            let app_for_cleanup = app_handle.clone();
            let heartbeat_path_clone = heartbeat_path.clone();

            let monitoring_handle = tokio::spawn(async move {
                // Monitoring loop start
                // Wait for Flutter ready signal (with timeout)
                log::info!(
                    "[Heartbeat] Waiting for Flutter ready signal (timeout: {}s)...",
                    READY_SIGNAL_TIMEOUT_SECONDS
                );
                let mut ready_timeout = READY_SIGNAL_TIMEOUT_SECONDS;
                while ready_timeout > 0 && !check_flutter_ready_signal(&heartbeat_path_clone) {
                    tokio::time::sleep(Duration::from_secs(1)).await;
                    ready_timeout -= 1;
                }

                if ready_timeout == 0 {
                    // Instead of exiting, continue monitoring and keep waiting for Flutter to appear later
                    log::warn!("[Heartbeat] Timeout waiting for Flutter ready signal - continuing to wait in background");
                }

                log::info!("[Heartbeat] Flutter ready signal received, starting heartbeat monitoring (check interval: {}s)", 
                          HEARTBEAT_CHECK_INTERVAL_SECONDS);

                let mut interval =
                    tokio::time::interval(Duration::from_secs(HEARTBEAT_CHECK_INTERVAL_SECONDS));
                let mut check_count = 0u64;
                // Track wall time to detect sleep/wake gaps and apply a post-wake grace window
                let mut last_wall = std::time::SystemTime::now();
                let mut grace_deadline: Option<std::time::SystemTime> = None;

                loop {
                    interval.tick().await;
                    check_count += 1;

                    // Detect significant wall-clock jumps (system sleep/wake)
                    let wall_now = std::time::SystemTime::now();
                    if let Ok(elapsed) = wall_now.duration_since(last_wall) {
                        // Threshold: 3x the check interval → likely a suspend
                        let threshold = Duration::from_secs(HEARTBEAT_CHECK_INTERVAL_SECONDS * 3);
                        if elapsed > threshold {
                            let grace = Duration::from_secs(20);
                            grace_deadline = Some(wall_now + grace);
                            log::info!(
                                "[Heartbeat] Detected possible system wake (gap: {:?}). Applying grace: {:?}",
                                elapsed,
                                grace
                            );
                        }
                    }
                    last_wall = wall_now;

                    // Log every 12 checks (1 minute) to show monitoring is alive
                    if check_count % 12 == 0 {
                        log::debug!(
                            "[Heartbeat] Monitoring alive - check #{} completed",
                            check_count
                        );
                    }

                    // During grace window after wake, skip failure checks
                    if let Some(deadline) = grace_deadline {
                        if wall_now < deadline {
                            continue;
                        } else {
                            grace_deadline = None;
                        }
                    }

                    if !check_flutter_heartbeat_simple(&heartbeat_path_clone) {
                        // Flutter stopped or sleeping: perform cleanup, then continue waiting for it to come back
                        log::warn!("[Heartbeat] Flutter heartbeat failed - performing cleanup & waiting for return");

                        if let Err(e) = cleanup_before_exit(&app_for_cleanup) {
                            log::error!("[Heartbeat] Cleanup failed: {}", e);
                        } else {
                            log::info!("[Heartbeat] Cleanup completed successfully");
                        }

                        // After cleanup, block until ready signal or heartbeat reappears
                        loop {
                            if check_flutter_ready_signal(&heartbeat_path_clone)
                                || check_flutter_heartbeat_simple(&heartbeat_path_clone)
                            {
                                log::info!("[Heartbeat] Flutter returned - resuming monitoring");
                                // Placeholder: re-acquire anti-App Nap guard after resume on macOS
                                break;
                            }
                            tokio::time::sleep(Duration::from_secs(1)).await;
                        }
                    }
                }
            });

            // Wait for the monitoring task to complete or panic
            match monitoring_handle.await {
                Ok(_) => {
                    log::info!(
                        "[Heartbeat] Monitoring task completed normally - exiting supervision"
                    );
                    break;
                }
                Err(e) if e.is_panic() => {
                    log::error!(
                        "[Heartbeat] CRITICAL: Monitoring task panicked! Details: {:?}",
                        e
                    );
                    log::error!(
                        "[Heartbeat] Restarting monitoring immediately to prevent zombie agent"
                    );

                    // Brief delay before restart to prevent tight loop
                    tokio::time::sleep(Duration::from_millis(100)).await;
                    // Continue the loop to restart monitoring
                }
                Err(e) => {
                    log::warn!(
                        "[Heartbeat] Monitoring task was cancelled: {} - exiting supervision",
                        e
                    );
                    break;
                }
            }
        }
    });
}

/// Perform graceful cleanup before agent shutdown
fn cleanup_before_exit(app_handle: &AppHandle) -> Result<(), String> {
    log::info!("[Cleanup] Starting graceful cleanup before agent shutdown");

    // Force kill any active recorder and cleanup recording state
    crate::core::record::force_kill_active_recorder(app_handle);
    log::info!("[Cleanup] Active recorder cleanup completed");

    // Log shutdown reason for debugging
    log::info!("[Cleanup] Agent shutdown due to Flutter heartbeat failure");

    Ok(())
}

/// Start a cross-platform guard that exits the agent when the Flutter parent process dies
fn start_parent_lifecycle_guard(app_handle: AppHandle) {
    let ppid = std::env::var("FLUTTER_PARENT_PID")
        .ok()
        .and_then(|s| s.parse::<u32>().ok());
    let Some(parent_pid) = ppid else {
        log::info!("[Lifecycle] No FLUTTER_PARENT_PID provided - skipping parent guard");
        return;
    };

    #[cfg(target_os = "macos")]
    {
        log::info!(
            "[Lifecycle] Starting macOS parent guard for PID {}",
            parent_pid
        );
        tokio::spawn(async move {
            loop {
                let rc = unsafe { libc::kill(parent_pid as i32, 0) };
                let last = Errno::last_raw();
                let alive = rc == 0 || last != Errno::ESRCH as i32;
                if !alive {
                    log::info!("[Lifecycle] Parent PID {} gone - exiting agent", parent_pid);
                    let _ = cleanup_before_exit(&app_handle);
                    std::process::exit(0);
                }
                tokio::time::sleep(Duration::from_secs(1)).await;
            }
        });
    }

    #[cfg(windows)]
    {
        log::info!(
            "[Lifecycle] Starting Windows parent guard for PID {}",
            parent_pid
        );
        std::thread::spawn(move || unsafe {
            let handle: HANDLE = match OpenProcess(PROCESS_SYNCHRONIZE, false, parent_pid) {
                Ok(h) => h,
                Err(_) => {
                    log::info!("[Lifecycle] Parent not found - exiting agent");
                    let _ = cleanup_before_exit(&app_handle);
                    std::process::exit(0);
                }
            };
            if handle.0 == 0 {
                log::info!("[Lifecycle] Parent not found - exiting agent");
                let _ = cleanup_before_exit(&app_handle);
                std::process::exit(0);
            }
            let _ = WaitForSingleObject(handle, INFINITE);
            let _ = CloseHandle(handle);
            log::info!("[Lifecycle] Parent exited - exiting agent");
            let _ = cleanup_before_exit(&app_handle);
            std::process::exit(0);
        });
    }
}

// Handler to list recordings
async fn list_recordings_handler(
    State(state): State<AppState>,
) -> Result<impl IntoResponse, (StatusCode, String)> {
    match record::list_recordings(state.app_handle).await {
        Ok(recordings) => Ok((StatusCode::OK, Json(recordings))),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e.to_string())),
    }
}

// Handler to write a recording file
async fn write_recording_file_handler(
    State(state): State<AppState>,
    axum::extract::Path(id): axum::extract::Path<String>,
    Json(payload): Json<WriteFilePayload>,
) -> Result<StatusCode, (StatusCode, String)> {
    match record::write_recording_file(state.app_handle, id, payload.filename, payload.content)
        .await
    {
        Ok(_) => Ok(StatusCode::OK),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e.to_string())),
    }
}

// Handler to get a recording video URL for streaming
async fn get_recording_video_url_handler(
    State(state): State<AppState>,
    axum::extract::Path(id): axum::extract::Path<String>,
) -> impl IntoResponse {
    log::info!("[IPC] Getting video URL for recording: {}", id);

    match video_server::get_video_url(state.app_handle.clone(), &id).await {
        Ok(url) => {
            log::info!("[IPC] Video URL generated successfully: {}", url);
            (StatusCode::OK, Json(serde_json::json!({ "url": url }))).into_response()
        }
        Err(e) => {
            log::error!("[IPC] Failed to get video URL: {}", e);
            (
                StatusCode::NOT_FOUND,
                Json(serde_json::json!({ "error": e })),
            )
                .into_response()
        }
    }
}

// Handler to get a recording file (simplified)
async fn get_recording_file_handler(
    State(state): State<AppState>,
    axum::extract::Path(id): axum::extract::Path<String>,
    Query(query): Query<GetFileQuery>,
) -> Result<impl IntoResponse, (StatusCode, String)> {
    match record::get_recording_file(
        state.app_handle,
        id,
        query.filename,
        query.as_base64,
        query.as_path,
    )
    .await
    {
        Ok(content) => Ok((StatusCode::OK, content)),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e.to_string())),
    }
}

// Handler to start a recording
async fn start_recording_handler(
    State(state): State<AppState>,
    Json(payload): Json<StartRecordingPayload>,
) -> impl IntoResponse {
    match record::start_recording(state.app_handle.clone(), payload.demonstration, payload.fps)
        .await
    {
        Ok(_) => StatusCode::OK.into_response(),
        Err(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()).into_response(),
    }
}

// Handler to stop a recording
async fn stop_recording_handler(
    State(state): State<AppState>,
    Json(payload): Json<StopRecordingPayload>,
) -> Result<impl IntoResponse, (StatusCode, String)> {
    match record::stop_recording(state.app_handle.clone(), Some(payload.status)).await {
        Ok(recording_id) => Ok((StatusCode::OK, recording_id)),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e.to_string())),
    }
}

// Handler to delete a recording
async fn delete_recording_handler(
    State(state): State<AppState>,
    axum::extract::Path(id): axum::extract::Path<String>,
) -> Result<StatusCode, (StatusCode, String)> {
    match record::delete_recording(state.app_handle, id).await {
        Ok(_) => Ok(StatusCode::OK),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e.to_string())),
    }
}

// Handler to create a zip of a recording
async fn create_recording_zip_handler(
    State(state): State<AppState>,
    axum::extract::Path(id): axum::extract::Path<String>,
) -> Result<impl IntoResponse, (StatusCode, String)> {
    match record::create_recording_zip(state.app_handle, id.clone()).await {
        Ok(zip_data) => {
            let filename = format!("attachment; filename=\"recording_{}.zip\"", id);
            let mut headers = axum::http::HeaderMap::new();
            headers.insert(
                axum::http::header::CONTENT_TYPE,
                "application/zip"
                    .parse()
                    .unwrap_or_else(|_| "application/octet-stream".parse().unwrap()),
            );
            headers.insert(
                axum::http::header::CONTENT_DISPOSITION,
                filename
                    .parse()
                    .unwrap_or_else(|_| "download.zip".parse().unwrap()),
            );
            Ok((headers, zip_data))
        }
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e.to_string())),
    }
}

// Handler to list applications
async fn list_apps_handler(
    State(state): State<AppState>,
) -> Result<impl IntoResponse, (StatusCode, String)> {
    // The second parameter `include_icons` is an `Option<bool>`, we set it to `Some(true)` to get the icons.
    match list_apps(state.app_handle, Some(true)).await {
        Ok(apps) => Ok((StatusCode::OK, Json(apps))),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e.to_string())),
    }
}

// Handler to take a screenshot
async fn take_screenshot_handler() -> Result<impl IntoResponse, (StatusCode, String)> {
    match take_screenshot().await {
        Ok(base64_image) => Ok((StatusCode::OK, base64_image)),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e.to_string())),
    }
}

// Handler for `get_upload_data_allowed`
async fn get_upload_data_allowed_handler(State(state): State<AppState>) -> impl IntoResponse {
    (
        StatusCode::OK,
        Json(get_upload_data_allowed(state.app_handle)),
    )
}

// Handler for `set_upload_data_allowed`
async fn set_upload_data_allowed_handler(
    State(state): State<AppState>,
    Json(payload): Json<SetUploadAllowedPayload>,
) -> Result<StatusCode, (StatusCode, String)> {
    match set_upload_data_allowed(state.app_handle, payload.allowed) {
        Ok(_) => Ok(StatusCode::OK),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e.to_string())),
    }
}

// Handler for `has_ax_perms`
async fn has_ax_perms_handler() -> impl IntoResponse {
    log::info!("[IPC] Processing has_ax_perms request");
    let status = has_ax_perms();
    log::info!("[IPC] has_ax_perms result: {}", status);
    (
        StatusCode::OK,
        Json(PermissionStatus {
            has_permission: status,
        }),
    )
}

// --- Handlers for permissions and settings ---

async fn has_record_perms_handler() -> impl IntoResponse {
    log::info!("[IPC] Processing has_record_perms request");
    let status = has_record_perms();
    log::info!("[IPC] has_record_perms result: {}", status);
    (
        StatusCode::OK,
        Json(PermissionStatus {
            has_permission: status,
        }),
    )
}

async fn request_record_perms_handler() -> Result<impl IntoResponse, (StatusCode, String)> {
    log::info!("[IPC] Processing request_record_perms request");
    match request_record_perms().await {
        Ok(granted) => {
            log::info!("[IPC] request_record_perms result: {}", granted);
            Ok((StatusCode::OK, Json(serde_json::json!({"granted": granted}))))
        },
        Err(e) => {
            log::error!("[IPC] request_record_perms error: {}", e);
            Err((StatusCode::INTERNAL_SERVER_ERROR, e))
        }
    }
}

async fn request_ax_perms_handler() -> Result<impl IntoResponse, (StatusCode, String)> {
    log::info!("[IPC] Processing request_ax_perms request");
    match request_ax_perms().await {
        Ok(granted) => {
            log::info!("[IPC] request_ax_perms result: {}", granted);
            Ok((StatusCode::OK, Json(serde_json::json!({"granted": granted}))))
        },
        Err(e) => {
            log::error!("[IPC] request_ax_perms error: {}", e);
            Err((StatusCode::INTERNAL_SERVER_ERROR, e))
        }
    }
}

// --- Handlers for tools ---

async fn check_tools_handler() -> Result<impl IntoResponse, (StatusCode, String)> {
    match check_tools().await {
        Ok(status) => Ok((StatusCode::OK, Json(status))),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e.to_string())),
    }
}

// --- Handlers for recording actions ---

async fn process_recording_handler(
    State(state): State<AppState>,
    axum::extract::Path(id): axum::extract::Path<String>,
    Query(query): Query<ProcessRecordingQuery>,
    headers: axum::http::HeaderMap,
) -> Result<StatusCode, (StatusCode, String)> {
    // Extract connect token from headers
    let connect_token = headers
        .get("x-connect-token")
        .and_then(|v| v.to_str().ok())
        .map(|s| s.to_string());

    match process_recording(state.app_handle, id, connect_token, query.backend_url).await {
        Ok(_) => Ok(StatusCode::OK),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e.to_string())),
    }
}

// Handler to get the deep link URL
async fn get_deeplink_handler(
    State(state): State<AppState>,
) -> Result<impl IntoResponse, (StatusCode, String)> {
    let deeplink_state = state.app_handle.state::<DeepLinkState>();
    let mut url = match deeplink_state.0.lock() {
        Ok(url) => url,
        Err(poisoned) => {
            log::warn!("[IPC Server] DeepLinkState mutex was poisoned, recovering...");
            poisoned.into_inner()
        }
    };

    // Take the URL from the state, leaving `None` in its place.
    if let Some(url_str) = url.take() {
        Ok((StatusCode::OK, Json(serde_json::json!({ "url": url_str }))))
    } else {
        Ok((StatusCode::OK, Json(serde_json::json!({ "url": null }))))
    }
}

// Handler to open an external URL
pub async fn open_external_url_handler(
    State(state): State<AppState>,
    Json(payload): Json<OpenUrlPayload>,
) -> Result<StatusCode, (StatusCode, String)> {
    match open_external_url(&state.app_handle, &payload) {
        Ok(_) => Ok(StatusCode::OK),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e)),
    }
}

// Get the platform of the current system
pub async fn get_platform_handler(State(_state): State<AppState>) -> String {
    get_platform()
}

// Transaction handlers

// Handler to generate a new session token
async fn generate_session_token_handler() -> Result<impl IntoResponse, (StatusCode, String)> {
    match generate_session_token() {
        Ok(token) => Ok((StatusCode::OK, Json(token))),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e)),
    }
}

// Handler to prepare a transaction request
async fn prepare_transaction_request_handler(
    State(state): State<AppState>,
    Json(payload): Json<PrepareTransactionPayload>,
) -> Result<impl IntoResponse, (StatusCode, String)> {
    match prepare_transaction_request(
        state.app_handle,
        payload.transaction_type,
        payload.session_token,
        payload.creator,
        payload.token,
        payload.amount,
        payload.pool_address,
    )
    .await
    {
        Ok(request) => Ok((StatusCode::OK, Json(request))),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e)),
    }
}

// Handler to generate deep link URL
async fn generate_deep_link_handler(
    Json(payload): Json<GenerateDeepLinkPayload>,
) -> Result<impl IntoResponse, (StatusCode, String)> {
    // Convert JSON value to TransactionRequest
    let request: TransactionRequest = match serde_json::from_value(payload.request) {
        Ok(req) => req,
        Err(e) => {
            return Err((
                StatusCode::BAD_REQUEST,
                format!("Invalid request format: {}", e),
            ))
        }
    };

    match generate_transaction_deep_link(request, payload.website_base_url) {
        Ok(url) => Ok((StatusCode::OK, Json(url))),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e)),
    }
}

// Handler to get transaction request by ID
async fn get_transaction_request_handler(
    State(state): State<AppState>,
    axum::extract::Path(request_id): axum::extract::Path<String>,
) -> Result<impl IntoResponse, (StatusCode, String)> {
    match get_transaction_request(state.app_handle, request_id).await {
        Ok(Some(request)) => Ok((StatusCode::OK, Json(request))),
        Ok(None) => Err((
            StatusCode::NOT_FOUND,
            "Transaction request not found".to_string(),
        )),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e)),
    }
}

// Handler to update transaction status
async fn update_transaction_status_handler(
    State(state): State<AppState>,
    axum::extract::Path(request_id): axum::extract::Path<String>,
    Json(payload): Json<UpdateTransactionStatusPayload>,
) -> Result<StatusCode, (StatusCode, String)> {
    // Parse status
    let status = match payload.status.as_str() {
        "pending" => TransactionStatus::Pending,
        "validating" => TransactionStatus::Validating,
        "ready" => TransactionStatus::Ready,
        "executing" => TransactionStatus::Executing,
        "completed" => TransactionStatus::Completed,
        "failed" => TransactionStatus::Failed,
        "cancelled" => TransactionStatus::Cancelled,
        _ => return Err((StatusCode::BAD_REQUEST, "Invalid status".to_string())),
    };

    // Parse gas estimate if provided
    let gas_estimate = if let Some(estimate_json) = payload.gas_estimate {
        match serde_json::from_value(estimate_json) {
            Ok(estimate) => Some(estimate),
            Err(e) => {
                return Err((
                    StatusCode::BAD_REQUEST,
                    format!("Invalid gas estimate: {}", e),
                ))
            }
        }
    } else {
        None
    };

    match update_transaction_status(state.app_handle, request_id, status, gas_estimate).await {
        Ok(_) => Ok(StatusCode::OK),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e)),
    }
}

// Handler to list pending transactions
async fn list_pending_transactions_handler(
    State(state): State<AppState>,
) -> Result<impl IntoResponse, (StatusCode, String)> {
    match list_pending_transactions(state.app_handle).await {
        Ok(transactions) => Ok((StatusCode::OK, Json(transactions))),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e)),
    }
}

// Handler to clean up old transactions
async fn cleanup_old_transactions_handler(
    State(state): State<AppState>,
) -> Result<impl IntoResponse, (StatusCode, String)> {
    match cleanup_old_transactions(state.app_handle).await {
        Ok(count) => Ok((StatusCode::OK, Json(count))),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e)),
    }
}

// Handler to handle transaction callback
async fn handle_transaction_callback_handler(
    State(state): State<AppState>,
    Json(payload): Json<TransactionCallbackPayload>,
) -> Result<StatusCode, (StatusCode, String)> {
    match handle_transaction_callback(
        state.app_handle,
        payload.status,
        payload.tx_hash,
        payload.message,
        payload.transaction_type,
    )
    .await
    {
        Ok(_) => Ok(StatusCode::OK),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e)),
    }
}

// Handler to create a filtered recording zip
async fn create_filtered_recording_zip_handler(
    State(state): State<AppState>,
    axum::extract::Path(id): axum::extract::Path<String>,
    Json(payload): Json<FilteredZipPayload>,
) -> Result<impl IntoResponse, (StatusCode, String)> {
    let mut deleted_ranges: Vec<(f64, f64)> = payload
        .deleted_ranges
        .into_iter()
        .map(|r| (r.start, r.end))
        .collect();

    // Validate and sort deleted ranges
    deleted_ranges.sort_by(|a, b| a.0.partial_cmp(&b.0).unwrap());
    
    // Validate ranges are non-overlapping and positive
    for (i, (start, end)) in deleted_ranges.iter().enumerate() {
        if *start < 0.0 || *end <= *start {
            log::error!(
                "🚨 [create_filtered_recording_zip_handler] Invalid range at index {}: {:.2}ms to {:.2}ms",
                i, start, end
            );
            return Err((
                StatusCode::BAD_REQUEST,
                format!("Invalid deleted range: {:.2}ms to {:.2}ms", start, end)
            ));
        }
        
        if i > 0 && deleted_ranges[i-1].1 > *start {
            log::error!(
                "🚨 [create_filtered_recording_zip_handler] Overlapping ranges: {:?} and {:?}",
                deleted_ranges[i-1], (start, end)
            );
            return Err((
                StatusCode::BAD_REQUEST,
                "Deleted ranges must not overlap".to_string()
            ));
        }
    }

    log::info!(
        "🔍 [create_filtered_recording_zip_handler] Processing recording {} with {} validated deleted ranges (ms): {:?}",
        id,
        deleted_ranges.len(),
        deleted_ranges
    );

    // Log each range for debugging
    for (i, (start_ms, end_ms)) in deleted_ranges.iter().enumerate() {
        log::info!(
            "🔍 [Range {}] Deleting {:.3}s to {:.3}s (duration: {:.3}s)",
            i,
            start_ms / 1000.0,
            end_ms / 1000.0,
            (end_ms - start_ms) / 1000.0
        );
    }

    match record::create_filtered_recording_zip(state.app_handle, id.clone(), deleted_ranges).await
    {
        Ok(zip_data) => {
            let filename = format!("attachment; filename=\"recording_{}_filtered.zip\"", id);
            let mut headers = axum::http::HeaderMap::new();
            headers.insert(
                axum::http::header::CONTENT_TYPE,
                "application/zip"
                    .parse()
                    .unwrap_or_else(|_| "application/octet-stream".parse().unwrap()),
            );
            headers.insert(
                axum::http::header::CONTENT_DISPOSITION,
                filename
                    .parse()
                    .unwrap_or_else(|_| "download.zip".parse().unwrap()),
            );
            Ok((headers, zip_data))
        }
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e.to_string())),
    }
}

// Handler to open logs folder
async fn open_logs_folder_handler(
    State(state): State<AppState>,
) -> Result<StatusCode, (StatusCode, String)> {
    match open_logs_folder(state.app_handle) {
        Ok(_) => Ok(StatusCode::OK),
        Err(e) => Err((StatusCode::INTERNAL_SERVER_ERROR, e)),
    }
}
