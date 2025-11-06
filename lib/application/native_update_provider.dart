import 'dart:io';
import 'package:clones_desktop/infrastructure/sparkle_updater.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NativeUpdateState {
  const NativeUpdateState({
    this.isInitialized = false,
    this.status = UpdateStatus.idle,
    this.availableVersion,
    this.currentVersion,
    this.error,
  });

  final bool isInitialized;
  final UpdateStatus status;
  final String? availableVersion;
  final String? currentVersion;
  final String? error;

  NativeUpdateState copyWith({
    bool? isInitialized,
    UpdateStatus? status,
    String? availableVersion,
    String? currentVersion,
    String? error,
  }) {
    return NativeUpdateState(
      isInitialized: isInitialized ?? this.isInitialized,
      status: status ?? this.status,
      availableVersion: availableVersion ?? this.availableVersion,
      currentVersion: currentVersion ?? this.currentVersion,
      error: error ?? this.error,
    );
  }
}

enum UpdateStatus {
  idle,
  initializing,
  checking,
  available,
  downloading,
  installing,
  completed,
  error,
}

final nativeUpdateProvider =
    StateNotifierProvider<NativeUpdateNotifier, NativeUpdateState>((ref) {
  return NativeUpdateNotifier();
});

class NativeUpdateNotifier extends StateNotifier<NativeUpdateState> {
  NativeUpdateNotifier() : super(const NativeUpdateState());

  SparkleUpdater? _sparkleUpdater;

  /// Initialize the appropriate native updater for the platform
  Future<void> initialize() async {
    if (!mounted) return;

    state = state.copyWith(status: UpdateStatus.initializing);

    try {
      if (Platform.isMacOS) {
        await _initializeSparkle();
      } else if (Platform.isWindows) {
        // TODO(reddwarf03): Implement native Windows updater (WinSparkle or similar)
        debugPrint('Windows native updater not yet implemented');
        state = state.copyWith(
          status: UpdateStatus.error,
          error: 'Windows native updater not implemented',
        );
        return;
      } else if (Platform.isLinux) {
        // TODO(reddwarf03): Implement Linux updater (AppImage updater or package manager)
        debugPrint('Linux native updater not yet implemented');
        state = state.copyWith(
          status: UpdateStatus.error,
          error: 'Linux native updater not implemented',
        );
        return;
      }

      state = state.copyWith(
        isInitialized: true,
        status: UpdateStatus.idle,
      );

      // Check for updates after initialization
      await checkForUpdates();
    } catch (e) {
      state = state.copyWith(
        status: UpdateStatus.error,
        error: 'Failed to initialize updater: $e',
      );
    }
  }

  Future<void> _initializeSparkle() async {
    _sparkleUpdater = SparkleUpdater();

    // Determine appcast URL based on environment
    String appcastUrl;
    if (const String.fromEnvironment('ENVIRONMENT') == 'prod') {
      appcastUrl = 'https://releases.clones-ai.com/latest/darwin/appcast.xml';
    } else {
      appcastUrl =
          'https://releases-test.clones-ai.com/latest/darwin/appcast.xml';
    }

    await _sparkleUpdater!.initialize(
      appcastUrl: appcastUrl,
    );

    // Get current version
    final currentVersion = await _sparkleUpdater!.getCurrentVersion();
    state = state.copyWith(currentVersion: currentVersion);

    debugPrint('Sparkle updater initialized');
  }

  /// Check for updates manually
  Future<void> checkForUpdates() async {
    if (!state.isInitialized || !mounted) return;

    state = state.copyWith(
      status: UpdateStatus.checking,
    );

    try {
      if (Platform.isMacOS && _sparkleUpdater != null) {
        // Sparkle handles update checking internally
        await _sparkleUpdater!.checkForUpdatesInBackground();
        state = state.copyWith(status: UpdateStatus.idle);
      } else {
        state = state.copyWith(
          status: UpdateStatus.error,
          error: 'No updater available for this platform',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: UpdateStatus.error,
        error: 'Failed to check for updates: $e',
      );
    }
  }

  /// Show update dialog (for manual updates)
  Future<void> showUpdateDialog() async {
    if (!state.isInitialized) return;

    try {
      if (Platform.isMacOS && _sparkleUpdater != null) {
        await _sparkleUpdater!.checkForUpdates();
      }
    } catch (e) {
      state = state.copyWith(
        status: UpdateStatus.error,
        error: 'Failed to show update dialog: $e',
      );
    }
  }

  /// Enable/disable automatic update checking
  Future<void> setAutomaticUpdates(bool enabled) async {
    if (!state.isInitialized) return;

    try {
      if (Platform.isMacOS && _sparkleUpdater != null) {
        await _sparkleUpdater!.setAutomaticallyChecksForUpdates(enabled);
      }
    } catch (e) {
      state = state.copyWith(
        status: UpdateStatus.error,
        error: 'Failed to set automatic updates: $e',
      );
    }
  }

  @override
  void dispose() {
    _sparkleUpdater = null;
    super.dispose();
  }
}
