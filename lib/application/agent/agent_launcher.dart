import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AgentLauncher {
  factory AgentLauncher() => _instance;
  AgentLauncher._internal();
  static final AgentLauncher _instance = AgentLauncher._internal();

  Process? _agentProcess; // Keep reference to kill on exit
  bool _starting = false;
  String? _authToken;
  ServerSocket? _lifelineServer;
  Socket? _lifelineAcceptedSocket;

  /// Ensures the Tauri agent is running. If not, attempts to start it.
  Future<void> ensureStarted() async {
    if (kIsWeb) return;

    // Brief pre-wait to avoid race with compound launch (Flutter + Tauri started separately)
    // If another process already started the agent, this prevents a bind race on port 19847.
    for (var i = 0; i < 5; i++) {
      if (await _isAgentAlive()) return;
      await Future.delayed(const Duration(milliseconds: 120));
    }

    // Check if agent is already running (e.g., launched manually in dev mode)
    if (await _isAgentAlive()) {
      debugPrint('Agent already running, skipping launch');
      return;
    }

    if (_starting) return;

    _starting = true;
    try {
      final executable = await _resolveAgentExecutablePath();
      if (executable == null) {
        throw Exception('Tauri agent executable not found');
      }

      // Generate ephemeral auth token for this session
      _authToken = _generateToken();

      // Create lifeline server socket before launching the agent
      // Agent will connect to this port; when Flutter dies, socket closes => agent exits
      final lifelineServer =
          await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      _lifelineServer = lifelineServer;

      final env = <String, String>{
        'PRIMARY_LOGGER': 'true',
        'RUST_LOG': 'info',
        'AGENT_LIFELINE_PORT': lifelineServer.port.toString(),
        'AGENT_PARENT_PID': pid.toString(),
        // Don't pass AGENT_AUTH_TOKEN for now - causes issues
      };

      debugPrint('Starting Tauri agent: $executable');
      debugPrint('Working directory: ${Directory(executable).parent.path}');
      debugPrint('Environment variables: $env');

      // Start in normal mode to avoid macOS EPERM restrictions.
      // Use repo root as working directory instead of executable directory
      final repoRoot = _findRepoRoot();
      final workingDir = repoRoot ?? Directory.current.path;

      debugPrint('Using working directory: $workingDir');

      // Prefer direct launch with lifeline; keep supervisor only as optional fallback
      _agentProcess = await Process.start(
        executable,
        const <String>[],
        workingDirectory: workingDir,
        environment: env,
      );

      // Properly drain streams to prevent blocking the child process.
      // Don't await - keep pipes drained in background.
      _agentProcess!.stdout.listen((_) {}, onError: (_) {});
      _agentProcess!.stderr.listen((_) {}, onError: (_) {});

      // Accept a single lifeline connection from the agent and keep it open
      // Do not await: keep the accepted socket stored to prevent GC/close
      unawaited(
        _lifelineServer!.first.then((client) {
          _lifelineAcceptedSocket = client;
          debugPrint(
            'Agent lifeline connected from ${client.remoteAddress.address}:${client.remotePort}',
          );
        }).catchError((e) {
          debugPrint('Lifeline accept error: $e');
        }),
      );

      // Wait for readiness by polling the health endpoint.
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
      debugPrint(
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
      debugPrint(
        'Checking agent path: $path (exists: ${File(path).existsSync()})',
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

  String? _findRepoRoot() {
    // First try from current working directory
    final current = Directory.current;
    debugPrint('Starting repo root search from current dir: ${current.path}');

    var foundRoot = _searchUpForRepoMarkers(current);
    if (foundRoot != null) return foundRoot;

    // If not found from current dir, try from the executable's location
    // This handles cases where the app is launched from a different working directory
    if (!kIsWeb) {
      final executableDir = File(Platform.resolvedExecutable).parent;
      debugPrint(
        'Trying repo root search from executable dir: ${executableDir.path}',
      );
      foundRoot = _searchUpForRepoMarkers(executableDir);
      if (foundRoot != null) return foundRoot;
    }

    debugPrint('No repo root found');
    return null;
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

  String _generateToken() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  String? get authToken => _authToken;

  // Supervisor script path lookup removed; lifeline TCP replaces it.

  /// Stops the Tauri agent process if it was started by this launcher
  Future<void> stop() async {
    if (_agentProcess != null) {
      debugPrint('Stopping Tauri agent...');

      try {
        // 1) Close lifeline sockets to signal agent to exit and cleanup FFmpeg
        try {
          await _lifelineAcceptedSocket?.close();
        } catch (_) {}
        _lifelineAcceptedSocket = null;
        try {
          await _lifelineServer?.close();
        } catch (_) {}
        _lifelineServer = null;

        // 2) Wait a bit for agent to exit by itself
        try {
          final exitCode =
              await _agentProcess!.exitCode.timeout(const Duration(seconds: 5));
          debugPrint('Agent stopped via lifeline with exit code: $exitCode');
        } on TimeoutException {
          // 3) Fallback: terminate, then force kill if needed
          debugPrint(
            'Agent did not exit after lifeline close - sending terminate',
          );
          _agentProcess!.kill();
          try {
            final exitCode = await _agentProcess!.exitCode
                .timeout(const Duration(seconds: 2));
            debugPrint(
              'Agent stopped after terminate with exit code: $exitCode',
            );
          } on TimeoutException {
            debugPrint('Terminate timeout - force killing agent');
            _agentProcess!.kill(ProcessSignal.sigkill);
          }
        }
      } catch (e) {
        // If graceful termination fails, force kill
        debugPrint('Graceful shutdown failed, force killing agent: $e');
        _agentProcess!.kill(ProcessSignal.sigkill);
      } finally {
        _agentProcess = null;
        _authToken = null;
      }
    }
  }
}
