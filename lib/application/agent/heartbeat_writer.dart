import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

class HeartbeatWriter {
  factory HeartbeatWriter() => _instance;
  HeartbeatWriter._internal();
  static final HeartbeatWriter _instance = HeartbeatWriter._internal();

  // Constants for heartbeat configuration
  static const Duration _heartbeatInterval = Duration(seconds: 2);
  static const int _maxRetryAttempts = 3;
  static const Duration _retryDelay = Duration(milliseconds: 100);
  static const String _loggerName = 'HeartbeatWriter';
  static const String _windowsTempFallback = r'C:\Windows\Temp';

  Timer? _heartbeatTimer;
  String? _heartbeatPath;

  /// Get the standardized heartbeat file path for cross-platform compatibility
  String _getHeartbeatPath() {
    // Allow explicit override (useful for testing or multi-instance scenarios)
    final override = Platform.environment['FLUTTER_HEARTBEAT_PATH'];
    if (override != null && override.isNotEmpty) {
      return override;
    }

    if (Platform.isWindows) {
      // EXACT same logic as Rust: TEMP -> TMP -> fallback
      final tempDir = Platform.environment['TEMP'] ??
          Platform.environment['TMP'] ??
          _windowsTempFallback;
      return '$tempDir\\clones-flutter.heartbeat';
    } else {
      // EXACT same logic as Rust: check /tmp exists, fallback to system temp
      final tempDir =
          Directory('/tmp').existsSync() ? '/tmp' : Directory.systemTemp.path;
      return '$tempDir/clones-flutter.heartbeat';
    }
  }

  /// Start writing heartbeat file every 2 seconds
  void startHeartbeat() {
    if (_heartbeatTimer != null) {
      developer.log('Heartbeat already started', name: _loggerName);
      return;
    }

    _heartbeatPath = _getHeartbeatPath();
    developer.log(
      'Starting heartbeat writer (interval: ${_heartbeatInterval.inSeconds}s): $_heartbeatPath',
      name: _loggerName,
    );

    // Write ready signal first to indicate Flutter is starting heartbeat
    _writeReadySignal();

    // Write initial heartbeat immediately
    _writeHeartbeat();

    // Start periodic heartbeat
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) {
      _writeHeartbeat();
    });
  }

  /// Stop writing heartbeat and cleanup file
  void stopHeartbeat() {
    developer.log('Stopping heartbeat writer', name: _loggerName);

    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;

    // Clean up heartbeat files
    if (_heartbeatPath != null) {
      try {
        final file = File(_heartbeatPath!);
        if (file.existsSync()) {
          file.deleteSync();
          developer.log(
            'Heartbeat file cleaned up: $_heartbeatPath',
            name: _loggerName,
          );
        }

        // Also clean up ready signal file
        final readyFile = File('$_heartbeatPath.ready');
        if (readyFile.existsSync()) {
          readyFile.deleteSync();
          developer.log('Ready signal file cleaned up', name: _loggerName);
        }
      } catch (e) {
        developer.log(
          'Failed to cleanup heartbeat files: $e',
          name: _loggerName,
        );
      }
      _heartbeatPath = null;
    }
  }

  /// Write ready signal to indicate Flutter is starting heartbeat monitoring
  void _writeReadySignal() {
    if (_heartbeatPath == null) return;

    try {
      final readyFile = File('$_heartbeatPath.ready');

      // Ensure parent directory exists
      readyFile.parent.createSync(recursive: true);

      // Write ready signal with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      readyFile.writeAsStringSync(timestamp);

      developer.log(
        'Ready signal written with timestamp: $timestamp',
        name: _loggerName,
      );
    } catch (e) {
      developer.log('Failed to write ready signal: $e', name: _loggerName);
    }
  }

  /// Write current timestamp to heartbeat file
  Future<void> _writeHeartbeat() async {
    if (_heartbeatPath == null) return;

    var retryCount = 0;

    while (retryCount < _maxRetryAttempts) {
      try {
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final file = File(_heartbeatPath!);

        // Ensure parent directory exists
        file.parent.createSync(recursive: true);

        // Write timestamp
        file.writeAsStringSync(timestamp);

        developer.log(
          'Heartbeat written: $timestamp',
          name: _loggerName,
          level: 500,
        );
        return; // Success, exit retry loop
      } catch (e) {
        retryCount++;
        developer.log(
          'Failed to write heartbeat (attempt $retryCount/$_maxRetryAttempts): $e',
          name: _loggerName,
        );

        if (retryCount >= _maxRetryAttempts) {
          developer.log(
            'CRITICAL: Heartbeat writing failed after $_maxRetryAttempts attempts - agent may kill this process',
            name: _loggerName,
          );
        } else {
          // Brief delay before retry
          await Future.delayed(_retryDelay);
        }
      }
    }
  }
}
