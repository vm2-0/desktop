import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Native Sparkle 2.x updater integration for macOS
class SparkleUpdater {
  factory SparkleUpdater() {
    _instance ??= SparkleUpdater._internal();
    return _instance!;
  }
  SparkleUpdater._internal();

  static const MethodChannel _channel = MethodChannel('clones_desktop/sparkle');

  static SparkleUpdater? _instance;

  /// Initialize Sparkle updater with configuration
  Future<void> initialize({
    required String appcastUrl,
    String? publicKey,
    bool automaticallyChecksForUpdates = true,
    bool automaticallyDownloadsUpdates = false,
  }) async {
    if (!Platform.isMacOS || kIsWeb) {
      debugPrint('Sparkle updater only works on macOS');
      return;
    }

    try {
      await _channel.invokeMethod('initialize', {
        'appcastUrl': appcastUrl,
        'publicKey': publicKey,
        'automaticallyChecksForUpdates': automaticallyChecksForUpdates,
        'automaticallyDownloadsUpdates': automaticallyDownloadsUpdates,
      });
      debugPrint('Sparkle updater initialized');
    } catch (e) {
      debugPrint('Failed to initialize Sparkle updater: $e');
    }
  }

  /// Check for updates manually
  Future<void> checkForUpdates() async {
    if (!Platform.isMacOS || kIsWeb) return;

    try {
      await _channel.invokeMethod('checkForUpdates');
    } catch (e) {
      debugPrint('Failed to check for updates: $e');
    }
  }

  /// Check for updates in background (silent)
  Future<void> checkForUpdatesInBackground() async {
    if (!Platform.isMacOS || kIsWeb) return;

    try {
      await _channel.invokeMethod('checkForUpdatesInBackground');
    } catch (e) {
      debugPrint('Failed to check for updates in background: $e');
    }
  }

  /// Get current app version
  Future<String?> getCurrentVersion() async {
    if (!Platform.isMacOS || kIsWeb) return null;

    try {
      return await _channel.invokeMethod('getCurrentVersion');
    } catch (e) {
      debugPrint('Failed to get current version: $e');
      return null;
    }
  }

  /// Set whether to automatically check for updates
  Future<void> setAutomaticallyChecksForUpdates(bool enabled) async {
    if (!Platform.isMacOS || kIsWeb) return;

    try {
      await _channel.invokeMethod('setAutomaticallyChecksForUpdates', {
        'enabled': enabled,
      });
    } catch (e) {
      debugPrint('Failed to set automatic update checking: $e');
    }
  }

  /// Set whether to automatically download updates
  Future<void> setAutomaticallyDownloadsUpdates(bool enabled) async {
    if (!Platform.isMacOS || kIsWeb) return;

    try {
      await _channel.invokeMethod('setAutomaticallyDownloadsUpdates', {
        'enabled': enabled,
      });
    } catch (e) {
      debugPrint('Failed to set automatic update downloading: $e');
    }
  }
}
