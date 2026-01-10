import 'dart:async';

import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/application/transaction/state.dart';
import 'package:clones_desktop/domain/models/api/api_error.dart';
import 'package:clones_desktop/domain/models/api/request_options.dart';
import 'package:clones_desktop/domain/models/factory/workflow_task.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/design_widget/dialog/popup_template.dart';
import 'package:clones_desktop/utils/api_client.dart';
import 'package:clones_desktop/utils/env.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'provider.g.dart';

@riverpod
class TransactionManager extends _$TransactionManager {
  Timer? _pollingTimer;

  @override
  TransactionState build() {
    ref.onDispose(() {
      _pollingTimer?.cancel();
    });
    return const TransactionState();
  }

  /// Create a new factory transaction workflow
  Future<void> createFactory({
    required String token,
    required String creator,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final apiClient = ref.read(apiClientProvider);

      // Get wallet connection token from session
      final session = ref.read(sessionNotifierProvider);
      final connectionToken = session.connectionToken;

      if (connectionToken == null) {
        throw Exception(
          'No wallet connection found. Please connect your wallet first.',
        );
      }

      // Prepare transaction via backend API and get session ID
      final response = await apiClient.post<Map<String, dynamic>>(
        '/transaction/prepare-tx',
        data: {
          'type': 'createFactory',
          'sessionToken': connectionToken,
          'creator': creator,
          'token': token,
        },
      );

      final sessionId = response['sessionId'] as String;

      // Generate website URL with session ID for transaction execution
      final url =
          '${Env.apiWebsiteUrl}/wallet/transaction?sessionId=$sessionId';

      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Failed to launch URL: $url');
      }

      // Start polling for transaction status
      _startTransactionPolling(sessionId);

      state = state.copyWith(
        isLoading: false,
        awaitingCallback: true,
        currentTransactionType: 'createFactory',
        currentSessionId: sessionId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create factory: $e',
      );
    }
  }

  Future<void> createDataset({
    required String datasetId,
    required String name,
    required String symbol,
    required int burnThresholdPercentage,
    required String creator,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final apiClient = ref.read(apiClientProvider);

      final session = ref.read(sessionNotifierProvider);
      final connectionToken = session.connectionToken;

      if (connectionToken == null) {
        throw Exception(
          'No wallet connection found. Please connect your wallet first.',
        );
      }

      final response = await apiClient.post<Map<String, dynamic>>(
        '/transaction/prepare-tx',
        data: {
          'type': 'createDataset',
          'sessionToken': connectionToken,
          'datasetId': datasetId,
          'creator': creator,
          'name': name,
          'symbol': symbol,
          'burnThresholdPercentage': burnThresholdPercentage,
        },
      );

      final sessionId = response['sessionId'] as String;

      // Generate website URL with session ID for transaction execution
      final url =
          '${Env.apiWebsiteUrl}/wallet/transaction?sessionId=$sessionId';

      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Failed to launch URL: $url');
      }

      // Start polling for transaction status
      _startTransactionPolling(sessionId);

      state = state.copyWith(
        isLoading: false,
        awaitingCallback: true,
        currentTransactionType: 'createDataset',
        currentSessionId: sessionId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create dataset: $e',
      );
    }
  }

  /// Create and fund a factory transaction workflow (atomic operation)
  Future<void> createAndFundPool({
    required String token,
    required String creator,
    required String amount,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final apiClient = ref.read(apiClientProvider);

      // Get wallet connection token from session
      final session = ref.read(sessionNotifierProvider);
      final connectionToken = session.connectionToken;

      if (connectionToken == null) {
        throw Exception(
          'No wallet connection found. Please connect your wallet first.',
        );
      }

      // Prepare transaction via backend API and get session ID
      final response = await apiClient.post<Map<String, dynamic>>(
        '/transaction/prepare-tx',
        data: {
          'type': 'createAndFundPool',
          'sessionToken': connectionToken,
          'creator': creator,
          'token': token,
          'amount': amount,
        },
      );

      final sessionId = response['sessionId'] as String;

      // Generate website URL with session ID for transaction execution
      final url =
          '${Env.apiWebsiteUrl}/wallet/transaction?sessionId=$sessionId';

      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Failed to launch URL: $url');
      }

      // Start polling for transaction status
      _startTransactionPolling(sessionId);

      state = state.copyWith(
        isLoading: false,
        awaitingCallback: true,
        currentTransactionType: 'createAndFundPool',
        currentSessionId: sessionId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create and fund factory: $e',
      );
    }
  }

  /// Fund a pool transaction workflow
  Future<void> fundPool({
    required String token,
    required String amount,
    required String poolAddress,
    required String creator,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final apiClient = ref.read(apiClientProvider);

      // Get wallet connection token from session
      final session = ref.read(sessionNotifierProvider);
      final connectionToken = session.connectionToken;

      if (connectionToken == null) {
        throw Exception(
          'No wallet connection found. Please connect your wallet first.',
        );
      }

      // Prepare transaction via backend API and get session ID
      final response = await apiClient.post<Map<String, dynamic>>(
        '/transaction/prepare-tx',
        data: {
          'type': 'fundPool',
          'sessionToken': connectionToken,
          'creator': creator,
          'token': token,
          'amount': amount,
          'poolAddress': poolAddress,
        },
      );

      final sessionId = response['sessionId'] as String;

      // Generate website URL with session ID for transaction execution
      final url =
          '${Env.apiWebsiteUrl}/wallet/transaction?sessionId=$sessionId';

      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Failed to launch URL: $url');
      }

      // Start polling for transaction status
      _startTransactionPolling(sessionId);

      state = state.copyWith(
        isLoading: false,
        awaitingCallback: true,
        currentTransactionType: 'fundPool',
        currentSessionId: sessionId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fund pool: $e',
      );
    }
  }

  /// Withdraw from pool transaction workflow
  Future<void> withdrawPool({
    required String token,
    required String amount,
    required String poolAddress,
    required String creator,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final apiClient = ref.read(apiClientProvider);

      // Get wallet connection token from session
      final session = ref.read(sessionNotifierProvider);
      final connectionToken = session.connectionToken;

      if (connectionToken == null) {
        throw Exception(
          'No wallet connection found. Please connect your wallet first.',
        );
      }

      // Prepare transaction via backend API and get session ID
      final response = await apiClient.post<Map<String, dynamic>>(
        '/transaction/prepare-tx',
        data: {
          'type': 'withdrawPool',
          'sessionToken': connectionToken,
          'creator': creator,
          'token': token,
          'amount': amount,
          'poolAddress': poolAddress,
        },
      );

      final sessionId = response['sessionId'] as String;

      // Generate website URL with session ID for transaction execution
      final url =
          '${Env.apiWebsiteUrl}/wallet/transaction?sessionId=$sessionId';

      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Failed to launch URL: $url');
      }

      // Start polling for transaction status
      _startTransactionPolling(sessionId);

      state = state.copyWith(
        isLoading: false,
        awaitingCallback: true,
        currentTransactionType: 'withdrawPool',
        currentSessionId: sessionId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to withdraw from pool: $e',
      );
    }
  }

  /// Claim rewards transaction workflow
  Future<void> claimRewards({
    required String poolAddress,
    required String amount,
    required String creator,
    String? submissionId,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final apiClient = ref.read(apiClientProvider);

      // Get wallet connection token from session
      final session = ref.read(sessionNotifierProvider);
      final connectionToken = session.connectionToken;

      if (connectionToken == null) {
        throw Exception(
          'No wallet connection found. Please connect your wallet first.',
        );
      }

      final response = await apiClient.post<Map<String, dynamic>>(
        '/transaction/prepare-tx',
        data: {
          'type': 'claimRewards',
          'sessionToken': connectionToken,
          'creator': creator,
          'poolAddress': poolAddress,
          'amount': amount,
          'submissionId': submissionId,
        },
      );

      final sessionId = response['sessionId'] as String;

      // Generate website URL with session ID for transaction execution
      final url =
          '${Env.apiWebsiteUrl}/wallet/transaction?sessionId=$sessionId';

      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Failed to launch URL: $url');
      }

      // Start polling for transaction status
      _startTransactionPolling(sessionId);

      state = state.copyWith(
        isLoading: false,
        awaitingCallback: true,
        currentTransactionType: 'claimRewards',
        currentSessionId: sessionId,
      );
    } catch (e) {
      String errorMessage;

      if (e is ApiError) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString();
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    }
  }

  /// Start polling for transaction status updates
  void _startTransactionPolling(String sessionId) {
    _pollingTimer?.cancel();

    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final apiClient = ref.read(apiClientProvider);
        final response = await apiClient.get<Map<String, dynamic>>(
          '/transaction/status',
          params: {'sessionId': sessionId},
        );

        final status = response['status'] as String;
        final txHash = response['txHash'] as String?;
        final error = response['error'] as String?;

        // Handle completed transactions
        if (status != 'pending') {
          timer.cancel();
          _pollingTimer = null;

          switch (status) {
            case 'completed':
              state = state.copyWith(
                awaitingCallback: false,
                lastSuccessfulTx: txHash,
              );
              break;
            case 'failed':
              state = state.copyWith(
                awaitingCallback: false,
                error: error ?? 'Transaction failed',
              );
              break;
            case 'cancelled':
              state = state.copyWith(
                awaitingCallback: false,
                wasCancelled: true,
              );
              break;
            default:
              debugPrint('[Transaction] Unknown status: $status');
              state = state.copyWith(
                awaitingCallback: false,
                error: 'Unknown transaction status: $status',
              );
          }
        }
      } catch (e) {
        debugPrint('[Transaction] Polling error: $e');
        // Continue polling on errors, don't cancel immediately
      }

      // Cancel after 10 minutes timeout (300 ticks * 2 seconds = 10 minutes)
      if (timer.tick > 300) {
        timer.cancel();
        _pollingTimer = null;
        if (state.awaitingCallback) {
          state = state.copyWith(
            awaitingCallback: false,
            error: 'Transaction timeout - no response received',
          );
        }
      }
    });
  }

  /// Clear current transaction and reset state
  void clearTransaction() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    state = const TransactionState();
  }

  /// Show transaction status dialog
  Future<void> showTransactionStatus(BuildContext context) async {
    if (state.lastSuccessfulTx != null) {
      await _showSuccessDialog(context, state.lastSuccessfulTx!);
    } else if (state.error != null) {
      await _showErrorDialog(context, state.error!);
    } else if (state.wasCancelled) {
      await _showCancelledDialog(context);
    }
  }

  Future<void> _showSuccessDialog(BuildContext context, String txHash) async {
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => PopupTemplate(
        popupTitle: 'Transaction Successful',
        popupContent: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your transaction has been confirmed on the blockchain.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            const Text(
              'Transaction Hash:',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Text(
                txHash,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () async {
                final url = '${Env.baseScanBaseUrl}/tx/$txHash';
                if (!await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                )) {
                  throw Exception('Failed to launch URL: $url');
                }
              },
              icon: const Icon(
                Icons.open_in_new,
                color: Color(0xFF8B5CF6),
                size: 16,
              ),
              label: const Text(
                'View on BaseScan',
                style: TextStyle(color: Color(0xFF8B5CF6)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BtnPrimary(
                  onTap: () {
                    Navigator.of(context).pop();
                    clearTransaction();
                  },
                  buttonText: 'Close',
                  btnPrimaryType: BtnPrimaryType.outlinePrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showErrorDialog(BuildContext context, String error) async {
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => PopupTemplate(
        popupTitle: 'Transaction Failed',
        popupContent: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              error,
              style: const TextStyle(color: Colors.white70),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BtnPrimary(
                  onTap: () {
                    Navigator.of(context).pop();
                    clearTransaction();
                  },
                  buttonText: 'Close',
                  btnPrimaryType: BtnPrimaryType.outlinePrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCancelledDialog(BuildContext context) async {
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => PopupTemplate(
        popupTitle: 'Transaction Cancelled',
        popupContent: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'The transaction was cancelled in the browser. No changes were made to the blockchain.',
              style: TextStyle(color: Colors.white70),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BtnPrimary(
                  onTap: () {
                    Navigator.of(context).pop();
                    clearTransaction();
                  },
                  buttonText: 'Close',
                  btnPrimaryType: BtnPrimaryType.outlinePrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Finalize factory creation by saving metadata to MongoDB
  Future<void> finalizeFactoryCreation({
    required String txHash,
    required String sessionId,
    required String factoryName,
    required String skills,
    required List<WorkflowTask> tasks,
    required String token,
    String? fundingAmount,
  }) async {
    final apiClient = ref.read(apiClientProvider);

    await apiClient.post<Map<String, dynamic>>(
      '/transaction/finalize-factory',
      data: {
        'txHash': txHash,
        'sessionId': sessionId,
        'metadata': {
          'name': factoryName,
          'skills': skills,
          'tasks': tasks.map((task) => task.toJson()).toList(),
          'token': token,
          'fundingAmount': fundingAmount,
        },
      },
      options: const RequestOptions(requiresAuth: true),
    );
  }

  /// Stop polling for current transaction
  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }
}
