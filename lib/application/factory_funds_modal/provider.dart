import 'dart:async';
import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/application/factory_funds_modal/state.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/application/transaction/provider.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class FactoryFundsModalNotifier extends _$FactoryFundsModalNotifier {
  Timer? _debounceTimer;
  String? _currentEstimationRequest;

  @override
  FactoryFundsModalState build() {
    ref
      ..onDispose(() {
        _debounceTimer?.cancel();
      })

      // Listen to transaction state changes
      ..listen(transactionManagerProvider, (previous, next) {
        // Only react if modal is shown and we're funding
        if (!state.isShown) return;

        // Close modal on successful transaction and refresh balance
        if (next.lastSuccessfulTx != null &&
            next.currentTransactionType == 'fundPool' &&
            previous?.lastSuccessfulTx != next.lastSuccessfulTx) {
          hide();

          // Trigger balance refresh to update factory balance in UI
          try {
            ref.read(forgeDetailNotifierProvider.notifier).refreshBalance();
          } catch (e) {
            // Don't block modal closing if refresh fails
            debugPrint('Failed to refresh balance after funding: $e');
          }
        }

        // Show error if transaction failed
        if (next.error != null &&
            next.currentTransactionType == 'fundPool' &&
            previous?.error != next.error) {
          state = state.copyWith(
            isFunding: false,
            error: _formatTransactionError(next.error!),
          );
        }
      });

    return const FactoryFundsModalState();
  }

  void show(Factory factory) {
    state = state.copyWith(
      factory: factory,
      isShown: true,
      fundingAmount: '',
      error: null,
      estimatedGasCost: null,
      gasExceedsReward: false,
    );
  }

  void hide() {
    state = state.copyWith(isShown: false);
  }

  void setFundingAmount(String amount) {
    // Input validation
    if (amount.isNotEmpty) {
      final numAmount = double.tryParse(amount);
      if (numAmount == null || numAmount <= 0) {
        state = state.copyWith(
          fundingAmount: amount,
          error: 'Please enter a valid amount greater than 0',
          estimatedGasCost: null,
          gasExceedsReward: false,
        );
        return;
      }
    }

    state = state.copyWith(
      fundingAmount: amount,
      error: null,
    );
    _updateGasEstimationDebounced();
  }

  void setError(String error) {
    state = state.copyWith(error: error);
  }

  void _updateGasEstimationDebounced() {
    _debounceTimer?.cancel();
    _debounceTimer =
        Timer(const Duration(milliseconds: 500), _updateGasEstimation);
  }

  Future<void> _updateGasEstimation() async {
    if (state.fundingAmount.isEmpty || state.factory == null) {
      state = state.copyWith(
        estimatedGasCost: null,
        gasExceedsReward: false,
      );
      return;
    }

    // Prevent concurrent requests
    final requestId = '${state.factory!.poolAddress}_${state.fundingAmount}';
    if (_currentEstimationRequest == requestId) return;
    _currentEstimationRequest = requestId;

    try {
      final gasEstimation = await ref.read(
        estimateFactoryGasProvider(
          type: 'fundPool',
          amount: state.fundingAmount,
          token: state.factory!.token?.symbol,
        ).future,
      );

      // Check if request is still current
      if (_currentEstimationRequest != requestId) return;

      final data = gasEstimation['data'] as Map<String, dynamic>?;
      final gasCostInUSD = data?['gasCostInUSD'] as double?;
      final fundingAmountNum = double.tryParse(state.fundingAmount) ?? 0;
      final gasExceedsReward = (gasCostInUSD ?? 0) > (fundingAmountNum * 0.9);

      state = state.copyWith(
        estimatedGasCost: data?['formatted'] as String?,
        gasExceedsReward: gasExceedsReward,
      );
    } catch (e) {
      // Only update if request is still current
      if (_currentEstimationRequest == requestId) {
        state = state.copyWith(
          estimatedGasCost: null,
          gasExceedsReward: false,
        );
      }
    } finally {
      if (_currentEstimationRequest == requestId) {
        _currentEstimationRequest = null;
      }
    }
  }

  Future<void> fundFactory() async {
    // Pre-validation
    if (state.factory == null) {
      setError('No factory selected');
      return;
    }

    if (state.fundingAmount.isEmpty) {
      setError('Please enter a funding amount');
      return;
    }

    final numAmount = double.tryParse(state.fundingAmount);
    if (numAmount == null || numAmount <= 0) {
      setError('Please enter a valid amount greater than 0');
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
        'Gas cost exceeds reward value. Please increase funding amount.',
      );
      return;
    }

    // Prevent concurrent funding operations
    if (state.isFunding) return;

    state = state.copyWith(isFunding: true, error: null);

    try {
      final transactionManager = ref.read(transactionManagerProvider.notifier);
      await transactionManager.fundPool(
        token: state.factory!.token?.symbol ?? '',
        amount: state.fundingAmount,
        poolAddress: state.factory!.poolAddress ?? '',
        creator: userAddress,
      );

      // Transaction initiated successfully - modal should remain open
      // It will be closed by the transaction callback when completed
      state = state.copyWith(isFunding: false);
    } catch (e) {
      // User-friendly error messages
      String errorMessage;
      debugPrint('error: $e');
      final errorString = e.toString().toLowerCase();

      if (errorString.contains('insufficient funds')) {
        errorMessage = 'Insufficient funds in your wallet';
      } else if (errorString.contains('user denied') ||
          errorString.contains('rejected')) {
        errorMessage = 'Transaction cancelled by user';
      } else if (errorString.contains('network')) {
        errorMessage = 'Network error. Please check your connection';
      } else if (errorString.contains('gas')) {
        errorMessage = 'Transaction failed due to gas issues';
      } else {
        errorMessage = 'Transaction failed. Please try again';
      }

      state = state.copyWith(
        isFunding: false,
        error: errorMessage,
      );
    }
  }

  String _formatTransactionError(String error) {
    final errorString = error.toLowerCase();

    // Parse custom Solidity errors first (most specific)
    if (error.contains('SecurityViolation("token_transfer")')) {
      return 'Token rejected: This token has fees on transfer and is not supported';
    }
    if (error.contains('SecurityViolation("permit")')) {
      return 'Permit signature failed: Please try again or use regular approval';
    }
    if (error.contains('InvalidParameter("')) {
      final match = RegExp(r'InvalidParameter\("([^"]+)"\)').firstMatch(error);
      final param = match?.group(1) ?? 'parameter';
      return 'Invalid $param: Please check your input';
    }
    if (error.contains('Unauthorized("')) {
      final match = RegExp(r'Unauthorized\("([^"]+)"\)').firstMatch(error);
      final role = match?.group(1) ?? 'permission';
      return 'Unauthorized: Missing $role permission';
    }
    if (error.contains('AlreadyExists("')) {
      final match = RegExp(r'AlreadyExists\("([^"]+)"\)').firstMatch(error);
      final resource = match?.group(1) ?? 'resource';
      return 'Already exists: $resource has already been created';
    }

    // Parse standard ERC20 errors
    if (errorString.contains('erc20: transfer amount exceeds balance')) {
      return 'Insufficient token balance in your wallet';
    }
    if (errorString.contains('erc20: transfer amount exceeds allowance') ||
        errorString.contains('erc20: insufficient allowance')) {
      return 'Token allowance too low: Please approve tokens first';
    }

    // Parse pause errors
    if (errorString.contains('pausable: paused')) {
      return 'Contract is currently paused for maintenance';
    }

    // Parse transaction-level errors
    if (errorString.contains('insufficient funds')) {
      return 'Insufficient ETH balance for gas fees';
    } else if (errorString.contains('user denied') ||
        errorString.contains('rejected')) {
      return 'Transaction cancelled by user';
    } else if (errorString.contains('revert')) {
      return 'Transaction rejected by smart contract';
    } else if (errorString.contains('network')) {
      return 'Network error. Please check your connection';
    } else if (errorString.contains('gas')) {
      return 'Transaction failed due to gas issues';
    } else {
      return 'Transaction failed. Please try again';
    }
  }
}
