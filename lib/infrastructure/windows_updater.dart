import 'dart:developer' as developer;
import 'dart:io';

import 'package:auto_updater/auto_updater.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

      // Get current app version (without build number)
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version; // e.g., "0.3.4"

      developer.log(
        '[WindowsUpdater] Current app version: $currentVersion (build: ${packageInfo.buildNumber})',
        name: 'WindowsUpdater',
      );

      // Fetch and parse the appcast.xml to get the available version
      const environment =
          String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
      final appcastUrl = _getAppcastUrl(environment);

      final availableVersion = await _fetchAvailableVersion(appcastUrl);

      if (availableVersion == null) {
        developer.log(
          '[WindowsUpdater] Could not determine available version from appcast',
          name: 'WindowsUpdater',
        );
        return;
      }

      developer.log(
        '[WindowsUpdater] Available version: $availableVersion',
        name: 'WindowsUpdater',
      );

      // Compare versions (semantic only, ignore build number)
      if (_isNewerVersion(availableVersion, currentVersion)) {
        developer.log(
          '[WindowsUpdater] New version available: $availableVersion > $currentVersion',
          name: 'WindowsUpdater',
        );

        // Trigger the update check which will show the UI
        await autoUpdater.checkForUpdates();
      } else {
        developer.log(
          '[WindowsUpdater] No update needed: $availableVersion <= $currentVersion',
          name: 'WindowsUpdater',
        );
      }

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

  /// Fetches the available version from the appcast.xml
  static Future<String?> _fetchAvailableVersion(String appcastUrl) async {
    try {
      final dio = Dio();
      final response = await dio.get<String>(appcastUrl);

      if (response.statusCode != 200 || response.data == null) {
        return null;
      }

      // Parse the XML to extract sparkle:version or sparkle:shortVersionString
      final xml = response.data!;

      // Try to extract sparkle:version first
      final versionMatch = RegExp('sparkle:version="([^"]+)"').firstMatch(xml);
      if (versionMatch != null) {
        return versionMatch.group(1);
      }

      // Fall back to sparkle:shortVersionString
      final shortVersionMatch =
          RegExp('sparkle:shortVersionString="([^"]+)"').firstMatch(xml);
      if (shortVersionMatch != null) {
        return shortVersionMatch.group(1);
      }

      return null;
    } catch (e) {
      developer.log(
        '[WindowsUpdater] Failed to fetch appcast: $e',
        name: 'WindowsUpdater',
        level: 1000,
      );
      return null;
    }
  }

  /// Compares two semantic versions (ignoring build numbers)
  /// Returns true if availableVersion > currentVersion
  static bool _isNewerVersion(String availableVersion, String currentVersion) {
    // Remove any build number suffix (e.g., "+114")
    final availableClean = availableVersion.split('+').first;
    final currentClean = currentVersion.split('+').first;

    final availableParts = availableClean.split('.').map(int.tryParse).toList();
    final currentParts = currentClean.split('.').map(int.tryParse).toList();

    // Ensure both have 3 parts
    while (availableParts.length < 3) {
      availableParts.add(0);
    }
    while (currentParts.length < 3) {
      currentParts.add(0);
    }

    // Compare major.minor.patch
    for (var i = 0; i < 3; i++) {
      final available = availableParts[i] ?? 0;
      final current = currentParts[i] ?? 0;

      if (available > current) return true;
      if (available < current) return false;
    }

    // Versions are equal
    return false;
  }

  static String _getAppcastUrl(String environment) {
    if (environment == 'prod') {
      return 'https://releases.clones-ai.com/latest/windows/appcast.xml';
    } else {
      return 'https://releases-test.clones-ai.com/latest/windows/appcast.xml';
    }
  }
}
