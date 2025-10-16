//! AxTree tool integration for running and polling the dump-tree binary.
use crate::tools::helpers::lock_with_timeout;
use log::info;
use serde_json::{json, Value};
use std::sync::{Arc, Mutex, OnceLock};
use std::thread;
use std::time::{Duration, Instant};

static RECORDING_MODE: OnceLock<Arc<Mutex<bool>>> = OnceLock::new();
static LAST_INTERACTION_TIME: OnceLock<Arc<Mutex<Option<Instant>>>> = OnceLock::new();

/// Recursively converts floating point coordinates to integers in JSON objects
/// This ensures compatibility with the backend API which expects u32 coordinates
fn convert_coordinates_to_integers(obj: &mut serde_json::Map<String, Value>) {
    // Convert bbox coordinates
    if let Some(bbox) = obj.get_mut("bbox").and_then(|v| v.as_object_mut()) {
        for coord_key in ["x", "y", "width", "height"] {
            if let Some(coord_val) = bbox.get_mut(coord_key) {
                if let Some(float_val) = coord_val.as_f64() {
                    *coord_val = json!(float_val.round().max(0.0) as u32);
                }
            }
        }
    }

    // Recursively process children
    if let Some(children) = obj.get_mut("children").and_then(|v| v.as_array_mut()) {
        for child in children {
            if let Some(child_obj) = child.as_object_mut() {
                convert_coordinates_to_integers(child_obj);
            }
        }
    }

    // Process data.tree for event format
    if let Some(data) = obj.get_mut("data").and_then(|v| v.as_object_mut()) {
        if let Some(tree) = data.get_mut("tree").and_then(|v| v.as_array_mut()) {
            for app in tree {
                if let Some(app_obj) = app.as_object_mut() {
                    convert_coordinates_to_integers(app_obj);
                }
            }
        }
    }
}

/// Triggers an immediate AX tree dump when significant user interaction occurs
pub fn trigger_ui_dump_on_interaction<R: tauri::Runtime>(
    _app: tauri::AppHandle<R>,
) -> Result<(), String> {
    println!("[DEBUG AXTREE] trigger_ui_dump_on_interaction function called!");
    // Only trigger during recording mode
    let is_recording = {
        if let Some(recording_mode) = RECORDING_MODE.get() {
            let lock = lock_with_timeout(recording_mode, Duration::from_secs(1));
            if let Some(recording) = lock {
                *recording
            } else {
                false
            }
        } else {
            false
        }
    };

    println!("[DEBUG AXTREE] is_recording: {}", is_recording);
    if !is_recording {
        println!("[DEBUG AXTREE] Not recording, skipping AXTree extraction");
        return Ok(());
    }

    // Debounce: avoid multiple captures within 500ms
    let last_time = LAST_INTERACTION_TIME.get_or_init(|| Arc::new(Mutex::new(None)));
    if let Ok(mut last) = last_time.lock() {
        let now = Instant::now();
        if let Some(last_instant) = *last {
            if now.duration_since(last_instant) < Duration::from_millis(500) {
                return Ok(()); // Skip this capture, too recent
            }
        }
        *last = Some(now);
    }

    info!("[AxTree] Triggering UI dump due to user interaction");

    thread::spawn(move || {
        use crate::tools::axtree_native;

        println!("[DEBUG AXTREE] About to call extract_native_tree");
        // Extract using native API
        let result = axtree_native::extract_native_tree(Some(0)); // TODO: Calculate actual display index
        println!(
            "[DEBUG AXTREE] extract_native_tree returned: {:?}",
            result.is_ok()
        );

        match result {
            Ok(mut json) => {
                if let Some(obj) = json.as_object_mut() {
                    // Check if Clones app is focused and skip if so
                    let should_skip = if let Some(data) =
                        obj.get("data").and_then(|v| v.as_object())
                    {
                        if let Some(focused_app) =
                            data.get("focused_app").and_then(|v| v.as_object())
                        {
                            if let Some(name) = focused_app.get("name").and_then(|v| v.as_str()) {
                                name == "clones_desktop"
                                    || name == "clones"
                                    || name == "clones-desktop"
                            } else {
                                false
                            }
                        } else {
                            false
                        }
                    } else {
                        false
                    };

                    if should_skip {
                        info!("[AxTree] Skipping interaction - Clones app is focused");
                        return;
                    }

                    obj.insert("event".to_string(), json!("axtree_interaction"));

                    // Calculate app_status before logging
                    info!("[AxTree] Starting app_status calculation");

                    // First, extract data immutably to calculate status
                    let app_status = if let Some(data) = obj.get("data").and_then(|v| v.as_object())
                    {
                        info!("[AxTree] Found data object for app_status");

                        let focused_app_name = data
                            .get("focused_app")
                            .and_then(|v| v.as_object())
                            .and_then(|app| app.get("name"))
                            .and_then(|name| name.as_str());

                        let available_apps: Vec<String> = data
                            .get("tree")
                            .and_then(|v| v.as_array())
                            .map(|tree| {
                                tree.iter()
                                    .filter_map(|app| {
                                        app.get("name")
                                            .and_then(|n| n.as_str())
                                            .map(|s| s.to_string())
                                    })
                                    .collect()
                            })
                            .unwrap_or_default();

                        info!(
                            "[AxTree] Focused app: {:?}, Available apps count: {}",
                            focused_app_name,
                            available_apps.len()
                        );

                        if focused_app_name.is_some() {
                            // We have a focused app detected
                            if !available_apps.is_empty() {
                                info!(
                                    "[AxTree] App status: ready (focused app: {:?})",
                                    focused_app_name
                                );
                                "ready"
                            } else {
                                info!("[AxTree] App status: launching (focused but no available apps)");
                                "launching"
                            }
                        } else {
                            // No focused app detected by native API, but we might have apps available
                            if !available_apps.is_empty() {
                                info!("[AxTree] No focused app detected, but {} apps available - status ready", available_apps.len());
                                "ready"
                            } else {
                                info!("[AxTree] App status: unknown (no focused app and no available apps)");
                                "unknown"
                            }
                        }
                    } else {
                        info!("[AxTree] App status: unknown (no data object)");
                        "unknown"
                    };

                    // Now insert app_status with a mutable borrow
                    info!("[AxTree] Inserting app_status: {}", app_status);
                    if let Some(data) = obj.get_mut("data").and_then(|v| v.as_object_mut()) {
                        data.insert("app_status".to_string(), json!(app_status));
                        info!("[AxTree] Successfully added app_status");
                    } else {
                        info!("[AxTree] Warning: Could not insert app_status (no data object)");
                    }

                    // Convert floating point coordinates to integers for backend compatibility
                    convert_coordinates_to_integers(obj);

                    let _ = crate::core::record::log_input(serde_json::Value::Object(obj.clone()));
                }
            }
            Err(e) => {
                info!("[AxTree] Error in native extraction: {}", e);
            }
        }
    });

    Ok(())
}

/// Sets the recording mode for AXTree polling.
/// When recording is true, polling frequency is reduced to avoid focus stealing.
pub fn set_recording_mode(recording: bool) -> Result<(), String> {
    info!("[AxTree] Setting recording mode: {}", recording);

    let recording_mode = RECORDING_MODE.get_or_init(|| Arc::new(Mutex::new(false)));
    let lock = lock_with_timeout(recording_mode, Duration::from_secs(2));
    if let Some(mut mode) = lock {
        *mode = recording;
        Ok(())
    } else {
        Err("Could not acquire recording mode lock".to_string())
    }
}
