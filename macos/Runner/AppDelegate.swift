import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate, NSWindowDelegate {
  private var isTerminating = false
  
  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
    
    // Set window delegate for close detection
    if let window = NSApplication.shared.windows.first {
      window.delegate = self
      NSLog("[AppDelegate] Window delegate set for comprehensive close detection")
    }
    
    // Register for app termination notifications
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(applicationWillTerminate),
      name: NSApplication.willTerminateNotification,
      object: nil
    )
    
    NSLog("[AppDelegate] Enhanced app lifecycle management initialized")
  }
  
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    NSLog("[AppDelegate] applicationShouldTerminateAfterLastWindowClosed called")
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  override func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
    NSLog("[AppDelegate] applicationShouldTerminate called - initiating graceful shutdown")
    
    if isTerminating {
      NSLog("[AppDelegate] Already terminating, allowing immediate termination")
      return .terminateNow
    }
    
    isTerminating = true
    
    // Give Flutter time to cleanup via signal handlers
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      NSLog("[AppDelegate] Termination delay completed, proceeding with app exit")
      NSApplication.shared.terminate(nil)
    }
    
    return .terminateLater
  }
  
  @objc override func applicationWillTerminate(_ notification: Notification) {
    NSLog("[AppDelegate] applicationWillTerminate - app is about to terminate")
  }
  
  // MARK: - NSWindowDelegate
  
  func windowShouldClose(_ sender: NSWindow) -> Bool {
    NSLog("[AppDelegate] windowShouldClose called - window close button pressed")
    // Allow window to close, the window manager will handle cleanup
    return true
  }
  
  func windowWillClose(_ notification: Notification) {
    NSLog("[AppDelegate] windowWillClose - window is about to close")
  }
  
  func windowDidBecomeKey(_ notification: Notification) {
    NSLog("[AppDelegate] Window became key (focused)")
  }
  
  func windowDidResignKey(_ notification: Notification) {
    NSLog("[AppDelegate] Window resigned key (lost focus)")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
    NSLog("[AppDelegate] AppDelegate deallocated")
  }
}
