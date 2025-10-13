//! Recording and logging core logic for screen, input, and demonstration data.
//!
//! This module provides the main types and functions for managing recording sessions, metadata, demonstrations, and file operations.

use crate::core::input;
use crate::tools::axtree;
use crate::tools::cqa;
use crate::tools::ffmpeg::{init_ffmpeg, FFmpegRecorder, FFMPEG_PATH};
#[cfg(not(target_os = "macos"))]
use crate::utils::keyboard_layout;
use crate::utils::logger::Logger;
#[cfg(target_os = "macos")]
use crate::utils::permissions::{has_ax_perms, request_ax_perms};
use crate::utils::settings::get_custom_app_local_data_dir;
use base64::{engine::general_purpose::STANDARD as BASE64, Engine as _};
use chrono::Local;
use display_info::DisplayInfo;
use serde::{Deserialize, Serialize};
use std::fs::{self, create_dir_all, File};
use std::io::{BufReader, Cursor, Read, Write};
use std::path::PathBuf;
use std::process::Command;
use std::sync::{Arc, Mutex};
use tauri::Emitter;
use zip::{write::FileOptions, ZipWriter};
/// Schema version for meta.json files - Semantic versioning for backward compatibility
#[derive(Serialize, Deserialize, Clone)]
pub struct SchemaVersion {
    pub major: u32, // Breaking changes
    pub minor: u32, // New features, backward compatible
    pub patch: u32, // Bug fixes
}

impl Default for SchemaVersion {
    fn default() -> Self {
        Self {
            major: 1,
            minor: 0,
            patch: 0,
        }
    }
}

impl SchemaVersion {
    #[allow(dead_code)]
    pub fn to_string(&self) -> String {
        format!("{}.{}.{}", self.major, self.minor, self.patch)
    }

    #[allow(dead_code)]
    pub fn is_compatible(&self, other: &SchemaVersion) -> bool {
        // Compatible if same major version and this minor >= other minor
        self.major == other.major && self.minor >= other.minor
    }
}

/// Metadata for input_log.jsonl file
#[derive(Serialize, Deserialize, Clone)]
pub struct InputLogMeta {
    pub schema_version: SchemaVersion,
    pub format: String,
    pub event_count: u32,
    pub timestamp_type: String,
    pub created_at: String,
}

/// Metadata for a recording session, including quest, platform, and monitor info.
#[derive(Serialize, Deserialize, Clone)]
pub struct RecordingMeta {
    /// Schema version for backward compatibility
    #[serde(default)]
    pub schema_version: SchemaVersion,
    id: String,
    timestamp: String,
    duration_seconds: u64,
    status: String,
    reason: Option<String>,
    title: String,
    description: String,
    platform: String,
    arch: String,
    version: String,
    locale: String,
    keyboard_layout: Option<String>,
    primary_monitor: MonitorInfo,
    // TODO: rename to demonstration when backend is updated
    quest: Option<Demonstration>,
}

/// Metadata for a demonstration associated with a recording.
#[derive(Serialize, Deserialize, Clone)]
pub struct Demonstration {
    title: String,
    app: String,
    icon_url: String,
    objectives: Vec<String>,
    content: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pool_id: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    reward: Option<DemonstrationReward>,
    #[serde(skip_serializing_if = "Option::is_none")]
    task_id: Option<String>,
}

/// Reward information for a demonstration.
#[derive(Serialize, Deserialize, Clone)]
pub struct DemonstrationReward {
    time: i64,
    max_reward: f64,
}

/// Information about the primary monitor used for recording.
#[derive(Serialize, Deserialize, Clone)]
pub struct MonitorInfo {
    pub width: u32,
    pub height: u32,
    #[serde(default)]
    pub scale_factor: f32,
    /// Position in virtual screen space (for multi-monitor setups)
    /// Note: display_info crate doesn't provide x,y coordinates
    /// These will be 0,0 for now but structure is future-proof
    #[serde(default)]
    pub x: i32,
    #[serde(default)]
    pub y: i32,
}

enum Recorder {
    // #[cfg(not(target_os = "macos"))]
    FFmpeg(FFmpegRecorder),
    // #[cfg(target_os = "macos")]
    // MacOS(MacOSScreenRecorder),
}

impl Recorder {
    fn start(&mut self) -> Result<(), String> {
        match self {
            // #[cfg(not(target_os = "macos"))]
            Recorder::FFmpeg(recorder) => {
                #[cfg(target_os = "linux")]
                {
                    // On veut détecter l'échec pipewire/ffmpeg et logger un avertissement
                    let input_format = recorder.input_format().map(|s| s.as_str()).unwrap_or("");
                    if input_format == "pipewire" {
                        let result = recorder.start();
                        if let Err(ref err) = result {
                            log::warn!(
                                "[record] FFmpeg pipewire capture failed: {}. \
                                Check that pipewire is running, that ffmpeg was compiled with --enable-libpipewire, \
                                and that you have the necessary permissions for screen capture under Wayland.",
                                err
                            );
                        }
                        return result;
                    }
                }
                recorder.start()
            } // #[cfg(target_os = "macos")]
              // Recorder::MacOS(recorder) => recorder.start(),
        }
    }

    fn stop(&mut self) -> Result<(), String> {
        match self {
            // #[cfg(not(target_os = "macos"))]
            Recorder::FFmpeg(recorder) => recorder.stop(),
            // #[cfg(target_os = "macos")]
            // Recorder::MacOS(recorder) => recorder.stop(),
        }
    }

    fn new(video_path: &PathBuf, primary: &DisplayInfo, fps: u32) -> Result<Self, String> {
        log::info!("[record] Starting new recorder");
        // #[cfg(target_os = "macos")]
        // {
        //     return Ok(Recorder::MacOS(MacOSScreenRecorder::new(
        //         video_path.to_path_buf(),
        //         primary,
        //     )));
        // }

        // #[cfg(not(target_os = "macos"))]
        {
            let (input_format, input_device) = {
                #[cfg(target_os = "windows")]
                {
                    ("gdigrab", "desktop".to_string())
                }
                #[cfg(target_os = "linux")]
                {
                    // Dynamic detection of X11/Wayland
                    let session_type =
                        std::env::var("XDG_SESSION_TYPE").unwrap_or_else(|_| "x11".to_string());
                    if session_type == "wayland" {
                        log::info!(
                            "[record] Wayland session detected, using pipewire for screen capture"
                        );
                        // pipewire requires ffmpeg compiled with --enable-libpipewire
                        // and pipewire running on the user side
                        ("pipewire", "default".to_string())
                    } else {
                        log::info!(
                            "[record] X11 session detected, using x11grab for screen capture"
                        );
                        ("x11grab", ":0.0".to_string())
                    }
                }
                #[cfg(target_os = "macos")]
                {
                    // Run ffmpeg to list availabkle devices
                    let ffmpeg = FFMPEG_PATH.get().ok_or_else(|| {
                        log::info!("[FFmpeg] Error: FFmpeg not initialized");
                        PathBuf::from("ffmpeg")
                    });
                    let output =
                        Command::new(ffmpeg.unwrap_or(&PathBuf::from("ffmpeg")).as_os_str())
                            .env("LANG", "en_US.UTF-8")
                            .args(["-f", "avfoundation", "-list_devices", "true", "-i", ""])
                            .output()
                            .map_err(|e| {
                                format!("Failed to execute ffmpeg to list devices: {}", e)
                            })?;

                    let output_str = String::from_utf8_lossy(&output.stderr);

                    log::info!("[record] FFmpeg screen devices output:\n{}", output_str);

                    // Find the screen capture device
                    let mut screen_device_index = None;

                    // Parse the output to find the screen capture device
                    for line in output_str.lines() {
                        if line.contains("Capture screen") {
                            // This is a screen capture device
                            log::info!("[record] Found screen capture line: {}", line);

                            // Find the opening bracket
                            if let Some(first_bracket) = line.find('[') {
                                // Find the second opening bracket
                                if let Some(start_idx) = line[first_bracket + 1..].find('[') {
                                    // Adjust index to be relative to the original string
                                    let start_idx = first_bracket + 1 + start_idx;

                                    // Find the closing bracket after the second opening bracket
                                    if let Some(end_idx) = line[start_idx + 1..].find(']') {
                                        // Extract the content between brackets
                                        let number_str =
                                            &line[start_idx + 1..start_idx + 1 + end_idx];

                                        // Parse as integer
                                        if let Ok(index) = number_str.parse::<i32>() {
                                            screen_device_index = Some(index);
                                            log::info!(
                                                "[record] Found screen capture device at index: {}",
                                                index
                                            );
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Format the input device string - just the video device index with a colon
                    let input_device = if let Some(index) = screen_device_index {
                        format!("{}:", index)
                    } else {
                        log::info!("[record] No screen capture device found.");
                        log::info!("[record] Defualting to device [1].");
                        // Fallback to a default if no screen capture device found
                        "1".to_string() // Common default for screen capture
                    };

                    ("avfoundation", input_device)
                }
                #[cfg(not(any(target_os = "windows", target_os = "linux", target_os = "macos")))]
                {
                    return Err("Unsupported platform".to_string());
                }
            };

            let physical_width = (primary.width as f32 * primary.scale_factor).round() as u32;
            let physical_height = (primary.height as f32 * primary.scale_factor).round() as u32;

            Ok(Recorder::FFmpeg(FFmpegRecorder::new_with_input(
                physical_width,
                physical_height,
                fps,
                video_path.to_path_buf(),
                input_format.to_string(),
                input_device,
            )))
        }
    }
}

/// State for managing the current demonstration and recording session.
#[derive(Default)]
pub struct DemonstrationState {
    pub recording_start_time: Option<chrono::DateTime<chrono::Local>>,
    pub current_recording_id: Option<String>,
    pub current_demonstration: Option<Demonstration>,
}

impl DemonstrationState {
    /// Get the current recording start time for timestamp calculations
    pub fn get_recording_start_time(&self) -> Option<chrono::DateTime<chrono::Local>> {
        self.recording_start_time
    }
}

// Separate atomic storage for monitor dimensions to avoid Mutex issues
use std::sync::atomic::{AtomicI64, AtomicU32, Ordering};
pub(crate) static MONITOR_WIDTH: AtomicU32 = AtomicU32::new(0);
pub(crate) static MONITOR_HEIGHT: AtomicU32 = AtomicU32::new(0);

// CRITICAL: Store recording_start_time as atomic to avoid deadlocks
// Multiple threads need to read this value frequently (input events, ffmpeg logs)
// Using AtomicI64 instead of Mutex eliminates contention and deadlock risk
pub(crate) static RECORDING_START_TIME_MILLIS: AtomicI64 = AtomicI64::new(0);

// Global state for recording and logging
lazy_static::lazy_static! {
    static ref RECORDER_STATE: Arc<Mutex<Option<Recorder>>> = Arc::new(Mutex::new(None));
    static ref RECORDING_STATE: Arc<Mutex<Option<String>>> = Arc::new(Mutex::new(Some("off".to_string())));
    static ref LOGGER_STATE: Arc<Mutex<Option<Logger>>> = Arc::new(Mutex::new(None));
    static ref DEMONSTRATION_STATE: Arc<Mutex<DemonstrationState>> = Arc::new(Mutex::new(DemonstrationState::default()));
}

// Defensive wrappers around tauri_plugin_os calls to avoid panics on some macOS setups
fn safe_os_platform() -> String {
    match std::panic::catch_unwind(|| tauri_plugin_os::platform().to_string()) {
        Ok(val) => val,
        Err(_) => {
            log::warn!("[record] tauri_plugin_os::platform() panicked; defaulting to empty");
            String::new()
        }
    }
}

fn safe_os_arch() -> String {
    match std::panic::catch_unwind(|| tauri_plugin_os::arch().to_string()) {
        Ok(val) => val,
        Err(_) => {
            log::warn!("[record] tauri_plugin_os::arch() panicked; defaulting to empty");
            String::new()
        }
    }
}

fn safe_os_version() -> String {
    match std::panic::catch_unwind(|| tauri_plugin_os::version().to_string()) {
        Ok(val) => val,
        Err(_) => {
            log::warn!("[record] tauri_plugin_os::version() panicked; defaulting to empty");
            String::new()
        }
    }
}

fn safe_os_locale() -> String {
    match std::panic::catch_unwind(|| tauri_plugin_os::locale().unwrap_or_default()) {
        Ok(val) => val,
        Err(_) => {
            log::warn!("[record] tauri_plugin_os::locale() panicked; defaulting to empty");
            String::new()
        }
    }
}

#[cfg(target_os = "macos")]
fn safe_keyboard_layout_id() -> Option<String> {
    // Temporary hardening: some macOS setups trigger a SIGTRAP inside low-level
    // keyboard layout APIs. Skip layout detection to avoid startup crashes.
    log::warn!(
        "[record] Skipping keyboard layout detection on macOS to avoid rare startup crashes"
    );
    None
}

#[cfg(not(target_os = "macos"))]
fn safe_keyboard_layout_id() -> Option<String> {
    match std::panic::catch_unwind(|| keyboard_layout::get_current_keyboard_layout()) {
        Ok(res) => res.ok().map(|info| info.layout_id),
        Err(_) => {
            log::warn!(
                "[record] keyboard_layout::get_current_keyboard_layout() panicked; defaulting to None"
            );
            None
        }
    }
}

fn get_session_path(app: &tauri::AppHandle) -> Result<(PathBuf, String), String> {
    let recordings_dir = get_custom_app_local_data_dir(app)?.join("recordings");

    std::fs::create_dir_all(&recordings_dir)
        .map_err(|e| format!("Failed to create recordings directory: {}", e))?;

    let timestamp = Local::now().format("%Y%m%d_%H%M%S").to_string();
    let session_dir = recordings_dir.join(&timestamp);

    std::fs::create_dir_all(&session_dir)
        .map_err(|e| format!("Failed to create session directory: {}", e))?;

    Ok((session_dir, timestamp))
}

/// List all available recordings and their metadata.
///
/// # Arguments
/// * `app` - The Tauri application handle.
///
/// # Returns
/// * `Ok(Vec<RecordingMeta>)` with all found recordings.
/// * `Err` if an error occurred.
pub async fn list_recordings(app: tauri::AppHandle) -> Result<Vec<RecordingMeta>, String> {
    let recordings_dir = get_custom_app_local_data_dir(&app)?.join("recordings");

    if !recordings_dir.exists() {
        return Ok(Vec::new());
    }

    let mut recordings = Vec::new();
    for entry in fs::read_dir(&recordings_dir)
        .map_err(|e| format!("Failed to read recordings directory: {}", e))?
    {
        let entry = entry.map_err(|e| format!("Failed to read directory entry: {}", e))?;
        let meta_path = entry.path().join("meta.json");
        if meta_path.exists() {
            let meta_str = fs::read_to_string(&meta_path)
                .map_err(|e| format!("Failed to read meta file: {}", e))?;
            let meta: RecordingMeta = serde_json::from_str(&meta_str)
                .map_err(|e| format!("Failed to parse meta file: {}", e))?;
            recordings.push(meta);
        }
    }

    recordings.sort_by(|a, b| b.timestamp.cmp(&a.timestamp));
    Ok(recordings)
}

/// Set the current recording state and emit an event to the frontend.
///
/// # Arguments
/// * `app` - The Tauri application handle.
/// * `state` - The new state as a string (e.g., "recording", "off").
/// * `id` - Optional recording ID.
///
/// # Returns
/// * `Ok(())` if successful.
/// * `Err` if an error occurred.
pub fn set_rec_state(
    app: &tauri::AppHandle,
    state: String,
    id: Option<String>,
) -> Result<(), String> {
    let mut recording_state = RECORDING_STATE.lock().map_err(|e| e.to_string())?;
    *recording_state = Some(state.clone());
    if id.is_some() {
        if let Err(e) = app.emit(
            "recording-status",
            serde_json::json!({
                "state": state,
                "id": id
            }),
        ) {
            log::warn!("[record] Failed to emit recording-status with id: {}", e);
        }
    } else {
        if let Err(e) = app.emit(
            "recording-status",
            serde_json::json!({
                "state": state
            }),
        ) {
            log::warn!("[record] Failed to emit recording-status: {}", e);
        }
    }
    Ok(())
}

/// Get the current recording state as a string.
///
/// # Returns
/// * `Ok(String)` with the current state.
/// * `Err` if not initialized or on error.
pub async fn get_recording_state() -> Result<String, String> {
    let recording_state = RECORDING_STATE.lock().map_err(|e| e.to_string())?;
    recording_state
        .as_ref()
        .map(|s| s.clone())
        .ok_or_else(|| "Recording state not initialized".to_string())
}

/// Start a new recording session, including screen, input, and demonstration data.
///
/// # Arguments
/// * `app` - The Tauri application handle.
/// * `demonstration_state` - The shared demonstration state.
/// * `demonstration` - Optional demonstration metadata.
/// * `fps` - The frame rate for the recording.
///
/// # Returns
/// * `Ok(())` if successful.
/// * `Err` if an error occurred.
pub async fn start_recording(
    app: tauri::AppHandle,
    demonstration: Option<Demonstration>,
    fps: u32,
) -> Result<(), String> {
    // Start screen recording
    let mut recorder_state = RECORDER_STATE.lock().map_err(|e| e.to_string())?;
    if recorder_state.is_some() {
        set_rec_state(&app, "recording".to_string(), None)?;
        return Err("Recording already in progress".to_string());
    }

    set_rec_state(&app, "starting".to_string(), None)?;

    // Initialize FFmpeg and FFprobe
    init_ffmpeg()?;
    crate::tools::ffmpeg::init_ffprobe()
        .map_err(|e| format!("Failed to initialize FFprobe: {}", e))?;

    let (session_dir, timestamp) = get_session_path(&app)?;

    // CRITICAL: Store ALL demonstration state in a SINGLE lock to avoid deadlocks
    // This must happen BEFORE starting any threads that might also lock DEMONSTRATION_STATE
    let recording_start = Local::now();
    {
        let mut global_state = DEMONSTRATION_STATE
            .lock()
            .map_err(|e| format!("Failed to lock demonstration state: {}", e))?;

        if let Some(demonstration_data) = &demonstration {
            global_state.current_demonstration = Some(demonstration_data.clone());
        }
        global_state.current_recording_id = Some(timestamp.clone());
        global_state.recording_start_time = Some(recording_start);

        log::info!(
            "[record] Initialized demonstration state: recording_id={}, has_demo={}",
            timestamp,
            demonstration.is_some()
        );
    } // Lock is released here before we start any threads

    // Store recording start time in atomic variable (lock-free, thread-safe)
    // This allows input/ffmpeg threads to read it without mutex contention
    RECORDING_START_TIME_MILLIS.store(recording_start.timestamp_millis(), Ordering::Relaxed);
    log::info!(
        "[record] Stored recording start time: {} ms",
        recording_start.timestamp_millis()
    );

    let video_path = session_dir.join("recording.mp4");

    let displays = DisplayInfo::all().map_err(|e| format!("Failed to get display info: {}", e))?;
    let primary = displays
        .iter()
        .find(|d| d.is_primary)
        .or_else(|| displays.first())
        .ok_or_else(|| "No display found".to_string())?;

    let physical_width = (primary.width as f32 * primary.scale_factor).round() as u32;
    let physical_height = (primary.height as f32 * primary.scale_factor).round() as u32;
    log::info!(
        "[record] Display info: logical {}x{}, scale_factor: {}, physical {}x{}",
        primary.width,
        primary.height,
        primary.scale_factor,
        physical_width,
        physical_height
    );

    // Create and save initial meta file
    let meta = RecordingMeta {
        schema_version: SchemaVersion::default(),
        id: timestamp.clone(),
        timestamp: Local::now().to_rfc3339(),
        duration_seconds: 0,
        status: "recording".to_string(),
        title: if let Some(q) = &demonstration {
            q.title.clone()
        } else {
            "Recording Session".to_string()
        },
        description: if let Some(q) = &demonstration {
            q.content.clone()
        } else {
            "".to_string()
        },
        platform: safe_os_platform(),
        arch: safe_os_arch(),
        version: safe_os_version(),
        locale: safe_os_locale(),
        keyboard_layout: safe_keyboard_layout_id(),
        primary_monitor: MonitorInfo {
            // Store physical dimensions for video recording (meta.json)
            width: physical_width,
            height: physical_height,
            scale_factor: primary.scale_factor,
            x: 0, // display_info doesn't provide position yet
            y: 0, // display_info doesn't provide position yet
        },
        reason: None,
        quest: demonstration,
    };

    fs::write(
        session_dir.join("meta.json"),
        serde_json::to_string_pretty(&meta)
            .map_err(|e| format!("Failed to serialize meta: {}", e))?,
    )
    .map_err(|e| format!("Failed to write meta file: {}", e))?;

    // Store monitor dimensions in atomic variables (thread-safe, no Mutex needed)
    MONITOR_WIDTH.store(primary.width, Ordering::Relaxed);
    MONITOR_HEIGHT.store(primary.height, Ordering::Relaxed);
    log::info!(
        "[record] Stored monitor dimensions: {}x{}",
        primary.width,
        primary.height
    );

    // Extract recording start time ONCE (already set in DEMONSTRATION_STATE above)
    let recording_start_time = if let Ok(global_state) = DEMONSTRATION_STATE.lock() {
        global_state.get_recording_start_time()
    } else {
        None
    };

    set_rec_state(&app, "recording".to_string(), None)?;

    let mut recorder = Recorder::new(&video_path, &primary, fps)?;
    recorder.start()?;
    *recorder_state = Some(recorder);

    // Start input logging and listening
    let mut log_state = LOGGER_STATE.lock().map_err(|e| e.to_string())?;
    if log_state.is_none() {
        *log_state = Some(Logger::new(session_dir.clone())?);
    }

    #[cfg(target_os = "macos")]
    {
        if !has_ax_perms() {
            log::warn!(
                "[Input] Accessibility permission missing; skipping input listener and AX dumps. Go to System Settings → Privacy & Security → Accessibility and enable permissions for Clones."
            );
            // Optionally prompt the user (no-op in headless runs)
            request_ax_perms();
        } else {
            input::start_input_listener(app.clone(), recording_start_time)?;
            axtree::set_recording_mode(true)?;
        }
    }

    #[cfg(not(target_os = "macos"))]
    {
        input::start_input_listener(app.clone(), recording_start_time)?;
        axtree::set_recording_mode(true)?;
    }

    Ok(())
}

/// Stop the current recording session and finalize files.
///
/// # Arguments
/// * `app` - The Tauri application handle.
/// * `demonstration_state` - The shared demonstration state.
/// * `reason` - Optional reason for stopping.
///
/// # Returns
/// * `Ok(String)` with the recording ID.
/// * `Err` if an error occurred.
pub async fn stop_recording(
    app: tauri::AppHandle,
    reason: Option<String>,
) -> Result<String, String> {
    // Emit recording stopping event
    set_rec_state(&app, "stopping".to_string(), None)?;

    // Stop event-driven UI dumps
    axtree::set_recording_mode(false)?;

    // Note: No post-recording AXTree capture since it would only show Clones app

    // Stop input logging and listening after capturing final state
    let mut log_state = LOGGER_STATE.lock().map_err(|e| e.to_string())?;
    *log_state = None;

    // Stop input listener
    input::stop_input_listener()?;

    let mut rec_state = RECORDER_STATE.lock().map_err(|e| e.to_string())?;
    if let Some(mut recorder) = rec_state.take() {
        recorder.stop()?;
    }

    // Update meta file with duration
    let recordings_dir = get_custom_app_local_data_dir(&app)?.join("recordings");

    // Find the most recent recording directory
    let mut entries: Vec<_> = fs::read_dir(&recordings_dir)
        .map_err(|e| format!("Failed to read recordings directory: {}", e))?
        .collect::<Result<_, _>>()
        .map_err(|e| format!("Failed to read directory entries: {}", e))?;

    entries.sort_by_key(|entry| std::cmp::Reverse(entry.metadata().unwrap().modified().unwrap()));

    if let Some(latest_dir) = entries.first() {
        let video_path = latest_dir.path().join("recording.mp4");

        // Get the actual video duration from the file using FFprobe
        // This ensures meta.json duration matches the real video file duration
        let duration = if video_path.exists() {
            match get_video_duration(&video_path) {
                Ok(duration_f64) => {
                    log::info!(
                        "[stop_recording] Video duration from FFprobe: {:.2}s",
                        duration_f64
                    );
                    duration_f64.round() as u64
                }
                Err(e) => {
                    log::warn!(
                        "[stop_recording] Failed to get video duration from FFprobe: {}. Using wallclock time as fallback.",
                        e
                    );
                    // Fallback to wallclock time if FFprobe fails
                    if let Ok(global_state) = DEMONSTRATION_STATE.lock() {
                        if let Some(start_time) = global_state.recording_start_time {
                            Local::now().signed_duration_since(start_time).num_seconds() as u64
                        } else {
                            0
                        }
                    } else {
                        0
                    }
                }
            }
        } else {
            log::warn!("[stop_recording] Video file not found, using wallclock time");
            // Fallback if video file doesn't exist yet
            if let Ok(global_state) = DEMONSTRATION_STATE.lock() {
                if let Some(start_time) = global_state.recording_start_time {
                    Local::now().signed_duration_since(start_time).num_seconds() as u64
                } else {
                    0
                }
            } else {
                0
            }
        };

        let meta_path = latest_dir.path().join("meta.json");
        if meta_path.exists() {
            let meta_str = fs::read_to_string(&meta_path)
                .map_err(|e| format!("Failed to read meta file: {}", e))?;
            let mut meta: RecordingMeta = serde_json::from_str(&meta_str)
                .map_err(|e| format!("Failed to parse meta file: {}", e))?;

            meta.duration_seconds = duration;
            meta.status = "completed".to_string();
            meta.reason = reason;

            fs::write(
                &meta_path,
                serde_json::to_string_pretty(&meta)
                    .map_err(|e| format!("Failed to serialize meta: {}", e))?,
            )
            .map_err(|e| format!("Failed to write meta file: {}", e))?;

            // Generate input_log_meta.json
            let input_log_path = latest_dir.path().join("input_log.jsonl");
            if input_log_path.exists() {
                let input_log_content = fs::read_to_string(&input_log_path)
                    .map_err(|e| format!("Failed to read input_log.jsonl: {}", e))?;

                let event_count = input_log_content
                    .lines()
                    .filter(|line| !line.trim().is_empty())
                    .count() as u32;

                let input_log_meta = InputLogMeta {
                    schema_version: SchemaVersion::default(),
                    format: "jsonl".to_string(),
                    event_count,
                    timestamp_type: "relative".to_string(), // Since we now use relative timestamps
                    created_at: Local::now().to_rfc3339(),
                };

                let input_log_meta_path = latest_dir.path().join("input_log_meta.json");
                fs::write(
                    &input_log_meta_path,
                    serde_json::to_string_pretty(&input_log_meta)
                        .map_err(|e| format!("Failed to serialize input_log_meta: {}", e))?,
                )
                .map_err(|e| format!("Failed to write input_log_meta file: {}", e))?;
            }
        }
    }

    // Find the most recent recording directory to get its ID
    let recordings_dir = get_custom_app_local_data_dir(&app)?.join("recordings");

    let mut entries: Vec<_> = fs::read_dir(&recordings_dir)
        .map_err(|e| format!("Failed to read recordings directory: {}", e))?
        .collect::<Result<_, _>>()
        .map_err(|e| format!("Failed to read directory entries: {}", e))?;

    entries.sort_by_key(|entry| std::cmp::Reverse(entry.metadata().unwrap().modified().unwrap()));

    // Clear the current demonstration and get recording ID from global state
    let recording_id_opt = if let Ok(mut global_state) = DEMONSTRATION_STATE.lock() {
        global_state.current_demonstration = None;
        global_state.recording_start_time = None;
        global_state.current_recording_id.clone()
    } else {
        None
    };

    // Reset atomic recording start time
    RECORDING_START_TIME_MILLIS.store(0, Ordering::Relaxed);

    if let Some(recording_id) = recording_id_opt {
        set_rec_state(&app, "saved".to_string(), Some(recording_id.clone()))?;
        set_rec_state(&app, "off".to_string(), None)?;

        Ok(recording_id.to_string())
    } else {
        Err("No recording ID found".to_string())
    }
}

/// Log an input event to the current recording session.
/// Automatically converts absolute timestamps to relative for axtree_interaction events.
///
/// # Arguments
/// * `event` - The event as a JSON value.
///
/// # Returns
/// * `Ok(())` if successful.
/// * `Err` if an error occurred.
pub fn log_input(mut event: serde_json::Value) -> Result<(), String> {
    // Check if this is an axtree_interaction event and convert timestamp to relative
    if let Some(event_type) = event.get("event").and_then(|v| v.as_str()) {
        if event_type == "axtree_interaction" {
            // Get recording start time from atomic variable (lock-free, no deadlock risk)
            let start_time_millis = RECORDING_START_TIME_MILLIS.load(Ordering::Relaxed);

            if start_time_millis > 0 {
                // Calculate relative timestamp
                let relative_timestamp =
                    (chrono::Local::now().timestamp_millis() - start_time_millis).max(0);

                // Update the time field in the event
                if let Some(obj) = event.as_object_mut() {
                    obj.insert(
                        "time".to_string(),
                        serde_json::Value::Number(serde_json::Number::from(relative_timestamp)),
                    );
                }
            }
        }
    }

    if let Ok(mut state) = LOGGER_STATE.lock() {
        if let Some(logger) = state.as_mut() {
            logger.log_event(event)?;
        }
    }
    Ok(())
}

/// Log FFmpeg output (stdout or stderr) to the current recording session.
/// Uses atomic recording start time for timestamp calculation (lock-free).
///
/// # Arguments
/// * `output` - The output string.
/// * `is_stderr` - Whether this is stderr output.
///
/// # Returns
/// * `Ok(())` if successful.
/// * `Err` if an error occurred.
pub fn log_ffmpeg(output: &str, is_stderr: bool) -> Result<(), String> {
    // Get recording start time from atomic variable (lock-free, no deadlock risk)
    let start_time_millis = RECORDING_START_TIME_MILLIS.load(Ordering::Relaxed);

    // Calculate relative timestamp
    let timestamp = if start_time_millis > 0 {
        (chrono::Local::now().timestamp_millis() - start_time_millis).max(0)
    } else {
        chrono::Local::now().timestamp_millis()
    };

    // Create event with relative timestamp
    let event = serde_json::json!({
        "event": if is_stderr { "ffmpeg_stderr" } else { "ffmpeg_stdout" },
        "data": {
            "output": output
        },
        "time": timestamp
    });

    // Log to file
    if let Ok(mut state) = LOGGER_STATE.lock() {
        if let Some(logger) = state.as_mut() {
            logger.log_event(event)?;
        }
    }
    Ok(())
}

pub async fn get_recording_file(
    app: tauri::AppHandle,
    recording_id: String,
    filename: String,
    as_base64: Option<bool>,
    as_path: Option<bool>,
) -> Result<String, String> {
    let recordings_dir = get_custom_app_local_data_dir(&app)?
        .join("recordings")
        .join(&recording_id);

    let file_path = recordings_dir.join(&filename);
    if !file_path.exists() {
        return Err(format!("File not found: {}", filename));
    }

    let mut file = File::open(&file_path).map_err(|e| format!("Failed to open file: {}", e))?;
    if as_base64 == Some(true) {
        let mut reader = BufReader::new(file);
        let mut buffer = Vec::new();
        reader
            .read_to_end(&mut buffer)
            .map_err(|e| format!("Failed to read file: {}", e))?;

        Ok(format!("data:video/mp4;base64,{}", BASE64.encode(&buffer)))
    } else if as_path == Some(true) {
        Ok(file_path.to_str().ok_or("Invalid path")?.to_string())
    } else {
        let mut contents = String::new();
        file.read_to_string(&mut contents)
            .map_err(|e| format!("Failed to read file: {}", e))?;

        Ok(contents)
    }
}

pub async fn process_recording(app: tauri::AppHandle, recording_id: String) -> Result<(), String> {
    cqa::process_recording(&app, &recording_id)
}

pub async fn write_file(
    _app: tauri::AppHandle,
    path: String,
    content: String,
) -> Result<(), String> {
    // Create parent directories if they don't exist
    if let Some(parent) = std::path::Path::new(&path).parent() {
        create_dir_all(parent).map_err(|e| format!("Failed to create directories: {}", e))?;
    }

    fs::write(&path, content).map_err(|e| format!("Failed to write file: {}", e))?;

    Ok(())
}

pub async fn write_recording_file(
    app: tauri::AppHandle,
    recording_id: String,
    filename: String,
    content: String,
) -> Result<(), String> {
    // Get the path to the recording directory
    let recordings_dir = get_custom_app_local_data_dir(&app)?
        .join("recordings")
        .join(&recording_id);

    // Check if the recording directory exists
    if !recordings_dir.exists() {
        return Err(format!("Recording folder not found: {}", recording_id));
    }

    // Create the full file path
    let file_path = recordings_dir.join(&filename);

    // Write the content to the file
    fs::write(&file_path, content).map_err(|e| format!("Failed to write file: {}", e))?;

    Ok(())
}

pub async fn delete_recording(app: tauri::AppHandle, recording_id: String) -> Result<(), String> {
    let recordings_dir = get_custom_app_local_data_dir(&app)?
        .join("recordings")
        .join(&recording_id);

    if !recordings_dir.exists() {
        return Err(format!("Recording folder not found: {}", recording_id));
    }

    fs::remove_dir_all(&recordings_dir)
        .map_err(|e| format!("Failed to delete recording: {}", e))?;

    Ok(())
}

pub async fn create_recording_zip(
    app: tauri::AppHandle,
    recording_id: String,
) -> Result<Vec<u8>, String> {
    create_filtered_recording_zip(app, recording_id, Vec::new()).await
}

pub async fn create_filtered_recording_zip(
    app: tauri::AppHandle,
    recording_id: String,
    deleted_ranges: Vec<(f64, f64)>,
) -> Result<Vec<u8>, String> {
    log::info!(
        "[create_filtered_recording_zip] Starting to create filtered zip for recording ID: {} with {} deleted ranges",
        recording_id,
        deleted_ranges.len()
    );

    let recordings_dir = get_custom_app_local_data_dir(&app)?
        .join("recordings")
        .join(&recording_id);

    // Create a buffer to store the zip file
    let buf = Cursor::new(Vec::new());
    let mut zip = ZipWriter::new(buf);
    let options = FileOptions::default().compression_method(zip::CompressionMethod::Stored);

    // Process each file with filtering if needed
    let filenames = ["input_log.jsonl", "meta.json", "recording.mp4", "sft.json"];

    for filename in filenames {
        let file_path = recordings_dir.join(filename);

        if !file_path.exists() {
            log::warn!(
                "[create_filtered_recording_zip] File not found: {}",
                filename
            );
            continue;
        }

        let contents = match filename {
            "input_log.jsonl" => filter_input_log(&file_path, &deleted_ranges)?,
            "sft.json" => filter_sft_json(&file_path, &deleted_ranges)?,
            "meta.json" => update_meta_json(&file_path, &deleted_ranges)?,
            "recording.mp4" => {
                // Apply video edits if deleted ranges exist
                if deleted_ranges.is_empty() {
                    read_file_contents(&file_path)?
                } else {
                    apply_video_edits(&file_path, &deleted_ranges)?
                }
            }
            _ => read_file_contents(&file_path)?,
        };

        zip.start_file(filename, options)
            .map_err(|e| format!("Failed to add {} to zip: {}", filename, e))?;
        zip.write_all(&contents)
            .map_err(|e| format!("Failed to write {} to zip: {}", filename, e))?;

        log::info!(
            "[create_filtered_recording_zip] Added filtered {} ({} bytes)",
            filename,
            contents.len()
        );
    }

    let buf = zip
        .finish()
        .map_err(|e| format!("Failed to finalize zip: {}", e))?
        .into_inner();

    log::info!(
        "[create_filtered_recording_zip] Completed filtered zip, size: {} bytes",
        buf.len()
    );
    Ok(buf)
}

fn read_file_contents(file_path: &std::path::Path) -> Result<Vec<u8>, String> {
    let mut file = File::open(file_path)
        .map_err(|e| format!("Failed to open {}: {}", file_path.display(), e))?;
    let mut contents = Vec::new();
    file.read_to_end(&mut contents)
        .map_err(|e| format!("Failed to read {}: {}", file_path.display(), e))?;
    Ok(contents)
}

fn filter_input_log(
    file_path: &std::path::Path,
    deleted_ranges: &[(f64, f64)],
) -> Result<Vec<u8>, String> {
    if deleted_ranges.is_empty() {
        return read_file_contents(file_path);
    }

    let contents = std::fs::read_to_string(file_path)
        .map_err(|e| format!("Failed to read input_log.jsonl: {}", e))?;

    // Convert deleted ranges from milliseconds to seconds
    let deleted_ranges_seconds: Vec<(f64, f64)> = deleted_ranges
        .iter()
        .map(|(start_ms, end_ms)| (start_ms / 1000.0, end_ms / 1000.0))
        .collect();

    let mut filtered_lines: Vec<String> = Vec::new();

    for line in contents.lines() {
        if line.trim().is_empty() {
            continue;
        }

        match serde_json::from_str::<serde_json::Value>(line) {
            Ok(json) => {
                // Always preserve critical events regardless of timestamp
                if let Some(event_type) = json.get("event").and_then(|e| e.as_str()) {
                    if event_type == "ffmpeg_stderr" || event_type == "axtree" {
                        filtered_lines.push(line.to_string());
                        continue;
                    }
                }

                if let Some(time_ms) = json.get("time").and_then(|t| t.as_f64()) {
                    let time_seconds = time_ms / 1000.0;

                    // Check if this timestamp is in any deleted range
                    let is_deleted = deleted_ranges_seconds
                        .iter()
                        .any(|(start, end)| time_seconds >= *start && time_seconds <= *end);

                    if !is_deleted {
                        // Calculate how much time was deleted before this timestamp
                        let deleted_time_before: f64 = deleted_ranges_seconds
                            .iter()
                            .filter(|(start, _end)| *start < time_seconds)
                            .map(|(start, end)| end - start)
                            .sum();

                        // Adjust the timestamp by subtracting deleted time
                        let adjusted_time_seconds = time_seconds - deleted_time_before;
                        let adjusted_time_ms = adjusted_time_seconds * 1000.0;

                        // Update the timestamp in the JSON entry (convert to integer)
                        let mut json_entry = json.clone();
                        json_entry["time"] = serde_json::Value::from(adjusted_time_ms as i64);

                        // Serialize the adjusted entry
                        match serde_json::to_string(&json_entry) {
                            Ok(adjusted_line) => filtered_lines.push(adjusted_line),
                            Err(_) => filtered_lines.push(line.to_string()), // Fallback to original
                        }
                    }
                } else {
                    // Keep lines without timestamp
                    filtered_lines.push(line.to_string());
                }
            }
            Err(_) => {
                // Keep malformed lines
                filtered_lines.push(line.to_string());
            }
        }
    }

    let filtered_content = filtered_lines.join("\n");
    if !filtered_content.is_empty() {
        Ok(format!("{}\n", filtered_content).into_bytes())
    } else {
        Ok(Vec::new())
    }
}

fn filter_sft_json(
    file_path: &std::path::Path,
    deleted_ranges: &[(f64, f64)],
) -> Result<Vec<u8>, String> {
    if deleted_ranges.is_empty() {
        return read_file_contents(file_path);
    }

    let contents = std::fs::read_to_string(file_path)
        .map_err(|e| format!("Failed to read sft.json: {}", e))?;

    let sft_data: Vec<serde_json::Value> =
        serde_json::from_str(&contents).map_err(|e| format!("Failed to parse sft.json: {}", e))?;

    // Convert deleted ranges from milliseconds to seconds
    let deleted_ranges_seconds: Vec<(f64, f64)> = deleted_ranges
        .iter()
        .map(|(start_ms, end_ms)| (start_ms / 1000.0, end_ms / 1000.0))
        .collect();

    // Filter and adjust timestamps
    let mut filtered_sft_data = Vec::new();

    for mut entry in sft_data {
        if let Some(timestamp_ms) = entry.get("timestamp").and_then(|t| t.as_f64()) {
            let timestamp_seconds = timestamp_ms / 1000.0;

            // Check if this timestamp is in any deleted range
            let is_in_deleted_range = deleted_ranges_seconds
                .iter()
                .any(|(start, end)| timestamp_seconds >= *start && timestamp_seconds <= *end);

            if !is_in_deleted_range {
                // Calculate how much time was deleted before this timestamp
                let deleted_time_before: f64 = deleted_ranges_seconds
                    .iter()
                    .filter(|(start, _end)| *start < timestamp_seconds)
                    .map(|(start, end)| end - start)
                    .sum();

                // Adjust the timestamp by subtracting deleted time
                let adjusted_timestamp_seconds = timestamp_seconds - deleted_time_before;
                let adjusted_timestamp_ms = adjusted_timestamp_seconds * 1000.0;

                // Update the timestamp in the entry (convert to integer)
                entry["timestamp"] = serde_json::Value::from(adjusted_timestamp_ms as i64);
                filtered_sft_data.push(entry);
            }
            // If in deleted range, skip this entry entirely
        } else {
            // Keep entries without timestamp
            filtered_sft_data.push(entry);
        }
    }

    let filtered_json = serde_json::to_string_pretty(&filtered_sft_data)
        .map_err(|e| format!("Failed to serialize filtered sft.json: {}", e))?;

    Ok(filtered_json.into_bytes())
}

fn update_meta_json(
    file_path: &std::path::Path,
    deleted_ranges: &[(f64, f64)],
) -> Result<Vec<u8>, String> {
    let contents = std::fs::read_to_string(file_path)
        .map_err(|e| format!("Failed to read meta.json: {}", e))?;

    let mut meta: serde_json::Value =
        serde_json::from_str(&contents).map_err(|e| format!("Failed to parse meta.json: {}", e))?;

    if !deleted_ranges.is_empty() {
        if let Some(original_duration) = meta.get("duration_seconds").and_then(|d| d.as_f64()) {
            // Convert deleted ranges from milliseconds to seconds and calculate total deleted time
            let total_deleted: f64 = deleted_ranges
                .iter()
                .map(|(start_ms, end_ms)| (end_ms - start_ms) / 1000.0)
                .sum();

            let new_duration = (original_duration - total_deleted).max(0.0);
            meta["duration_seconds"] = serde_json::Value::from(new_duration);

            log::info!(
                "[update_meta_json] Updated duration from {:.2}s to {:.2}s (deleted {:.2}s)",
                original_duration,
                new_duration,
                total_deleted
            );
        }
    }

    let updated_json = serde_json::to_string_pretty(&meta)
        .map_err(|e| format!("Failed to serialize updated meta.json: {}", e))?;

    Ok(updated_json.into_bytes())
}

/// Apply video edits by trimming out deleted ranges using FFmpeg
fn apply_video_edits(
    input_path: &std::path::Path,
    deleted_ranges: &[(f64, f64)],
) -> Result<Vec<u8>, String> {
    if deleted_ranges.is_empty() {
        return read_file_contents(input_path);
    }

    log::info!(
        "[apply_video_edits] Processing video with {} deleted ranges",
        deleted_ranges.len()
    );

    // Ensure FFmpeg is initialized
    FFMPEG_PATH.get().ok_or("FFmpeg not initialized")?;

    // Create temporary output file
    let temp_dir = std::env::temp_dir();
    let temp_output = temp_dir.join(format!(
        "edited_video_{}.mp4",
        chrono::Local::now().format("%Y%m%d_%H%M%S_%3f")
    ));

    // Get video duration first
    let duration = get_video_duration(input_path)?;
    log::info!(
        "[apply_video_edits] Original video duration: {:.2}s",
        duration
    );

    // Create segments to keep (inverse of deleted ranges)
    let mut keep_segments = Vec::new();
    let mut current_start = 0.0;

    // Convert ranges from milliseconds to seconds and sort by start time
    let mut sorted_ranges: Vec<(f64, f64)> = deleted_ranges
        .iter()
        .map(|(start_ms, end_ms)| (start_ms / 1000.0, end_ms / 1000.0))
        .collect();
    sorted_ranges.sort_by(|a, b| a.0.partial_cmp(&b.0).unwrap());

    log::info!(
        "[apply_video_edits] Converted deleted ranges from ms to seconds: {:?}",
        sorted_ranges
    );
    log::info!(
        "[apply_video_edits] Video duration: {:.2}s, Processing deletion from {:.2}s to {:.2}s",
        duration,
        sorted_ranges.get(0).map(|(s, _)| *s).unwrap_or(0.0),
        sorted_ranges.get(0).map(|(_, e)| *e).unwrap_or(0.0)
    );

    for (delete_start, delete_end) in sorted_ranges {
        if current_start < delete_start {
            keep_segments.push((current_start, delete_start));
        }
        current_start = delete_end.max(current_start);
    }

    // Add final segment if there's remaining video
    if current_start < duration {
        keep_segments.push((current_start, duration));
    }

    if keep_segments.is_empty() {
        return Err("No video segments left after applying edits".to_string());
    }

    log::info!(
        "[apply_video_edits] Keeping {} segments: {:?}",
        keep_segments.len(),
        keep_segments
    );

    // Create FFmpeg filter for concatenation
    if keep_segments.len() == 1 {
        // Simple trim case
        let (start, end) = keep_segments[0];
        trim_video_segment(input_path, &temp_output, start, end - start)?;
    } else {
        // Multiple segments - need to concatenate
        concatenate_video_segments(input_path, &temp_output, &keep_segments)?;
    }

    // Read the processed video
    let result = read_file_contents(&temp_output);

    // Clean up temporary file
    if let Err(e) = std::fs::remove_file(&temp_output) {
        log::warn!("[apply_video_edits] Failed to cleanup temp file: {}", e);
    }

    result
}

/// Trim a single video segment using FFmpeg
fn trim_video_segment(
    input_path: &std::path::Path,
    output_path: &std::path::Path,
    start_seconds: f64,
    duration_seconds: f64,
) -> Result<(), String> {
    let ffmpeg_path = FFMPEG_PATH.get().ok_or("FFmpeg not initialized")?;

    log::info!(
        "[trim_video_segment] Trimming from {:.2}s for {:.2}s",
        start_seconds,
        duration_seconds
    );

    let mut command = std::process::Command::new(ffmpeg_path);

    #[cfg(windows)]
    {
        use std::os::windows::process::CommandExt;
        command.creation_flags(0x08000000); // CREATE_NO_WINDOW
    }

    let output = command
        .args([
            "-i",
            input_path.to_str().unwrap(),
            "-ss",
            &start_seconds.to_string(),
            "-t",
            &duration_seconds.to_string(),
            "-c:v",
            "libx264", // Re-encode for precision
            "-c:a",
            "aac", // Re-encode audio
            "-preset",
            "ultrafast", // Fast encoding
            "-avoid_negative_ts",
            "make_zero",
            "-y", // Overwrite output file
            output_path.to_str().unwrap(),
        ])
        .output()
        .map_err(|e| format!("Failed to execute FFmpeg: {}", e))?;

    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        return Err(format!("FFmpeg failed: {}", stderr));
    }

    Ok(())
}

/// Concatenate multiple video segments using FFmpeg
fn concatenate_video_segments(
    input_path: &std::path::Path,
    output_path: &std::path::Path,
    segments: &[(f64, f64)],
) -> Result<(), String> {
    let ffmpeg_path = FFMPEG_PATH.get().ok_or("FFmpeg not initialized")?;

    log::info!(
        "[concatenate_video_segments] Concatenating {} segments",
        segments.len()
    );

    // Create temporary directory for segment files
    let temp_dir = std::env::temp_dir().join(format!(
        "video_segments_{}",
        chrono::Local::now().format("%Y%m%d_%H%M%S_%3f")
    ));
    std::fs::create_dir_all(&temp_dir)
        .map_err(|e| format!("Failed to create temp directory: {}", e))?;

    let mut segment_files = Vec::new();
    let mut concat_list = String::new();

    // Extract each segment
    for (i, (start, end)) in segments.iter().enumerate() {
        let segment_file = temp_dir.join(format!("segment_{}.mp4", i));
        trim_video_segment(input_path, &segment_file, *start, end - start)?;

        concat_list.push_str(&format!("file '{}'\n", segment_file.to_str().unwrap()));
        segment_files.push(segment_file);
    }

    // Write concat list file
    let concat_file = temp_dir.join("concat_list.txt");
    std::fs::write(&concat_file, concat_list)
        .map_err(|e| format!("Failed to write concat file: {}", e))?;

    // Concatenate segments
    let mut command = std::process::Command::new(ffmpeg_path);

    #[cfg(windows)]
    {
        use std::os::windows::process::CommandExt;
        command.creation_flags(0x08000000); // CREATE_NO_WINDOW
    }

    let output = command
        .args([
            "-f",
            "concat",
            "-safe",
            "0",
            "-i",
            concat_file.to_str().unwrap(),
            "-c:v",
            "libx264",
            "-c:a",
            "aac",
            "-preset",
            "ultrafast",
            "-y",
            output_path.to_str().unwrap(),
        ])
        .output()
        .map_err(|e| format!("Failed to execute FFmpeg concat: {}", e))?;

    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);

        // Clean up temp files before returning error
        let _ = std::fs::remove_dir_all(&temp_dir);

        return Err(format!("FFmpeg concat failed: {}", stderr));
    }

    // Clean up temporary files
    if let Err(e) = std::fs::remove_dir_all(&temp_dir) {
        log::warn!(
            "[concatenate_video_segments] Failed to cleanup temp directory: {}",
            e
        );
    }

    Ok(())
}

/// Get video duration using FFprobe
fn get_video_duration(video_path: &std::path::Path) -> Result<f64, String> {
    use crate::tools::ffmpeg::FFPROBE_PATH;

    let ffprobe_path = FFPROBE_PATH.get().ok_or("FFprobe not initialized")?;

    let mut command = std::process::Command::new(ffprobe_path);

    #[cfg(windows)]
    {
        use std::os::windows::process::CommandExt;
        command.creation_flags(0x08000000); // CREATE_NO_WINDOW
    }

    let output = command
        .args([
            "-v",
            "quiet",
            "-print_format",
            "json",
            "-show_format",
            video_path.to_str().unwrap(),
        ])
        .output()
        .map_err(|e| format!("Failed to execute FFprobe: {}", e))?;

    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        return Err(format!("FFprobe failed: {}", stderr));
    }

    let output_str = String::from_utf8_lossy(&output.stdout);
    let json: serde_json::Value = serde_json::from_str(&output_str)
        .map_err(|e| format!("Failed to parse FFprobe output: {}", e))?;

    let duration_str = json["format"]["duration"]
        .as_str()
        .ok_or("Duration not found in FFprobe output")?;

    duration_str
        .parse::<f64>()
        .map_err(|e| format!("Failed to parse duration: {}", e))
}

pub async fn get_current_demonstration() -> Result<Option<Demonstration>, String> {
    if let Ok(global_state) = DEMONSTRATION_STATE.lock() {
        Ok(global_state.current_demonstration.clone())
    } else {
        Ok(None)
    }
}
