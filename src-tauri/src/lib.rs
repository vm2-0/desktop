//! Main entry point and Tauri integration for the desktop application.
//!
//! This crate wires together all core, tool, and utility modules, and sets up the Tauri runtime, plugins, and command handlers for the application.

use tauri::Manager;
mod commands;
mod core;
pub mod ipc_server;
mod services;
mod tools;
pub mod utils;
use std::sync::{Arc, Mutex};
use tauri::Listener;

use utils::permissions::{has_ax_perms, has_record_perms, request_ax_perms, request_record_perms};
use utils::heartbeat;
use utils::pid_monitor;

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

            // Single instance check - exit if another agent is running
            if let Ok(_) = std::net::TcpStream::connect("127.0.0.1:19847") {
                log::error!("Another agent instance is already running on port 19847");
                std::process::exit(1);
            }

            // Check if agent is launched in development mode
            // Use explicit environment variable for reliable detection
            // Set CLONES_DEV_MODE=true or CLONES_DEV_MODE=1 to enable development mode
            // This disables Flutter lifecycle monitoring for standalone testing
            let is_dev_mode = std::env::var("CLONES_DEV_MODE")
                .map(|v| v == "true" || v == "1")
                .unwrap_or(false);
            
            if is_dev_mode {
                log::info!("[Monitor] Development mode detected - skipping Flutter lifecycle monitoring");
                log::info!("[Monitor] Agent will run independently until manually stopped");
            } else {
                // Start hybrid monitoring system in background (production mode only)
                let app_for_monitoring = app.handle().clone();
                tauri::async_runtime::spawn(async move {
                    // Try to get Flutter PID for OS-level monitoring
                    if let Ok(ppid_str) = std::env::var("FLUTTER_PARENT_PID") {
                        if let Ok(flutter_pid) = ppid_str.parse::<u32>() {
                            log::info!("[Monitor] Starting hybrid monitoring for Flutter PID: {}", flutter_pid);
                            
                            // Start OS-level PID monitor (primary)
                            let app_for_pid = app_for_monitoring.clone();
                            tauri::async_runtime::spawn(async move {
                                pid_monitor::start_parent_process_monitor(flutter_pid, app_for_pid).await;
                            });
                            
                            // Start heartbeat monitor (fallback)
                            let app_for_heartbeat = app_for_monitoring.clone();
                            tauri::async_runtime::spawn(async move {
                                heartbeat::start_flutter_heartbeat_monitor(flutter_pid, app_for_heartbeat).await;
                            });
                            
                            return;
                        }
                    }
                    
                    // Fallback to heartbeat-only monitoring
                    log::info!("[Monitor] No Flutter PID provided - using heartbeat-only monitoring");
                    heartbeat::auto_detect_and_monitor_flutter(app_for_monitoring).await;
                });
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


    log::info!("Agent started with heartbeat-based lifecycle management");

    app.run(|app_handle, event| {
        match event {
            tauri::RunEvent::ExitRequested { code, .. } => {
                // Only prevent exit if there's an active recording or other critical process
                // For now, we allow the app to exit normally
                if code.is_none() {
                    // User requested exit (e.g., clicked X button)
                    // Perform any cleanup here if needed
                    log::info!(
                        "Application exit requested by user - attempting graceful recorder stop"
                    );
                    force_kill_active_recorder(&app_handle);
                }
                // Don't call api.prevent_exit() - let the app close normally
            }
            _ => {}
        }
    });
}
