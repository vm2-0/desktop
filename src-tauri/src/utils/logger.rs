//! Simple file-based logger for recording events and ffmpeg output in JSONL format.
//!
//! This module provides a `Logger` struct for writing structured logs to a file, typically used for input events and ffmpeg process output.

use std::fs::{File, OpenOptions};
use std::io::Write;
use std::path::PathBuf;

pub struct Logger {
    file: File,
}

impl Logger {
    /// Creates a new `Logger` instance that writes to `input_log.jsonl` in the given session directory.
    ///
    /// # Arguments
    /// * `session_dir` - The directory where the log file will be created.
    ///
    /// # Returns
    /// * `Ok(Logger)` if the file was created successfully.
    /// * `Err` if the file could not be created.
    pub fn new(session_dir: PathBuf) -> Result<Self, String> {
        // Ensure the session directory exists
        std::fs::create_dir_all(&session_dir).map_err(|e| {
            format!(
                "Failed to create session directory: {}: {}",
                session_dir.display(),
                e
            )
        })?;

        let log_path = session_dir.join("input_log.jsonl");

        let file = OpenOptions::new()
            .create(true)
            .append(true)
            .open(&log_path)
            .map_err(|e| format!("Failed to create log file: {}", e))?;

        Ok(Logger { file })
    }

    /// Logs a structured event as a JSON value to the log file.
    ///
    /// # Arguments
    /// * `event` - The event to log, as a serde_json::Value.
    ///
    /// # Returns
    /// * `Ok(())` if the event was logged successfully.
    /// * `Err` if serialization or writing failed.
    pub fn log_event(&mut self, event: serde_json::Value) -> Result<(), String> {
        let json = serde_json::to_string(&event)
            .map_err(|e| format!("Failed to serialize event: {}", e))?;

        writeln!(self.file, "{}", json)
            .map_err(|e| format!("Failed to write to log file: {}", e))?;
        self.file
            .flush()
            .map_err(|e| format!("Failed to flush log file: {}", e))?;

        Ok(())
    }

}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;
    use std::fs;
    use tempfile::tempdir;

    #[test]
    fn test_log_event_creates_file_and_writes_event() {
        let dir = tempdir().unwrap();
        let session_dir = dir.path().to_path_buf();

        let mut logger = Logger::new(session_dir.clone()).unwrap();

        let event_data = json!({
            "type": "test_event",
            "value": 42
        });
        logger.log_event(event_data.clone()).unwrap();

        let log_file_path = session_dir.join("input_log.jsonl");
        assert!(log_file_path.exists(), "Log file should be created");

        let content = fs::read_to_string(log_file_path).unwrap();
        let expected_content = format!("{}\n", serde_json::to_string(&event_data).unwrap());
        assert_eq!(content, expected_content, "Log file content mismatch");

        // The tempdir will be automatically cleaned up when `dir` goes out of scope.
    }

    #[test]
    fn test_log_ffmpeg_writes_correct_event_format() {
        let dir = tempdir().unwrap();
        let session_dir = dir.path().to_path_buf();
        let mut logger = Logger::new(session_dir.clone()).unwrap();

        let ffmpeg_output =
            "frame= 1 fps=0.0 q=0.0 size=       0kB time=00:00:00.00 bitrate=N/A speed=N/A";
        // Use record::log_ffmpeg instead for testing
        let event = serde_json::json!({
            "event": "ffmpeg_stdout",
            "data": {
                "output": ffmpeg_output
            },
            "time": chrono::Local::now().timestamp_millis()
        });
        logger.log_event(event).unwrap();

        let log_file_path = session_dir.join("input_log.jsonl");
        let content = fs::read_to_string(log_file_path).unwrap();

        // We need to parse the JSON to check its structure, as timestamp will vary.
        let logged_event: serde_json::Value =
            serde_json::from_str(content.lines().next().unwrap()).unwrap();

        assert_eq!(logged_event["event"], "ffmpeg_stdout");
        assert_eq!(logged_event["data"]["output"], ffmpeg_output);
        assert!(logged_event["time"].is_number());

        // Test for stderr
        let ffmpeg_error_output = "Error: Something went wrong";
        let error_event = serde_json::json!({
            "event": "ffmpeg_stderr", 
            "data": {
                "output": ffmpeg_error_output
            },
            "time": chrono::Local::now().timestamp_millis()
        });
        logger.log_event(error_event).unwrap();

        let content_after_second_log =
            fs::read_to_string(session_dir.join("input_log.jsonl")).unwrap();
        let lines: Vec<&str> = content_after_second_log.trim().split('\n').collect();
        assert_eq!(lines.len(), 2, "Should have two log entries");

        let logged_error_event: serde_json::Value = serde_json::from_str(lines[1]).unwrap();
        assert_eq!(logged_error_event["event"], "ffmpeg_stderr");
        assert_eq!(logged_error_event["data"]["output"], ffmpeg_error_output);
        assert!(logged_error_event["time"].is_number());
    }

    #[test]
    fn test_logger_new_creates_directory_if_not_exists() {
        let base_dir = tempdir().unwrap();
        let non_existent_session_dir = base_dir.path().join("new_session_dir");

        assert!(
            !non_existent_session_dir.exists(),
            "Test precondition: session dir should not exist"
        );

        let logger_result = Logger::new(non_existent_session_dir.clone());
        assert!(
            logger_result.is_ok(),
            "Logger::new should succeed even if directory does not exist initially."
        );

        let log_file_path = non_existent_session_dir.join("input_log.jsonl");
        assert!(
            log_file_path.exists(),
            "Log file should be created in the new directory"
        );

        // Cleanup: tempdir will clean up base_dir, and non_existent_session_dir with it.
    }
}
