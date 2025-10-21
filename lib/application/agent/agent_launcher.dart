import 'dart:async';
import 'dart:io';

import 'package:clones_desktop/application/agent/heartbeat_monitor.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:process/process.dart';
import 'package:synchronized/synchronized.dart';

class AgentLauncher {
  factory AgentLauncher() => _instance;
  AgentLauncher._internal();
  static final AgentLauncher _instance = AgentLauncher._internal();

  Process? _agentProcess;
  bool _starting = false;
  final ProcessManager _processManager = const LocalProcessManager();
  String? _cachedRepoRoot;
  final _repoRootLock = Lock();

  // File permission bits: owner execute (0x40) is what we care about for the current user
  static const int _ownerExecutePermission = 0x40;

  /// Ensures the Tauri agent is running. If not, attempts to start it.
  Future<void> ensureStarted() async {
    if (kIsWeb) return;

    // Quick check if agent already running (e.g., launched via VSCode)
    if (await _isAgentAlive()) {
      debugPrint(
        'Agent already running - starting heartbeat for existing agent',
      );
      // CRUCIAL: Always start heartbeat even if agent already exists
      await HeartbeatMonitor().startFlutterHeartbeat();
      return;
    }

    if (_starting) return;

    _starting = true;
    try {
      final executable = await _resolveAgentExecutablePath();
      if (executable == null) {
        throw Exception('Tauri agent executable not found');
      }

      // Ensure the agent binary is executable by the current user (owner)
      final executableFile = File(executable);
      final stat = executableFile.statSync();
      if (!Platform.isWindows && (stat.mode & _ownerExecutePermission) == 0) {
        debugPrint('Making agent executable: $executable');
        await Process.run('chmod', ['+x', executable]);
      }

      final env = <String, String>{
        'PRIMARY_LOGGER': 'true',
        'RUST_LOG': 'info',
      };

      debugPrint('Starting Tauri agent: $executable');
      debugPrint('Binary parent dir: ${Directory(executable).parent.path}');
      debugPrint('Environment variables: $env');

      final repoRoot = await _findRepoRoot();
      final workingDir = repoRoot ?? Directory.current.path;

      debugPrint('Starting agent with process manager: $executable');
      debugPrint('Working directory: $workingDir');

      // Single robust process start with comprehensive environment
      try {
        _agentProcess = await _processManager.start(
          [executable],
          workingDirectory: workingDir,
          environment: {
            ...Platform.environment, // Preserve existing environment
            ...env, // Add our custom variables
          },
        );
      } catch (e) {
        // Single fallback: use Process.start if ProcessManager fails
        debugPrint(
          'ProcessManager.start failed ($e), using Process.start fallback',
        );
        _agentProcess = await Process.start(
          executable,
          [],
          workingDirectory: workingDir,
          environment: {
            ...Platform.environment,
            ...env,
          },
        );
      }

      final agentPid = _agentProcess!.pid;
      debugPrint('Agent started with PID: $agentPid');

      // Validate process state before considering it started
      await _validateProcessState();

      // Start Flutter heartbeat writer (agent will monitor this)
      await HeartbeatMonitor().startFlutterHeartbeat();

      // Drain streams to prevent blocking
      _agentProcess!.stdout.listen((_) {}, onError: (_) {});
      _agentProcess!.stderr.listen((_) {}, onError: (_) {});

      await _waitUntilAlive(timeout: const Duration(seconds: 8));
    } finally {
      _starting = false;
    }
  }

  Future<bool> _isAgentAlive() async {
    try {
      final uri = Uri.parse('http://127.0.0.1:19847/platform');
      // Skip auth for now to simplify debugging
      final res = await http.get(uri).timeout(const Duration(seconds: 2));
      final isAlive = res.statusCode == 200;
      if (isAlive) {
        debugPrint('Agent health check: ✓ alive');
      }
      return isAlive;
    } catch (e) {
      debugPrint('Agent health check: ✗ not responding ($e)');
      return false;
    }
  }

  Future<void> _waitUntilAlive({required Duration timeout}) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      if (await _isAgentAlive()) return;
      await Future.delayed(const Duration(milliseconds: 200));
    }
    throw Exception('Agent did not become ready in time');
  }

  Future<String?> _resolveAgentExecutablePath() async {
    // 1) Explicit override via environment
    final override = Platform.environment['TAURI_AGENT_PATH'];
    if (override?.isNotEmpty == true) {
      final file = File(override!);
      if (file.existsSync()) {
        debugPrint('Using explicit agent override: $override');
        return file.path;
      }
      debugPrint('Agent override path does not exist: $override');
    }

    // 2) Standard packaged location (single, predictable path)
    final packagedPath = _getPackagedAgentPath();
    if (packagedPath != null) {
      final file = File(packagedPath);
      if (file.existsSync()) {
        debugPrint('Using packaged agent: $packagedPath');
        return packagedPath;
      }
      debugPrint('Packaged agent not found: $packagedPath');
    }

    // 3) Development mode only (environment gated)
    if (_isDevelopmentMode()) {
      final devPath = await _findDevelopmentAgentPath();
      if (devPath != null) {
        debugPrint('Using development agent: $devPath');
        return devPath;
      }
      debugPrint('No development agent found');
    } else {
      debugPrint('Development mode disabled - skipping dev agent search');
    }

    return null;
  }

  /// Get standard packaged agent path based on platform conventions
  String? _getPackagedAgentPath() {
    final execDir = File(Platform.resolvedExecutable).parent;
    final agentName =
        Platform.isWindows ? 'clones-desktop.exe' : 'clones-desktop';

    if (Platform.isMacOS) {
      // Standard macOS app bundle: MyApp.app/Contents/Resources/agent/clones-desktop
      return '${execDir.parent.path}/Resources/agent/$agentName';
    } else if (Platform.isWindows) {
      // Standard Windows layout: MyApp/agent/clones-desktop.exe
      return '${execDir.path}/agent/$agentName';
    } else {
      // Linux: MyApp/agent/clones-desktop
      return '${execDir.path}/agent/$agentName';
    }
  }

  /// Check if development mode is enabled via environment
  bool _isDevelopmentMode() {
    // Enable dev mode if any of these env vars are set
    return Platform.environment['FLUTTER_DEV'] == 'true' ||
        Platform.environment['CLONES_DEV_MODE'] == 'true' ||
        kDebugMode; // Flutter debug mode
  }

  /// Find agent in development build locations
  Future<String?> _findDevelopmentAgentPath() async {
    final candidates = <String>[
      'src-tauri/target/release/clones_desktop${Platform.isWindows ? '.exe' : ''}',
      'src-tauri/target/debug/clones_desktop${Platform.isWindows ? '.exe' : ''}',
    ];

    for (final candidate in candidates) {
      final path = await _abspath(candidate);
      if (File(path).existsSync()) {
        return path;
      }
    }

    return null;
  }

  Future<String> _abspath(String relative) async {
    if (File(relative).isAbsolute) return relative;

    // For Flutter development, we need to resolve paths relative to the project root
    // not the app bundle location
    final repoRoot = await _findRepoRoot();
    if (repoRoot != null) {
      final fromRepo = File('$repoRoot/$relative').path;
      debugPrint(
        'Trying repo-relative path: $fromRepo (exists: ${File(fromRepo).existsSync()})',
      );
      if (File(fromRepo).existsSync()) return fromRepo;
    }

    // Try current working directory as fallback
    final fromCwd = File('${Directory.current.path}/$relative').path;
    debugPrint(
      'Trying cwd-relative path: $fromCwd (exists: ${File(fromCwd).existsSync()})',
    );
    if (File(fromCwd).existsSync()) return fromCwd;

    return fromCwd; // fallback
  }

  Future<String?> _findRepoRoot() async {
    // Thread-safe access to cached result
    return _repoRootLock.synchronized(() {
      if (_cachedRepoRoot != null) {
        return _cachedRepoRoot;
      }

      // First try from current working directory
      final current = Directory.current;
      debugPrint('Starting repo root search from current dir: ${current.path}');

      var foundRoot = _searchUpForRepoMarkers(current);
      if (foundRoot != null) {
        _cachedRepoRoot = foundRoot;
        return foundRoot;
      }

      // If not found from current dir, try from the executable's location
      // This handles cases where the app is launched from a different working directory
      if (!kIsWeb) {
        final executableDir = File(Platform.resolvedExecutable).parent;
        debugPrint(
          'Trying repo root search from executable dir: ${executableDir.path}',
        );
        foundRoot = _searchUpForRepoMarkers(executableDir);
        if (foundRoot != null) {
          _cachedRepoRoot = foundRoot;
          return foundRoot;
        }
      }

      debugPrint('No repo root found');
      return null;
    });
  }

  String? _searchUpForRepoMarkers(Directory startDir) {
    var current = startDir;

    // Search up the directory tree for project markers
    while (current.path != current.parent.path) {
      debugPrint('Checking directory: ${current.path}');

      // Check for Flutter project markers
      final hasPubspec = File('${current.path}/pubspec.yaml').existsSync();
      final hasTauri = Directory('${current.path}/src-tauri').existsSync();

      debugPrint('  pubspec.yaml: $hasPubspec, src-tauri/: $hasTauri');

      if (hasPubspec && hasTauri) {
        debugPrint('Found repo root: ${current.path}');
        return current.path;
      }
      current = current.parent;
    }

    return null;
  }

  /// Stops the Tauri agent process
  Future<void> stop() async {
    debugPrint('Stopping agent...');

    // Stop Flutter heartbeat writer (agent will detect and exit)
    await HeartbeatMonitor().stopFlutterHeartbeat();

    if (_agentProcess != null) {
      try {
        // Wait briefly for agent to detect heartbeat stop and exit gracefully
        try {
          final exitCode =
              await _agentProcess!.exitCode.timeout(const Duration(seconds: 8));
          debugPrint('Agent exited gracefully with code: $exitCode');
        } on TimeoutException {
          // If agent doesn't exit gracefully, force kill
          debugPrint('Agent timeout - force killing');
          await _killProcessCrossPlatform(_agentProcess!);

          try {
            final exitCode = await _agentProcess!.exitCode
                .timeout(const Duration(seconds: 2));
            debugPrint('Agent force killed with code: $exitCode');
          } on TimeoutException {
            debugPrint(
              'Agent unresponsive - using platform-specific force kill',
            );
            await _killProcessCrossPlatform(_agentProcess!, force: true);
          }
        }
      } catch (e) {
        debugPrint('Error stopping agent: $e');
        await _killProcessCrossPlatform(_agentProcess!, force: true);
      } finally {
        _agentProcess = null;
      }
    }
  }

  /// Validates that the agent process is in a healthy state
  Future<void> _validateProcessState() async {
    if (_agentProcess == null) {
      throw Exception('Agent process is null after startup');
    }

    // Check if process is still alive
    final exitCode = _agentProcess!.exitCode;
    final isAlive = await Future.any([
      exitCode.then((_) => false), // Process exited
      Future.delayed(
        const Duration(milliseconds: 100),
        () => true,
      ), // Still running
    ]);

    if (!isAlive) {
      final code = await exitCode;
      throw Exception('Agent process exited immediately with code: $code');
    }

    // Verify process has proper PID
    final pid = _agentProcess!.pid;
    if (pid <= 0) {
      throw Exception('Invalid process PID: $pid');
    }

    debugPrint('Agent process validation passed: PID $pid, still alive');
  }

  /// Check if process is still alive (non-blocking)
  Future<bool> _isProcessAlive(Process process) async {
    try {
      // Quick non-blocking check using exitCode future
      final exitCodeFuture = process.exitCode;
      final isStillRunning = await Future.any([
        exitCodeFuture.then((_) => false), // Process exited
        Future.delayed(
            const Duration(milliseconds: 1), () => true), // Still running
      ]);
      return isStillRunning;
    } catch (e) {
      // If any error, assume process is dead for safety
      debugPrint('Error checking process liveness: $e');
      return false;
    }
  }

  /// Cross-platform process killing with liveness check
  Future<void> _killProcessCrossPlatform(Process process,
      {bool force = false}) async {
    // Check if process is already dead
    if (!await _isProcessAlive(process)) {
      debugPrint('Process already dead - skipping kill attempt');
      return;
    }

    try {
      if (Platform.isWindows) {
        // Windows: kill() always terminates, no signals
        debugPrint('Killing process on Windows (PID: ${process.pid})');
        process.kill();
      } else {
        // Unix-like: use appropriate signal
        if (force) {
          debugPrint(
              'Force killing process with SIGKILL (PID: ${process.pid})');
          process.kill(ProcessSignal.sigkill);
        } else {
          debugPrint(
              'Gracefully terminating process with SIGTERM (PID: ${process.pid})');
          process.kill(); // Defaults to SIGTERM on Unix
        }
      }
    } catch (e) {
      debugPrint('Error killing process (PID: ${process.pid}): $e');

      // Only try fallback if process is still alive
      if (await _isProcessAlive(process)) {
        try {
          debugPrint('Attempting fallback kill...');
          process.kill();
        } catch (e2) {
          debugPrint('Fallback kill also failed: $e2');
        }
      } else {
        debugPrint('Process died during kill attempt - success');
      }
    }
  }
}
