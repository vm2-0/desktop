//! Archive extraction utilities for handling zip and tar.xz files, used to extract binaries for the application.
//! Currently unused with embedded binaries but kept for potential future use.

#![allow(dead_code)]

use crate::tools::sanitize_and_check_path;
use std::fs;
use std::io;
use std::path::Path;

/// Extracts a file from a zip archive.
///
/// # Arguments
/// * `archive_path` - Path to the zip archive file.
/// * `output_path` - Path where the extracted file should be written.
/// * `file_pattern` - Pattern to match the file to extract within the archive.
///
/// # Returns
/// * `Ok(true)` if the file was found and extracted.
/// * `Ok(false)` if no matching file was found.
/// * `Err` if an error occurred during extraction.
pub fn extract_from_zip(
    archive_path: &Path,
    output_path: &Path,
    file_pattern: &str,
) -> Result<bool, String> {
    log::info!(
        "[Archive] Opening zip archive at {}",
        archive_path.display()
    );
    let file = fs::File::open(archive_path).map_err(|e| {
        log::info!("[Archive] Error: Failed to open zip: {}", e);
        format!("Failed to open zip: {}", e)
    })?;

    let mut archive = match zip::ZipArchive::new(file) {
        Ok(archive) => archive,
        Err(e) => {
            log::info!("[Archive] Error: Failed to read zip: {}", e);
            return Err("RETRY_NEEDED".to_string());
        }
    };

    // Process the archive contents
    for i in 0..archive.len() {
        let mut file = archive.by_index(i).map_err(|e| {
            log::info!("[Archive] Error: Failed to read zip entry: {}", e);
            format!("Failed to read zip entry: {}", e)
        })?;

        let name = file.name();
        if name.contains(file_pattern) {
            log::info!("[Archive] Found matching file in zip: {}", name);
            let mut outfile = create_output_file(output_path)?;
            copy_file_data(&mut file, &mut outfile)?;
            return Ok(true);
        }
    }

    log::info!("[Archive] No file matching '{}' found in zip", file_pattern);
    Ok(false) // File not found
}

/// Extracts a file from a tar.xz archive.
///
/// # Arguments
/// * `archive_path` - Path to the tar.xz archive file.
/// * `output_path` - Path where the extracted file should be written.
/// * `file_pattern` - Pattern to match the file to extract within the archive.
/// * `exclude_pattern` - Optional pattern to exclude certain files.
///
/// # Returns
/// * `Ok(true)` if the file was found and extracted.
/// * `Ok(false)` if no matching file was found.
/// * `Err` if an error occurred during extraction.
pub fn extract_from_tar_xz(
    archive_path: &Path,
    output_path: &Path,
    file_pattern: &str,
    exclude_pattern: Option<&str>,
) -> Result<bool, String> {
    log::info!(
        "[Archive] Opening tar.xz archive at {}",
        archive_path.display()
    );
    let file = fs::File::open(archive_path).map_err(|e| {
        log::info!("[Archive] Error: Failed to open tar.xz: {}", e);
        format!("Failed to open tar.xz: {}", e)
    })?;

    let tar = xz2::read::XzDecoder::new(file);
    let mut archive = tar::Archive::new(tar);

    let entries = match archive.entries() {
        Ok(entries) => entries,
        Err(e) => {
            log::info!("[Archive] Error: Failed to read tar entries: {}", e);
            return Err("RETRY_NEEDED".to_string());
        }
    };

    for entry_result in entries {
        let mut entry = entry_result.map_err(|e| {
            log::info!("[Archive] Error: Failed to read tar entry: {}", e);
            format!("Failed to read tar entry: {}", e)
        })?;

        let path = entry.path().map_err(|e| {
            log::info!("[Archive] Error: Failed to get entry path: {}", e);
            format!("Failed to get entry path: {}", e)
        })?;

        let path_str = path.to_string_lossy();

        // Check if the path matches our pattern and doesn't match the exclude pattern
        let is_match = path_str.contains(file_pattern)
            && (exclude_pattern.is_none() || !path_str.contains(exclude_pattern.unwrap()));

        if is_match {
            log::info!("[Archive] Found matching file in tar.xz: {}", path_str);
            let mut outfile = create_output_file(output_path)?;
            copy_file_data(&mut entry, &mut outfile)?;
            return Ok(true);
        }
    }

    log::info!(
        "[Archive] No file matching '{}' found in tar.xz",
        file_pattern
    );
    Ok(false) // File not found
}

/// Creates the output file for the binary
fn create_output_file(output_path: &Path) -> Result<fs::File, String> {
    let base = std::env::temp_dir();
    let safe_path = sanitize_and_check_path(&base, output_path)?;
    let file = fs::File::create(&safe_path).map_err(|e| {
        log::info!("[Archive] Error: Failed to create output file: {}", e);
        format!("Failed to create output file: {}", e)
    })?;
    let metadata = file
        .metadata()
        .map_err(|e| format!("Failed to get file metadata: {}", e))?;
    if metadata.permissions().readonly() {
        return Err("Output file is not writable".to_string());
    }
    Ok(file)
}

/// Copies data from source to destination
fn copy_file_data<R: io::Read, W: io::Write>(
    source: &mut R,
    destination: &mut W,
) -> Result<(), String> {
    io::copy(source, destination).map_err(|e| {
        log::info!("[Archive] Error: Failed to extract file: {}", e);
        format!("Failed to extract file: {}", e)
    })?;
    Ok(())
}

/// Makes a file executable on Unix systems.
///
/// # Arguments
/// * `file_path` - Path to the file to make executable.
///
/// # Returns
/// * `Ok(())` if successful.
/// * `Err` if an error occurred.
#[cfg(unix)]
pub fn make_file_executable(file_path: &Path) -> Result<(), String> {
    use std::os::unix::fs::PermissionsExt;
    log::info!(
        "[Archive] Setting executable permissions for {}",
        file_path.display()
    );
    fs::set_permissions(file_path, fs::Permissions::from_mode(0o755)).map_err(|e| {
        log::info!("[Archive] Error: Failed to make file executable: {}", e);
        format!("Failed to make file executable: {}", e)
    })
}

/// Deletes an archive file from disk.
///
/// # Arguments
/// * `archive_path` - Path to the archive file to delete.
///
/// # Returns
/// * `Ok(())` if successful.
/// * `Err` if an error occurred.
pub fn cleanup_archive(archive_path: &Path) -> Result<(), String> {
    log::info!("[Archive] Cleaning up archive file");
    fs::remove_file(archive_path).map_err(|e| {
        log::info!("[Archive] Warning: Failed to cleanup archive: {}", e);
        format!("Failed to cleanup archive: {}", e)
    })
}

#[cfg(test)]
mod tests {
    use super::*; // Import functions from the parent module (archive.rs)
    use std::io::Cursor;

    #[test]
    fn test_copy_file_data_success() {
        let input_data = b"Hello, world! This is a test string.";
        let mut source = Cursor::new(input_data);
        let mut destination_vec = Vec::new(); // Use a Vec<u8> as a Writeable destination

        let result = copy_file_data(&mut source, &mut destination_vec);

        assert!(result.is_ok(), "copy_file_data should succeed");
        assert_eq!(
            destination_vec, input_data,
            "Destination data should match source data"
        );
    }

    #[test]
    fn test_copy_file_data_empty_source() {
        let input_data = b""; // Empty source
        let mut source = Cursor::new(input_data);
        let mut destination_vec = Vec::new();

        let result = copy_file_data(&mut source, &mut destination_vec);

        assert!(
            result.is_ok(),
            "copy_file_data should succeed for empty source"
        );
        assert_eq!(
            destination_vec, input_data,
            "Destination data should be empty for empty source"
        );
        assert!(destination_vec.is_empty(), "Destination should be empty");
    }

    // Helper struct to simulate read errors
    struct ErrorReader;

    impl io::Read for ErrorReader {
        fn read(&mut self, _buf: &mut [u8]) -> io::Result<usize> {
            Err(io::Error::new(io::ErrorKind::Other, "Simulated read error"))
        }
    }

    #[test]
    fn test_copy_file_data_read_error() {
        let mut source = ErrorReader;
        let mut destination_vec = Vec::new();

        let result = copy_file_data(&mut source, &mut destination_vec);

        assert!(result.is_err(), "copy_file_data should fail on read error");
        if let Err(e) = result {
            assert!(
                e.contains("Failed to extract file"),
                "Error message should indicate extraction failure"
            );
            assert!(
                e.contains("Simulated read error"),
                "Error message should contain the original error"
            );
        }
        assert!(
            destination_vec.is_empty(),
            "Destination should be empty after a read error"
        );
    }

    // Note: Testing write errors is more complex as io::copy might write partially before failing.
    // A simple Vec<u8> doesn't easily simulate write errors in the middle of a copy.
    // For a more thorough test, a custom mock writer would be needed.

    #[cfg(unix)] // Tests specific to Unix-like systems for file permissions
    mod unix_tests {
        use super::super::*; // Access parent (archive.rs) functions
        use std::fs as std_fs;
        use std::os::unix::fs::PermissionsExt;
        use tempfile::NamedTempFile;

        #[test]
        fn test_make_file_executable_success() {
            let temp_file = NamedTempFile::new().expect("Failed to create temp file");
            let file_path = temp_file.path();

            // Ensure it's not executable initially (though default might vary)
            let initial_perms = std_fs::metadata(file_path).unwrap().permissions();
            let mut mutable_perms = initial_perms.clone();
            mutable_perms.set_mode(0o644); // Set to non-executable r--r--r--
            std_fs::set_permissions(file_path, mutable_perms).unwrap();

            let result = make_file_executable(file_path);
            assert!(
                result.is_ok(),
                "make_file_executable should succeed: {:?}",
                result.err()
            );

            let perms = std_fs::metadata(file_path).unwrap().permissions();
            assert_eq!(
                perms.mode() & 0o777,
                0o755,
                "File permissions should be rwxr-xr-x (0755)"
            );
        }
    }

    #[cfg(test)] // General tests, not unix-specific for cleanup
    mod cleanup_tests {
        use super::super::*; // Access parent (archive.rs) functions
        use std::path::PathBuf;
        use tempfile::tempdir;

        #[test]
        fn test_cleanup_archive_success() {
            use std::fs::File;
            use std::io::Write;

            let dir = tempdir().expect("Failed to create temp dir");
            let file_path = dir.path().join("to_delete.txt");
            {
                let mut f = File::create(&file_path).expect("Failed to create file");
                writeln!(f, "test").unwrap();
            }
            assert!(file_path.exists(), "Temp file should exist before cleanup");

            let result = cleanup_archive(&file_path);
            assert!(
                result.is_ok(),
                "cleanup_archive should succeed: {:?}",
                result.err()
            );
            assert!(!file_path.exists(), "File should not exist after cleanup");
        }

        #[test]
        fn test_cleanup_archive_non_existent_file() {
            let dir = tempdir().expect("Failed to create temp dir");
            let non_existent_path: PathBuf = dir.path().join("definitely_not_there.zip");

            assert!(
                !non_existent_path.exists(),
                "File should not exist initially"
            );

            let result = cleanup_archive(&non_existent_path);
            assert!(
                result.is_err(),
                "cleanup_archive should fail for non-existent file"
            );
            if let Err(e) = result {
                assert!(
                    e.contains("Failed to cleanup archive"),
                    "Error message mismatch"
                );
            }
        }
    }
}
