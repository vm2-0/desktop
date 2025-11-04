import 'dart:async';

import 'package:clones_desktop/application/onboarding_provider.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/application/tool_status_modal_provider.dart';
import 'package:clones_desktop/application/tool_status_provider.dart';
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
    // Check if tools are already available
    final tauriApiClient = ref.read(tauriApiClientProvider);
    try {
      final status = await tauriApiClient.checkTools();
      final ffmpegReady = status['ffmpeg'] ?? false;
      final ffprobeReady = status['ffprobe'] ?? false;

      // If tools are not ready, show informative dialog for first-time users
      if (!ffmpegReady || !ffprobeReady) {
        if (mounted) {
          ref.watch(toolStatusNotifierProvider);
          _showToolInitializationDialog();
          final notifier = ref.read(toolStatusNotifierProvider.notifier);
          unawaited(notifier.initializeTools());
        }
      }
    } catch (e) {
      // Show modal and try initialization anyway
      if (mounted) {
        try {
          ref.watch(toolStatusNotifierProvider);
          _showToolInitializationDialog();
          unawaited(
            ref.read(toolStatusNotifierProvider.notifier).initializeTools(),
          );
        } catch (initError) {
          // Silent fail - user will see error in modal
        }
      }
    }
  }

  void _showToolInitializationDialog() {
    ref.read(toolStatusModalProvider.notifier).show();
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
