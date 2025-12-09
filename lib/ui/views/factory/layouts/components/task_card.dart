import 'package:clones_desktop/application/coin_price.dart';
import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/application/feature_flags.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/domain/models/factory/workflow_task.dart';
import 'package:clones_desktop/ui/components/app_chip_widget.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/design_widget/text/app_text.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/referral_required_dialog.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/demo_detail_view.dart';
import 'package:clones_desktop/utils/format_num.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TaskCard extends ConsumerStatefulWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.currencyMode = 'crypto',
  });

  final WorkflowTask task;
  final String currencyMode;

  @override
  ConsumerState<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final currencyMode = widget.currencyMode;
    final theme = Theme.of(context);
    final factoryAsync = ref.watch(
      getFactoryProvider(factoryId: task.poolId!),
    );
    final factory = factoryAsync.valueOrNull;

    if (factory == null) {
      return const Padding(
        padding: EdgeInsets.all(10),
        child: SizedBox(height: 190),
      );
    }

    final tokenSymbol = factory.token?.symbol ?? '';

    final rewardAmount = task.rewardLimit?.toDouble() ?? 0.0;

    final String rewardText;
    if (currencyMode == 'fiat') {
      final priceUSD = ref.watch(coinPriceNotifierProvider(tokenSymbol));
      final usdAmount = rewardAmount * priceUSD;
      rewardText = '\$${usdAmount.toStringAsFixedLowValue(2, 5)}';
    } else {
      rewardText = '${rewardAmount.toStringAsFixedLowValue(2, 5)} $tokenSymbol';
    }

    Future<void> onTap(BuildContext context) async {
      // Check if farming is locked without referral code
      if (FeatureFlags.lockFarmingWithoutReferral) {
        final session = ref.read(sessionNotifierProvider);
        if (session.referrerCode == null || session.referrerCode!.isEmpty) {
          await ReferralRequiredDialog.show(context, ref);
          return;
        }
      }

      context.go(
        DemoDetailView.routeName,
        extra: {
          'prompt': task.prompt,
          'poolId': factory.id,
          'taskId': task.id,
        },
      );
    }

    final content = Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SelectionArea(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: task.appsUsed
                  .asMap()
                  .entries
                  .map(
                    (entry) => AppChipWidget(
                      appName: entry.value.name,
                      domain: entry.value.domain,
                      index: entry.key,
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          SelectionArea(
            child: Text(
              task.prompt,
              maxLines: 3,
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 8),
          _buildTaskContent(theme),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(10),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: _isExpanded ? null : 240,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: CardWidget(
                  padding: CardPadding.small,
                  variant: CardVariant.secondary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: SelectableText(
                                task.taskName,
                                style: theme.textTheme.titleSmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_isExpanded) content else Expanded(child: content),
                      if (task.uploadLimit != null &&
                          task.currentSubmissions != null &&
                          task.currentSubmissions! < task.uploadLimit!)
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            'Only ${task.uploadLimit! - task.currentSubmissions!} more - keep going!',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: ClonesColors.important,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (factory.status == FactoryStatus.archived)
                const BtnPrimary(
                  isLocked: true,
                  btnPrimaryType: BtnPrimaryType.outlinePrimary,
                  onTap: null,
                  buttonText: 'Archived',
                )
              else if (task.uploadLimit != null &&
                  task.currentSubmissions != null &&
                  task.currentSubmissions! >= task.uploadLimit!)
                const BtnPrimary(
                  isLocked: true,
                  btnPrimaryType: BtnPrimaryType.outlinePrimary,
                  onTap: null,
                  buttonText: 'All demos completed!',
                )
              else if (factory.balance >= rewardAmount)
                BtnPrimary(
                  onTap: () async => onTap(context),
                  buttonText: 'Start Training',
                  icon: Icons.play_arrow,
                  iconPosition: IconPosition.trailing,
                )
              else
                const BtnPrimary(
                  isLocked: true,
                  btnPrimaryType: BtnPrimaryType.outlinePrimary,
                  onTap: null,
                  buttonText: 'Insufficient funds',
                ),
              if (rewardAmount > 0) ...[
                Positioned(
                  top: 25,
                  right: 25,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: factory.balance >= rewardAmount
                          ? ClonesColors.rewardInfo.withValues(alpha: 0.3)
                          : ClonesColors.rewardInfo.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withAlpha(60),
                          blurRadius: 6,
                          offset: const Offset(
                            0,
                            3,
                          ),
                        ),
                      ],
                    ),
                    child: Text(
                      rewardText,
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: factory.balance >= rewardAmount
                            ? ClonesColors.rewardInfo
                            : Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskContent(ThemeData theme) {
    final task = widget.task;
    final hasObjectives =
        task.objectives != null && task.objectives!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show expand button if objectives exist
        if (hasObjectives) ...[
          Row(
            children: [
              _buildExpandButton(theme),
              if (_isExpanded) ...[
                const SizedBox(width: 8),
                _buildCopyButton(theme),
              ],
            ],
          ),
        ],

        // Show objectives when expanded
        if (_isExpanded && hasObjectives) ...[
          const SizedBox(height: 12),
          SelectionArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: task.objectives!.asMap().entries.map((entry) {
                final index = entry.key;
                final objective = entry.value;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < task.objectives!.length - 1 ? 6 : 0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 2, right: 8),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: ClonesColors.secondary.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: AppText(
                          text: objective,
                          style: theme.textTheme.bodySmall?.copyWith(
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildExpandButton(ThemeData theme) {
    final task = widget.task;
    final objectivesCount = task.objectives!.length;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: ClonesColors.secondary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ClonesColors.secondary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isExpanded
                    ? 'Hide objectives'
                    : 'Show $objectivesCount objective${objectivesCount > 1 ? 's' : ''}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: ClonesColors.secondary,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 4),
              AnimatedRotation(
                turns: _isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 14,
                  color: ClonesColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCopyButton(ThemeData theme) {
    final task = widget.task;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final objectives = task.objectives!.join('\n');
          await Clipboard.setData(ClipboardData(text: objectives));

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${task.objectives!.length} objectives copied to clipboard'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: ClonesColors.secondary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ClonesColors.secondary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.copy,
                size: 12,
                color: ClonesColors.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                'Copy all',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: ClonesColors.secondary,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
