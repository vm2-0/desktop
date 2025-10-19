//! Main entry point and Tauri integration for the desktop application.
//!
//! This crate wires together all core, tool, and utility modules, and sets up the Tauri runtime, plugins, and command handlers for the application.

use tauri::Manager;
mod commands;
mod core;
pub mod ipc_server;
mod tools;
pub mod utils;
use std::sync::{Arc, Mutex};
use tauri::Listener;
use tokio::io::AsyncReadExt;
use tokio::net::TcpStream;
use tokio::time::{sleep, Duration};

use utils::permissions::{has_ax_perms, has_record_perms, request_ax_perms, request_record_perms};

use crate::commands::general::{greet, list_apps, take_screenshot};
use crate::commands::record::{
    create_recording_zip, delete_recording, get_app_data_dir, get_current_demonstration,
    get_recording_file, get_recording_state, get_video_url, list_recordings, process_recording,
    start_recording, stop_recording, write_file, write_recording_file,
};
use crate::commands::settings::{get_upload_data_allowed, set_upload_data_allowed};
use crate::commands::tools::{check_tools, init_tools};
use crate::commands::transaction::{
    cleanup_old_transactions, generate_session_token, generate_transaction_deep_link,
    get_transaction_request, handle_transaction_callback, list_pending_transactions,
    prepare_transaction_request, update_transaction_status,
};
use crate::core::record::force_kill_active_recorder;
// State to hold the latest deep link URL
pub struct DeepLinkState(pub Arc<Mutex<Option<String>>>);

/// Monitors a parent process (explicit PID if provided, else getppid) and exits if it dies
async fn monitor_parent_process(app: tauri::AppHandle) {
    let explicit = std::env::var("AGENT_PARENT_PID")
        .ok()
        .and_then(|s| s.parse::<i32>().ok());
    let parent_pid = explicit.unwrap_or_else(|| unsafe { libc::getppid() });
    log::info!("Starting parent process monitor for PID: {}", parent_pid);

    loop {
        sleep(Duration::from_secs(2)).await;

        // Check if parent process is still alive
        let parent_exists = unsafe { libc::kill(parent_pid, 0) == 0 };

        if !parent_exists {
            log::info!(
                "Parent process {} died, stopping active capture and exiting agent",
                parent_pid
            );
            force_kill_active_recorder(&app);
            app.exit(0);
        }
    }
}

/// Connects to a TCP lifeline provided by the Flutter parent and exits when it closes
async fn monitor_lifeline(port: u16, app: tauri::AppHandle) {
    log::info!("Starting lifeline monitor on 127.0.0.1:{}", port);

    // Retry for a bounded time, then keep a slower background retry just in case
    let mut attempts: u32 = 0;
    let max_attempts: u32 = 100; // ~20s with 200ms sleep
    loop {
        match TcpStream::connect(("127.0.0.1", port)).await {
            Ok(mut stream) => {
                log::info!("Lifeline connected; waiting for EOF to exit");
                let mut buf = [0u8; 1];
                let _ = stream.read(&mut buf).await; // EOF or error => return
                log::info!("Lifeline closed; stopping active capture and exiting agent");
                // Kill any active recorder, then exit cleanly through Tauri runtime
                force_kill_active_recorder(&app);
                app.exit(0);
            }
            Err(e) => {
                attempts += 1;
                if attempts >= max_attempts {
                    log::warn!("Failed to connect lifeline on port {} after {} attempts: {}. Will keep retrying slowly.", port, attempts, e);
                    // Slow background retry every 2s
                    loop {
                        if let Ok(mut stream) = TcpStream::connect(("127.0.0.1", port)).await {
                            log::info!("Lifeline connected (late); waiting for EOF to exit");
                            let mut buf = [0u8; 1];
                            let _ = stream.read(&mut buf).await;
                            log::info!(
                                "Lifeline closed; stopping active capture and exiting agent"
                            );
                            force_kill_active_recorder(&app);
                            app.exit(0);
                        }
                        sleep(Duration::from_secs(2)).await;
                    }
                }
                sleep(Duration::from_millis(200)).await;
            }
        }
    }
}

/// Creates a Tauri builder with all plugins, state, and command handlers.
pub fn setup_builder() -> tauri::Builder<tauri::Wry> {
    let builder = tauri::Builder::default().plugin(tauri_plugin_deep_link::init());

    let builder = if std::env::var("PRIMARY_LOGGER").unwrap_or_default() == "true" {
        builder.plugin(
            tauri_plugin_log::Builder::new()
                .level_for("tao::platform_impl::platform", log::LevelFilter::Error)
                .level_for("reqwest::blocking::wait", log::LevelFilter::Error)
                .target(tauri_plugin_log::Target::new(
                    tauri_plugin_log::TargetKind::Stdout,
                ))
                .target(tauri_plugin_log::Target::new(
                    tauri_plugin_log::TargetKind::LogDir {
                        file_name: Some("logs".to_string()),
                    },
                ))
                .build(),
        )
    } else {
        builder
    };

    builder
        .plugin(tauri_plugin_process::init())
        .plugin(tauri_plugin_clipboard_manager::init())
        .plugin(tauri_plugin_os::init())
        .plugin(tauri_plugin_shell::init())
        .plugin(tauri_plugin_dialog::init())
        .manage(DeepLinkState(Arc::new(Mutex::new(None))))
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![
            greet,
            start_recording,
            stop_recording,
            take_screenshot,
            list_apps,
            has_record_perms,
            request_record_perms,
            has_ax_perms,
            request_ax_perms,
            list_recordings,
            get_recording_file,
            init_tools,
            check_tools,
            get_app_data_dir,
            write_file,
            write_recording_file,
            process_recording,
            create_recording_zip,
            get_upload_data_allowed,
            set_upload_data_allowed,
            delete_recording,
            get_video_url,
            get_recording_state,
            get_current_demonstration,
            generate_session_token,
            prepare_transaction_request,
            generate_transaction_deep_link,
            get_transaction_request,
            update_transaction_status,
            list_pending_transactions,
            cleanup_old_transactions,
            handle_transaction_callback,
        ])
}

/// Runs the Tauri application, setting up plugins, state, and command handlers.
///
/// This function initializes the Tauri runtime, registers all plugins, manages state, and exposes command handlers for frontend invocation.
#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    let app = setup_builder()
        .setup(|app| {
            #[cfg(target_os = "macos")]
            {
                // Hide the app icon from the Dock - this is a background agent
                app.set_activation_policy(tauri::ActivationPolicy::Accessory);
            }

            let app_handle = app.handle();
            let listen_handle = app_handle.clone();

            listen_handle.clone().listen("deep-link", move |event| {
                let url = event.payload();
                let state = listen_handle.state::<DeepLinkState>();
                let mut lock = match state.0.lock() {
                    Ok(lock) => lock,
                    Err(poisoned) => {
                        log::warn!("[Deep Link] DeepLinkState mutex was poisoned, recovering...");
                        poisoned.into_inner()
                    }
                };
                *lock = Some(url.to_string().trim_matches('"').to_string());
            });

            Ok(())
        })
        .build(tauri::generate_context!())
        .expect("error while building tauri application");

    // The IPC server must always be started in the main process to ensure proper communication
    // between the main process and the renderer process in Tauri's architecture. Starting it
    // after the window is created ensures that all window-related APIs are available.
    // We wait a short moment to ensure the window is fully initialized.
    let app_handle = app.handle().clone();
    tauri::async_runtime::spawn(async move {
        // Small delay to ensure the window is fully created
        tokio::time::sleep(tokio::time::Duration::from_millis(100)).await;
        ipc_server::init(app_handle).await;
    });

    // Start parent process monitoring to auto-exit if parent dies
    let app_for_parent = app.handle().clone();
    tauri::async_runtime::spawn(async move {
        monitor_parent_process(app_for_parent).await;
    });

    // Start lifeline monitor if Flutter provided a port
    if let Ok(port_str) = std::env::var("AGENT_LIFELINE_PORT") {
        if let Ok(port) = port_str.parse::<u16>() {
            let app_for_lifeline = app.handle().clone();
            tauri::async_runtime::spawn(async move {
                monitor_lifeline(port, app_for_lifeline).await;
            });
        } else {
            log::warn!("Invalid AGENT_LIFELINE_PORT value: {}", port_str);
        }
    }

    app.run(|app_handle, event| {
        match event {
            tauri::RunEvent::ExitRequested { api, code, .. } => {
                // Only prevent exit if there's an active recording or other critical process
                // For now, we allow the app to exit normally
                if code.is_none() {
                    // User requested exit (e.g., clicked X button)
                    // Perform any cleanup here if needed
                    log::info!(
                        "Application exit requested by user - attempting graceful recorder stop"
                    );
                    // Best-effort stop; if something is recording, ensure it is killed
                    force_kill_active_recorder(&app_handle);
                }
                // Don't call api.prevent_exit() - let the app close normally
            }
            _ => {}
        }
    });
}
