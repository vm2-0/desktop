import 'package:clones_desktop/application/apps.dart';
import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/application/transaction/provider.dart';
import 'package:clones_desktop/domain/models/factory/factory_app.dart';
import 'package:clones_desktop/domain/models/factory/factory_task.dart';
import 'package:clones_desktop/ui/views/generate_factory/bloc/setters.dart';
import 'package:clones_desktop/ui/views/generate_factory/bloc/state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class GenerateFactoryNotifier extends _$GenerateFactoryNotifier
    with GenerateFactorySetters {
  GenerateFactoryNotifier();

  @override
  GenerateFactoryState build() {
    ref.onDispose(() {
      // Clear transaction state when provider is disposed
      ref.read(transactionManagerProvider.notifier).clearTransaction();
    });
    // Reset state when provider is built (fresh start)
    return const GenerateFactoryState();
  }

  Future<void> validateAndStartGeneration() async {
    // Validate balance before proceeding
    if (state.fundingAmount != null && state.fundingAmount!.isNotEmpty) {
      final creatorAddress = ref.read(sessionNotifierProvider).address;
      if (creatorAddress == null) {
        setError('User is not authenticated');
        return;
      }

      try {
        // Check balance for funding amount
        final tokenSymbol = state.selectedTokenSymbol;
        if (tokenSymbol != null) {
          final fundingAmountDouble = double.tryParse(state.fundingAmount!);
          if (fundingAmountDouble == null || fundingAmountDouble <= 0) {
            setError('Please enter a valid funding amount greater than 0');
            return;
          }

          // Check user balance via API
          try {
            final balance = await ref.read(
              getTokenBalanceProvider(
                creatorAddress,
                tokenSymbol,
              ).future,
            );

            if (balance < fundingAmountDouble) {
              setError(
                'Insufficient $tokenSymbol balance. You have $balance but need $fundingAmountDouble',
              );
              return;
            }
          } catch (e) {
            setError('Error checking balance: $e');
            return;
          }
        }
      } catch (e) {
        setError('Error validating balance: $e');
        return;
      }
    }

    // Proceed with generation if validation passes
    await startGeneration();
  }

  Future<void> startGeneration() async {
    if (state.skills?.trim().isEmpty ?? true) return;

    // Check if there are any validation errors
    if (state.error != null) {
      return;
    }

    state = state.copyWith(currentStep: GenerateFactoryStep.generating);
    try {
      final result = await ref.read(
        generateAppsProvider(prompt: state.skills!.trim()).future,
      );
      final forgeApps = (result['content']['apps'] as List)
          .map((app) => FactoryApp.fromJson(app))
          .toList();

      setFactoryName(result['content']['name'] ?? 'Desktop Agent Factory');
      setApps(forgeApps);
      setCurrentStep(GenerateFactoryStep.preview);
    } catch (e) {
      setError(e.toString());
      setCurrentStep(GenerateFactoryStep.input);
    }
  }

  void updateAppName(int appIndex, String value) {
    if (state.apps == null) return;

    // Validate app name length (500 characters max)
    if (value.length > 500) {
      setError('App name is too long (${value.length}/500 characters max)');
      return;
    } else {
      // Clear error if it was about app name length
      if (state.error != null &&
          state.error!.contains('App name is too long')) {
        setError('');
      }
    }

    final newApps = List<FactoryApp>.from(state.apps!);
    newApps[appIndex] = newApps[appIndex].copyWith(name: value);
    setApps(newApps);
  }

  void updateTaskPrompt(int appIndex, int taskIndex, String value) {
    if (state.apps == null) return;

    // Validate prompt length (500 characters max like skills)
    if (value.length > 500) {
      setError('Task prompt is too long (${value.length}/500 characters max)');
      return;
    } else {
      // Clear error if it was about prompt length
      if (state.error != null &&
          state.error!.contains('Task prompt is too long')) {
        setError('');
      }
    }

    final newApps = List<FactoryApp>.from(state.apps!);
    final appToUpdate = newApps[appIndex];
    final newTasks = List.from(appToUpdate.tasks);
    newTasks[taskIndex] = newTasks[taskIndex].copyWith(prompt: value);
    newApps[appIndex] = appToUpdate.copyWith(tasks: newTasks.cast());
    setApps(newApps);
  }

  void updateTaskWithLimits(
    int appIndex, 
    int taskIndex, 
    String prompt,
    double? rewardLimit,
    int? uploadLimit,
  ) {
    if (state.apps == null) return;

    // Validate prompt length (500 characters max like skills)
    if (prompt.length > 500) {
      setError('Task prompt is too long (${prompt.length}/500 characters max)');
      return;
    } else {
      // Clear error if it was about prompt length
      if (state.error != null &&
          state.error!.contains('Task prompt is too long')) {
        setError('');
      }
    }

    final newApps = List<FactoryApp>.from(state.apps!);
    final appToUpdate = newApps[appIndex];
    final newTasks = List.from(appToUpdate.tasks);
    newTasks[taskIndex] = newTasks[taskIndex].copyWith(
      prompt: prompt,
      rewardLimit: rewardLimit,
      uploadLimit: uploadLimit,
    );
    newApps[appIndex] = appToUpdate.copyWith(tasks: newTasks.cast());
    setApps(newApps);
  }

  void addTask(int appIndex) {
    if (state.apps == null) return;

    final newApps = List<FactoryApp>.from(state.apps!);
    final appToUpdate = newApps[appIndex];
    final newTasks = List.from(appToUpdate.tasks)

      // Add a new empty task
      ..add(
        const FactoryTask(
          prompt: '',
        ),
      );

    newApps[appIndex] = appToUpdate.copyWith(tasks: newTasks.cast());
    setApps(newApps);
  }

  void removeTask(int appIndex, int taskIndex) {
    if (state.apps == null) return;

    final newApps = List<FactoryApp>.from(state.apps!);
    final appToUpdate = newApps[appIndex];
    final newTasks = List.from(appToUpdate.tasks);

    if (taskIndex >= 0 && taskIndex < newTasks.length) {
      newTasks.removeAt(taskIndex);
      newApps[appIndex] = appToUpdate.copyWith(tasks: newTasks.cast());
      setApps(newApps);
    }
  }

  void addApp() {
    final newApps = List<FactoryApp>.from(state.apps ?? [])

      // Add a new empty app with one empty task
      ..add(
        const FactoryApp(
          name: '',
          domain: '',
          description: '',
          tasks: [
            FactoryTask(prompt: ''),
          ],
        ),
      );

    setApps(newApps);
  }

  void removeApp(int appIndex) {
    if (state.apps == null) return;

    final newApps = List<FactoryApp>.from(state.apps!);

    if (appIndex >= 0 && appIndex < newApps.length) {
      newApps.removeAt(appIndex);
      setApps(newApps);
    }
  }

  void setSelectedTokenWithPrediction(String tokenSymbol) {
    setSelectedToken(tokenSymbol);
    _predictPoolAddress();
  }

  Future<void> fetchSupportedTokens() async {
    try {
      final tokens = await ref.read(getSupportedTokensProvider.future);
      // Preserve previously selected token if it exists and is valid
      var selectedToken = state.selectedTokenSymbol;
      if (selectedToken == null ||
          !tokens.any((t) => t.symbol == selectedToken)) {
        selectedToken = tokens.isNotEmpty ? tokens.first.symbol : null;
      }

      state = state.copyWith(
        supportedTokens: tokens,
        selectedTokenSymbol: selectedToken,
      );
      // Predict pool address when token is selected
      if (selectedToken != null) {
        await _predictPoolAddress();
      }
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> _predictPoolAddress() async {
    final creatorAddress = ref.read(sessionNotifierProvider).address;
    if (creatorAddress == null || state.selectedTokenSymbol == null) return;

    try {
      // Backend knows token addresses, we just pass the symbol
      // The backend will do: symbol → address → CREATE2 prediction
      final prediction = await ref.read(
        predictPoolAddressProvider(
          creator: creatorAddress,
          token: state.selectedTokenSymbol!,
        ).future,
      );

      final predictedPoolAddress = prediction['predicted'] as String?;
      if (predictedPoolAddress != null) {
        state = state.copyWith(predictedPoolAddress: predictedPoolAddress);
      }
    } catch (e) {
      // Silent fail for prediction - not critical for UX
      // Could log for debugging in development
    }
  }

  @override
  void setFundingAmount(String amount) {
    state = state.copyWith(fundingAmount: amount);
    _calculateGasEstimation();
  }

  @override
  Future<void> predictPoolAddress() async {
    await _predictPoolAddress();
  }

  Future<void> _calculateGasEstimation() async {
    if (state.fundingAmount == null ||
        state.fundingAmount!.isEmpty ||
        state.selectedTokenSymbol == null) {
      state = state.copyWith(
        estimatedGasCost: null,
        gasExceedsReward: null,
      );
      return;
    }

    final creatorAddress = ref.read(sessionNotifierProvider).address;
    if (creatorAddress == null) return;

    try {
      final gasData = await ref.read(
        estimateFactoryGasProvider(
          type:
              'createFactory', // TODO: this should be dynamic based on context (create vs fund)
          token: state.selectedTokenSymbol,
          creator: creatorAddress,
          amount: state.fundingAmount,
        ).future,
      );

      final isExpensive = gasData['isExpensive'] as bool;

      // TODO: Get ETH price from a provider to show USD value
      final estimatedGas = '~${gasData['totalCost']} ETH';

      state = state.copyWith(
        estimatedGasCost: estimatedGas,
        gasExceedsReward: isExpensive,
      );
    } catch (e) {
      // Invalid funding amount or API error
      state = state.copyWith(
        estimatedGasCost: 'Error estimating',
        gasExceedsReward: false,
      );
    }
  }

  Future<void> createPool() async {
    if (state.selectedTokenSymbol == null) {
      setError('Please select a reward token.');
      return;
    }

    if (state.fundingAmount == null || state.fundingAmount!.isEmpty) {
      setError('Please specify a funding amount.');
      return;
    }

    try {
      state = state.copyWith(
        isCreating: true,
        error: null,
        transactionStatus: 'Preparing transaction...',
      );

      final creatorAddress = ref.read(sessionNotifierProvider).address;
      if (creatorAddress == null) {
        throw Exception('User is not authenticated');
      }

      final transactionManager = ref.read(transactionManagerProvider.notifier);

      // Start the transaction workflow
      state = state.copyWith(
        transactionStatus: 'Opening wallet for transaction approval...',
      );

      // Choose transaction type based on funding amount
      if (state.fundingAmount != null && state.fundingAmount!.isNotEmpty) {
        final fundingAmount = double.tryParse(state.fundingAmount!);
        if (fundingAmount != null && fundingAmount > 0) {
          // Use createAndFundPool for atomic operation
          await transactionManager.createAndFundPool(
            token: state.selectedTokenSymbol!,
            creator: creatorAddress,
            amount: state.fundingAmount!,
          );
        } else {
          // Use regular createFactory
          await transactionManager.createFactory(
            token: state.selectedTokenSymbol!,
            creator: creatorAddress,
          );
        }
      } else {
        // Use regular createFactory
        await transactionManager.createFactory(
          token: state.selectedTokenSymbol!,
          creator: creatorAddress,
        );
      }

      // Monitor transaction status
      state = state.copyWith(
        transactionStatus: 'Waiting for transaction confirmation...',
      );
      await _monitorTransactionStatus();
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        error: e.toString(),
        transactionStatus: null,
      );
    }
  }

  Future<void> _monitorTransactionStatus() async {
    // Poll transaction status every 2 seconds for up to 10 minutes
    const maxAttempts = 300; // 10 minutes at 2 second intervals
    var attempts = 0;
    while (attempts < maxAttempts) {
      await Future.delayed(const Duration(seconds: 2));
      attempts++;
      final transactionState = ref.read(transactionManagerProvider);

      // Transaction completed successfully
      if (transactionState.lastSuccessfulTx != null) {
        state = state.copyWith(
          transactionStatus:
              'Transaction confirmed! Finalizing factory registration...',
        );

        try {
          final transactionManager =
              ref.read(transactionManagerProvider.notifier);

          // Finalize factory creation by saving metadata to MongoDB
          await transactionManager.finalizeFactoryCreation(
            txHash: transactionState.lastSuccessfulTx!,
            sessionId: transactionState.currentSessionId!,
            factoryName: state.factoryName ?? 'Unnamed Factory',
            skills: state.skills ?? '',
            apps: state.apps ?? [],
            token: state.selectedTokenSymbol!,
            fundingAmount: state.fundingAmount,
          );

          state = state.copyWith(
            isCreating: false,
            isCreated: true,
            transactionStatus: 'Factory created and registered successfully!',
          );

          ref.invalidate(
            getFactoriesByCreatorProvider(
              creatorAddress: ref.read(sessionNotifierProvider).address!,
            ),
          );
          return;
        } catch (e) {
          state = state.copyWith(
            isCreating: false,
            error: 'Factory created on-chain but registration failed: $e',
            transactionStatus: null,
          );
          return;
        }
      }

      // Transaction failed
      if (transactionState.error != null) {
        state = state.copyWith(
          isCreating: false,
          error: 'Transaction failed: ${transactionState.error}',
          transactionStatus: null,
        );
        return;
      }

      // Check if user is no longer waiting for callback (cancelled/timeout)
      if (!transactionState.awaitingCallback && !transactionState.isLoading) {
        state = state.copyWith(
          isCreating: false,
          error: 'Transaction was cancelled or timed out',
          transactionStatus: null,
        );
        return;
      }
    }

    // Timeout after 10 minutes
    state = state.copyWith(
      isCreating: false,
      error: 'Transaction timed out. Please check your wallet and try again.',
      transactionStatus: null,
    );
  }
}
