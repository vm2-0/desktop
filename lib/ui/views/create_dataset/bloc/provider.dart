import 'package:clones_desktop/application/datasets.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/application/transaction/provider.dart';
import 'package:clones_desktop/domain/models/dataset/dataset.dart';
import 'package:clones_desktop/infrastructure/dataset.repository.dart';
import 'package:clones_desktop/ui/views/create_dataset/bloc/state.dart';
import 'package:clones_desktop/utils/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class CreateDatasetNotifier extends _$CreateDatasetNotifier {
  @override
  CreateDatasetState build() {
    return const CreateDatasetState();
  }

  void setName(String value) {
    state = state.copyWith(name: value);
  }

  void setSymbol(String value) {
    // Auto-uppercase the symbol
    state = state.copyWith(symbol: value.toUpperCase());
  }

  void setDescription(String value) {
    state = state.copyWith(description: value);
  }

  void setCategory(String value) {
    state = state.copyWith(category: value);
  }

  void setBurnThresholdPercentage(int value) {
    if (value >= 1 && value <= 10) {
      state = state.copyWith(burnThresholdPercentage: value);
    }
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void setFactoryContext({
    required String factoryId,
    required List<String> demoHashes,
  }) {
    state = state.copyWith(
      factoryId: factoryId,
      demoHashes: demoHashes,
      demonstrationCount: demoHashes.length,
    );
  }

  void reset() {
    // Save factoryId before resetting state
    final factoryId = state.factoryId;

    // Reset state
    state = const CreateDatasetState();

    // Invalidate datasets list if we were creating from a factory
    if (factoryId != null) {
      ref.invalidate(getFactoryDatasetsProvider(factoryId));
    }
  }

  Future<void> validateAndCreate() async {
    // Clear previous errors
    setError(null);

    // Validate form
    if (state.nameError != null) {
      setError(state.nameError);
      return;
    }

    if (state.symbolError != null) {
      setError(state.symbolError);
      return;
    }

    if (state.descriptionError != null) {
      setError(state.descriptionError);
      return;
    }

    if (state.categoryError != null) {
      setError(state.categoryError);
      return;
    }

    if (!state.canCreate) {
      setError('Please fill in all required fields');
      return;
    }

    await createDataset();
  }

  Future<void> createDataset() async {
    if (!state.canCreate) return;

    state = state.copyWith(
      isCreating: true,
      currentStep: CreateDatasetStep.creating,
      error: null,
    );

    try {
      final apiClient = ref.read(apiClientProvider);
      final repository = DatasetRepositoryImpl(apiClient);
      final session = ref.read(sessionNotifierProvider);

      // Check wallet connection
      if (session.address == null) {
        throw Exception('Please connect your wallet first');
      }

      // Step 1: Create dataset in draft phase in MongoDB
      final request = CreateDatasetRequest(
        name: state.name!.trim(),
        symbol: state.symbol!.trim(),
        description: state.description?.trim(),
        category: state.category?.trim(),
        demoHashes: state.demoHashes ?? [],
        factoryId: state.factoryId,
      );

      final dataset = await repository.createDataset(request);

      state = state.copyWith(
        createdDatasetId: dataset.id,
        calculatedQualityScore: dataset.qualityScore,
        transactionStatus: 'Preparing transaction...',
      );

      state = state.copyWith(
        transactionStatus: 'Opening wallet for transaction approval...',
      );

      await ref.read(transactionManagerProvider.notifier).createDataset(
            datasetId: dataset.id,
            name: state.name!.trim(),
            symbol: state.symbol!.trim(),
            burnThresholdPercentage: state.burnThresholdPercentage,
            creator: session.address!,
          );

      state = state.copyWith(
        transactionStatus: 'Waiting for transaction confirmation...',
      );
      await _monitorTransactionStatus();
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        currentStep: CreateDatasetStep.input,
        error: e.toString(),
        transactionStatus: null,
      );
    }
  }

  Future<void> _monitorTransactionStatus() async {
    const maxAttempts = 300;
    var attempts = 0;
    while (attempts < maxAttempts) {
      await Future.delayed(const Duration(seconds: 2));
      attempts++;
      final transactionState = ref.read(transactionManagerProvider);

      if (transactionState.lastSuccessfulTx != null) {
        state = state.copyWith(
          isCreating: false,
          isCreated: true,
          currentStep: CreateDatasetStep.created,
          transactionStatus: 'Dataset deployed successfully on-chain!',
        );

        if (state.factoryId != null) {
          ref.invalidate(getFactoryDatasetsProvider(state.factoryId!));
        }
        return;
      }

      if (transactionState.error != null) {
        throw Exception('Transaction failed: ${transactionState.error}');
      }

      if (transactionState.awaitingCallback) {
        state = state.copyWith(
          transactionStatus: 'Waiting for wallet signature...',
        );
      }
    }

    throw Exception('Transaction timed out after 10 minutes. Please check your wallet.');
  }
}
