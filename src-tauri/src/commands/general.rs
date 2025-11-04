//! General Tauri commands for greeting, screenshots, and application listing.
//!
//! This module provides basic commands for frontend-backend interaction, including a greeting, screenshot capture, and listing installed applications.

use crate::tools::helpers::lock_with_timeout;
use crate::tools::sanitize_and_check_path;
use crate::utils::settings::get_custom_app_local_data_dir;
use base64::{engine::general_purpose::STANDARD as BASE64, Engine as _};
use chrono::Utc;
use log::info;
use serde::{Deserialize, Serialize};
use serde_json;
use tauri::Manager;
use std::{
    fs::File,
    io::{BufReader, BufWriter, Cursor, Write},
    path::Path,
    process::Command,
    sync::{Mutex, OnceLock},
    time::Duration,
};
use xcap::{image::ImageFormat, Monitor};

#[cfg(not(target_os = "linux"))]
use app_finder::{AppCommon, AppFinder};

// Learn more about Tauri commands at https://tauri.app/develop/calling-rust/
#[tauri::command]
pub fn greet(name: &str) -> String {
    if let Err(e) = validate_name(name) {
        return format!("Invalid name: {}", e);
    }
    format!("Hello, {}! You've been greeted from Rust!", name)
}

#[tauri::command]
pub async fn take_screenshot() -> Result<String, String> {
    // Get primary monitor
    let monitors = Monitor::all().map_err(|e| e.to_string())?;
    let primary = monitors
        .into_iter()
        .next()
        .ok_or_else(|| "No monitor found".to_string())?;

    // Capture image
    let xcap_image = primary.capture_image().map_err(|e| e.to_string())?;

    // Convert to PNG bytes
    let mut buffer = Vec::new();
    let mut cursor = Cursor::new(&mut buffer);
    xcap_image
        .write_to(&mut cursor, ImageFormat::Png)
        .map_err(|e| e.to_string())?;

    // Convert to base64
    Ok(format!("data:image/png;base64,{}", BASE64.encode(&buffer)))
}

// Global lock for app list cache concurrency
static APP_LIST_CACHE_LOCK: OnceLock<Mutex<()>> = OnceLock::new();

#[derive(Serialize, Deserialize)]
struct AppListCache {
    timestamp: i64, // Unix timestamp (seconds)
    apps: Vec<serde_json::Value>,
}

const APP_LIST_CACHE_MAX_AGE_SECS: i64 = 600; // 10 minutes
const APP_LIST_CACHE_MAX_LEN: usize = 1000;

#[tauri::command]
pub async fn list_apps(
    app: tauri::AppHandle,
    include_icons: Option<bool>,
) -> Result<Vec<serde_json::Value>, String> {
    #[cfg(not(target_os = "linux"))]
    {
        let base =
            get_custom_app_local_data_dir(&app).map_err(|e| format!("Failed to get app data directory: {}", e))?;
        let path = sanitize_and_check_path(&base, Path::new("app_list.json"))?;

        // Concurrency lock
        let lock = APP_LIST_CACHE_LOCK.get_or_init(|| Mutex::new(()));
        let _guard = match lock_with_timeout(lock, Duration::from_secs(2)) {
            Some(g) => g,
            None => return Err("App list cache is busy, please try again".to_string()),
        };

        let now = Utc::now().timestamp();
        let exists = path.exists();
        if exists {
            info!("[App List] Using App List cache.");
            let app_cache = File::open(&path).map_err(|e| format!("Could not open file: {}", e))?;
            let app_cache_reader = BufReader::new(app_cache);
            let cache: Result<AppListCache, _> = serde_json::from_reader(app_cache_reader);
            if let Ok(cache) = cache {
                // Check cache freshness
                if now - cache.timestamp < APP_LIST_CACHE_MAX_AGE_SECS {
                    return Ok(cache.apps);
                } else {
                    info!("[App List] Cache expired, refreshing...");
                }
            } else {
                info!("[App List] Cache file invalid, refreshing...");
            }
        } else {
            info!("[App List] No App List cache found. Gathering application data...");
        }

        let apps = AppFinder::list();
        let filtered: Vec<_> = apps
            .into_iter()
            .filter(|item| !item.path.contains("Frameworks"))
            .collect();

        let mut results = filtered
            .into_iter()
            .map(|app| {
                let mut json = serde_json::json!({
                    "name": app.name,
                    "path": app.path,
                });

                if include_icons.unwrap_or(false) {
                    if let Ok(icon) = app.get_app_icon_base64(64) {
                        json.as_object_mut()
                            .unwrap()
                            .insert("icon".to_string(), serde_json::Value::String(icon));
                    }
                }
                json
            })
            .collect::<Vec<_>>();

        // Limit cache length
        if results.len() > APP_LIST_CACHE_MAX_LEN {
            results.truncate(APP_LIST_CACHE_MAX_LEN);
        }

        let cache = AppListCache {
            timestamp: now,
            apps: results.clone(),
        };

        let file = File::create(&path).map_err(|e| format!("Error creating file: {}", e))?;
        let metadata = file
            .metadata()
            .map_err(|e| format!("Error getting file metadata: {}", e))?;
        if metadata.permissions().readonly() {
            return Err("File is not writable".to_string());
        }
        let mut writer = BufWriter::new(file);
        serde_json::to_writer(&mut writer, &cache)
            .map_err(|e| format!("Error writing JSON: {}", e))?;
        writer
            .flush()
            .map_err(|e| format!("Failed to flush buffer: {}", e))?;
        Ok(results)
    }

    #[cfg(target_os = "linux")]
    {
        // Return empty list for Linux
        Ok(Vec::new())
    }
}

fn validate_name(name: &str) -> Result<(), String> {
    if name.trim().is_empty() {
        return Err("Name cannot be empty".to_string());
    }
    if name.len() > 100 {
        return Err("Name is too long".to_string());
    }
    Ok(())
}

#[tauri::command]
pub fn open_logs_folder(app: tauri::AppHandle) -> Result<(), String> {
    let logs_dir = app
        .path()
        .app_log_dir()
        .map_err(|e| format!("Failed to get logs directory: {}", e))?;

    if !logs_dir.exists() {
        return Err("Logs directory does not exist".to_string());
    }

    #[cfg(target_os = "macos")]
    {
        Command::new("open")
            .arg(&logs_dir)
            .spawn()
            .map_err(|e| format!("Failed to open logs folder on macOS: {}", e))?;
    }

    #[cfg(target_os = "windows")]
    {
        Command::new("explorer")
            .arg(&logs_dir)
            .spawn()
            .map_err(|e| format!("Failed to open logs folder on Windows: {}", e))?;
    }

    #[cfg(target_os = "linux")]
    {
        Command::new("xdg-open")
            .arg(&logs_dir)
            .spawn()
            .map_err(|e| format!("Failed to open logs folder on Linux: {}", e))?;
    }

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_validate_name_empty() {
        let result = validate_name("");
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Name cannot be empty");
    }

    #[test]
    fn test_validate_name_too_long() {
        let long_name = "a".repeat(101);
        let result = validate_name(&long_name);
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Name is too long");
    }

    #[test]
    fn test_validate_name_valid() {
        let result = validate_name("Alice");
        assert!(result.is_ok());
    }
}
