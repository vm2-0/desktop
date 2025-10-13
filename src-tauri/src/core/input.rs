//! Input event listening and logging utilities for capturing keyboard, mouse, and joystick events across platforms.

use crate::core::record;
use crate::tools::helpers::lock_with_timeout;
use log::{error, info};
use rdev::{listen, Event as RdevEvent, EventType as RdevEventType};
use serde::Serialize;
use std::{
    sync::{
        atomic::{AtomicBool, Ordering},
        Arc, Mutex,
    },
    thread::{self, JoinHandle},
};
use tauri::Emitter;
use tauri::Runtime;

/// Determines if an input event should trigger a UI accessibility tree dump
/// This function is layout-aware and works with any keyboard layout (QWERTY, AZERTY, QWERTZ, etc.)
fn should_trigger_ui_dump(event: &InputEvent) -> bool {
    match event.event.as_str() {
        // Mouse clicks are significant UI interactions (layout-independent)
        "mousedown" | "mouseup" => true,

        // Key navigation events (layout-independent function keys and navigation)
        "keydown" => {
            if let Some(key) = event.data.get("key").and_then(|k| k.as_str()) {
                is_navigation_or_function_key(key)
            } else {
                false
            }
        }

        // Significant scroll events (filter out tiny movements)
        "mousewheel" => {
            if let Some(delta) = event.data.get("delta").and_then(|d| d.as_f64()) {
                delta.abs() > 1.0 // Only significant scroll movements
            } else {
                false
            }
        }

        _ => false,
    }
}

/// Determines if a key is a navigation or function key that should trigger UI dumps
/// This works regardless of keyboard layout (QWERTY, AZERTY, QWERTZ, Dvorak, etc.)
fn is_navigation_or_function_key(key: &str) -> bool {
    match key {
        // Layout-independent navigation keys
        "Tab" | "Return" | "Enter" | "Escape" | "Space" => true,

        // Arrow keys (may appear as "ArrowUp", "Up", etc. depending on platform)
        key if key.contains("Arrow")
            || key.contains("Up")
            || key.contains("Down")
            || key.contains("Left")
            || key.contains("Right") =>
        {
            true
        }

        // Function keys (universal across layouts)
        "F1" | "F2" | "F3" | "F4" | "F5" | "F6" | "F7" | "F8" | "F9" | "F10" | "F11" | "F12" => {
            true
        }

        // Page navigation (universal)
        "PageUp" | "PageDown" | "Home" | "End" => true,

        // Common modifier combinations that change UI context
        "Alt" | "Meta" | "Super" | "Cmd" | "Control" => true,

        // Layout-independent special keys
        "Insert" | "Delete" | "Backspace" => true,

        _ => false,
    }
}

/// A listener for input events (keyboard, mouse, joystick) that can be started and stopped.
pub struct InputListener {
    running: Arc<AtomicBool>,
    threads: Vec<JoinHandle<()>>,
}

impl InputListener {
    /// Creates a new `InputListener` instance.
    pub fn new() -> Self {
        Self {
            running: Arc::new(AtomicBool::new(true)),
            threads: Vec::new(),
        }
    }

    /// Stops the input listener and clears all threads.
    pub fn stop(&mut self) {
        self.running.store(false, Ordering::SeqCst);
        // Don't wait for threads since they might be blocked in rdev listen()
        self.threads.clear();
    }
}

impl Drop for InputListener {
    /// Ensures the input listener is stopped when dropped.
    fn drop(&mut self) {
        self.stop();
    }
}

// Global state for input listening
lazy_static::lazy_static! {
    static ref INPUT_LISTENER_STATE: Arc<Mutex<Option<InputListener>>> = Arc::new(Mutex::new(None));
}

/// Represents a generic input event (keyboard, mouse, joystick) with event type and data.
#[derive(Debug, Clone, Serialize)]
pub struct InputEvent {
    pub event: String,
    pub data: serde_json::Value,
}

impl InputEvent {
    /// Creates a new `InputEvent` with the given event name and data.
    ///
    /// # Arguments
    /// * `event` - The event type as a string (e.g., "keydown", "mousemove").
    /// * `data` - The event data as a JSON value.
    pub fn new(event: &str, data: serde_json::Value) -> Self {
        Self {
            event: event.to_string(),
            data,
        }
    }

    /// Converts the input event to a log entry with a timestamp relative to recording start.
    pub fn to_log_entry(
        &self,
        recording_start_time: Option<chrono::DateTime<chrono::Local>>,
    ) -> serde_json::Value {
        let timestamp = if let Some(start_time) = recording_start_time {
            // Calculate milliseconds since recording started
            chrono::Local::now()
                .signed_duration_since(start_time)
                .num_milliseconds()
                .max(0) // Ensure non-negative
        } else {
            // Fallback to absolute timestamp if no recording start time
            chrono::Local::now().timestamp_millis()
        };

        serde_json::json!({
            "event": self.event,
            "data": self.data,
            "time": timestamp
        })
    }
}

/// Normalizes mouse coordinates by clamping to monitor bounds
/// Returns (clamped_x, clamped_y, raw_x, raw_y)
fn normalize_coordinates(x: f64, y: f64) -> (f64, f64, f64, f64) {
    use std::sync::atomic::Ordering;

    // Get monitor dimensions from atomic variables (lock-free, thread-safe)
    let width = crate::core::record::MONITOR_WIDTH.load(Ordering::Relaxed);
    let height = crate::core::record::MONITOR_HEIGHT.load(Ordering::Relaxed);

    if width > 0 && height > 0 {
        // Clamp coordinates to [0, width] and [0, height]
        let clamped_x = x.max(0.0).min(width as f64);
        let clamped_y = y.max(0.0).min(height as f64);
        (clamped_x, clamped_y, x, y)
    } else {
        // Monitor dimensions not set yet - return raw coords
        (x, y, x, y)
    }
}

/// Starts the global input listener, capturing and emitting input events to the frontend and logging them.
///
/// # Arguments
/// * `app_handle` - The Tauri application handle for emitting events.
/// * `demonstration_state` - State containing recording start time for relative timestamps.
///
/// # Returns
/// * `Ok(())` if the listener was started successfully.
/// * `Err` if an error occurred.
pub fn start_input_listener<R: Runtime>(
    app_handle: tauri::AppHandle<R>,
    recording_start_time: Option<chrono::DateTime<chrono::Local>>,
) -> Result<(), String> {
    info!("[Input] Starting input listener");

    // Check if already listening
    let lock = lock_with_timeout(&INPUT_LISTENER_STATE, std::time::Duration::from_secs(2));
    let mut state = match lock {
        Some(state) => state,
        None => return Ok(()), // Already listening
    };

    let mut input_listener = InputListener::new();
    let running = input_listener.running.clone();
    let other_app_handle = app_handle.clone();

    // Platform-specific input handling
    // For Windows: use multiinput for all input events (mouse, keyboard, joystick)
    #[cfg(target_os = "windows")]
    {
        use multiinput::*;
        let running_clone = running.clone();
        let handle = thread::spawn(move || {
            let mut manager = RawInputManager::new().unwrap();
            manager.register_devices(DeviceType::Joysticks(XInputInclude::True));
            manager.register_devices(DeviceType::Keyboards);
            manager.register_devices(DeviceType::Mice);

            while running_clone.load(Ordering::SeqCst) {
                if let Some(event) = manager.get_event() {
                    let input_event = match event {
                        RawEvent::KeyboardEvent(_device_id, key, state) => match state {
                            State::Pressed => Some(InputEvent::new(
                                "keydown",
                                serde_json::json!({
                                    "key": format!("{:?}", key),
                                    "actual_char": "", // multiinput doesn't provide char info
                                    "layout_dependent": true,
                                    "detection_method": "multiinput_windows"
                                }),
                            )),
                            State::Released => Some(InputEvent::new(
                                "keyup",
                                serde_json::json!({
                                    "key": format!("{:?}", key),
                                    "actual_char": "", // multiinput doesn't provide char info
                                    "layout_dependent": true,
                                    "detection_method": "multiinput_windows"
                                }),
                            )),
                        },
                        RawEvent::MouseMoveEvent(_device_id, x, y) => Some(InputEvent::new(
                            "mousedelta",
                            serde_json::json!({
                                "x": x,
                                "y": y
                            }),
                        )),
                        RawEvent::MouseButtonEvent(_device_id, button, state) => {
                            Some(InputEvent::new(
                                match state {
                                    State::Pressed => "mousedown",
                                    State::Released => "mouseup",
                                },
                                serde_json::json!({
                                    "button": format!("{:?}", button)
                                }),
                            ))
                        }
                        RawEvent::MouseWheelEvent(_device_id, delta) => Some(InputEvent::new(
                            "mousewheel",
                            serde_json::json!({
                                "delta": delta
                            }),
                        )),
                        RawEvent::JoystickButtonEvent(device_id, button, state) => {
                            Some(InputEvent::new(
                                match state {
                                    State::Pressed => "joystickdown",
                                    State::Released => "joystickup",
                                },
                                serde_json::json!({
                                    "id": device_id,
                                    "button": button
                                }),
                            ))
                        }
                        RawEvent::JoystickAxisEvent(device_id, axis, value) => {
                            Some(InputEvent::new(
                                "joystickaxis",
                                serde_json::json!({
                                    "id": device_id,
                                    "axis": format!("{:?}", axis),
                                    "value": value
                                }),
                            ))
                        }
                        _ => None,
                    };

                    if let Some(event) = input_event {
                        if let Err(e) = other_app_handle.emit("input-event", &event) {
                            error!("Failed to emit input event: {}", e);
                        }
                        // Log the input event
                        let _ = record::log_input(event.to_log_entry(recording_start_time));

                        // Trigger UI dump for significant interactions
                        let should_dump = should_trigger_ui_dump(&event);
                        info!(
                            "[Input] Event: {}, should_trigger_ui_dump: {}",
                            event.event, should_dump
                        );
                        if should_dump {
                            info!("[Input] ⚡ Triggering UI dump for event: {}", event.event);
                            let _ = crate::tools::axtree::trigger_ui_dump_on_interaction(
                                other_app_handle.clone(),
                            );
                        }
                    }
                }
            }
        });
        input_listener.threads.push(handle);

        // For Windows, we also need a separate rdev listener for absolute mouse position
        let running_clone = running.clone();
        let handle = thread::spawn(move || {
            let callback = move |event: RdevEvent| {
                if let RdevEventType::MouseMove { x, y } = event.event_type {
                    let (norm_x, norm_y, raw_x, raw_y) = normalize_coordinates(x, y);
                    let input_event = InputEvent::new(
                        "mousemove",
                        serde_json::json!({
                            "x": norm_x,
                            "y": norm_y,
                            "raw_x": raw_x,
                            "raw_y": raw_y
                        }),
                    );
                    // Log the mouse move event
                    let _ = record::log_input(input_event.to_log_entry(recording_start_time));
                }
            };

            if let Err(error) = listen(move |event| {
                if !running_clone.load(Ordering::SeqCst) {
                    return;
                }
                callback(event);
            }) {
                info!("Error: {:?}", error)
            }
        });
        input_listener.threads.push(handle);
    }

    // For non-Windows platforms: use a single rdev instance for all events
    #[cfg(not(target_os = "windows"))]
    {
        let running_clone = running.clone();
        let handle = thread::spawn(move || {
            let callback = move |event: RdevEvent| {
                let input_event = match event.event_type {
                    RdevEventType::KeyPress(key) => Some(InputEvent::new(
                        "keydown",
                        serde_json::json!({
                            "key": format!("{:?}", key),
                            "actual_char": match &event.unicode {
                                Some(unicode_info) => format!("{:?}", unicode_info),
                                None => String::new(),
                            },
                            "layout_dependent": true,
                            "detection_method": "rdev_cross_platform"
                        }),
                    )),
                    RdevEventType::KeyRelease(key) => Some(InputEvent::new(
                        "keyup",
                        serde_json::json!({
                            "key": format!("{:?}", key),
                            "actual_char": match &event.unicode {
                                Some(unicode_info) => format!("{:?}", unicode_info),
                                None => String::new(),
                            },
                            "layout_dependent": true,
                            "detection_method": "rdev_cross_platform"
                        }),
                    )),
                    RdevEventType::ButtonPress(button) => Some(InputEvent::new(
                        "mousedown",
                        serde_json::json!({
                            "button": format!("{:?}", button)
                        }),
                    )),
                    RdevEventType::ButtonRelease(button) => Some(InputEvent::new(
                        "mouseup",
                        serde_json::json!({
                            "button": format!("{:?}", button)
                        }),
                    )),
                    RdevEventType::Wheel {
                        delta_x: _,
                        delta_y,
                    } => Some(InputEvent::new(
                        "mousewheel",
                        serde_json::json!({
                            "delta": delta_y as f32
                        }),
                    )),
                    RdevEventType::MouseMove { x, y } => {
                        let (norm_x, norm_y, raw_x, raw_y) = normalize_coordinates(x, y);
                        Some(InputEvent::new(
                            "mousemove",
                            serde_json::json!({
                                "x": norm_x,
                                "y": norm_y,
                                "raw_x": raw_x,
                                "raw_y": raw_y
                            }),
                        ))
                    }
                };

                if let Some(event) = input_event {
                    if let Err(e) = other_app_handle.emit("input-event", &event) {
                        error!("Failed to emit input event: {}", e);
                    }
                    // Log the input event
                    let _ = record::log_input(event.to_log_entry(recording_start_time));

                    // Trigger UI dump for significant interactions
                    let should_dump = should_trigger_ui_dump(&event);
                    info!(
                        "[Input] Event: {}, should_trigger_ui_dump: {}",
                        event.event, should_dump
                    );
                    if should_dump {
                        info!("[Input] ⚡ Triggering UI dump for event: {}", event.event);
                        let _ = crate::tools::axtree::trigger_ui_dump_on_interaction(
                            other_app_handle.clone(),
                        );
                    }
                }
            };

            if let Err(error) = listen(move |event| {
                if !running_clone.load(Ordering::SeqCst) {
                    return;
                }
                callback(event);
            }) {
                error!("Input listener rdev failed: {:?}", error);
            }
        });
        input_listener.threads.push(handle);
    }

    *state = Some(input_listener);
    Ok(())
}

/// Stops the global input listener and cleans up resources.
///
/// # Returns
/// * `Ok(())` if the listener was stopped successfully.
/// * `Err` if an error occurred.
pub fn stop_input_listener() -> Result<(), String> {
    info!("[Input] Stopping input listener");
    let lock = lock_with_timeout(&INPUT_LISTENER_STATE, std::time::Duration::from_secs(2));
    let mut state = match lock {
        Some(state) => state,
        None => return Ok(()), // Already stopped
    };
    if let Some(mut listener) = state.take() {
        listener.stop();
    }
    info!("[Input] Input listener stopped");
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;

    #[test]
    fn test_input_event_new() {
        let event_name = "test_event";
        let event_data = json!({ "key": "value" });
        let input_event = InputEvent::new(event_name, event_data.clone());

        assert_eq!(input_event.event, event_name);
        assert_eq!(input_event.data, event_data);
    }

    #[test]
    fn test_input_event_to_log_entry() {
        let event_name = "log_event";
        let event_data = json!({ "detail": "some_info" });
        let input_event = InputEvent::new(event_name, event_data.clone());

        let log_entry = input_event.to_log_entry(None); // Test without recording start time

        assert_eq!(log_entry["event"], event_name);
        assert_eq!(log_entry["data"], event_data);
        assert!(log_entry["time"].is_number());

        let current_time = chrono::Local::now().timestamp_millis();
        let log_time = log_entry["time"].as_i64().unwrap();
        // Allow a small difference, e.g., 5 seconds (5000 ms)
        assert!(
            (current_time - log_time).abs() < 5000,
            "Timestamp is not recent"
        );
    }
}
