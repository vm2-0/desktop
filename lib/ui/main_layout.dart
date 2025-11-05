import 'package:clones_desktop/application/onboarding_provider.dart';
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
    // Initialize onboarding after widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardingProvider);
    });
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
