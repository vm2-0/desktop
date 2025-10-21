import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';

/// Simple heartbeat writer - single file shared across all processes
class HeartbeatMonitor {
  factory HeartbeatMonitor() => _instance;
  HeartbeatMonitor._internal();
  static final HeartbeatMonitor _instance = HeartbeatMonitor._internal();

  Timer? _heartbeatTimer;
  static const String _heartbeatFileName = 'clones-desktop-heartbeat';
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(milliseconds: 100);

  /// Start Flutter heartbeat writer - writes every 1 second for deterministic timing
  Future<void> startFlutterHeartbeat() async {
    await stopFlutterHeartbeat();

    _log('info', 'Starting Flutter heartbeat writer at ${getHeartbeatPath()}');

    // Write heartbeat every 1 second (monitors check every 2s with 5s timeout)
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _writeHeartbeat();
    });

    // Write initial heartbeat
    await _writeHeartbeat();
  }

  /// Stop Flutter heartbeat writer - file stays for process cleanup
  Future<void> stopFlutterHeartbeat() async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _log('info', 'Stopped Flutter heartbeat writer');
  }

  /// Write timestamp to heartbeat file with retry logic
  Future<void> _writeHeartbeat() async {
    var retryCount = 0;
    
    while (retryCount < _maxRetries) {
      try {
        final file = File(getHeartbeatPath());
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        
        // Validate timestamp before writing
        if (!_isValidTimestamp(timestamp)) {
          _log('warn', 'Invalid timestamp detected: $timestamp');
          return;
        }
        
        await file.writeAsString(timestamp);
        _log('debug', 'Heartbeat written successfully (attempt ${retryCount + 1})');
        return; // Success
      } catch (e) {
        retryCount++;
        _log('warn', 'Error writing heartbeat (attempt $retryCount): $e');
        
        if (retryCount < _maxRetries) {
          final jitter = Random().nextInt(50); // Add jitter to prevent thundering herd
          await Future.delayed(_retryDelay + Duration(milliseconds: jitter));
        }
      }
    }
    
    _log('error', 'Failed to write heartbeat after $_maxRetries attempts');
  }

  /// Get heartbeat file path - consistent with Rust implementation
  static String getHeartbeatPath() {
    if (Platform.isWindows) {
      // Match Rust logic exactly: TEMP -> TMP -> C:\temp fallback
      final tempDir = Platform.environment['TEMP'] ?? 
                     Platform.environment['TMP'] ?? 
                     r'C:\temp';
      return '$tempDir\\$_heartbeatFileName';
    } else {
      // Use /tmp on macOS/Linux (consistent with Rust)
      return '/tmp/$_heartbeatFileName';
    }
  }

  /// Validates heartbeat file freshness similar to Rust implementation
  static bool isHeartbeatFresh({Duration timeout = const Duration(seconds: 5)}) {
    try {
      final file = File(getHeartbeatPath());
      if (!file.existsSync()) {
        _log('warn', 'Heartbeat file missing: ${file.path}');
        return false;
      }

      final content = file.readAsStringSync().trim();
      final timestampMs = int.parse(content);
      
      // Get current time with clock skew handling
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      
      // Handle both forward and backward time skew
      final ageMs = nowMs >= timestampMs ? nowMs - timestampMs : 0;
      final ageSecs = ageMs / 1000;
      
      if (ageSecs > timeout.inSeconds) {
        _log('warn', 'Heartbeat too old: ${ageSecs}s');
        return false;
      }
      
      _log('debug', 'Heartbeat OK (age: ${ageSecs}s)');
      return true;
    } catch (e) {
      _log('warn', 'Error checking heartbeat: $e');
      return false;
    }
  }

  /// Unified logging that matches Rust log format
  static void _log(String level, String message) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp] [Heartbeat] $message';
    
    switch (level) {
      case 'info':
        developer.log(logMessage, name: 'HeartbeatMonitor');
        break;
      case 'warn':
        developer.log(logMessage, level: 900, name: 'HeartbeatMonitor');
        break;
      case 'error':
        developer.log(logMessage, level: 1000, name: 'HeartbeatMonitor');
        break;
      default:
        developer.log(logMessage, name: 'HeartbeatMonitor');
    }
    
    // Also output to debug console for development
    if (kDebugMode) {
      debugPrint(logMessage);
    }
  }

  /// Validates timestamp format and range
  static bool _isValidTimestamp(String timestamp) {
    try {
      final ms = int.parse(timestamp);
      final now = DateTime.now().millisecondsSinceEpoch;
      
      // Check for reasonable timestamp range (within 1 hour of current time)
      const oneHour = 60 * 60 * 1000; // 1 hour in milliseconds
      if ((ms - now).abs() > oneHour) {
        return false;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }
}
