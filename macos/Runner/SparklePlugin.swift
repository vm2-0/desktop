import Cocoa
import FlutterMacOS
import Sparkle

/// Native Sparkle 2.x integration plugin for Flutter
public class SparklePlugin: NSObject, FlutterPlugin {
    private var updaterController: SPUStandardUpdaterController?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "clones_desktop/sparkle", binaryMessenger: registrar.messenger)
        let instance = SparklePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            initialize(call: call, result: result)
        case "checkForUpdates":
            checkForUpdates(result: result)
        case "checkForUpdatesInBackground":
            checkForUpdatesInBackground(result: result)
        case "getCurrentVersion":
            getCurrentVersion(result: result)
        case "setAutomaticallyChecksForUpdates":
            setAutomaticallyChecksForUpdates(call: call, result: result)
        case "setAutomaticallyDownloadsUpdates":
            setAutomaticallyDownloadsUpdates(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func initialize(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
            return
        }
        
        guard let appcastURL = args["appcastUrl"] as? String else {
            result(FlutterError(code: "INVALID_URL", message: "Invalid appcast URL", details: nil))
            return
        }
        
        // Initialize Sparkle with SPUStandardUpdaterController
        // In Sparkle 2.x, the feedURL is read from Info.plist (SUFeedURL key)
        // We'll verify it matches or log a warning
        updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
        
        // Configure the updater
        let updater = updaterController!.updater
        
        // Verify feedURL matches (it's read-only in 2.x, set via Info.plist)
        if let currentFeedURL = updater.feedURL?.absoluteString {
            if currentFeedURL != appcastURL {
                NSLog("Warning: Requested feedURL '\(appcastURL)' differs from Info.plist SUFeedURL '\(currentFeedURL)'")
            }
        }
        
        // Configure automatic checking
        if let autoCheck = args["automaticallyChecksForUpdates"] as? Bool {
            updater.automaticallyChecksForUpdates = autoCheck
        }
        
        // Configure automatic downloading
        if let autoDownload = args["automaticallyDownloadsUpdates"] as? Bool {
            updater.automaticallyDownloadsUpdates = autoDownload
        }
        
        // Set update check interval (24 hours by default)
        updater.updateCheckInterval = 24 * 60 * 60
        
        NSLog("Sparkle updater initialized with appcast: \(appcastURL)")
        result(nil)
    }
    
    private func checkForUpdates(result: @escaping FlutterResult) {
        guard let updater = updaterController?.updater else {
            result(FlutterError(code: "NOT_INITIALIZED", message: "Sparkle not initialized", details: nil))
            return
        }
        
        updater.checkForUpdates()
        result(nil)
    }
    
    private func checkForUpdatesInBackground(result: @escaping FlutterResult) {
        guard let updater = updaterController?.updater else {
            result(FlutterError(code: "NOT_INITIALIZED", message: "Sparkle not initialized", details: nil))
            return
        }
        
        updater.checkForUpdatesInBackground()
        result(nil)
    }
    
    private func getCurrentVersion(result: @escaping FlutterResult) {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        result(version)
    }
    
    private func setAutomaticallyChecksForUpdates(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let updater = updaterController?.updater else {
            result(FlutterError(code: "NOT_INITIALIZED", message: "Sparkle not initialized", details: nil))
            return
        }
        
        guard let args = call.arguments as? [String: Any],
              let enabled = args["enabled"] as? Bool else {
            result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
            return
        }
        
        updater.automaticallyChecksForUpdates = enabled
        result(nil)
    }
    
    private func setAutomaticallyDownloadsUpdates(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let updater = updaterController?.updater else {
            result(FlutterError(code: "NOT_INITIALIZED", message: "Sparkle not initialized", details: nil))
            return
        }
        
        guard let args = call.arguments as? [String: Any],
              let enabled = args["enabled"] as? Bool else {
            result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
            return
        }
        
        updater.automaticallyDownloadsUpdates = enabled
        result(nil)
    }
}