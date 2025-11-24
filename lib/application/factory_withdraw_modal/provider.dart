import 'dart:async';
import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/application/factory_withdraw_modal/state.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/application/transaction/provider.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class FactoryWithdrawModalNotifier extends _$FactoryWithdrawModalNotifier {
  Timer? _debounceTimer;
  String? _currentEstimationRequest;

  @override
  FactoryWithdrawModalState build() {
    ref
      ..onDispose(() {
        _debounceTimer?.cancel();
      })

      // Listen to transaction state changes
      ..listen(transactionManagerProvider, (previous, next) {
        // Only react if modal is shown and we're withdrawing
        if (!state.isShown) return;

        // Close modal on successful transaction and refresh balance
        if (next.lastSuccessfulTx != null &&
            next.currentTransactionType == 'withdrawPool' &&
            previous?.lastSuccessfulTx != next.lastSuccessfulTx) {
          // Trigger balance refresh to update factory balance in UI
          try {
            ref.read(forgeDetailNotifierProvider.notifier).refreshBalance();
          } catch (e) {
            // Don't block modal closing if refresh fails
            debugPrint('Failed to refresh balance after withdrawing: $e');
          }
        }

        // Show error if transaction failed
        if (next.error != null &&
            next.currentTransactionType == 'withdrawPool' &&
            previous?.error != next.error) {
          state = state.copyWith(
            isWithdrawing: false,
            error: _formatTransactionError(next.error!),
          );
        }
      });

    return const FactoryWithdrawModalState();
  }

  Future<void> show(Factory factory) async {
    state = state.copyWith(
      factory: factory,
      isShown: true,
      withdrawAmount: '',
      error: null,
      estimatedGasCost: null,
      gasExceedsAmount: false,
      maxSafeWithdrawal: null,
      validationResult: null,
      poolHealth: null,
      validationLoading: true,
    );

    // Fetch max safe withdrawal and pool health on modal open
    try {
      final maxWithdrawal = await ref.read(
        getMaxWithdrawalProvider(poolAddress: factory.poolAddress ?? '').future,
      );

      final poolHealth = await ref.read(
        getPoolHealthProvider(poolAddress: factory.poolAddress ?? '').future,
      );

      state = state.copyWith(
        maxSafeWithdrawal: maxWithdrawal.maxSafeWithdrawal,
        poolHealth: poolHealth,
        validationLoading: false,
      );

      // Show warning if pool is unhealthy
      if (!poolHealth.healthy && poolHealth.alerts.isNotEmpty) {
        debugPrint('Pool health alerts: ${poolHealth.alerts.join(", ")}');
      }
    } catch (e) {
      debugPrint('Failed to fetch withdrawal validation data: $e');
      state = state.copyWith(validationLoading: false);
    }
  }

  void hide() {
    state = state.copyWith(
      isShown: false,
      maxSafeWithdrawal: null,
      validationResult: null,
      poolHealth: null,
    );
    ref.read(transactionManagerProvider.notifier).clearTransaction();
  }

  void setWithdrawAmount(String amount) {
    // Input validation
    if (amount.isNotEmpty) {
      final numAmount = double.tryParse(amount);
      if (numAmount == null || numAmount <= 0) {
        state = state.copyWith(
          withdrawAmount: amount,
          error: 'Please enter a valid amount greater than 0',
          estimatedGasCost: null,
          gasExceedsAmount: false,
        );
        return;
      }

      // Check if amount exceeds balance
      if (state.factory != null && numAmount > state.factory!.balance) {
        state = state.copyWith(
          withdrawAmount: amount,
          error: 'Amount exceeds available balance',
          estimatedGasCost: null,
          gasExceedsAmount: false,
        );
        return;
      }
    }

    state = state.copyWith(
      withdrawAmount: amount,
      error: null,
    );
    _updateGasEstimationDebounced();
  }

  void setMaxAmount() {
    if (state.factory != null) {
      setWithdrawAmount(state.factory!.balance.toString());
    }
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
    if (state.withdrawAmount.isEmpty || state.factory == null) {
      state = state.copyWith(
        estimatedGasCost: null,
        gasExceedsAmount: false,
      );
      return;
    }

    // Prevent concurrent requests
    final requestId = '${state.factory!.poolAddress}_${state.withdrawAmount}';
    if (_currentEstimationRequest == requestId) return;
    _currentEstimationRequest = requestId;

    try {
      final gasEstimation = await ref.read(
        estimateFactoryGasProvider(
          type: 'withdrawPool',
          amount: state.withdrawAmount,
          token: state.factory!.token?.symbol,
          creator: ref.read(sessionNotifierProvider).address,
          poolAddress: state.factory!.poolAddress ?? '',
        ).future,
      );

      // Check if request is still current
      if (_currentEstimationRequest != requestId) return;

      final totalCostEth =
          double.tryParse(gasEstimation['totalCost'] as String? ?? '0') ?? 0;
      final withdrawAmountNum = double.tryParse(state.withdrawAmount) ?? 0;
      final gasExceedsAmount = totalCostEth > (withdrawAmountNum * 0.1);

      state = state.copyWith(
        estimatedGasCost: '${gasEstimation['totalCost']} ETH',
        gasExceedsAmount: gasExceedsAmount,
      );
    } catch (e) {
      // Only update if request is still current
      if (_currentEstimationRequest == requestId) {
        state = state.copyWith(
          estimatedGasCost: null,
          gasExceedsAmount: false,
        );
      }
    } finally {
      if (_currentEstimationRequest == requestId) {
        _currentEstimationRequest = null;
      }
    }
  }

  Future<void> withdrawFromFactory() async {
    // Pre-validation
    if (state.factory == null) {
      setError('No factory selected');
      return;
    }

    if (state.withdrawAmount.isEmpty) {
      setError('Please enter a withdraw amount');
      return;
    }

    final numAmount = double.tryParse(state.withdrawAmount);
    if (numAmount == null || numAmount <= 0) {
      setError('Please enter a valid amount greater than 0');
      return;
    }

    if (numAmount > state.factory!.balance) {
      setError('Amount exceeds available balance');
      return;
    }

    final userAddress = ref.read(sessionNotifierProvider).address;
    if (userAddress == null) {
      setError('Wallet not connected. Please connect your wallet first.');
      return;
    }

    // Check if gas exceeds amount (prevent user from proceeding)
    if (state.gasExceedsAmount) {
      setError(
        'Gas cost exceeds withdraw value. Please increase withdraw amount.',
      );
      return;
    }

    // Prevent concurrent withdraw operations
    if (state.isWithdrawing) return;

    state = state.copyWith(isWithdrawing: true, error: null);

    try {
      final validation = await ref.read(
        validateWithdrawalProvider(
          poolAddress: state.factory!.poolAddress ?? '',
          amount: state.withdrawAmount,
        ).future,
      );

      // Store validation result
      state = state.copyWith(validationResult: validation);

      // Check if withdrawal is allowed by backend
      if (!validation.allowed) {
        state = state.copyWith(
          isWithdrawing: false,
          error:
              'Withdrawal not allowed: ${validation.reason ?? "Unknown reason"}',
        );
        return;
      }

      final transactionManager = ref.read(transactionManagerProvider.notifier);
      await transactionManager.withdrawPool(
        token: state.factory!.token?.symbol ?? '',
        amount: state.withdrawAmount,
        poolAddress: state.factory!.poolAddress ?? '',
        creator: userAddress,
      );

      // Transaction initiated successfully - modal should remain open
      // It will be closed by the transaction callback when completed
      state = state.copyWith(isWithdrawing: false);
    } catch (e) {
      // User-friendly error messages
      String errorMessage;
      debugPrint('error: $e');
      final errorString = e.toString().toLowerCase();

      // Check for backend validation errors first
      if (errorString.contains('withdrawal_locked') ||
          errorString.contains('withdrawallocked')) {
        errorMessage =
            'Withdrawal locked: Must wait 24h after last deposit for security';
      } else if (errorString.contains('insufficient funds for') ||
          errorString.contains('pending claim')) {
        errorMessage = 'Insufficient funds: $errorString';
      } else if (errorString.contains('only the pool creator can withdraw')) {
        errorMessage = 'Only the pool creator can withdraw funds';
      } else if (errorString.contains('insufficient funds')) {
        errorMessage = 'Insufficient ETH balance for gas fees';
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
        isWithdrawing: false,
        error: errorMessage,
      );
    }
  }

  String _formatTransactionError(String error) {
    final errorString = error.toLowerCase();

    // Parse custom Solidity errors first (most specific)
    if (error.contains('Unauthorized("creator")')) {
      return 'Unauthorized: Only the pool creator can withdraw funds';
    }
    if (error.contains('InvalidParameter("amount")')) {
      return 'Invalid amount: Please check your input';
    }
    if (error.contains('InvalidParameter("balance")')) {
      return 'Insufficient balance: Not enough funds to withdraw';
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
