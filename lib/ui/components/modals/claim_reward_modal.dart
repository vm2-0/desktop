import 'dart:ui';
import 'package:clones_desktop/application/claim_reward_modal/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/usd_price.dart';
import 'package:clones_desktop/utils/format_num.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClaimRewardModal extends ConsumerWidget {
  const ClaimRewardModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final modalState = ref.watch(claimRewardModalNotifierProvider);
    final claimAuth = modalState.claimAuthorization;

    if (claimAuth == null) {
      return const SizedBox.shrink();
    }

    final feePercentage = claimAuth.feePercentage;
    final feeMultiplier = feePercentage != null
        ? (feePercentage / Decimal.fromInt(100)).toDecimal()
        : null;
    final netMultiplier =
        feeMultiplier != null ? Decimal.one - feeMultiplier : null;

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
              width: mediaQuery.size.width * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Claim Reward',
                        style: theme.textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(claimRewardModalNotifierProvider.notifier)
                              .hide();
                        },
                        icon: Icon(
                          Icons.close,
                          color: ClonesColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Reward Info
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                          gradient: ClonesColors.gradientInputFormBackground,
                        ),
                        child: Column(
                          children: [
                            if (feePercentage != null &&
                                feeMultiplier != null &&
                                netMultiplier != null) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Reward:',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${formatNumberWithSeparator(modalState.rewardAmount?.toDouble() ?? 0.0)} ${modalState.tokenSymbol}',
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      UsdPrice(
                                        amount: modalState.rewardAmount ??
                                            Decimal.zero,
                                        symbol: modalState.tokenSymbol ?? '',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Platform Fee (${feePercentage.toStringAsFixed(1)}%):',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: ClonesColors.secondaryText,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${formatNumberWithSeparator((modalState.rewardAmount! * feeMultiplier).toDouble())} ${modalState.tokenSymbol}',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: ClonesColors.secondaryText,
                                        ),
                                      ),
                                      UsdPrice(
                                        amount: modalState.rewardAmount! *
                                            feeMultiplier,
                                        symbol: modalState.tokenSymbol ?? '',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'You Receive:',
                                    style:
                                        theme.textTheme.bodyMedium?.copyWith(),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${formatNumberWithSeparator((modalState.rewardAmount! * netMultiplier).toDouble())} ${modalState.tokenSymbol}',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color:
                                              ClonesColors.getScoreColor(100),
                                        ),
                                      ),
                                      UsdPrice(
                                        amount: modalState.rewardAmount! *
                                            netMultiplier,
                                        symbol: modalState.tokenSymbol ?? '',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color:
                                              ClonesColors.getScoreColor(100),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ] else ...[
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Failed to calculate reward amounts. Platform fee information could not be retrieved from smart contract.',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Info Text
                      Text(
                        'Claim Your Reward',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This will open your browser to complete the transaction. You will need to sign with your wallet to claim the reward.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color!
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      _buildGasInfo(context, ref),
                      _buildErrorMessage(context, ref),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BtnPrimary(
                            buttonText: 'Cancel',
                            onTap: () {
                              ref
                                  .read(
                                    claimRewardModalNotifierProvider.notifier,
                                  )
                                  .hide();
                            },
                            btnPrimaryType: BtnPrimaryType.outlinePrimary,
                          ),
                          const SizedBox(width: 10),
                          BtnPrimary(
                            buttonText: 'Claim Reward',
                            isLoading: modalState.isClaiming,
                            isLocked: modalState.gasExceedsReward ||
                                modalState.error != null ||
                                feePercentage == null,
                            onTap: () {
                              ref
                                  .read(
                                    claimRewardModalNotifierProvider.notifier,
                                  )
                                  .claimReward();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGasInfo(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final modalState = ref.watch(claimRewardModalNotifierProvider);

    if (modalState.estimatedGasCost == null && !modalState.gasExceedsReward) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        if (modalState.estimatedGasCost != null) ...[
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              Text(
                'Estimated gas: ${modalState.estimatedGasCost}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
        if (modalState.gasExceedsReward) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Gas cost exceeds reward value. This claim is not economically viable.',
                    style:
                        theme.textTheme.bodySmall?.copyWith(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorMessage(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final modalState = ref.watch(claimRewardModalNotifierProvider);

    if (modalState.error == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  modalState.error!,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
