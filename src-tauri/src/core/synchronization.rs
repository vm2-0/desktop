use chrono::{DateTime, Local};
use std::sync::atomic::{AtomicBool, AtomicI64, Ordering};
use std::time::Instant;

/// Callback for when video recording actually starts
pub type VideoStartCallback = Box<dyn Fn(Instant) + Send + Sync>;

static mut VIDEO_START_CALLBACK: Option<VideoStartCallback> = None;
static CALLBACK_SET: AtomicBool = AtomicBool::new(false);

static SYNC_REFERENCE_MILLIS: AtomicI64 = AtomicI64::new(0);
static SYNC_ACTIVE: AtomicBool = AtomicBool::new(false);

pub fn start_sync(_recorder_ready_instant: Instant) -> DateTime<Local> {
    let reference_timestamp = Local::now();
    
    // Store reference time as milliseconds since epoch for thread-safe access
    SYNC_REFERENCE_MILLIS.store(reference_timestamp.timestamp_millis(), Ordering::SeqCst);
    SYNC_ACTIVE.store(true, Ordering::SeqCst);
    
    log::info!("[sync] Reference established at {}", reference_timestamp.to_rfc3339());
    reference_timestamp
}

pub fn get_relative_timestamp() -> Option<i64> {
    if !SYNC_ACTIVE.load(Ordering::SeqCst) {
        return None;
    }

    let reference_millis = SYNC_REFERENCE_MILLIS.load(Ordering::SeqCst);
    if reference_millis == 0 {
        return None;
    }

    let now_millis = Local::now().timestamp_millis();
    Some(now_millis - reference_millis)
}

pub fn stop_sync() {
    SYNC_ACTIVE.store(false, Ordering::SeqCst);
    SYNC_REFERENCE_MILLIS.store(0, Ordering::SeqCst);
    
    // Clear callback
    unsafe {
        VIDEO_START_CALLBACK = None;
    }
    CALLBACK_SET.store(false, Ordering::SeqCst);
    
    log::info!("[sync] Synchronization stopped");
}

/// Set callback to be called when video actually starts recording
pub fn set_video_start_callback<F>(callback: F) 
where 
    F: Fn(Instant) + Send + Sync + 'static 
{
    unsafe {
        VIDEO_START_CALLBACK = Some(Box::new(callback));
    }
    CALLBACK_SET.store(true, Ordering::SeqCst);
    log::info!("[sync] Video start callback registered");
}

/// Called by video recorders when they start capturing frames
pub fn notify_video_started(video_start_instant: Instant) {
    if CALLBACK_SET.load(Ordering::SeqCst) {
        unsafe {
            if let Some(ref callback) = VIDEO_START_CALLBACK {
                callback(video_start_instant);
            }
        }
    }
}