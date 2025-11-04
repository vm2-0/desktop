import 'dart:ui';

import 'package:clones_desktop/application/tool_status_modal_provider.dart';
import 'package:clones_desktop/application/tool_status_provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/tool_status/tool_status.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToolStatusModal extends ConsumerStatefulWidget {
  const ToolStatusModal({super.key});

  @override
  ConsumerState<ToolStatusModal> createState() => _ToolStatusModalState();
}

class _ToolStatusModalState extends ConsumerState<ToolStatusModal> {
  @override
  Widget build(BuildContext context) {
    final toolStatus = ref.watch(toolStatusNotifierProvider);
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ),
        Center(
          child: CardWidget(
            padding: CardPadding.large,
            child: SizedBox(
              width: mediaQuery.size.width * 0.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'First-time Setup',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Clones Desktop is downloading required tools for screen recording.',
                    style: ClonesFonts.getPrimaryFont(
                      fontSize: 14,
                      color: ClonesColors.secondaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _buildStatusContent(context, toolStatus),
                  const SizedBox(height: 24),
                  _buildActionButtons(toolStatus),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusContent(BuildContext context, ToolStatus toolStatus) {
    final theme = Theme.of(context);
    return toolStatus.status.when(
      idle: () => Text(
        'Preparing to download tools...',
        style: theme.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      starting: () => Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Starting download...',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      downloading: () => Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            toolStatus.message,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: toolStatus.progress / 100.0,
            backgroundColor: ClonesColors.secondary.withValues(alpha: 0.3),
            valueColor:
                const AlwaysStoppedAnimation<Color>(ClonesColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            '${toolStatus.progress}%',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
      completed: () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            'Setup complete!',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      error: () => Column(
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Setup failed. Please check your internet connection and try again.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            toolStatus.message,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ToolStatus toolStatus) {
    return toolStatus.status.when(
      idle: () => const SizedBox.shrink(),
      starting: () => const SizedBox.shrink(),
      downloading: () => const SizedBox.shrink(),
      completed: () => BtnPrimary(
        buttonText: 'Close',
        onTap: () {
          ref.read(toolStatusModalProvider.notifier).hide();
        },
      ),
      error: () => Row(
        children: [
          Expanded(
            child: BtnPrimary(
              buttonText: 'Retry',
              onTap: () {
                ref.read(toolStatusNotifierProvider.notifier).initializeTools();
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: BtnPrimary(
              buttonText: 'Cancel',
              btnPrimaryType: BtnPrimaryType.outlinePrimary,
              onTap: () {
                ref.read(toolStatusModalProvider.notifier).hide();
              },
            ),
          ),
        ],
      ),
    );
  }
}
