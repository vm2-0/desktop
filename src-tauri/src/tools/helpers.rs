use std::path::{Path, PathBuf};
use std::time::{Duration, Instant};

/// Utility to sanitize a path and ensure it is within the allowed base directory.
pub fn sanitize_and_check_path(base: &Path, target: &Path) -> Result<PathBuf, String> {
    log::info!(
        "[sanitize_and_check_path] base: {} | target: {}",
        base.display(),
        target.display()
    );
    let canonical_base = match base.canonicalize() {
        Ok(cb) => cb,
        Err(e) => {
            log::error!(
                "[sanitize_and_check_path] Failed to canonicalize base directory: {}",
                e
            );
            return Err("Failed to canonicalize base directory".to_string());
        }
    };
    let joined = canonical_base.join(target);
    let canonical_target = match joined.canonicalize() {
        Ok(ct) => {
            log::info!(
                "[sanitize_and_check_path] canonical_target exists: {}",
                ct.display()
            );
            ct
        }
        Err(e) => {
            // Si le fichier n'existe pas, on canonicalize le parent
            log::warn!(
                "[sanitize_and_check_path] canonicalize failed ({}), essaye sur le parent",
                e
            );
            if let Some(parent) = joined.parent() {
                match parent.canonicalize() {
                    Ok(canonical_parent) => {
                        if !canonical_parent.starts_with(&canonical_base) {
                            log::error!("[sanitize_and_check_path] Parent path is not allowed: {} not in {}", canonical_parent.display(), canonical_base.display());
                            return Err("Path is not allowed".to_string());
                        }
                        log::info!(
                            "[sanitize_and_check_path] Parent path accepted: {}",
                            canonical_parent.display()
                        );
                        // On retourne le chemin cible (non-canonicalisé, mais validé)
                        return Ok(joined);
                    }
                    Err(e2) => {
                        log::error!(
                            "[sanitize_and_check_path] Failed to canonicalize parent: {}",
                            e2
                        );
                        return Err("Invalid or unsafe file path (parent)".to_string());
                    }
                }
            } else {
                log::error!(
                    "[sanitize_and_check_path] No parent for target: {}",
                    joined.display()
                );
                return Err("Invalid or unsafe file path (no parent)".to_string());
            }
        }
    };
    if !canonical_target.starts_with(&canonical_base) {
        log::error!(
            "[sanitize_and_check_path] Path is not allowed: {} not in {}",
            canonical_target.display(),
            canonical_base.display()
        );
        return Err("Path is not allowed".to_string());
    }
    log::info!(
        "[sanitize_and_check_path] Path accepted: {}",
        canonical_target.display()
    );
    Ok(canonical_target)
}

/// Helper to acquire a Mutex with a timeout. Returns None if the lock cannot be acquired in the given duration.
pub fn lock_with_timeout<'a, T>(
    mutex: &'a std::sync::Mutex<T>,
    timeout: Duration,
) -> Option<std::sync::MutexGuard<'a, T>> {
    let start = Instant::now();
    loop {
        if let Ok(guard) = mutex.try_lock() {
            return Some(guard);
        }
        if start.elapsed() >= timeout {
            return None;
        }
        std::thread::sleep(Duration::from_millis(10));
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs::File;
    use std::path::PathBuf;
    use std::sync::{Arc, Mutex};
    use std::thread;
    use std::time::Duration;
    use tempfile::tempdir;

    #[test]
    fn test_sanitize_and_check_path_valid() {
        let dir = tempdir().unwrap();
        let base = dir.path();
        let file_path = base.join("file.txt");
        File::create(&file_path).unwrap();
        let result = sanitize_and_check_path(base, Path::new("file.txt"));
        assert!(result.is_ok());
        assert_eq!(result.unwrap(), file_path.canonicalize().unwrap());
    }

    #[test]
    fn test_sanitize_and_check_path_outside_base() {
        let dir = tempdir().unwrap();
        let base = dir.path();
        let result = sanitize_and_check_path(base, Path::new("../evil.txt"));
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Path is not allowed");
    }

    #[test]
    fn test_sanitize_and_check_path_nonexistent_but_parent_valid() {
        let dir = tempdir().unwrap();
        let base = dir.path();
        let file_path = base.join("newfile.txt");
        // File does not exist, but parent is valid
        let result = sanitize_and_check_path(base, Path::new("newfile.txt"));
        assert!(result.is_ok());
        // Compare les chemins après canonicalisation pour éviter les soucis de /private sur macOS
        let expected = file_path.canonicalize().unwrap_or(file_path.clone());
        let path = result.unwrap();
        let actual = path.canonicalize().unwrap_or(path.clone());
        if actual != expected {
            // Tolère la différence /private/var vs /var sur macOS
            let actual_str = actual.to_string_lossy();
            let expected_str = expected.to_string_lossy();
            let actual_str = actual_str.strip_prefix("/private").unwrap_or(&actual_str);
            let expected_str = expected_str
                .strip_prefix("/private")
                .unwrap_or(&expected_str);
            assert_eq!(
                actual_str, expected_str,
                "Paths differ even after normalisation: {} vs {}",
                actual_str, expected_str
            );
        }
    }

    #[test]
    fn test_sanitize_and_check_path_no_parent() {
        let dir = tempdir().unwrap();
        let base = dir.path();
        // Path with no parent (root)
        let result = sanitize_and_check_path(base, Path::new("/"));
        assert!(result.is_err());
        let err = result.unwrap_err();
        // Accepte les deux messages possibles selon le code
        assert!(
            err == "Invalid or unsafe file path (no parent)" || err == "Path is not allowed",
            "Unexpected error message: {}",
            err
        );
    }

    #[test]
    fn test_sanitize_and_check_path_invalid_base() {
        // Use a base that doesn't exist
        let base = PathBuf::from("/definitely/does/not/exist");
        let result = sanitize_and_check_path(&base, Path::new("file.txt"));
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Failed to canonicalize base directory");
    }

    #[test]
    fn test_lock_with_timeout_success() {
        let m = Mutex::new(42);
        let guard = lock_with_timeout(&m, Duration::from_millis(100));
        assert!(guard.is_some());
        assert_eq!(*guard.unwrap(), 42);
    }

    #[test]
    fn test_lock_with_timeout_timeout() {
        let m = Arc::new(Mutex::new(42));
        let m2 = m.clone();
        let _guard = m.lock().expect("Test mutex should not be poisoned");
        // Lock is held, so lock_with_timeout should time out
        let handle = thread::spawn(move || {
            let result = lock_with_timeout(&m2, Duration::from_millis(100));
            assert!(result.is_none());
        });
        handle.join().unwrap();
    }
}
