import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  private var lifecycleChannel: FlutterMethodChannel?

  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
    
    // Register Sparkle plugin
    let controller: FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
    SparklePlugin.register(with: controller.engine.registrar(forPlugin: "SparklePlugin"))

    // Setup lifecycle channel to notify Flutter on app termination
    lifecycleChannel = FlutterMethodChannel(
      name: "app.lifecycle",
      binaryMessenger: controller.engine.binaryMessenger
    )
  }
  
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  // Intercept Dock Quit earlier so Flutter can run shutdown before engine teardown
  override func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
    // Ask Flutter to shutdown (closes lifeline, stops agent)
    lifecycleChannel?.invokeMethod("willTerminate", arguments: nil)
    // Allow a brief moment for Flutter side to process and close sockets
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
      NSApp.reply(toApplicationShouldTerminate: true)
    }
    return .terminateLater
  }

  override func applicationWillTerminate(_ notification: Notification) {
    // Notify Flutter so it can gracefully shutdown (closes lifeline, stops agent)
    lifecycleChannel?.invokeMethod("willTerminate", arguments: nil)
  }
}
