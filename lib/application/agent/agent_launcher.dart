import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:clones_desktop/application/agent/heartbeat_writer.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:process/process.dart';

class AgentLauncher {
  factory AgentLauncher() => _instance;
  AgentLauncher._internal();
  static final AgentLauncher _instance = AgentLauncher._internal();

  Process? _agentProcess;
  bool _starting = false;
  final ProcessManager _processManager = const LocalProcessManager();
  String? _cachedRepoRoot;

  // File permission bits: owner execute (0x40) is what we care about for the current user
  static const int _ownerExecutePermission = 0x40;

  /// Ensures the Tauri agent is running. If not, attempts to start it.
  Future<void> ensureStarted() async {
    if (kIsWeb) return;

    // Quick check if agent already running (e.g., launched via VSCode)
    if (await _isAgentAlive()) {
      developer.log(
        'Agent already running - no lifecycle monitoring',
        name: 'AgentLauncher',
      );
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
      if ((stat.mode & _ownerExecutePermission) == 0) {
        developer.log(
          'Making agent executable: $executable',
          name: 'AgentLauncher',
        );
        await Process.run('chmod', ['+x', executable]);
      }

      final flutterPid = pid;
      final env = <String, String>{
        'PRIMARY_LOGGER': 'true',
        'RUST_LOG': 'info',
        'FLUTTER_PARENT_PID': '$flutterPid',
      };

      developer.log('Starting Tauri agent: $executable', name: 'AgentLauncher');
      developer.log('Environment variables: $env', name: 'AgentLauncher');

      // Determine working directory:
      // 1. For development (repo root exists), use repo root
      // 2. For packaged Windows apps, use Flutter executable's directory (where clones.exe is)
      // 3. For packaged macOS apps, use repo root fallback (agent is in Resources/)
      final repoRoot = _findRepoRoot();
      String workingDir;
      if (repoRoot != null) {
        // Development mode - use repo root
        workingDir = repoRoot;
      } else if (Platform.isWindows) {
        // Packaged Windows app - use directory where clones.exe is located
        workingDir = File(Platform.resolvedExecutable).parent.path;
      } else {
        // Packaged macOS/Linux - use current directory as fallback
        workingDir = Directory.current.path;
      }

      developer.log(
        'Starting agent with process manager: $executable',
        name: 'AgentLauncher',
      );
      developer.log(
        'Working directory: $workingDir (repo root: ${repoRoot != null}, platform: ${Platform.operatingSystem})',
        name: 'AgentLauncher',
      );

      // On Windows in release mode, use normal mode (not detached) with hidden console
      // The console window fix in main.cpp prevents windows from appearing
      // On other platforms, use ProcessManager for better process management
      if (Platform.isWindows) {
        developer.log(
          'Using Process.start for Windows (normal mode with hidden console)',
          name: 'AgentLauncher',
        );
        _agentProcess = await Process.start(
          executable,
          [],
          workingDirectory: workingDir,
          environment: {
            ...Platform.environment, // Preserve existing environment
            ...env, // Add our custom variables
          },
          mode: ProcessStartMode.detached,
        );
      } else {
        // macOS/Linux: use ProcessManager
        try {
          _agentProcess = await _processManager.start(
            [executable],
            workingDirectory: workingDir,
            environment: env,
            mode: ProcessStartMode.detached,
          );
        } catch (e) {
          developer.log(
            'ProcessManager.start failed ($e), trying Process.start fallback',
            name: 'AgentLauncher',
          );
          _agentProcess = await Process.start(
            executable,
            [],
            workingDirectory: workingDir,
            environment: env,
            mode: ProcessStartMode.detached,
          );
        }
      }

      final agentPid = _agentProcess!.pid;
      developer.log(
        'Agent started with PID: $agentPid (standalone mode)',
        name: 'AgentLauncher',
      );

      // Capture agent output only in debug builds to avoid coupling I/O in release
      if (kDebugMode) {
        _agentProcess!.stdout.transform(systemEncoding.decoder).listen(
          (line) {
            developer.log('[Agent stdout] $line', name: 'AgentLauncher');
          },
          onError: (e) {
            developer.log('[Agent stdout error] $e', name: 'AgentLauncher');
          },
        );

        _agentProcess!.stderr.transform(systemEncoding.decoder).listen(
          (line) {
            developer.log('[Agent stderr] $line', name: 'AgentLauncher');
          },
          onError: (e) {
            developer.log('[Agent stderr error] $e', name: 'AgentLauncher');
          },
        );
      }

      await _waitUntilAlive(timeout: const Duration(seconds: 8));

      // Start heartbeat writing once agent is confirmed alive
      HeartbeatWriter().startHeartbeat();
      developer.log('Heartbeat writer started', name: 'AgentLauncher');
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
        developer.log('Agent health check: ✓ alive', name: 'AgentLauncher');
      }
      return isAlive;
    } catch (e) {
      developer.log(
        'Agent health check: ✗ not responding ($e)',
        name: 'AgentLauncher',
      );
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
    if (override != null && override.isNotEmpty) {
      final file = File(override);
      if (file.existsSync()) return file.path;
    }

    // 2) Packaged app layout next to the Flutter executable (PRIORITIZE PACKAGED)
    final execDir = File(Platform.resolvedExecutable).parent;
    final packagedCandidates = <String>[];
    if (Platform.isMacOS) {
      // MyApp.app/Contents/MacOS/MyApp
      packagedCandidates.addAll([
        execDir.parent.uri
            .resolve('Resources/agent/clones-desktop')
            .toFilePath(),
        execDir.uri.resolve('clones-desktop').toFilePath(),
      ]);
    } else if (Platform.isWindows) {
      packagedCandidates.addAll([
        execDir.uri.resolve('clones-desktop.exe').toFilePath(),
        execDir.uri.resolve('agent/clones-desktop.exe').toFilePath(),
      ]);
    }
    for (final path in packagedCandidates) {
      developer.log(
        'Checking packaged agent path: $path (exists: ${File(path).existsSync()})',
      );
      if (File(path).existsSync()) return path;
    }

    // 3) Development defaults within the repo (FALLBACK)
    final repoCandidates = <String>[];
    if (Platform.isMacOS) {
      repoCandidates.addAll([
        'src-tauri/target/release/clones_desktop',
        'src-tauri/target/debug/clones_desktop',
        'src-tauri/target/release/bundle/macos/clones-desktop.app/Contents/MacOS/clones-desktop',
        'src-tauri/target/debug/bundle/macos/clones-desktop.app/Contents/MacOS/clones-desktop',
      ]);
    } else if (Platform.isWindows) {
      repoCandidates.addAll([
        r'src-tauri/target\release\clones_desktop.exe',
        r'src-tauri/target\debug\clones_desktop.exe',
        r'src-tauri\target\release\bundle\msi\clones-desktop.exe',
      ]);
    }
    for (final rel in repoCandidates) {
      final path = _abspath(rel);
      developer.log(
        'Checking agent path: $path (exists: ${File(path).existsSync()})',
        name: 'AgentLauncher',
      );
      if (File(path).existsSync()) return path;
    }

    return null;
  }

  String _abspath(String relative) {
    if (File(relative).isAbsolute) return relative;

    // For Flutter development, we need to resolve paths relative to the project root
    // not the app bundle location
    final repoRoot = _findRepoRoot();
    if (repoRoot != null) {
      final fromRepo = File('$repoRoot/$relative').path;
      developer.log(
        'Trying repo-relative path: $fromRepo (exists: ${File(fromRepo).existsSync()})',
        name: 'AgentLauncher',
      );
      if (File(fromRepo).existsSync()) return fromRepo;
    }

    // Try current working directory as fallback
    final fromCwd = File('${Directory.current.path}/$relative').path;
    developer.log(
      'Trying cwd-relative path: $fromCwd (exists: ${File(fromCwd).existsSync()})',
      name: 'AgentLauncher',
    );
    if (File(fromCwd).existsSync()) return fromCwd;

    return fromCwd; // fallback
  }

  String? _findRepoRoot() {
    // Return cached result if available
    if (_cachedRepoRoot != null) {
      return _cachedRepoRoot;
    }

    // First try from current working directory
    final current = Directory.current;
    developer.log(
      'Starting repo root search from current dir: ${current.path}',
      name: 'AgentLauncher',
    );

    var foundRoot = _searchUpForRepoMarkers(current);
    if (foundRoot != null) {
      _cachedRepoRoot = foundRoot;
      return foundRoot;
    }

    // If not found from current dir, try from the executable's location
    // This handles cases where the app is launched from a different working directory
    if (!kIsWeb) {
      final executableDir = File(Platform.resolvedExecutable).parent;
      developer.log(
        'Trying repo root search from executable dir: ${executableDir.path}',
        name: 'AgentLauncher',
      );
      foundRoot = _searchUpForRepoMarkers(executableDir);
      if (foundRoot != null) {
        _cachedRepoRoot = foundRoot;
        return foundRoot;
      }
    }

    developer.log('No repo root found', name: 'AgentLauncher');
    return null;
  }

  String? _searchUpForRepoMarkers(Directory startDir) {
    var current = startDir;

    // Search up the directory tree for project markers
    while (current.path != current.parent.path) {
      developer.log(
        'Checking directory: ${current.path}',
        name: 'AgentLauncher',
      );

      // Check for Flutter project markers
      final hasPubspec = File('${current.path}/pubspec.yaml').existsSync();
      final hasTauri = Directory('${current.path}/src-tauri').existsSync();

      developer.log(
        '  pubspec.yaml: $hasPubspec, src-tauri/: $hasTauri',
        name: 'AgentLauncher',
      );

      if (hasPubspec && hasTauri) {
        developer.log(
          'Found repo root: ${current.path}',
          name: 'AgentLauncher',
        );
        return current.path;
      }
      current = current.parent;
    }

    return null;
  }

  /// Stops the Tauri agent process - simplified version
  Future<void> stop() async {
    developer.log(
      'Force stopping agent (no lifecycle monitoring)',
      name: 'AgentLauncher',
    );

    // Stop heartbeat writing
    HeartbeatWriter().stopHeartbeat();
    developer.log('Heartbeat writer stopped', name: 'AgentLauncher');

    if (_agentProcess != null) {
      try {
        // Immediate SIGKILL - no graceful shutdown attempts
        _agentProcess!.kill(ProcessSignal.sigkill);
        developer.log('Agent force killed with SIGKILL', name: 'AgentLauncher');
      } catch (e) {
        developer.log('Error force killing agent: $e', name: 'AgentLauncher');
      } finally {
        _agentProcess = null;
      }
    }
  }
}
