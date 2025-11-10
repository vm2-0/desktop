import 'dart:async';

import 'package:clones_desktop/application/claim_reward_modal/state.dart';
import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/application/transaction/provider.dart';
import 'package:clones_desktop/domain/models/submission/claim_authorization.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class ClaimRewardModalNotifier extends _$ClaimRewardModalNotifier {
  Timer? _debounceTimer;
  String? _currentEstimationRequest;

  @override
  ClaimRewardModalState build() {
    ref
      ..onDispose(() {
        _debounceTimer?.cancel();
      })

      // Listen to transaction state changes
      ..listen(transactionManagerProvider, (previous, next) {
        // Only react if modal is shown and we're claiming
        if (!state.isShown) return;

        // Close modal on successful transaction
        if (next.lastSuccessfulTx != null &&
            next.currentTransactionType == 'claimRewards' &&
            previous?.lastSuccessfulTx != next.lastSuccessfulTx) {
          hide();
        }
      });

    return const ClaimRewardModalState();
  }

  void show({
    required ClaimAuthorization claimAuthorization,
    required Decimal rewardAmount,
    required String tokenSymbol,
    String? submissionId,
  }) {
    state = state.copyWith(
      claimAuthorization: claimAuthorization,
      rewardAmount: rewardAmount,
      tokenSymbol: tokenSymbol,
      submissionId: submissionId,
      isShown: true,
      error: null,
      estimatedGasCost: null,
      gasExceedsReward: false,
    );

    // Start gas estimation
    _updateGasEstimation();
  }

  void hide() {
    state = state.copyWith(isShown: false);
  }

  void setError(String error) {
    state = state.copyWith(error: error);
  }

  Future<void> _updateGasEstimation() async {
    if (state.claimAuthorization == null) {
      state = state.copyWith(
        estimatedGasCost: null,
        gasExceedsReward: false,
      );
      return;
    }

    final userAddress = ref.read(sessionNotifierProvider).address;
    if (userAddress == null) {
      state = state.copyWith(
        estimatedGasCost: null,
        gasExceedsReward: false,
      );
      return;
    }

    // Prevent concurrent requests
    final requestId =
        '${state.claimAuthorization!.poolAddress}_${state.rewardAmount}';
    if (_currentEstimationRequest == requestId) return;
    _currentEstimationRequest = requestId;

    try {
      // Use dynamic gas estimation API like in factory generation
      final gasData = await ref.read(
        estimateFactoryGasProvider(
          type: 'claimRewards',
          poolAddress: state.claimAuthorization!.poolAddress,
          creator: userAddress,
          amount: state.rewardAmount.toString(),
        ).future,
      );

      final isExpensive = gasData['isExpensive'] as bool;
      final estimatedGas = '~${gasData['totalCost']} ETH';

      final feePercentage = state.claimAuthorization?.feePercentage;

      var gasExceedsReward = isExpensive;
      if (feePercentage != null) {
        final netMultiplier =
            Decimal.one - (feePercentage / Decimal.fromInt(100)).toDecimal();
        final netRewardAmount = state.rewardAmount! * netMultiplier;

        // Try to parse ETH cost for more precise comparison
        final ethCostStr = gasData['totalCost'].toString();
        final ethCost = double.tryParse(ethCostStr);
        if (ethCost != null) {
          // Compare ETH cost with USD reward amount (rough estimate)
          // This is a simplified comparison - ideally we'd convert to same currency
          gasExceedsReward = ethCost * 3000 >
              netRewardAmount.toDouble(); // Assuming ~$3000 per ETH
        }
      }

      state = state.copyWith(
        estimatedGasCost: estimatedGas,
        gasExceedsReward: gasExceedsReward,
      );
    } catch (e) {
      // Only update if request is still current
      if (_currentEstimationRequest == requestId) {
        state = state.copyWith(
          estimatedGasCost: 'Error estimating',
          gasExceedsReward: false,
        );
      }
    } finally {
      if (_currentEstimationRequest == requestId) {
        _currentEstimationRequest = null;
      }
    }
  }

  Future<void> claimReward() async {
    // Pre-validation
    if (state.claimAuthorization == null) {
      setError('No claim authorization available');
      return;
    }

    if (state.rewardAmount == null || state.rewardAmount! <= Decimal.zero) {
      setError('Invalid reward amount');
      return;
    }

    if (state.claimAuthorization?.feePercentage == null) {
      setError(
        'Failed to calculate reward amounts. Platform fee information could not be retrieved from smart contract.',
      );
      return;
    }

    final userAddress = ref.read(sessionNotifierProvider).address;
    if (userAddress == null) {
      setError('Wallet not connected. Please connect your wallet first.');
      return;
    }

    // Check if gas exceeds reward (prevent user from proceeding)
    if (state.gasExceedsReward) {
      setError(
        'Gas cost exceeds reward value. This claim is not economically viable.',
      );
      return;
    }

    // Prevent concurrent claim operations
    if (state.isClaiming) return;

    state = state.copyWith(isClaiming: true, error: null);

    final transactionManager = ref.read(transactionManagerProvider.notifier);
    await transactionManager.claimRewards(
      poolAddress: state.claimAuthorization!.poolAddress,
      amount: state.rewardAmount.toString(),
      creator: userAddress,
      submissionId:
          state.submissionId, // Pass submission ID for security verification
    );

    // Show error if transaction failed
    if (transactionManager.state.error != null) {
      state = state.copyWith(
        error: _formatTransactionError(transactionManager.state.error!),
      );
    }

    // Transaction initiated successfully - modal should remain open
    // It will be closed by the transaction callback when completed
    // Errors are handled by the listener watching transactionManagerProvider
    state = state.copyWith(isClaiming: false);
  }

  String _formatTransactionError(String error) {
    final errorString = error.toLowerCase();

    // Backend-specific errors from transaction.ts
    // Race condition protection (409 Conflict)
    if (errorString.contains('currently being claimed') ||
        errorString.contains('already being claimed')) {
      return 'This reward is currently being processed. Please wait a few moments and try again.';
    }

    // Already claimed on-chain (400 Bad Request)
    if (errorString.contains('already been claimed on-chain') ||
        errorString.contains('reward has already been claimed')) {
      return 'This reward has already been claimed. Please refresh the page.';
    }

    // Submission not found (404)
    if (errorString.contains('submission') &&
        errorString.contains('not found')) {
      return 'Submission not found. Please refresh and try again.';
    }

    // Not authorized (403)
    if (errorString.contains('does not belong to') ||
        errorString.contains('not authorized')) {
      return 'You are not authorized to claim this reward.';
    }

    // No claimable submission (404)
    if (errorString.contains('no claimable submission')) {
      return 'No claimable reward found. This reward may have already been claimed.';
    }

    // Custom Solidity errors (from smart contract)
    if (error.contains('InvalidSignature')) {
      return 'Invalid claim signature. Please refresh and try again.';
    }
    if (error.contains('ClaimAlreadyProcessed')) {
      return 'This claim has already been processed on-chain.';
    }
    if (error.contains('InsufficientBalance')) {
      return 'Pool has insufficient balance to process this claim.';
    }

    // Standard blockchain/network errors
    if (errorString.contains('insufficient funds')) {
      return 'Insufficient ETH for gas fees. Please add ETH to your wallet.';
    }

    if (errorString.contains('user denied') ||
        errorString.contains('rejected') ||
        errorString.contains('cancelled')) {
      return 'Transaction cancelled by user';
    }

    if (errorString.contains('revert')) {
      return 'Transaction rejected by smart contract. Please contact support.';
    }

    if (errorString.contains('network') || errorString.contains('socket')) {
      return 'Network error. Please check your connection and try again.';
    }

    if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    if (errorString.contains('gas')) {
      return 'Transaction failed due to gas issues. Try increasing gas limit.';
    }

    // Wallet connection errors
    if (errorString.contains('wallet') && errorString.contains('connection')) {
      return 'Wallet connection lost. Please reconnect your wallet.';
    }

    // If error message looks user-friendly (doesn't contain technical terms), return it as-is
    final technicalTerms = [
      'exception',
      'stacktrace',
      'undefined',
      'null',
      'error:',
      'exception:',
      'at ',
      'function',
    ];
    final containsTechnicalTerms = technicalTerms.any(errorString.contains);

    if (!containsTechnicalTerms && error.length < 150) {
      // Use the backend error message if it's concise and user-friendly
      return error;
    }

    // Generic fallback
    return 'Failed to claim reward. Please try again or contact support.';
  }
}
