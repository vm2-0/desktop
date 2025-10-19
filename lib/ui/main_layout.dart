import 'dart:async';

import 'package:clones_desktop/application/onboarding_provider.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/application/tools_provider.dart';
import 'package:clones_desktop/ui/components/layout_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Intent to open the Uploads modal via keyboard shortcut.
class OpenUploadsIntent extends Intent {
  const OpenUploadsIntent();
}

/// Intent to open the Wallet modal via keyboard shortcut.
class OpenWalletIntent extends Intent {
  const OpenWalletIntent();
}

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Delay tool initialization to ensure agent is fully ready
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _initializeTools();
      }
    });
    // Initialize onboarding after widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardingProvider);
    });
  }

  Future<void> _initializeTools() async {
    final tauriApiClient = ref.read(tauriApiClientProvider);
    const maxRetries = 10;
    const retryDelay = Duration(seconds: 2);

    // First check if agent is reachable
    try {
      await tauriApiClient.checkTools();
    } catch (e) {
      debugPrint('Agent not yet reachable, will retry tool initialization: $e');
    }

    for (var i = 0; i < maxRetries; i++) {
      try {
        await tauriApiClient.initTools();
        // If successful, start checking status and exit the loop
        await _checkToolsStatus();
        _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
          _checkToolsStatus();
        });
        return; // Exit the function on success
      } catch (e) {
        debugPrint('Failed to init tools (attempt ${i + 1}/$maxRetries): $e');
        if (i < maxRetries - 1) {
          await Future.delayed(retryDelay);
        } else {
          debugPrint('Could not initialize tools after $maxRetries attempts.');
          // TODO(reddwarf03): Handle the final failure (e.g., show an error message to the user)
        }
      }
    }
  }

  Future<void> _checkToolsStatus() async {
    try {
      final tauriApiClient = ref.read(tauriApiClientProvider);
      final status = await tauriApiClient.checkTools();

      const totalTools = 3;
      var initializedTools = 0;
      if (status['ffmpeg'] ?? false) initializedTools++;
      if (status['ffprobe'] ?? false) initializedTools++;
      if (status['cqa'] ?? false) initializedTools++;

      final progress = (initializedTools / totalTools) * 100;

      ref
          .read(toolsInitProvider.notifier)
          .setProgress(progress > 0 ? progress : 5.0);

      if (initializedTools == totalTools) {
        _timer?.cancel();
        _timer = null;

        ref.read(toolsInitProvider.notifier).setProgress(100);

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            ref.read(toolsInitProvider.notifier).setInitializing(false);
          }
        });
      } else {
        if (mounted) {
          ref.read(toolsInitProvider.notifier).setInitializing(true);
        }
      }
    } catch (error) {
      debugPrint('Failed to check tools status: $error');
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      canRequestFocus: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LayoutBackground(
          child: widget.child,
        ),
      ),
    );
  }
}
