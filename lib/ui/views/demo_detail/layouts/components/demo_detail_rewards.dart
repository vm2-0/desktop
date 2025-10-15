import 'package:clones_desktop/application/claim_reward_modal/provider.dart';
import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/submission/claim_authorization.dart';
import 'package:clones_desktop/domain/models/submission/grade_result.dart';
import 'package:clones_desktop/domain/models/submission/submission_status.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/design_widget/message_box/message_box.dart';
import 'package:clones_desktop/ui/components/wallet_not_connected.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:clones_desktop/utils/env.dart';
import 'package:clones_desktop/utils/format_address.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Check if the submission has already been claimed on-chain
/// Ignore CLAIMING_ markers (temporary locks)
bool _isAlreadyClaimed(SubmissionStatus submission) {
  final txHash = submission.onChainReward?.txHash;
  if (txHash == null || txHash.isEmpty) {
    return false;
  }
  // Ignore temporary CLAIMING_ markers
  return !txHash.startsWith('CLAIMING_');
}

class DemoDetailRewards extends ConsumerWidget {
  const DemoDetailRewards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected =
        ref.watch(sessionNotifierProvider.select((s) => s.isConnected));
    if (isConnected == false) {
      return const WalletNotConnected();
    }

    final recording = ref.watch(demoDetailNotifierProvider).recording;
    final submission = recording?.submission;
    final poolId = recording?.demonstration?.poolId;

    if (submission == null || poolId == null) {
      return const SizedBox.shrink();
    }

    final factoryAsync = ref.watch(getFactoryProvider(factoryId: poolId));

    return factoryAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          strokeWidth: 0.5,
        ),
      ),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      data: (factory) {
        final tokenSymbol = factory.token.symbol;

        final theme = Theme.of(context);
        final score =
            submission.gradeResult?.score ?? submission.clampedScore ?? 0;
        final maxReward = submission.maxReward ?? 0;
        final reward = submission.reward ?? 0;

        final feePercentage = submission.claimAuthorization?.feePercentage;
        final feeMultiplier =
            feePercentage != null ? feePercentage / 100.0 : null;
        final netMultiplier =
            feeMultiplier != null ? 1.0 - feeMultiplier : null;

        return Column(
          children: [
            CardWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rewards',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Reward:',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        '${reward.toStringAsFixed(4)} \$$tokenSymbol',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ClonesColors.getScoreColor(score),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  if (reward > 0)
                    if (feePercentage != null &&
                        feeMultiplier != null &&
                        netMultiplier != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Platform Fee (${feePercentage.toStringAsFixed(1)}%):',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            '${(reward * feeMultiplier).toStringAsFixed(4)} \$$tokenSymbol',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'You Receive:',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            '${(reward * netMultiplier).toStringAsFixed(4)} \$$tokenSymbol',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: ClonesColors.getScoreColor(score),
                            ),
                          ),
                        ],
                      ),
                    ] else
                      SizedBox(
                        width: double.infinity,
                        child: MessageBox(
                          messageBoxType: MessageBoxType.warning,
                          content: Text(
                            'Failed to calculate reward amounts. Platform fee information could not be retrieved from smart contract.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Max Reward:',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        '${maxReward.toStringAsFixed(4)} \$$tokenSymbol',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ClonesColors.getScoreColor(100),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  LinearProgressIndicator(
                    value: maxReward > 0 ? reward / maxReward : 0,
                    minHeight: 10,
                    color: ClonesColors.getScoreColor(score),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 20),
                  if (submission.gradeResult?.reasoningSystem != null &&
                      submission.gradeResult!.reasoningSystem.isNotEmpty &&
                      !_isAlreadyClaimed(submission))
                    SizedBox(
                      width: double.infinity,
                      child: MessageBox(
                        messageBoxType: MessageBoxType.info,
                        content: Text(
                          submission.gradeResult?.reasoningSystem ?? '',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  if (submission.claimAuthorization != null &&
                      !_isAlreadyClaimed(submission))
                    _buildClaimAuthorizationSection(
                      context,
                      ref,
                      submission.claimAuthorization!,
                      tokenSymbol,
                      reward,
                      submission
                          .id, // Pass submission ID for claim verification
                    ),
                  if (_isAlreadyClaimed(submission))
                    _buildClaimedSection(context, ref, submission, tokenSymbol),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildClaimAuthorizationSection(
    BuildContext context,
    WidgetRef ref,
    ClaimAuthorization claimAuth,
    String tokenSymbol,
    double rewardAmount,
    String? submissionId,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pool Address:',
              style: theme.textTheme.bodyMedium,
            ),
            InkWell(
              onTap: () async {
                try {
                  await ref.read(tauriApiClientProvider).openExternalUrl(
                        '${Env.baseScanBaseUrl}/address/${claimAuth.poolAddress}',
                      );
                } catch (e) {
                  debugPrint('Failed to open external URL: $e');
                }
              },
              child: Row(
                children: [
                  Text(
                    claimAuth.poolAddress.shortAddress(),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: ClonesColors.secondaryText,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.open_in_new,
                    color: ClonesColors.secondaryText,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: BtnPrimary(
            widthExpanded: true,
            btnPrimaryType: BtnPrimaryType.outlinePrimary,
            buttonText: 'Claim Reward',
            onTap: () => _handleClaimReward(
              context,
              ref,
              claimAuth,
              tokenSymbol,
              rewardAmount,
              submissionId,
            ),
          ),
        ),
      ],
    );
  }

  void _handleClaimReward(
    BuildContext context,
    WidgetRef ref,
    ClaimAuthorization claimAuth,
    String tokenSymbol,
    double rewardAmount,
    String? submissionId,
  ) {
    // Open the claim reward modal
    ref.read(claimRewardModalNotifierProvider.notifier).show(
          claimAuthorization: claimAuth,
          rewardAmount: rewardAmount,
          tokenSymbol: tokenSymbol,
          submissionId: submissionId,
        );
  }

  Widget _buildClaimedSection(
    BuildContext context,
    WidgetRef ref,
    SubmissionStatus submission,
    String tokenSymbol,
  ) {
    final theme = Theme.of(context);
    final txHash = submission.onChainReward?.txHash;
    final grossAmount =
        submission.onChainReward?.grossAmount ?? submission.reward ?? 0;

    final netAmount = submission.onChainReward?.netAmount;
    final feeAmount = submission.onChainReward?.feeAmount;
    final farmerReferrerAmount = submission.claimAuthorization?.referrals
        ?.firstWhereOrNull((r) => r.type == 'farmer_referrer')
        ?.amount;
    final factoryReferrerAmount = submission.claimAuthorization?.referrals
        ?.firstWhereOrNull((r) => r.type == 'factory_referrer')
        ?.amount;
    final farmerReferrerAddress = submission.claimAuthorization?.referrals
        ?.firstWhereOrNull((r) => r.type == 'farmer_referrer')
        ?.address;
    final factoryReferrerAddress = submission.claimAuthorization?.referrals
        ?.firstWhereOrNull((r) => r.type == 'factory_referrer')
        ?.address;

    return Column(
      children: [
        const SizedBox(height: 20),
        Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: MessageBox(
                messageBoxType: MessageBoxType.talkLeft,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reward Claimed',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: ClonesColors.highScore,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (netAmount != null && feeAmount != null) ...[
                      Text(
                        'Total Reward: ${grossAmount.toStringAsFixed(3)} \$$tokenSymbol',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        'Platform Fee: ${feeAmount.toStringAsFixed(3)} \$$tokenSymbol',
                        style: theme.textTheme.bodySmall,
                      ),
                      if (farmerReferrerAmount != null &&
                          farmerReferrerAddress != null)
                        Text(
                          'Farmer Referrer: ${farmerReferrerAmount.toStringAsFixed(3)} \$$tokenSymbol (${farmerReferrerAddress.shortAddress()})',
                          style: theme.textTheme.bodySmall,
                        ),
                      if (factoryReferrerAmount != null &&
                          factoryReferrerAddress != null)
                        Text(
                          'Factory Referrer: ${factoryReferrerAmount.toStringAsFixed(3)} \$$tokenSymbol (${factoryReferrerAddress.shortAddress()})',
                          style: theme.textTheme.bodySmall,
                        ),
                      Text(
                        'You Received: ${netAmount.toStringAsFixed(3)} \$$tokenSymbol',
                        style: theme.textTheme.bodySmall,
                      ),
                    ] else ...[
                      Text(
                        'You claimed ${grossAmount.toStringAsFixed(3)} \$$tokenSymbol',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        'Reward breakdown unavailable - claimed before fee tracking was implemented',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ClonesColors.secondaryText,
                        ),
                      ),
                    ],
                    if (txHash != null && txHash.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () async {
                          try {
                            await ref
                                .read(tauriApiClientProvider)
                                .openExternalUrl(
                                  '${Env.baseScanBaseUrl}/tx/$txHash',
                                );
                          } catch (e) {
                            debugPrint('Failed to open external URL: $e');
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              'Transaction: ${txHash.shortAddress()}',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                color: ClonesColors.secondaryText,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.open_in_new,
                              color: ClonesColors.secondaryText,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ClonesColors.rewardInfo.withValues(alpha: 0.3),
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
                  'On-Chain Stamp',
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: ClonesColors.rewardInfo,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
