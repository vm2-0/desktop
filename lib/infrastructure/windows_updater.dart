import 'dart:developer' as developer;
import 'dart:io';

import 'package:auto_updater/auto_updater.dart';
import 'package:flutter/foundation.dart';

class WindowsUpdater {
  WindowsUpdater._();

  static Future<void> initialize({
    required String environment,
  }) async {
    if (!Platform.isWindows || kIsWeb) {
      developer.log(
        'Windows updater only works on Windows',
        name: 'WindowsUpdater',
      );
      return;
    }

    try {
      final appcastUrl = _getAppcastUrl(environment);
      
      developer.log(
        '[WindowsUpdater] Initializing with appcast URL: $appcastUrl',
        name: 'WindowsUpdater',
      );

      await autoUpdater.setFeedURL(appcastUrl);
      await autoUpdater.setScheduledCheckInterval(3600); // Check every hour

      developer.log(
        '[WindowsUpdater] Windows updater initialized successfully',
        name: 'WindowsUpdater',
      );
    } catch (e) {
      developer.log(
        '[WindowsUpdater] Failed to initialize: $e',
        name: 'WindowsUpdater',
        level: 1000,
      );
    }
  }

  static Future<void> checkForUpdates() async {
    if (!Platform.isWindows || kIsWeb) return;

    try {
      developer.log(
        '[WindowsUpdater] Checking for updates...',
        name: 'WindowsUpdater',
      );
      
      await autoUpdater.checkForUpdates();
      
      developer.log(
        '[WindowsUpdater] Update check completed',
        name: 'WindowsUpdater',
      );
    } catch (e) {
      developer.log(
        '[WindowsUpdater] Failed to check for updates: $e',
        name: 'WindowsUpdater',
        level: 1000,
      );
    }
  }

  static String _getAppcastUrl(String environment) {
    if (environment == 'prod') {
      return 'https://releases.clones-ai.com/latest/windows/appcast.xml';
    } else {
      return 'https://releases-test.clones-ai.com/latest/windows/appcast.xml';
    }
  }
}