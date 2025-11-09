//! Simple FFmpeg binary management using embedded binaries.
//!
//! This module provides access to FFmpeg and FFprobe binaries that are embedded
//! directly in the project, eliminating the need for downloads or complex detection.

use once_cell::sync::OnceCell;
use std::path::PathBuf;

/// Global FFmpeg binary path
pub static FFMPEG_PATH: OnceCell<PathBuf> = OnceCell::new();

/// Global FFprobe binary path
pub static FFPROBE_PATH: OnceCell<PathBuf> = OnceCell::new();

/// Get the embedded FFmpeg binary path for the current platform
pub fn get_embedded_ffmpeg_path() -> Option<PathBuf> {
    if let Ok(exe_path) = std::env::current_exe() {
        if let Some(exe_dir) = exe_path.parent() {
            // In development, binaries are in src-tauri/binaries/
            let exe_dir_str = exe_dir.to_string_lossy();
            if exe_dir_str.contains("/target/debug") || exe_dir_str.contains("\\target\\debug") {
                let project_root = exe_dir.parent()?.parent()?.parent()?; // target/debug -> target -> src-tauri -> project
                return Some(
                    project_root
                        .join("src-tauri")
                        .join("binaries")
                        .join(get_platform_dir())
                        .join(get_ffmpeg_name()),
                );
            }

            // In production app bundle (macOS/Windows):
            // Agent is in a subdirectory: app_root/agent/clones-desktop(.exe)
            // FFmpeg is at: app_root/ffmpeg-binaries/
            // So we need to go up one level from the agent directory
            if let Some(app_root) = exe_dir.parent() {
                let ffmpeg_path = app_root.join("ffmpeg-binaries").join(get_ffmpeg_name());
                if ffmpeg_path.exists() {
                    return Some(ffmpeg_path);
                }
            }

            // Fallback: try next to executable (for other deployment scenarios)
            let ffmpeg_path = exe_dir.join("ffmpeg-binaries").join(get_ffmpeg_name());
            if ffmpeg_path.exists() {
                return Some(ffmpeg_path);
            }
        }
    }
    None
}

/// Get the embedded FFprobe binary path for the current platform
pub fn get_embedded_ffprobe_path() -> Option<PathBuf> {
    if let Ok(exe_path) = std::env::current_exe() {
        if let Some(exe_dir) = exe_path.parent() {
            // In development, binaries are in src-tauri/binaries/
            let exe_dir_str = exe_dir.to_string_lossy();
            if exe_dir_str.contains("/target/debug") || exe_dir_str.contains("\\target\\debug") {
                let project_root = exe_dir.parent()?.parent()?.parent()?; // target/debug -> target -> src-tauri -> project
                return Some(
                    project_root
                        .join("src-tauri")
                        .join("binaries")
                        .join(get_platform_dir())
                        .join(get_ffprobe_name()),
                );
            }

            // In production app bundle (macOS/Windows):
            // Agent is in a subdirectory: app_root/agent/clones-desktop(.exe)
            // FFmpeg is at: app_root/ffmpeg-binaries/
            // So we need to go up one level from the agent directory
            if let Some(app_root) = exe_dir.parent() {
                let ffprobe_path = app_root.join("ffmpeg-binaries").join(get_ffprobe_name());
                if ffprobe_path.exists() {
                    return Some(ffprobe_path);
                }
            }

            // Fallback: try next to executable (for other deployment scenarios)
            let ffprobe_path = exe_dir.join("ffmpeg-binaries").join(get_ffprobe_name());
            if ffprobe_path.exists() {
                return Some(ffprobe_path);
            }
        }
    }
    None
}

/// Get the platform-specific directory name
fn get_platform_dir() -> &'static str {
    if cfg!(target_os = "macos") {
        "macos"
    } else if cfg!(target_os = "windows") {
        "windows"
    } else {
        "linux"
    }
}

/// Get the platform-specific FFmpeg binary name
fn get_ffmpeg_name() -> &'static str {
    if cfg!(target_os = "windows") {
        "ffmpeg.exe"
    } else {
        "ffmpeg"
    }
}

/// Get the platform-specific FFprobe binary name
fn get_ffprobe_name() -> &'static str {
    if cfg!(target_os = "windows") {
        "ffprobe.exe"
    } else {
        "ffprobe"
    }
}

/// Initialize FFmpeg binary path (now just sets the global path)
pub fn init_ffmpeg() -> Result<(), String> {
    if FFMPEG_PATH.get().is_some() {
        log::info!("[FFmpeg] FFmpeg already initialized");
        return Ok(());
    }

    if let Some(path) = get_embedded_ffmpeg_path() {
        if path.exists() {
            log::info!("[FFmpeg] Using embedded FFmpeg at: {}", path.display());
            FFMPEG_PATH
                .set(path)
                .map_err(|_| "Failed to set FFmpeg path")?;
            return Ok(());
        }
    }

    Err("Embedded FFmpeg binary not found".to_string())
}

/// Initialize FFprobe binary path (now just sets the global path)
pub fn init_ffprobe() -> Result<(), String> {
    if FFPROBE_PATH.get().is_some() {
        log::info!("[FFmpeg] FFprobe already initialized");
        return Ok(());
    }

    if let Some(path) = get_embedded_ffprobe_path() {
        if path.exists() {
            log::info!("[FFmpeg] Using embedded FFprobe at: {}", path.display());
            FFPROBE_PATH
                .set(path)
                .map_err(|_| "Failed to set FFprobe path")?;
            return Ok(());
        }
    }

    Err("Embedded FFprobe binary not found".to_string())
}

/// Get the FFmpeg binary path
pub fn get_ffmpeg_dir() -> PathBuf {
    FFMPEG_PATH.get().cloned().unwrap_or_default()
}

/// Get the FFprobe binary path  
pub fn get_ffprobe_dir() -> PathBuf {
    FFPROBE_PATH.get().cloned().unwrap_or_default()
}

/// Check if FFmpeg is available
#[allow(dead_code)]
pub fn is_ffmpeg_available() -> bool {
    get_embedded_ffmpeg_path().map_or(false, |p| p.exists())
}

/// Check if FFprobe is available
#[allow(dead_code)]
pub fn is_ffprobe_available() -> bool {
    get_embedded_ffprobe_path().map_or(false, |p| p.exists())
}

#[cfg(not(target_os = "macos"))]
use std::io::Write;
#[cfg(not(target_os = "macos"))]
use std::process::{Command, Stdio};
#[cfg(not(target_os = "macos"))]
use std::sync::{
    atomic::{AtomicBool, Ordering},
    Arc,
};
#[cfg(not(target_os = "macos"))]
use std::thread;
#[cfg(not(target_os = "macos"))]
use std::time::Duration;

/// FFmpeg recorder structure for video recording
#[cfg(not(target_os = "macos"))]
pub struct FFmpegRecorder {
    width: u32,
    height: u32,
    fps: u32,
    output_path: PathBuf,
    process: Option<std::process::Child>,
    input_format: Option<String>,
    input_device: Option<String>,
    /// Signal that FFmpeg is ready and capturing frames
    pub ready_signal: Arc<AtomicBool>,
}

#[cfg(not(target_os = "macos"))]
impl FFmpegRecorder {
    /// Create a new FFmpeg recorder with input
    pub fn new_with_input(
        width: u32,
        height: u32,
        fps: u32,
        output_path: PathBuf,
        input_format: String,
        input_device: String,
    ) -> Result<Self, String> {
        log::info!(
            "[FFmpeg] Creating new recorder with input format {}: {}x{} @ {} fps -> {}",
            input_format,
            width,
            height,
            fps,
            output_path.display()
        );

        Ok(Self {
            width,
            height,
            fps,
            output_path,
            process: None,
            input_format: Some(input_format),
            input_device: Some(input_device),
            ready_signal: Arc::new(AtomicBool::new(false)),
        })
    }

    /// Get the input format for this recorder
    pub fn input_format(&self) -> Option<&String> {
        self.input_format.as_ref()
    }

    /// Wait for FFmpeg to be ready (capturing frames)
    pub fn wait_until_ready(&self, timeout_ms: u64) -> bool {
        let start = std::time::Instant::now();
        let timeout = Duration::from_millis(timeout_ms);

        while start.elapsed() < timeout {
            if self.ready_signal.load(Ordering::Relaxed) {
                log::info!("[FFmpeg] Ready signal received after {:?}", start.elapsed());
                return true;
            }
            std::thread::sleep(Duration::from_millis(50));
        }

        log::warn!(
            "[FFmpeg] Timeout waiting for ready signal after {:?}",
            timeout
        );
        false
    }

    /// Start the recording process
    pub fn start(&mut self) -> Result<(), String> {
        log::info!(
            "[FFmpeg] Starting recording: {}x{} @ {} fps",
            self.width,
            self.height,
            self.fps
        );

        let ffmpeg_path = get_embedded_ffmpeg_path()
            .ok_or_else(|| "Embedded FFmpeg binary not found".to_string())?;

        let mut args: Vec<String> = Vec::new();

        // Input format args
        if let (Some(format), Some(device)) = (&self.input_format, &self.input_device) {
            args.extend([
                "-f".to_string(),
                format.clone(),
                "-video_size".to_string(),
                format!("{}x{}", self.width, self.height),
                "-framerate".to_string(),
                self.fps.to_string(),
            ]);

            // Platform specific options
            if format == "gdigrab" {
                // Windows gdigrab: enable cursor and add stability-related options
                args.extend([
                    "-draw_mouse".to_string(),
                    "1".to_string(),
                    // Keep zero offsets by default (full desktop). If you later add region capture,
                    // these can be overridden.
                    "-offset_x".to_string(),
                    "0".to_string(),
                    "-offset_y".to_string(),
                    "0".to_string(),
                    // Increase probe size to help FFmpeg detect properties reliably on some GPUs
                    "-probesize".to_string(),
                    "10M".to_string(),
                    // Prevent buffer overflows on high-resolution/hi-fps displays
                    "-thread_queue_size".to_string(),
                    "1024".to_string(),
                ]);
            } else if format == "avfoundation" {
                args.extend(["-capture_cursor".to_string(), "1".to_string()]);
            }

            args.extend(["-i".to_string(), device.clone()]);
        }

        // Output encoding args
        args.extend([
            "-c:v".to_string(),
            "libx264".to_string(),
            "-preset".to_string(),
            "ultrafast".to_string(),
            "-crf".to_string(),
            "23".to_string(),
            "-pix_fmt".to_string(),
            "yuv420p".to_string(), // Required for compatibility
            "-movflags".to_string(),
            "+faststart".to_string(), // Enable streaming playback
            "-profile:v".to_string(),
            "high".to_string(),
            "-tune".to_string(),
            "zerolatency".to_string(), // Reduce encoding latency
            "-y".to_string(),
            self.output_path.to_str().unwrap().to_string(),
        ]);

        log::info!(
            "[FFmpeg] Command: {} {}",
            ffmpeg_path.display(),
            args.join(" ")
        );

        let mut command = Command::new(&ffmpeg_path);
        #[cfg(windows)]
        {
            use std::os::windows::process::CommandExt;
            command.creation_flags(0x08000000);
        }

        let mut process = command
            .args(&args)
            .stdin(Stdio::piped())
            .stdout(Stdio::piped())
            .stderr(Stdio::piped())
            .spawn()
            .map_err(|e| format!("Failed to start FFmpeg: {}", e))?;

        // Handle stderr for ready signal
        if let Some(stderr) = process.stderr.take() {
            let ready_signal = self.ready_signal.clone();
            thread::spawn(move || {
                use std::io::{BufRead, BufReader};
                let stderr_reader = BufReader::new(stderr);
                for line in stderr_reader.lines() {
                    if let Ok(line) = line {
                        log::info!("[FFmpeg] stderr: {}", line);
                        if line.contains("Press [q] to stop") {
                            log::info!("[FFmpeg] Ready signal detected");
                            ready_signal.store(true, Ordering::Relaxed);
                        }
                    }
                }
            });
        }

        self.process = Some(process);
        Ok(())
    }

    /// Stop the recorder with timeout and validation
    pub fn stop(&mut self) -> Result<(), String> {
        log::info!("[FFmpeg] Stopping recording");
        if let Some(mut process) = self.process.take() {
            // Send 'q' to FFmpeg for graceful shutdown
            if let Some(mut stdin) = process.stdin.take() {
                if let Err(e) = stdin.write_all(b"q") {
                    log::warn!("[FFmpeg] Failed to send 'q' command: {}", e);
                }
            }

            // Wait for graceful exit with timeout
            let start_time = std::time::Instant::now();
            let timeout = Duration::from_secs(15);
            let mut exit_status = None;

            while start_time.elapsed() < timeout {
                match process.try_wait() {
                    Ok(Some(status)) => {
                        exit_status = Some(status);
                        break;
                    }
                    Ok(None) => {
                        // Process still running, continue waiting
                        std::thread::sleep(Duration::from_millis(100));
                    }
                    Err(e) => {
                        return Err(format!("Error checking FFmpeg process status: {}", e));
                    }
                }
            }

            // If timeout, force kill
            if exit_status.is_none() {
                log::warn!("[FFmpeg] Graceful shutdown timed out, force killing process");
                if let Err(e) = process.kill() {
                    log::error!("[FFmpeg] Failed to force kill process: {}", e);
                }
                if let Err(e) = process.wait() {
                    log::error!("[FFmpeg] Failed to wait for killed process: {}", e);
                }
            }

            // Validate output file
            if self.output_path.exists() {
                match std::fs::metadata(&self.output_path) {
                    Ok(metadata) => {
                        if metadata.len() > 0 {
                            log::info!(
                                "[FFmpeg] Recording completed successfully: {} ({} bytes)",
                                self.output_path.display(),
                                metadata.len()
                            );
                        } else {
                            return Err(format!(
                                "Output file is empty: {}",
                                self.output_path.display()
                            ));
                        }
                    }
                    Err(e) => {
                        return Err(format!(
                            "Failed to check output file metadata: {}",
                            e
                        ));
                    }
                }
            } else {
                return Err(format!(
                    "Output file was not created: {}",
                    self.output_path.display()
                ));
            }

            Ok(())
        } else {
            log::warn!("[FFmpeg] No process to stop");
            Ok(())
        }
    }

    /// Force kill the process
    pub fn force_kill(&mut self) {
        if let Some(mut process) = self.process.take() {
            if let Err(e) = process.kill() {
                log::error!("[FFmpeg] Failed to force kill process: {}", e);
            }
            let _ = process.wait();
        }
    }
}
