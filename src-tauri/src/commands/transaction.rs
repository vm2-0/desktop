//! Transaction-related Tauri commands for Phase 3.5 desktop transaction workflow.
//!
//! This module provides commands for handling deep link transactions, gas estimation,
//! and session-based transaction preparation for the Clones desktop app.

use crate::tools::sanitize_and_check_path;
use crate::utils::settings::get_custom_app_local_data_dir;
use log::{error, info, warn};
use serde::{Deserialize, Serialize};
use std::{
    fs::{create_dir_all, File},
    io::{BufReader, BufWriter},
    path::Path,
    sync::{Mutex, OnceLock},
    time::{SystemTime, UNIX_EPOCH},
};
use uuid::Uuid;

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct TransactionRequest {
    pub id: String,
    pub transaction_type: String,
    pub session_token: String,
    pub creator: Option<String>,
    pub token: Option<String>,
    pub amount: Option<String>,
    pub pool_address: Option<String>,
    pub timestamp: u64,
    pub status: TransactionStatus,
    pub created_at: u64,
    pub gas_estimate: Option<GasEstimate>,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct GasEstimate {
    pub gas_limit: String,
    pub gas_price: String,
    pub total_cost: String,
    pub is_expensive: bool,
    pub estimated_at: u64,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub enum TransactionStatus {
    Pending,
    Validating,
    Ready,
    Executing,
    Completed,
    Failed,
    Cancelled,
}

// Global lock for transaction cache
static TRANSACTION_CACHE_LOCK: OnceLock<Mutex<()>> = OnceLock::new();

/// Generate a new session token for secure transaction workflow
#[tauri::command]
pub fn generate_session_token() -> Result<String, String> {
    let token = Uuid::new_v4().to_string();
    info!("[Transaction] Generated new session token: {}", token);
    Ok(token)
}

/// Prepare a transaction request for deep link workflow
#[tauri::command]
pub async fn prepare_transaction_request(
    app: tauri::AppHandle,
    transaction_type: String,
    session_token: String,
    creator: Option<String>,
    token: Option<String>,
    amount: Option<String>,
    pool_address: Option<String>,
) -> Result<TransactionRequest, String> {
    let now = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map_err(|e| format!("Time error: {}", e))?
        .as_millis() as u64;

    let request = TransactionRequest {
        id: Uuid::new_v4().to_string(),
        transaction_type,
        session_token,
        creator,
        token,
        amount,
        pool_address,
        timestamp: now,
        status: TransactionStatus::Pending,
        created_at: now,
        gas_estimate: None,
    };

    // Save to local storage for tracking
    save_transaction_request(&app, &request).await?;

    info!("[Transaction] Prepared transaction request: {:?}", request);
    Ok(request)
}

/// Generate deep link URL for transaction
#[tauri::command]
pub fn generate_transaction_deep_link(
    request: TransactionRequest,
    website_base_url: Option<String>,
) -> Result<String, String> {
    // Use environment variable API_WEBSITE_URL first, then parameter, then fallback
    let base_url = std::env::var("API_WEBSITE_URL")
        .ok()
        .or(website_base_url)
        .unwrap_or_else(|| "https://clones-ai.com".to_string());

    let mut params = vec![
        format!("type={}", request.transaction_type),
        format!("sessionToken={}", request.session_token),
        format!("timestamp={}", request.timestamp),
    ];

    if let Some(creator) = request.creator {
        params.push(format!("creator={}", creator));
    }
    if let Some(token) = request.token {
        params.push(format!("token={}", token));
    }
    if let Some(amount) = request.amount {
        params.push(format!("amount={}", amount));
    }
    if let Some(pool_address) = request.pool_address {
        params.push(format!("poolAddress={}", pool_address));
    }

    let url = format!("{}/wallet/transaction?{}", base_url, params.join("&"));

    info!("[Transaction] Generated deep link: {}", url);
    Ok(url)
}

/// Get stored transaction request by ID
#[tauri::command]
pub async fn get_transaction_request(
    app: tauri::AppHandle,
    request_id: String,
) -> Result<Option<TransactionRequest>, String> {
    let base_dir = get_custom_app_local_data_dir(&app)
        .map_err(|e| format!("Failed to get app data directory: {}", e))?;
    let transactions_dir = base_dir.join("transactions");
    let request_path = sanitize_and_check_path(
        &transactions_dir,
        Path::new(&format!("{}.json", request_id)),
    )?;

    if !request_path.exists() {
        return Ok(None);
    }

    let file =
        File::open(&request_path).map_err(|e| format!("Failed to open transaction file: {}", e))?;
    let reader = BufReader::new(file);
    let request: TransactionRequest = serde_json::from_reader(reader)
        .map_err(|e| format!("Failed to parse transaction request: {}", e))?;

    Ok(Some(request))
}

/// Update transaction request status
#[tauri::command]
pub async fn update_transaction_status(
    app: tauri::AppHandle,
    request_id: String,
    status: TransactionStatus,
    gas_estimate: Option<GasEstimate>,
) -> Result<(), String> {
    let mut request = get_transaction_request(app.clone(), request_id.clone())
        .await?
        .ok_or("Transaction request not found")?;

    request.status = status;
    if let Some(estimate) = gas_estimate {
        request.gas_estimate = Some(estimate);
    }

    save_transaction_request(&app, &request).await?;
    info!(
        "[Transaction] Updated transaction {} status: {:?}",
        request_id, request.status
    );
    Ok(())
}

/// List all pending transaction requests
#[tauri::command]
pub async fn list_pending_transactions(
    app: tauri::AppHandle,
) -> Result<Vec<TransactionRequest>, String> {
    let base_dir = get_custom_app_local_data_dir(&app)
        .map_err(|e| format!("Failed to get app data directory: {}", e))?;
    let transactions_dir = base_dir.join("transactions");

    if !transactions_dir.exists() {
        return Ok(Vec::new());
    }

    let mut transactions = Vec::new();
    let entries = std::fs::read_dir(&transactions_dir)
        .map_err(|e| format!("Failed to read transactions directory: {}", e))?;

    for entry in entries {
        let entry = entry.map_err(|e| format!("Failed to read directory entry: {}", e))?;
        let path = entry.path();

        if path.extension().and_then(|s| s.to_str()) == Some("json") {
            match File::open(&path) {
                Ok(file) => {
                    let reader = BufReader::new(file);
                    match serde_json::from_reader::<_, TransactionRequest>(reader) {
                        Ok(request) => {
                            // Only include pending transactions
                            match request.status {
                                TransactionStatus::Pending
                                | TransactionStatus::Validating
                                | TransactionStatus::Ready => {
                                    transactions.push(request);
                                }
                                _ => {} // Skip completed/failed transactions
                            }
                        }
                        Err(e) => {
                            warn!(
                                "[Transaction] Failed to parse transaction file {:?}: {}",
                                path, e
                            );
                        }
                    }
                }
                Err(e) => {
                    warn!(
                        "[Transaction] Failed to open transaction file {:?}: {}",
                        path, e
                    );
                }
            }
        }
    }

    Ok(transactions)
}

/// Clean up old transaction requests (older than 1 hour)
#[tauri::command]
pub async fn cleanup_old_transactions(app: tauri::AppHandle) -> Result<u32, String> {
    let base_dir = get_custom_app_local_data_dir(&app)
        .map_err(|e| format!("Failed to get app data directory: {}", e))?;
    let transactions_dir = base_dir.join("transactions");

    if !transactions_dir.exists() {
        return Ok(0);
    }

    let now = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map_err(|e| format!("Time error: {}", e))?
        .as_millis() as u64;

    let one_hour_ago = now.saturating_sub(60 * 60 * 1000); // 1 hour in milliseconds
    let mut cleaned = 0u32;

    let entries = std::fs::read_dir(&transactions_dir)
        .map_err(|e| format!("Failed to read transactions directory: {}", e))?;

    for entry in entries {
        let entry = entry.map_err(|e| format!("Failed to read directory entry: {}", e))?;
        let path = entry.path();

        if path.extension().and_then(|s| s.to_str()) == Some("json") {
            match File::open(&path) {
                Ok(file) => {
                    let reader = BufReader::new(file);
                    match serde_json::from_reader::<_, TransactionRequest>(reader) {
                        Ok(request) => {
                            if request.created_at < one_hour_ago {
                                match std::fs::remove_file(&path) {
                                    Ok(_) => {
                                        cleaned += 1;
                                        info!(
                                            "[Transaction] Cleaned up old transaction: {}",
                                            request.id
                                        );
                                    }
                                    Err(e) => {
                                        warn!("[Transaction] Failed to remove old transaction file {:?}: {}", path, e);
                                    }
                                }
                            }
                        }
                        Err(e) => {
                            warn!("[Transaction] Failed to parse transaction file for cleanup {:?}: {}", path, e);
                        }
                    }
                }
                Err(e) => {
                    warn!(
                        "[Transaction] Failed to open transaction file for cleanup {:?}: {}",
                        path, e
                    );
                }
            }
        }
    }

    info!(
        "[Transaction] Cleaned up {} old transaction requests",
        cleaned
    );
    Ok(cleaned)
}

/// Handle transaction callback from deep link
#[tauri::command]
pub async fn handle_transaction_callback(
    _app: tauri::AppHandle,
    status: String,
    tx_hash: Option<String>,
    message: Option<String>,
    transaction_type: String,
) -> Result<(), String> {
    info!(
        "[Transaction] Received callback - status: {}, type: {}, tx_hash: {:?}, message: {:?}",
        status, transaction_type, tx_hash, message
    );

    // You could match specific transaction requests here by type/timestamp
    // For now, just log the callback
    match status.as_str() {
        "success" => {
            if let Some(hash) = tx_hash {
                info!("[Transaction] Transaction successful: {}", hash);
                // You could emit an event to the frontend here
            }
        }
        "error" => {
            if let Some(err_msg) = message {
                error!("[Transaction] Transaction failed: {}", err_msg);
            }
        }
        "cancelled" => {
            info!("[Transaction] Transaction cancelled by user");
        }
        _ => {
            warn!("[Transaction] Unknown callback status: {}", status);
        }
    }

    Ok(())
}

/// Save transaction request to local storage
async fn save_transaction_request(
    app: &tauri::AppHandle,
    request: &TransactionRequest,
) -> Result<(), String> {
    let lock = TRANSACTION_CACHE_LOCK.get_or_init(|| Mutex::new(()));
    let _guard = lock
        .lock()
        .map_err(|e| format!("Failed to acquire lock: {}", e))?;

    let base_dir = get_custom_app_local_data_dir(app)
        .map_err(|e| format!("Failed to get app data directory: {}", e))?;
    let transactions_dir = base_dir.join("transactions");

    // Ensure directory exists
    create_dir_all(&transactions_dir)
        .map_err(|e| format!("Failed to create transactions directory: {}", e))?;

    let request_path = sanitize_and_check_path(
        &transactions_dir,
        Path::new(&format!("{}.json", request.id)),
    )?;

    let file = File::create(&request_path)
        .map_err(|e| format!("Failed to create transaction file: {}", e))?;
    let writer = BufWriter::new(file);
    serde_json::to_writer_pretty(writer, request)
        .map_err(|e| format!("Failed to write transaction request: {}", e))?;

    Ok(())
}
