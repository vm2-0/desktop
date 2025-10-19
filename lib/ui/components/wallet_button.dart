import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/application/upload_modal_provider.dart';
import 'package:clones_desktop/application/wallet_modal_provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletButton extends ConsumerStatefulWidget {
  const WalletButton({
    super.key,
  });

  @override
  ConsumerState<WalletButton> createState() => _WalletButtonState();
}

class _WalletButtonState extends ConsumerState<WalletButton> {
  Future<void> _handleConnect() async {
    await ref.read(sessionNotifierProvider.notifier).getConnectionUrl();
    final session = ref.read(sessionNotifierProvider);
    if (!mounted) return;

    try {
      if (!await launchUrl(
        Uri.parse(session.connectionUrl),
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Failed to launch URL: ${session.connectionUrl}');
      }
    } catch (e) {
      debugPrint('Failed to open external URL: $e');
    }
    await ref.read(sessionNotifierProvider.notifier).startPolling();
  }

  @override
  Widget build(BuildContext context) {
    final isConnected =
        ref.watch(sessionNotifierProvider.select((s) => s.isConnected));

    if (isConnected) {
      return InkWell(
        onTap: () {
          ref.read(uploadModalProvider.notifier).hide();
          ref.read(walletModalProvider.notifier).show();
        },
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                ClonesColors.primary.withValues(alpha: 0.5),
                ClonesColors.secondary.withValues(alpha: 0.9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: Image.asset(
            Assets.walletConnectedIcon,
            width: 50,
            height: 50,
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: _handleConnect,
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                ClonesColors.primary.withValues(alpha: 0.5),
                ClonesColors.secondary.withValues(alpha: 0.9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Image.asset(
                Assets.walletToConnectIcon,
                width: 50,
                height: 50,
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
