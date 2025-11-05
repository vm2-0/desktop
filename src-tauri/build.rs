use std::env;
use std::fs;
use std::path::Path;

fn main() {
    // Copy embedded binaries to output directory for release builds
    println!("cargo:rerun-if-changed=build.rs");
    println!("cargo:rerun-if-changed=binaries/");
    
    // Only copy binaries for release builds to keep them available in the final app
    if env::var("PROFILE").unwrap_or_default() == "release" {
        if let Err(e) = copy_embedded_binaries() {
            println!("cargo:warning=Failed to copy embedded binaries: {}", e);
        }
    }

    // Run Tauri build
    tauri_build::build()
}

fn copy_embedded_binaries() -> Result<(), Box<dyn std::error::Error>> {
    let out_dir = env::var("OUT_DIR")?;
    let target_dir = Path::new(&out_dir).join("../../../ffmpeg-binaries");
    
    // Create directory if it doesn't exist
    fs::create_dir_all(&target_dir)?;
    
    println!("cargo:warning=Copying embedded FFmpeg binaries to: {}", target_dir.display());
    
    // Determine platform and copy appropriate binaries
    let (platform_dir, ffmpeg_name, ffprobe_name) = if cfg!(target_os = "macos") {
        ("macos", "ffmpeg", "ffprobe")
    } else if cfg!(target_os = "windows") {
        ("windows", "ffmpeg.exe", "ffprobe.exe")
    } else {
        ("linux", "ffmpeg", "ffprobe")
    };
    
    let source_dir = Path::new("binaries").join(platform_dir);
    
    // Copy FFmpeg
    let ffmpeg_src = source_dir.join(ffmpeg_name);
    let ffmpeg_dst = target_dir.join(ffmpeg_name);
    if ffmpeg_src.exists() {
        fs::copy(&ffmpeg_src, &ffmpeg_dst)?;
        println!("cargo:warning=Copied {} to {}", ffmpeg_src.display(), ffmpeg_dst.display());
        
        // Set executable permissions on Unix
        #[cfg(unix)]
        {
            use std::os::unix::fs::PermissionsExt;
            let mut perms = fs::metadata(&ffmpeg_dst)?.permissions();
            perms.set_mode(0o755);
            fs::set_permissions(&ffmpeg_dst, perms)?;
        }
    }
    
    // Copy FFprobe
    let ffprobe_src = source_dir.join(ffprobe_name);
    let ffprobe_dst = target_dir.join(ffprobe_name);
    if ffprobe_src.exists() {
        fs::copy(&ffprobe_src, &ffprobe_dst)?;
        println!("cargo:warning=Copied {} to {}", ffprobe_src.display(), ffprobe_dst.display());
        
        // Set executable permissions on Unix
        #[cfg(unix)]
        {
            use std::os::unix::fs::PermissionsExt;
            let mut perms = fs::metadata(&ffprobe_dst)?.permissions();
            perms.set_mode(0o755);
            fs::set_permissions(&ffprobe_dst, perms)?;
        }
    }
    
    println!("cargo:warning=Embedded FFmpeg binaries copied successfully");
    Ok(())
}