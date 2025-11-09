//! Native macOS screen recording using ScreenCaptureKit → AVAssetWriter pipeline
//!
//! This implementation uses a compiled Objective-C helper that implements:
//! ScreenCaptureKit → CMSampleBuffer → AVAssetWriter (H.264) → MP4
//! This approach provides reliable, native Apple recording with minimal complexity.

#[cfg(target_os = "macos")]
pub mod macos {
    use chrono;
    use std::io::{BufRead, BufReader};
    use std::path::PathBuf;
    use std::process::{Child, Command, Stdio};
    use std::sync::atomic::{AtomicBool, Ordering};
    use std::sync::Arc;
    use std::time::{Duration, Instant};

    pub struct NativeRecorder {
        width: u32,
        height: u32,
        fps: u32,
        output_path: PathBuf,
        recording_process: Option<Child>,
        ready_signal: Arc<AtomicBool>,
        is_recording: Arc<AtomicBool>,
        start_time: Option<Instant>,
        reference_time_millis: Option<i64>, // Synchronized reference time with input system
        duration_seconds: u32,
    }

    impl NativeRecorder {
        pub fn new(
            width: u32,
            height: u32,
            fps: u32,
            output_path: PathBuf,
        ) -> Result<Self, String> {
            log::info!(
                "[NativeRecorder] Creating ScreenCaptureKit native recorder: {}x{} @ {} fps → {}",
                width,
                height,
                fps,
                output_path.display()
            );

            // Validate macOS version (ScreenCaptureKit requires 12.3+)
            if !Self::is_screencapturekit_available() {
                return Err("ScreenCaptureKit requires macOS 12.3 or later".to_string());
            }

            // Validate parameters
            if width == 0 || height == 0 || fps == 0 {
                return Err("Invalid recording parameters".to_string());
            }

            // Ensure MP4 extension
            let mut final_path = output_path;
            if final_path.extension().unwrap_or_default() != "mp4" {
                final_path.set_extension("mp4");
            }

            // Ensure output directory exists
            if let Some(parent) = final_path.parent() {
                std::fs::create_dir_all(parent)
                    .map_err(|e| format!("Failed to create output directory: {}", e))?;
            }

            Ok(Self {
                width,
                height,
                fps,
                output_path: final_path,
                recording_process: None,
                ready_signal: Arc::new(AtomicBool::new(false)),
                is_recording: Arc::new(AtomicBool::new(false)),
                start_time: None,
                reference_time_millis: None,
                duration_seconds: 3600, // Default 1 hour max
            })
        }

        pub fn start(&mut self) -> Result<(), String> {
            log::info!("[NativeRecorder] Starting ScreenCaptureKit → AVAssetWriter recording");

            // Check screen recording permission
            if !self.has_screen_recording_permission() {
                return Err("Screen recording permission not granted. Please enable in System Settings > Privacy & Security > Screen Recording.".to_string());
            }

            // Get path to our compiled screen recorder
            let recorder_path = Self::get_screen_recorder_path()?;
            // Log helper metadata (size, perms)
            match std::fs::metadata(&recorder_path) {
                Ok(meta) => {
                    #[cfg(unix)]
                    {
                        use std::os::unix::fs::PermissionsExt;
                        let mode = meta.permissions().mode();
                        log::info!(
                            "[NativeRecorder] Helper metadata - size: {} bytes, mode: {:o}, path: {}",
                            meta.len(),
                            mode,
                            recorder_path.display()
                        );
                    }
                    #[cfg(not(unix))]
                    {
                        log::info!(
                            "[NativeRecorder] Helper metadata - size: {} bytes, path: {}",
                            meta.len(),
                            recorder_path.display()
                        );
                    }
                }
                Err(e) => {
                    log::warn!(
                        "[NativeRecorder] Failed to read helper metadata ({}): {}",
                        recorder_path.display(),
                        e
                    );
                }
            }

            // Start the native recorder process
            let mut command = Command::new(&recorder_path);
            command.args([
                self.output_path.to_str().ok_or("Invalid output path")?,
                &self.width.to_string(),
                &self.height.to_string(),
                &self.fps.to_string(),
                &self.duration_seconds.to_string(),
            ]);

            // Set up process with proper stdio handling
            command.stdout(Stdio::piped());
            command.stderr(Stdio::piped());

            log::info!(
                "[NativeRecorder] Executing helper: {} {} {} {} {}",
                recorder_path.display(),
                self.output_path.display(),
                self.width,
                self.height,
                self.fps
            );

            match command.spawn() {
                Ok(child) => {
                    log::info!("[NativeRecorder] ScreenCaptureKit recorder process started");

                    self.recording_process = Some(child);
                    self.ready_signal.store(true, Ordering::Relaxed);
                    self.is_recording.store(true, Ordering::Relaxed);
                    self.start_time = Some(Instant::now());

                    Ok(())
                }
                Err(e) => Err(format!("Failed to start ScreenCaptureKit recorder: {}", e)),
            }
        }

        pub fn stop(&mut self) -> Result<(), String> {
            log::info!("[NativeRecorder] Stopping ScreenCaptureKit recording");

            self.is_recording.store(false, Ordering::Relaxed);

            if let Some(mut process) = self.recording_process.take() {
                // The process should terminate automatically after the duration
                // But we need to terminate it gracefully
                match process.try_wait() {
                    Ok(Some(status)) => {
                        log::info!(
                            "[NativeRecorder] Recorder process already finished: {}",
                            status
                        );
                    }
                    Ok(None) => {
                        // Process still running, send SIGTERM for graceful shutdown
                        log::info!("[NativeRecorder] Sending SIGTERM to recorder process");

                        // Use libc to send SIGTERM for graceful shutdown
                        let pid = process.id() as i32;
                        let result = unsafe { libc::kill(pid, libc::SIGTERM) };

                        if result == 0 {
                            log::info!("[NativeRecorder] SIGTERM sent successfully");
                        } else {
                            log::warn!(
                                "[NativeRecorder] Failed to send SIGTERM, falling back to SIGKILL"
                            );
                            if let Err(e) = process.kill() {
                                log::warn!("[NativeRecorder] Failed to send SIGKILL: {}", e);
                            }
                        }
                    }
                    Err(e) => {
                        log::error!("[NativeRecorder] Error checking process status: {}", e);
                    }
                }

                // Wait longer for process to finish gracefully
                log::info!("[NativeRecorder] Waiting for process to finish...");
                match process.wait() {
                    Ok(status) => {
                        log::info!("[NativeRecorder] Recorder process finished: {}", status);
                    }
                    Err(e) => {
                        log::warn!("[NativeRecorder] Error waiting for recorder: {}", e);
                    }
                }

                // Wait longer for AVAssetWriter to finalize and file system to flush
                log::info!("[NativeRecorder] Waiting for file finalization...");
                std::thread::sleep(Duration::from_millis(3000));
            }

            self.ready_signal.store(false, Ordering::Relaxed);

            // Log recording duration
            if let Some(start_time) = self.start_time.take() {
                let duration = start_time.elapsed();
                log::info!(
                    "[NativeRecorder] Recording completed. Duration: {:.2}s",
                    duration.as_secs_f64()
                );
            }

            // Verify output file was created
            if !self.output_path.exists() {
                return Err(format!(
                    "MP4 file was not created: {}",
                    self.output_path.display()
                ));
            }

            let file_size = std::fs::metadata(&self.output_path)
                .map_err(|e| format!("Failed to check MP4 file: {}", e))?
                .len();

            if file_size == 0 {
                return Err("MP4 file is empty".to_string());
            }

            log::info!(
                "[NativeRecorder] MP4 H.264 file created successfully: {} bytes at {}",
                file_size,
                self.output_path.display()
            );
            Ok(())
        }

        pub fn force_kill(&mut self) {
            log::info!("[NativeRecorder] Force killing ScreenCaptureKit recorder");

            self.is_recording.store(false, Ordering::Relaxed);
            self.ready_signal.store(false, Ordering::Relaxed);

            if let Some(mut process) = self.recording_process.take() {
                if let Err(e) = process.kill() {
                    log::error!("[NativeRecorder] Failed to force kill recorder: {}", e);
                }
                let _ = process.wait();
            }
        }

        pub fn wait_until_ready(&self, timeout_ms: u64) -> bool {
            let start = Instant::now();
            let timeout = Duration::from_millis(timeout_ms);

            while start.elapsed() < timeout {
                if self.ready_signal.load(Ordering::Relaxed) {
                    log::info!(
                        "[NativeRecorder] Ready signal received after {:?}",
                        start.elapsed()
                    );
                    return true;
                }
                std::thread::sleep(Duration::from_millis(50));
            }

            log::warn!(
                "[NativeRecorder] Timeout waiting for ready signal after {:?}",
                timeout
            );
            false
        }

        // Set recording duration in seconds (useful for manual termination)
        pub fn set_duration(&mut self, seconds: u32) {
            self.duration_seconds = seconds;
        }

        // Set synchronized reference time for timeline synchronization with input events
        pub fn set_reference_time(&mut self, reference_time_millis: i64) {
            self.reference_time_millis = Some(reference_time_millis);
            log::info!(
                "[NativeRecorder] Reference time synchronized: {} ms",
                reference_time_millis
            );
        }

        // Get the actual recording duration in seconds using synchronized timeline
        pub fn get_recording_duration(&self) -> Option<f64> {
            if let (Some(_start_time), Some(ref_time)) =
                (self.start_time, self.reference_time_millis)
            {
                // Use synchronized timeline (same as input system)
                let current_time_millis = chrono::Local::now().timestamp_millis();
                let duration_millis = current_time_millis - ref_time;
                Some(duration_millis.max(0) as f64 / 1000.0)
            } else {
                // Fallback to Instant-based duration
                self.start_time.map(|start| start.elapsed().as_secs_f64())
            }
        }

        // Private implementation methods

        fn is_screencapturekit_available() -> bool {
            // Check macOS version - ScreenCaptureKit available on 12.3+
            let version_output = Command::new("sw_vers").arg("-productVersion").output();

            match version_output {
                Ok(output) => {
                    let version_str = String::from_utf8_lossy(&output.stdout);
                    let version_parts: Vec<&str> = version_str.trim().split('.').collect();
                    log::info!(
                        "[NativeRecorder] macOS version reported by sw_vers: {}",
                        version_str.trim()
                    );

                    if version_parts.len() >= 2 {
                        if let (Ok(major), Ok(minor)) = (
                            version_parts[0].parse::<u32>(),
                            version_parts[1].parse::<u32>(),
                        ) {
                            // macOS 12.3+ required
                            let ok = major > 12 || (major == 12 && minor >= 3);
                            if !ok {
                                log::warn!(
                                    "[NativeRecorder] ScreenCaptureKit unavailable on macOS {}.{}",
                                    major,
                                    minor
                                );
                            }
                            return ok;
                        }
                    }
                }
                Err(e) => {
                    log::warn!("[NativeRecorder] Could not check macOS version: {}", e);
                }
            }

            false
        }

        fn has_screen_recording_permission(&self) -> bool {
            // For development, we'll assume permission is granted
            // In production, this should check TCC database or use a quick test
            log::info!(
                "[NativeRecorder] Assuming screen recording permission is granted for development"
            );

            // Quick permission check using screencapture - much faster than our binary
            let test_result = Command::new("/usr/sbin/screencapture")
                .args(["-t", "png", "/dev/null"])
                .output();

            match test_result {
                Ok(output) => {
                    let stderr = String::from_utf8_lossy(&output.stderr);
                    let success = output.status.success()
                        && !stderr.contains("Operation not permitted")
                        && !stderr.contains("not authorized")
                        && !stderr.contains("denied");

                    if !success {
                        log::warn!(
                            "[NativeRecorder] Screen recording permission check failed: {}",
                            stderr
                        );
                    } else {
                        log::info!(
                            "[NativeRecorder] Screen recording permission check passed (exit: {})",
                            output.status
                        );
                    }

                    success
                }
                Err(e) => {
                    log::error!(
                        "[NativeRecorder] Failed to test screen recording permission: {}",
                        e
                    );
                    false
                }
            }
        }

        fn get_screen_recorder_path() -> Result<PathBuf, String> {
            // Resolve robustly relative to the executable location (not the CWD)
            let mut candidates: Vec<PathBuf> = Vec::new();

            if let Ok(exe_path) = std::env::current_exe() {
                log::info!("[NativeRecorder] current_exe: {}", exe_path.display());
                if let Some(exe_dir) = exe_path.parent() {
                    log::info!("[NativeRecorder] exe_dir: {}", exe_dir.display());
                    // exe_dir is usually .../Contents/Resources/agent for our agent binary
                    // Try Contents/Helpers and legacy Contents/Resources from the bundle root
                    let contents_dir = exe_dir.parent(); // .../Contents/Resources
                    if let Some(contents_dir) = contents_dir {
                        log::info!("[NativeRecorder] contents_dir: {}", contents_dir.display());
                        let app_contents = contents_dir.parent(); // .../Contents
                        if let Some(app_contents) = app_contents {
                            log::info!("[NativeRecorder] app_contents: {}", app_contents.display());
                            candidates.push(app_contents.join("Helpers/screen_recorder"));
                            candidates.push(app_contents.join("Resources/screen_recorder"));
                        }
                        candidates.push(contents_dir.join("screen_recorder")); // Resources/screen_recorder
                    }
                }
            }

            // Fallbacks relative to likely working directories
            candidates.extend_from_slice(&[
                // Production fallbacks
                PathBuf::from("../Contents/Helpers/screen_recorder"),
                PathBuf::from("../Contents/Resources/screen_recorder"),
                PathBuf::from("./Contents/Helpers/screen_recorder"),
                PathBuf::from("./Contents/Resources/screen_recorder"),
                PathBuf::from("../Helpers/screen_recorder"),
                PathBuf::from("../Resources/screen_recorder"),
                // Development paths
                PathBuf::from("src-tauri/src/tools/screen_recorder"),
                PathBuf::from("./src-tauri/src/tools/screen_recorder"),
                PathBuf::from("src/tools/screen_recorder"),
                PathBuf::from("./screen_recorder"),
                PathBuf::from("./resources/screen_recorder"),
            ]);
            // Log candidate list (trimmed)
            let preview: Vec<String> = candidates
                .iter()
                .take(8)
                .map(|p| p.display().to_string())
                .collect();
            log::info!(
                "[NativeRecorder] Helper path candidates (first 8): {:?}",
                preview
            );

            for path in &candidates {
                if path.exists() && path.is_file() {
                    log::info!(
                        "[NativeRecorder] Found screen recorder at: {}",
                        path.display()
                    );
                    return Ok(path.clone());
                } else {
                    log::debug!(
                        "[NativeRecorder] Checked path (not found): {}",
                        path.display()
                    );
                }
            }

            log::warn!("[NativeRecorder] Screen recorder binary not found; tried multiple app-relative and dev paths");
            log::warn!("[NativeRecorder] Falling back to system screencapture command");
            Err(
                "ScreenCaptureKit recorder binary not found - falling back to system screencapture"
                    .to_string(),
            )
        }
    }

    impl Drop for NativeRecorder {
        fn drop(&mut self) {
            if self.is_recording.load(Ordering::Relaxed) {
                log::info!("[NativeRecorder] Auto-cleanup on drop");
                self.force_kill();
            }
        }
    }

    // Safe for threading
    unsafe impl Send for NativeRecorder {}
    unsafe impl Sync for NativeRecorder {}
}

#[cfg(not(target_os = "macos"))]
pub mod macos {
    use std::path::PathBuf;
    use std::sync::atomic::AtomicBool;
    use std::sync::Arc;

    pub struct NativeRecorder {
        ready_signal: Arc<AtomicBool>,
    }

    impl NativeRecorder {
        pub fn new(
            _width: u32,
            _height: u32,
            _fps: u32,
            _output_path: PathBuf,
        ) -> Result<Self, String> {
            Err("ScreenCaptureKit recording only available on macOS 12.3+".to_string())
        }

        pub fn start(&mut self) -> Result<(), String> {
            Err("ScreenCaptureKit recording only available on macOS 12.3+".to_string())
        }

        pub fn stop(&mut self) -> Result<(), String> {
            Err("ScreenCaptureKit recording only available on macOS 12.3+".to_string())
        }

        pub fn force_kill(&mut self) {}

        pub fn wait_until_ready(&self, _timeout_ms: u64) -> bool {
            false
        }

        pub fn set_duration(&mut self, _seconds: u32) {}

        pub fn set_reference_time(&mut self, _reference_time_millis: i64) {}

        pub fn get_recording_duration(&self) -> Option<f64> {
            None
        }
    }
}
