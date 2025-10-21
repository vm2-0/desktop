//! CQA API client for communicating with the backend CQA service.
//!
//! This module replaces the local CQA binary execution with API calls to the centralized backend service.

use crate::utils::settings::get_custom_app_local_data_dir;
use log::{error, info};
use reqwest::multipart::{Form, Part};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::fs;
use std::path::Path;
use tauri::AppHandle;
use tokio::fs as async_fs;

/// CQA scores returned by the backend
#[derive(Debug, Serialize, Deserialize)]
pub struct CQAScores {
    pub score: f64,
    pub confidence: f64,
    #[serde(rename = "confidenceReasoning")]
    pub confidence_reasoning: String,
    #[serde(rename = "outcomeAchievement")]
    pub outcome_achievement: f64,
    #[serde(rename = "outcomeAchievementReasoning")]
    pub outcome_achievement_reasoning: String,
    #[serde(rename = "processQuality")]
    pub process_quality: f64,
    #[serde(rename = "processQualityReasoning")]
    pub process_quality_reasoning: String,
    pub efficiency: f64,
    #[serde(rename = "efficiencyReasoning")]
    pub efficiency_reasoning: String,
    pub summary: String,
    pub observations: String,
    pub reasoning: String,
    pub version: Option<String>,
}

/// CQA metrics returned by the backend
#[derive(Debug, Serialize, Deserialize)]
pub struct CQAMetrics {
    #[serde(rename = "sessionId")]
    pub session_id: String,
    pub status: String,
    #[serde(rename = "totalRequests")]
    pub total_requests: i32,
    #[serde(rename = "successfulRequests")]
    pub successful_requests: Option<i32>,
    #[serde(rename = "failedRequests")]
    pub failed_requests: Option<i32>,
    #[serde(rename = "totalTokens")]
    pub total_tokens: i32,
    #[serde(rename = "totalDuration")]
    pub total_duration: i32,
    #[serde(rename = "averageRetries")]
    pub average_retries: f64,
}

/// Response from the CQA backend API
#[derive(Debug, Serialize, Deserialize)]
pub struct CQAResponse {
    pub success: bool,
    pub data: CQAData,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct CQAData {
    #[serde(rename = "recordingId")]
    pub recording_id: String,
    #[serde(rename = "generatedFiles")]
    pub generated_files: HashMap<String, String>,
    #[serde(rename = "processedAt")]
    pub processed_at: String,
}

/// Health check response from CQA backend
#[derive(Debug, Serialize, Deserialize)]
pub struct CQAHealthResponse {
    pub success: bool,
    pub data: Option<HashMap<String, String>>,
    pub error: Option<String>,
}

/// CQA API client
pub struct CQAApiClient {
    client: reqwest::Client,
    base_url: String,
}

impl CQAApiClient {
    /// Creates a new CQA API client
    pub fn new(base_url: String) -> Self {
        let client = reqwest::Client::new();
        Self { client, base_url }
    }

    /// Check if the CQA service is healthy
    pub async fn health_check(&self) -> Result<CQAHealthResponse, String> {
        let url = format!("{}/api/v1/forge/recordings/health", self.base_url);
        
        info!("[CQA API] Checking health at: {}", url);
        
        let response = self
            .client
            .get(&url)
            .send()
            .await
            .map_err(|e| format!("Failed to connect to CQA service: {}", e))?;

        let status = response.status();
        let body = response
            .text()
            .await
            .map_err(|e| format!("Failed to read response: {}", e))?;

        info!("[CQA API] Health check response ({}): {}", status, body);

        serde_json::from_str(&body)
            .map_err(|e| format!("Failed to parse health response: {}", e))
    }

    /// Process a recording by uploading files to the backend CQA service
    /// 
    /// # Arguments
    /// * `recording_id` - Validated recording identifier
    /// * `recording_dir` - Directory containing recording files
    /// * `connect_token` - Authentication token (required for API access)
    /// 
    /// # Errors
    /// Returns error if:
    /// - `connect_token` is None (authentication required)
    /// - Recording directory doesn't exist or is empty
    /// - Network request fails
    /// - Backend returns non-success status
    pub async fn process_recording(
        &self,
        recording_id: &str,
        recording_dir: &Path,
        connect_token: Option<String>,
    ) -> Result<CQAResponse, String> {
        // Validate recording ID to prevent injection attacks in URL
        validate_id(recording_id)?;
        
        let url = format!(
            "{}/api/v1/forge/recordings/{}/process",
            self.base_url, recording_id
        );

        info!(
            "[CQA API] Processing recording {} at directory: {}",
            recording_id,
            recording_dir.display()
        );

        // Collect all files in the recording directory
        let files = self.collect_recording_files(recording_dir)?;
        
        if files.is_empty() {
            return Err("No files found in recording directory".to_string());
        }

        info!("[CQA API] Found {} files to upload: {:?}", files.len(), files.keys().collect::<Vec<_>>());

        // Create multipart form with files
        let mut form = Form::new();
        
        for (filename, file_path) in files {
            let file_data = async_fs::read(&file_path)
                .await
                .map_err(|e| format!("Failed to read file {}: {}", filename, e))?;

            let part = Part::bytes(file_data)
                .file_name(filename.clone())
                .mime_str(self.get_mime_type(&filename))
                .map_err(|e| format!("Invalid MIME type for {}: {}", filename, e))?;

            form = form.part("files", part);
        }

        info!("[CQA API] Uploading to: {}", url);

        // Send request with wallet authentication (same as other desktop API calls)
        let token = connect_token.ok_or_else(|| {
            "Authentication required: missing x-connect-token header. Please ensure you're authenticated with a valid connect token.".to_string()
        })?;
            
        let response = self
            .client
            .post(&url)
            .header("x-connect-token", token)
            .multipart(form)
            .send()
            .await
            .map_err(|e| format!("Failed to upload recording: {}", e))?;

        let status = response.status();
        let body = response
            .text()
            .await
            .map_err(|e| format!("Failed to read response: {}", e))?;

        if !status.is_success() {
            error!("[CQA API] Request failed ({}): {}", status, body);
            return Err(format!("CQA processing failed ({}): {}", status, body));
        }

        info!("[CQA API] Processing completed successfully");
        
        serde_json::from_str(&body)
            .map_err(|e| format!("Failed to parse CQA response: {}", e))
    }

    /// Collect all files in the recording directory
    fn collect_recording_files(&self, recording_dir: &Path) -> Result<HashMap<String, std::path::PathBuf>, String> {
        let mut files = HashMap::new();
        
        if !recording_dir.exists() {
            return Err(format!("Recording directory does not exist: {}", recording_dir.display()));
        }

        let entries = fs::read_dir(recording_dir)
            .map_err(|e| format!("Failed to read recording directory: {}", e))?;

        for entry in entries {
            let entry = entry.map_err(|e| format!("Failed to read directory entry: {}", e))?;
            let path = entry.path();
            
            if path.is_file() {
                if let Some(filename) = path.file_name().and_then(|n| n.to_str()) {
                    // Filter common recording files
                    if self.is_valid_recording_file(filename) {
                        files.insert(filename.to_string(), path);
                    } else {
                        info!("[CQA API] Skipping file: {}", filename);
                    }
                }
            }
        }

        Ok(files)
    }

    /// Check if a file is a valid recording file type
    fn is_valid_recording_file(&self, filename: &str) -> bool {
        // Only allow the exact files that CQA expects
        match filename {
            "input_log.jsonl" => true,
            "input_log_meta.json" => true,
            "meta.json" => true,
            "recording.mp4" => true,
            _ => false,
        }
    }

    /// Get MIME type for a file based on extension
    fn get_mime_type(&self, filename: &str) -> &'static str {
        let filename_lower = filename.to_lowercase();
        
        if filename_lower.ends_with(".mp4") {
            "video/mp4"
        } else if filename_lower.ends_with(".webm") {
            "video/webm"
        } else if filename_lower.ends_with(".mov") {
            "video/quicktime"
        } else if filename_lower.ends_with(".png") {
            "image/png"
        } else if filename_lower.ends_with(".jpg") || filename_lower.ends_with(".jpeg") {
            "image/jpeg"
        } else if filename_lower.ends_with(".json") {
            "application/json"
        } else if filename_lower.ends_with(".txt") {
            "text/plain"
        } else {
            "application/octet-stream"
        }
    }
}

/// Validates that an ID is safe for file operations using whitelist approach
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

/// Process a recording using the backend CQA API
/// 
/// # Arguments
/// * `app` - Tauri application handle
/// * `recording_id` - Recording identifier (will be validated for security)
/// * `connect_token` - Authentication token from x-connect-token header (required)
/// 
/// # Errors
/// Returns error if:
/// - `recording_id` contains invalid characters (security validation)
/// - `connect_token` is None (authentication required)
/// - CQA service health check fails
/// - Recording directory not found
/// - Network or processing errors occur
pub async fn process_recording(app: &AppHandle, recording_id: &str, connect_token: Option<String>) -> Result<(), String> {
    // Validate recording ID to prevent path traversal attacks
    validate_id(recording_id)?;
    
    // Get the backend URL from environment or use default
    let backend_url = std::env::var("API_BACKEND_URL")
        .unwrap_or_else(|_| "http://localhost:8001".to_string());

    info!("[CQA API] Using backend URL: {}", backend_url);
    
    // Create API client
    let client = CQAApiClient::new(backend_url);
    
    // Check service health first
    match client.health_check().await {
        Ok(health) => {
            if !health.success {
                return Err(format!("CQA service is not healthy: {}", 
                    health.error.unwrap_or_else(|| "Unknown error".to_string())));
            }
            info!("[CQA API] Service health check passed");
        }
        Err(e) => {
            error!("[CQA API] Health check failed: {}", e);
            return Err(format!("CQA service health check failed: {}", e));
        }
    }

    // Get recording directory
    let recordings_dir = get_custom_app_local_data_dir(app)
        .map_err(|e| format!("Failed to get app data directory: {}", e))?
        .join("recordings")
        .join(recording_id);

    if !recordings_dir.exists() {
        return Err(format!("Recording directory not found: {}", recordings_dir.display()));
    }

    // Process the recording
    match client.process_recording(recording_id, &recordings_dir, connect_token).await {
        Ok(response) => {
            info!("[CQA API] Processing completed successfully");
            info!("[CQA API] Generated {} files: {:?}", 
                response.data.generated_files.len(), 
                response.data.generated_files.keys().collect::<Vec<_>>());
            
            // Save generated files locally
            save_generated_files_locally(&recordings_dir, &response.data.generated_files)?;
            
            Ok(())
        }
        Err(e) => {
            error!("[CQA API] Processing failed: {}", e);
            Err(e)
        }
    }
}

/// Save generated files locally to reproduce the same behavior as the original CQA
fn save_generated_files_locally(recording_dir: &Path, generated_files: &HashMap<String, String>) -> Result<(), String> {
    for (filename, content) in generated_files {
        let file_path = recording_dir.join(filename);
        
        fs::write(&file_path, content)
            .map_err(|e| format!("Failed to write {}: {}", filename, e))?;
        
        info!("[CQA API] Saved generated file to: {}", file_path.display());
    }

    Ok(())
}