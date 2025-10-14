use serde::{Deserialize, Serialize};
use tauri::AppHandle;
use tauri_plugin_updater::UpdaterExt;

#[derive(Debug, Serialize, Deserialize)]
pub struct UpdateInfo {
    pub update_available: bool,
    pub version: Option<String>,
    pub date: Option<String>,
    pub body: Option<String>,
}

/// Check for updates using Tauri's secure updater
#[tauri::command]
pub async fn check_for_update(app: AppHandle) -> Result<UpdateInfo, String> {
    log::info!("[Updater] Getting updater instance...");
    match app.updater() {
        Ok(updater) => {
            log::info!("[Updater] Updater instance obtained, checking for updates...");
            match updater.check().await {
                Ok(Some(update)) => {
                    log::info!("[Updater] Update found: version={}, body={:?}",
                        update.version, update.body);
                    Ok(UpdateInfo {
                        update_available: true,
                        version: Some(update.version.clone()),
                        date: update.date.map(|d| d.to_string()),
                        body: update.body.clone(),
                    })
                }
                Ok(None) => {
                    log::info!("[Updater] No update available");
                    Ok(UpdateInfo {
                        update_available: false,
                        version: None,
                        date: None,
                        body: None,
                    })
                }
                Err(e) => {
                    log::error!("[Updater] Error during update check: {:?}", e);
                    Err(format!("Failed to check for update: {}", e))
                }
            }
        }
        Err(e) => {
            log::error!("[Updater] Failed to get updater instance: {:?}", e);
            Err(format!("Updater not available: {}", e))
        }
    }
}

/// Install update using Tauri's secure updater (with signature verification)
#[tauri::command]
pub async fn install_update(app: AppHandle) -> Result<(), String> {
    match app.updater() {
        Ok(updater) => {
            match updater.check().await {
                Ok(Some(update)) => {
                    match update.download_and_install(|_, _| {}, || {}).await {
                        Ok(_) => Ok(()),
                        Err(e) => Err(format!("Failed to install update: {}", e)),
                    }
                }
                Ok(None) => Err("No update available".to_string()),
                Err(e) => Err(format!("Failed to check for update: {}", e)),
            }
        }
        Err(e) => Err(format!("Updater not available: {}", e)),
    }
}