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
use crate::commands::updater::{check_for_update, install_update};
// State to hold the latest deep link URL
pub struct DeepLinkState(pub Arc<Mutex<Option<String>>>);

/// Creates a Tauri builder with all plugins, state, and command handlers.
pub fn setup_builder() -> tauri::Builder<tauri::Wry> {
    let builder = tauri::Builder::default()
        .plugin(tauri_plugin_updater::Builder::new().build())
        .plugin(tauri_plugin_deep_link::init());

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
            check_for_update,
            install_update,
        ])
}

/// Runs the Tauri application, setting up plugins, state, and command handlers.
///
/// This function initializes the Tauri runtime, registers all plugins, manages state, and exposes command handlers for frontend invocation.
#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    let app = setup_builder()
        .setup(|app| {
            let app_handle = app.handle();
            let listen_handle = app_handle.clone();

            // The IPC server must always be started in the main process to ensure proper communication
            // between the main process and the renderer process in Tauri's architecture. Starting it
            // elsewhere could lead to communication failures or runtime errors, as the main process
            // is responsible for managing the application's state and handling IPC events.
            tauri::async_runtime::spawn({
                let app_handle = app_handle.clone();
                async move {
                    ipc_server::init(app_handle).await;
                }
            });

            listen_handle.clone().listen("deep-link", move |event| {
                let url = event.payload();
                let state = listen_handle.state::<DeepLinkState>();
                let mut lock = state.0.lock().unwrap();
                *lock = Some(url.to_string().trim_matches('"').to_string());
            });

            Ok(())
        })
        .build(tauri::generate_context!())
        .expect("error while building tauri application");

    app.run(|_app_handle, event| {
        if let tauri::RunEvent::ExitRequested { api, .. } = event {
            api.prevent_exit();
        }
    });
}
