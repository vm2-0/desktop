import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Monitors process lifecycle via heartbeat files
class HeartbeatMonitor {
  factory HeartbeatMonitor() => _instance;
  HeartbeatMonitor._internal();
  static final HeartbeatMonitor _instance = HeartbeatMonitor._internal();

  Timer? _flutterHeartbeatTimer;
  String? _flutterHeartbeatPath;

  /// Start Flutter heartbeat writer for agent to monitor
  /// Agent will monitor this file and exit if it gets stale
  Future<void> startFlutterHeartbeat() async {
    await stopFlutterHeartbeat();

    final flutterPid = pid;
    _flutterHeartbeatPath = await _getFlutterHeartbeatPath(flutterPid);

    debugPrint('Starting Flutter heartbeat writer at $_flutterHeartbeatPath');

    // Write heartbeat every 1 second
    _flutterHeartbeatTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _writeFlutterHeartbeat();
    });

    // Write initial heartbeat
    _writeFlutterHeartbeat();
  }

  /// Stop Flutter heartbeat writer
  Future<void> stopFlutterHeartbeat() async {
    _flutterHeartbeatTimer?.cancel();
    _flutterHeartbeatTimer = null;

    if (_flutterHeartbeatPath != null) {
      try {
        final file = File(_flutterHeartbeatPath!);
        if (file.existsSync()) {
          await file.delete();
          debugPrint('Deleted Flutter heartbeat file: $_flutterHeartbeatPath');
        }
      } catch (e) {
        debugPrint('Error deleting Flutter heartbeat file: $e');
      }
      _flutterHeartbeatPath = null;
    }
  }

  /// Get the Flutter heartbeat file path for a given PID
  Future<String> _getFlutterHeartbeatPath(int pid) async {
    if (Platform.isWindows) {
      final tempDir = await getTemporaryDirectory();
      return '${tempDir.path}\\clones-flutter-$pid.heartbeat';
    } else {
      return '/tmp/clones-flutter-$pid.heartbeat';
    }
  }

  /// Write Flutter heartbeat to file
  void _writeFlutterHeartbeat() {
    if (_flutterHeartbeatPath == null) return;

    try {
      final file = File(_flutterHeartbeatPath!);
      final timestamp = DateTime.now().toIso8601String();
      file.writeAsStringSync(timestamp);
    } catch (e) {
      debugPrint('Error writing Flutter heartbeat: $e');
    }
  }


  /// Get Flutter heartbeat file path for external use (agent needs to know where to monitor)
  static Future<String> getFlutterHeartbeatPathForPid(int pid) async {
    if (Platform.isWindows) {
      final tempDir = await getTemporaryDirectory();
      return '${tempDir.path}\\clones-flutter-$pid.heartbeat';
    } else {
      return '/tmp/clones-flutter-$pid.heartbeat';
    }
  }
}
