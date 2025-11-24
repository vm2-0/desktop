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
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/referral_required_dialog.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/demo_detail_view.dart';
import 'package:clones_desktop/utils/format_num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TaskCard extends ConsumerWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.currencyMode = 'crypto',
  });

  final WorkflowTask task;
  final String currencyMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final factory = ref
        .watch(
          getFactoryProvider(factoryId: task.poolId!),
        )
        .valueOrNull;

    if (factory == null) {
      return const SizedBox.shrink();
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

    return Container(
      height: 230,
      padding: const EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: CardWidget(
              padding: CardPadding.small,
              variant: CardVariant.secondary,
              child: InkWell(
                onTap: task.uploadLimit != null &&
                        task.currentSubmissions != null &&
                        task.currentSubmissions! >= task.uploadLimit!
                    ? null
                    : factory.balance >= rewardAmount
                        ? () async => onTap(context)
                        : null,
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
                            child: Text(
                              task.taskName,
                              style: theme.textTheme.titleSmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              task.prompt,
                              maxLines: 3,
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
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
                          ],
                        ),
                      ),
                    ),
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
    );
  }
}
