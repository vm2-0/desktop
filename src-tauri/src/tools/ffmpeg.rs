//! FFmpeg and FFprobe integration for video recording and processing.
//!
//! This module manages the download, initialization, and use of FFmpeg and FFprobe binaries, and provides a recorder struct for capturing video.

use crate::core::archive;
use crate::utils::downloader::download_file;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::sync::OnceLock;

// #[cfg(not(target_os = "macos"))]
use {
    std::io::Write,
    std::process::Stdio,
    std::sync::{
        atomic::{AtomicBool, Ordering},
        Arc,
    },
    std::thread,
    std::time::Duration,
};

/// Path to the FFmpeg binary, initialized once per session.
pub static FFMPEG_PATH: OnceLock<PathBuf> = OnceLock::new();
/// Path to the FFprobe binary, initialized once per session.
pub static FFPROBE_PATH: OnceLock<PathBuf> = OnceLock::new();

fn get_temp_dir() -> PathBuf {
    let mut temp = std::env::temp_dir();
    temp.push("clones-desktop");
    temp
}

/// Checks for ffmpeg in the PATH and in the temp directory
///
/// # Returns
/// * `PathBuf` containing the full file path if found, or an empty `PathBuf` if not found.
pub fn get_ffmpeg_dir() -> PathBuf {
    // First check if ffmpeg is in PATH
    let mut command = Command::new("ffmpeg");
    #[cfg(windows)]
    {
        use std::os::windows::process::CommandExt;
        command.creation_flags(0x08000000); // CREATE_NO_WINDOW constant
    }
    if let Ok(output) = command.arg("-version").output() {
        if output.status.success() {
            log::info!("[FFmpeg] Found FFmpeg in system PATH");
            return "ffmpeg".into();
        }
    }
    log::info!("[FFmpeg] FFmpeg not found in PATH, checking temp directory");

    // Check if ffmpeg exists in temp directory
    let temp_dir = get_temp_dir();
    if !temp_dir.exists() {
        return PathBuf::new();
    }

    let ffmpeg_path = temp_dir.join(if cfg!(windows) {
        "ffmpeg.exe"
    } else {
        "ffmpeg"
    });

    if ffmpeg_path.exists() {
        return ffmpeg_path;
    }

    // Not found or not working
    PathBuf::new()
}

/// Checks for ffprobe in the PATH and in the temp directory
///
/// # Returns
/// * `PathBuf` containing the full file path if found, or an empty `PathBuf` if not found.
pub fn get_ffprobe_dir() -> PathBuf {
    // First check if ffprobe is in PATH
    let mut command = Command::new("ffprobe");
    #[cfg(windows)]
    {
        use std::os::windows::process::CommandExt;
        command.creation_flags(0x08000000); // CREATE_NO_WINDOW constant
    }
    if let Ok(output) = command.arg("-version").output() {
        if output.status.success() {
            log::info!("[FFmpeg] Found FFprobe in system PATH");
            return "ffprobe".into();
        }
    }
    log::info!("[FFmpeg] FFprobe not found in PATH, checking temp directory");

    // Check if ffprobe exists in temp directory
    let temp_dir = get_temp_dir();
    if !temp_dir.exists() {
        return PathBuf::new();
    }

    let ffprobe_path = temp_dir.join(if cfg!(windows) {
        "ffprobe.exe"
    } else {
        "ffprobe"
    });

    if ffprobe_path.exists() {
        // Verify the binary works
        return ffprobe_path;
    }

    // Not found or not working
    PathBuf::new()
}

/// Extracts binary from archive based on OS type
fn extract_binary(
    archive_path: &Path,
    binary_path: &Path,
    binary_name: &str,
    os_type: &str,
) -> Result<bool, String> {
    if os_type.starts_with("windows") {
        // For Windows, look for bin/ffmpeg.exe or bin/ffprobe.exe
        archive::extract_from_zip(
            archive_path,
            binary_path,
            &format!("/bin/{}.exe", binary_name),
        )
    } else if os_type.starts_with("macos") {
        // For macOS, just look for the binary name
        archive::extract_from_zip(archive_path, binary_path, binary_name)
    } else if os_type.starts_with("linux") {
        // For Linux, we need to handle ffmpeg vs ffprobe differently
        let exclude_pattern = if binary_name == "ffmpeg" {
            Some("ffprobe")
        } else {
            None
        };

        archive::extract_from_tar_xz(archive_path, binary_path, binary_name, exclude_pattern)
    } else {
        Err(format!("Unsupported OS type: {}", os_type))
    }
}

/// Downloads and extracts a binary from an archive
/// If keep_archive is true, the archive file will not be deleted after extraction
/// If url is empty, it assumes the archive already exists and skips the download step
fn download_and_extract_binary(
    url: &str,
    archive_path: &Path,
    binary_path: &Path,
    binary_name: &str,
    os_type: &str,
    keep_archive: bool,
) -> Result<(), String> {
    // We'll use this to track if we've already attempted a retry
    let mut retry_attempted = false;

    // Function to handle the download process
    let download_archive = || -> Result<(), String> {
        if !url.is_empty() {
            log::info!(
                "[FFmpeg] Downloading {} for {} from {}",
                binary_name,
                os_type,
                url
            );

            // Download the archive
            download_file(url, archive_path)?;
        } else {
            // Just using existing archive, no download needed
            if !archive_path.exists() {
                return Err(format!(
                    "Archive file not found at {}",
                    archive_path.display()
                ));
            }
            log::info!(
                "[FFmpeg] Using existing archive for {} at {}",
                binary_name,
                archive_path.display()
            );
        }
        Ok(())
    };

    // Initial download attempt
    if !archive_path.exists() || url.is_empty() {
        download_archive()?;
    } else {
        log::info!(
            "[FFmpeg] Using existing archive for {} at {}",
            binary_name,
            archive_path.display()
        );
    }

    // Extraction process with retry logic
    loop {
        log::info!("[FFmpeg] Extracting {} from archive", binary_name);

        match extract_binary(archive_path, binary_path, binary_name, os_type) {
            Ok(true) => {
                // Binary was found and extracted successfully
                break;
            }
            Ok(false) => {
                // Archive was processed but binary wasn't found
                let error_msg = format!("Could not find {} binary in archive", binary_name);
                log::info!("[FFmpeg] Error: {}", error_msg);
                return Err(error_msg);
            }
            Err(e) if e == "RETRY_NEEDED" && !retry_attempted => {
                // Need to retry - download again
                log::info!("[FFmpeg] Retrying download after archive corruption");
                retry_attempted = true;

                // Delete corrupted archive
                if let Err(del_err) = fs::remove_file(archive_path) {
                    log::info!(
                        "[FFmpeg] Warning: Failed to delete corrupted archive: {}",
                        del_err
                    );
                }

                // Re-download if URL was provided
                if !url.is_empty() {
                    download_file(url, archive_path)?;
                } else {
                    return Err("Archive is corrupted and no URL provided for retry".to_string());
                }

                continue;
            }
            Err(e) => {
                // Any other error or retry already attempted
                return Err(e);
            }
        }
    }

    // Make executable on Unix
    #[cfg(unix)]
    archive::make_file_executable(binary_path)?;

    // Clean up archive file if not keeping it
    if !keep_archive {
        archive::cleanup_archive(archive_path)?;
    }

    Ok(())
}

/// Initialize both FFmpeg and FFprobe binaries.
///
/// # Returns
/// * `Ok(())` if both binaries were initialized successfully.
/// * `Err` if initialization failed.
pub fn init_ffmpeg_and_ffprobe() -> Result<(), String> {
    // Initialize FFmpeg first
    init_ffmpeg()?;

    // Then initialize FFprobe
    init_ffprobe()?;

    Ok(())
}

/// Initialize the FFmpeg binary.
///
/// # Returns
/// * `Ok(())` if FFmpeg was initialized successfully.
/// * `Err` if initialization failed.
pub fn init_ffmpeg() -> Result<(), String> {
    if FFMPEG_PATH.get().is_some() {
        log::info!("[FFmpeg] FFmpeg already initialized");
        return Ok(());
    }

    log::info!("[FFmpeg] Initializing FFmpeg");

    // Check for existing ffmpeg
    let ffmpeg_path = get_ffmpeg_dir();

    // If ffmpeg binary is found and working, use it
    if !ffmpeg_path.as_os_str().is_empty() {
        log::info!(
            "[FFmpeg] Using existing FFmpeg binary at {}",
            ffmpeg_path.display()
        );
        if let Err(_) = FFMPEG_PATH.set(ffmpeg_path.clone()) {
            log::warn!("[FFmpeg] FFMPEG_PATH already set, skipping");
        }
        return Ok(());
    }

    // Need to download the binary
    log::info!("[FFmpeg] Need to download FFmpeg binary");

    // Ensure temp directory exists
    let temp_dir = get_temp_dir();
    fs::create_dir_all(&temp_dir).map_err(|e| {
        log::info!("[FFmpeg] Error: Failed to create temp directory: {}", e);
        format!("Failed to create temp directory: {}", e)
    })?;

    // Define path for the binary we'll download
    let ffmpeg_path = temp_dir.join(if cfg!(windows) {
        "ffmpeg.exe"
    } else {
        "ffmpeg"
    });

    // Remove any existing binary that might be corrupted
    if ffmpeg_path.exists() {
        log::info!("[FFmpeg] Removing existing FFmpeg binary for fresh download");
        let _ = fs::remove_file(&ffmpeg_path);
    }

    // Download and extract FFmpeg
    let (url, os) = if cfg!(windows) {
        (get_ffmpeg_url_windows(), "windows")
    } else if cfg!(target_os = "macos") {
        (get_ffmpeg_url_macos(), "macos")
    } else {
        (get_ffmpeg_url_linux(), "linux")
    };

    let archive_path = temp_dir.join("ffmpeg.archive");

    // On Windows and Linux, we need to keep the archive for ffprobe extraction
    #[cfg(not(target_os = "macos"))]
    let keep_archive = true;
    #[cfg(target_os = "macos")]
    let keep_archive = false;

    download_and_extract_binary(
        &url,
        &archive_path,
        &ffmpeg_path,
        "ffmpeg",
        os,
        keep_archive,
    )?;

    // Set the path
    log::info!(
        "[FFmpeg] FFmpeg successfully initialized in {:?}",
        ffmpeg_path
    );
    if let Err(_) = FFMPEG_PATH.set(ffmpeg_path.clone()) {
        log::warn!("[FFmpeg] FFMPEG_PATH already set during download, skipping");
    }
    Ok(())
}

/// Initialize the FFprobe binary.
///
/// # Returns
/// * `Ok(())` if FFprobe was initialized successfully.
/// * `Err` if initialization failed.
pub fn init_ffprobe() -> Result<(), String> {
    if FFPROBE_PATH.get().is_some() {
        log::info!("[FFmpeg] FFprobe already initialized");
        return Ok(());
    }

    log::info!("[FFmpeg] Initializing FFprobe");

    // Check for existing ffprobe
    let ffprobe_path = get_ffprobe_dir();

    // If ffprobe binary is found and working, use it
    if !ffprobe_path.as_os_str().is_empty() {
        log::info!(
            "[FFmpeg] Using existing FFprobe binary at {}",
            ffprobe_path.display()
        );
        if let Err(_) = FFPROBE_PATH.set(ffprobe_path.clone()) {
            log::warn!("[FFmpeg] FFPROBE_PATH already set, skipping");
        }
        return Ok(());
    }

    // Need to download the binary
    log::info!("[FFmpeg] Need to download FFprobe binary");

    // Ensure temp directory exists
    let temp_dir = get_temp_dir();
    fs::create_dir_all(&temp_dir).map_err(|e| {
        log::info!("[FFmpeg] Error: Failed to create temp directory: {}", e);
        format!("Failed to create temp directory: {}", e)
    })?;

    // Define path for the binary we'll download
    let ffprobe_path = temp_dir.join(if cfg!(windows) {
        "ffprobe.exe"
    } else {
        "ffprobe"
    });

    // Remove any existing binary that might be corrupted
    if ffprobe_path.exists() {
        log::info!("[FFmpeg] Removing existing FFprobe binary for fresh download");
        let _ = fs::remove_file(&ffprobe_path);
    }

    // For macOS, FFprobe has a separate download URL
    #[cfg(target_os = "macos")]
    {
        let archive_path = temp_dir.join("ffprobe.archive");
        let url = get_ffprobe_url_macos();
        download_and_extract_binary(
            &url,
            &archive_path,
            &ffprobe_path,
            "ffprobe",
            "macos",
            false, // On macOS, ffprobe has its own archive, so we don't need to keep it
        )?;
    }

    // For Windows and Linux, FFprobe is included in the same archive as FFmpeg
    #[cfg(not(target_os = "macos"))]
    {
        // We need to use the FFmpeg archive which contains FFprobe
        let (url, os) = if cfg!(windows) {
            (get_ffmpeg_url_windows(), "windows")
        } else if cfg!(target_os = "macos") {
            (get_ffmpeg_url_macos(), "macos")
        } else {
            (get_ffmpeg_url_linux(), "linux")
        };

        let archive_path = temp_dir.join("ffmpeg.archive");
        download_and_extract_binary(&url, &archive_path, &ffprobe_path, "ffprobe", os, true)?;
    }

    // Set the path
    log::info!(
        "[FFmpeg] FFprobe successfully initialized in {:?}",
        ffprobe_path
    );
    if let Err(_) = FFPROBE_PATH.set(ffprobe_path.clone()) {
        log::warn!("[FFmpeg] FFPROBE_PATH already set during download, skipping");
    }
    Ok(())
}

// #[cfg(not(target_os = "macos"))]
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

// #[cfg(not(target_os = "macos"))]
impl FFmpegRecorder {
    /// Creates a new `FFmpegRecorder` with the specified input format and device.
    ///
    /// # Arguments
    /// * `width` - Video width in pixels.
    /// * `height` - Video height in pixels.
    /// * `fps` - Frames per second.
    /// * `output_path` - Path to the output video file.
    /// * `input_format` - Input format string (e.g., "gdigrab", "avfoundation").
    /// * `input_device` - Input device string.
    ///
    /// # Returns
    /// * `FFmpegRecorder` instance.
    pub fn new_with_input(
        width: u32,
        height: u32,
        fps: u32,
        output_path: PathBuf,
        input_format: String,
        input_device: String,
    ) -> Self {
        log::info!(
            "[FFmpeg] Creating new recorder with input format {}: {}x{} @ {} fps -> {}",
            input_format,
            width,
            height,
            fps,
            output_path.display()
        );

        Self {
            width,
            height,
            fps,
            output_path,
            process: None,
            input_format: Some(input_format),
            input_device: Some(input_device),
            ready_signal: Arc::new(AtomicBool::new(false)),
        }
    }

    /// Wait for FFmpeg to be ready (capturing frames)
    /// Returns true if ready within timeout, false otherwise
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

    /// Starts the recording process using FFmpeg.
    ///
    /// # Returns
    /// * `Ok(())` if recording started successfully.
    /// * `Err` if FFmpeg could not be started or failed immediately.
    pub fn start(&mut self) -> Result<(), String> {
        log::info!(
            "[FFmpeg] Starting recording: {}x{} @ {} fps",
            self.width,
            self.height,
            self.fps
        );
        let ffmpeg = FFMPEG_PATH.get().ok_or_else(|| {
            log::info!("[FFmpeg] Error: FFmpeg not initialized");
            "FFmpeg not initialized".to_string()
        })?;

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
                args.extend([
                    "-draw_mouse".to_string(),
                    "1".to_string(),
                    "-offset_x".to_string(),
                    "0".to_string(),
                    "-offset_y".to_string(),
                    "0".to_string(),
                    "-probesize".to_string(),
                    "10M".to_string(),
                    "-thread_queue_size".to_string(),
                    "1024".to_string(),
                ]);
            } else if format == "avfoundation" {
                args.extend(["-capture_cursor".to_string(), "1".to_string()]);
            }

            args.extend(["-i".to_string(), device.clone()]);
        } else {
            // Fallback to raw video input
            args.extend([
                "-f".to_string(),
                "rawvideo".to_string(),
                "-pixel_format".to_string(),
                "rgb24".to_string(),
                "-video_size".to_string(),
                format!("{}x{}", self.width, self.height),
                "-framerate".to_string(),
                self.fps.to_string(),
                "-i".to_string(),
                "-".to_string(), // Read from stdin
            ]);
        }

        // Output encoding args
        args.extend([
            "-c:v".to_string(),
            "libx264".to_string(),
            "-preset".to_string(),
            "ultrafast".to_string(),
            "-crf".to_string(),
            "23".to_string(), // Balance between quality and file size
            "-pix_fmt".to_string(),
            "yuv420p".to_string(), // Required for compatibility
            "-movflags".to_string(),
            "+faststart".to_string(), // Enable streaming playback
            "-profile:v".to_string(),
            "high".to_string(),
            "-tune".to_string(),
            "zerolatency".to_string(), // Reduce encoding latency
            "-y".to_string(),          // Overwrite output file
            self.output_path.to_str().unwrap().to_string(),
        ]);

        log::info!("[FFmpeg] Command: {} {}", ffmpeg.display(), args.join(" "));
        let mut command = Command::new(ffmpeg);
        #[cfg(windows)]
        {
            use std::os::windows::process::CommandExt;
            command.creation_flags(0x08000000); // CREATE_NO_WINDOW constant
        }
        let mut process = command
            .args(&args)
            .stdin(Stdio::piped())
            .stdout(Stdio::piped())
            .stderr(Stdio::piped())
            .spawn()
            .map_err(|e| {
                log::info!("[FFmpeg] Error: Failed to start process: {}", e);
                format!("Failed to start FFmpeg: {}", e)
            })?;

        // Spawn threads to handle stdout and stderr in real-time
        if let Some(stdout) = process.stdout.take() {
            let stdout_reader = std::io::BufReader::new(stdout);
            thread::spawn(move || {
                use std::io::BufRead;
                for line in stdout_reader.lines() {
                    if let Ok(line) = line {
                        log::info!("[FFmpeg] stdout: {}", line);
                        let _ = crate::core::record::log_ffmpeg(&line, false);
                    }
                }
            });
        }

        if let Some(stderr) = process.stderr.take() {
            let stderr_reader = std::io::BufReader::new(stderr);
            let ready_signal = self.ready_signal.clone();
            thread::spawn(move || {
                use std::io::BufRead;
                for line in stderr_reader.lines() {
                    if let Ok(line) = line {
                        log::info!("[FFmpeg] stderr: {}", line);

                        // Detect when FFmpeg is ready to capture
                        // "Press [q] to stop" indicates FFmpeg has started encoding
                        if line.contains("Press [q] to stop") {
                            log::info!(
                                "[FFmpeg] Ready signal detected: FFmpeg is capturing frames"
                            );
                            ready_signal.store(true, Ordering::Relaxed);
                        }

                        let _ = crate::core::record::log_ffmpeg(&line, true);
                    }
                }
            });
        }

        // Check if process died immediately and capture any error output
        match process.try_wait() {
            Ok(Some(status)) => {
                // Process exited immediately
                let mut error_msg =
                    format!("FFmpeg process exited immediately with status: {}", status);

                // Try to capture any error output
                if let Some(mut stderr) = process.stderr.take() {
                    let mut error_output = String::new();
                    if std::io::Read::read_to_string(&mut stderr, &mut error_output).is_ok()
                        && !error_output.is_empty()
                    {
                        error_msg = format!("{}\nFFmpeg error output: {}", error_msg, error_output);

                        // Check for common Windows-specific errors
                        if cfg!(windows) {
                            if error_output.contains("Could not find video device") {
                                error_msg = format!("{}\nHint: On Windows, make sure you have permission to access screen recording.", error_msg);
                            } else if error_output.contains("Permission denied") {
                                error_msg = format!(
                                    "{}\nHint: Try running the application as administrator.",
                                    error_msg
                                );
                            }
                        }
                    }
                }

                // Cleanup any partial output file
                if self.output_path.exists() {
                    if let Err(e) = fs::remove_file(&self.output_path) {
                        log::info!(
                            "[FFmpeg] Warning: Failed to cleanup partial output file: {}",
                            e
                        );
                    }
                }

                log::info!("[FFmpeg] Error: {}", error_msg);
                return Err(error_msg);
            }
            Ok(None) => {
                // Process is still running, which is what we want
                log::info!("[FFmpeg] Process started successfully");

                // On Windows, verify we can write to the output directory
                if cfg!(windows) {
                    if let Some(parent) = self.output_path.parent() {
                        if !parent.exists() {
                            if let Err(e) = fs::create_dir_all(parent) {
                                let error_msg = format!("Failed to create output directory: {}", e);
                                log::info!("[FFmpeg] Error: {}", error_msg);
                                return Err(error_msg);
                            }
                        }
                        // Try creating a test file to verify write permissions
                        let test_file = parent.join(".test_write");
                        if let Err(e) = fs::write(&test_file, b"test") {
                            let error_msg =
                                format!("No write permission in output directory: {}", e);
                            log::info!("[FFmpeg] Error: {}", error_msg);
                            return Err(error_msg);
                        }
                        let _ = fs::remove_file(test_file); // Cleanup test file
                    }
                }

                self.process = Some(process);
                Ok(())
            }
            Err(e) => {
                log::info!("[FFmpeg] Error: Failed to check process status: {}", e);
                Err(format!("Failed to check FFmpeg process status: {}", e))
            }
        }
    }

    /// Stops the recording process gracefully.
    ///
    /// # Returns
    /// * `Ok(())` if recording stopped successfully.
    /// * `Err` if the process could not be stopped.
    pub fn stop(&mut self) -> Result<(), String> {
        log::info!("[FFmpeg] Stopping recording");
        if let Some(mut process) = self.process.take() {
            // Send 'q' to FFmpeg to stop recording gracefully
            if let Some(mut stdin) = process.stdin.take() {
                if let Err(e) = stdin.write_all(b"q") {
                    log::info!("[FFmpeg] Warning: Failed to send quit command: {}", e);
                    // Continue with the process termination even if we couldn't write to stdin
                }
            }

            log::info!("[FFmpeg] Waiting for process to finish with timeout");

            // Give FFmpeg a chance to exit gracefully
            let timeout = Duration::from_secs(5);
            let start_time = std::time::Instant::now();

            // Try waiting with a timeout
            loop {
                match process.try_wait() {
                    Ok(Some(_status)) => {
                        // Process exited naturally
                        log::info!("[FFmpeg] Process exited gracefully");
                        break;
                    }
                    Ok(None) => {
                        // Process still running
                        if start_time.elapsed() >= timeout {
                            // Timeout reached, kill the process
                            log::info!("[FFmpeg] Timeout reached, killing process");
                            if let Err(e) = process.kill() {
                                log::info!("[FFmpeg] Warning: Failed to kill process: {}", e);
                            }
                            break;
                        }
                        // Sleep a bit before checking again
                        thread::sleep(Duration::from_millis(100));
                    }
                    Err(e) => {
                        log::info!("[FFmpeg] Warning: Failed to check process status: {}", e);
                        // Try to kill the process anyway
                        let _ = process.kill();
                        break;
                    }
                }
            }

            // Wait for any remaining cleanup
            match process.wait() {
                Ok(_) => {}
                Err(e) => {
                    log::info!("[FFmpeg] Warning: Error waiting for process: {}", e);
                }
            }

            // Check if output file exists and has size
            if !self.output_path.exists() {
                log::info!(
                    "[FFmpeg] Error: Failed to create output file at {}",
                    self.output_path.display()
                );
                return Err("FFmpeg failed to create output file".to_string());
            }

            let file_size = fs::metadata(&self.output_path)
                .map_err(|e| {
                    log::info!("[FFmpeg] Error: Failed to get output file metadata: {}", e);
                    format!("Failed to get output file metadata: {}", e)
                })?
                .len();

            if file_size == 0 {
                log::info!(
                    "[FFmpeg] Error: Created empty output file at {}",
                    self.output_path.display()
                );
                return Err("FFmpeg created empty output file".to_string());
            }

            log::info!(
                "[FFmpeg] Recording saved successfully: {} ({} bytes)",
                self.output_path.display(),
                file_size
            );
        } else {
            log::info!("[FFmpeg] No active process to stop");
        }
        Ok(())
    }

    /// Force kill the recording process immediately (no grace period).
    /// Use for emergency shutdown paths (app crash, parent death, lifeline EOF).
    pub fn force_kill(&mut self) {
        if let Some(mut process) = self.process.take() {
            let _ = process.kill();
            let _ = process.wait();
        }
    }
}

fn get_ffmpeg_url_windows() -> String {
    std::env::var("FFMPEG_URL_WIN").unwrap_or_else(|_| {
        "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip".to_string()
    })
}
fn get_ffmpeg_url_linux() -> String {
    std::env::var("FFMPEG_URL_LINUX").unwrap_or_else(|_| {
        "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-linux64-gpl-shared.tar.xz".to_string()
    })
}
fn get_ffmpeg_url_macos() -> String {
    std::env::var("FFMPEG_URL_MACOS")
        .unwrap_or_else(|_| "https://www.osxexperts.net/ffmpeg71intel.zip".to_string())
}
fn get_ffprobe_url_macos() -> String {
    std::env::var("FFPROBE_URL_MACOS")
        .unwrap_or_else(|_| "https://www.osxexperts.net/ffprobe71intel.zip".to_string())
}
