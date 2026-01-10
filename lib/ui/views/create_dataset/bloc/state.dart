import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

enum CreateDatasetStep {
  input,
  creating,
  created,
}

@freezed
class CreateDatasetState with _$CreateDatasetState {
  const factory CreateDatasetState({
    String? name,
    String? symbol,
    String? description,
    String? category,
    @Default(5) int burnThresholdPercentage,
    String? factoryId,
    List<String>? demoHashes,
    String? predictedTokenAddress,
    String? predictedBondingCurveAddress,
    String? estimatedEthFee,
    String? estimatedClonesFee,
    @Default(CreateDatasetStep.input) CreateDatasetStep currentStep,
    @Default(false) bool isCreating,
    @Default(false) bool isCreated,
    String? error,
    String? createdDatasetId,
    String? transactionStatus,
    double? calculatedQualityScore,
    int? demonstrationCount,
  }) = _CreateDatasetState;

  const CreateDatasetState._();

  bool get canCreate {
    return name != null &&
           name!.trim().isNotEmpty &&
           symbol != null &&
           symbol!.trim().length >= 2 &&
           burnThresholdPercentage >= 1 &&
           burnThresholdPercentage <= 10 &&
           demoHashes != null &&
           demoHashes!.isNotEmpty &&
           !isCreating;
  }

  int get maxDownloads => 100 ~/ burnThresholdPercentage;

  String get tokensPerDownload => (1000000000 * burnThresholdPercentage / 100).toStringAsFixed(0);

  String get thresholdRecommendation {
    if (burnThresholdPercentage <= 2) {
      return 'Low barrier: Ideal for mass adoption ($maxDownloads downloads)';
    } else if (burnThresholdPercentage <= 5) {
      return 'Balanced: Good for moderate scarcity ($maxDownloads downloads)';
    } else if (burnThresholdPercentage <= 7) {
      return 'Premium: Higher value per download ($maxDownloads downloads)';
    } else {
      return 'Exclusive: Very limited access ($maxDownloads downloads)';
    }
  }

  String? get nameError {
    if (name == null || name!.isEmpty) return null;
    if (name!.trim().isEmpty) return 'Dataset name cannot be empty';
    if (name!.length > 100) return 'Dataset name is too long (max 100 characters)';
    return null;
  }

  String? get symbolError {
    if (symbol == null || symbol!.isEmpty) return null;
    if (symbol!.trim().length < 2) return 'Symbol must be at least 2 characters';
    if (symbol!.length > 10) return 'Symbol is too long (max 10 characters)';
    return null;
  }

  String? get descriptionError {
    if (description == null || description!.isEmpty) return null;
    if (description!.length > 1000) return 'Description is too long (max 1000 characters)';
    return null;
  }

  String? get categoryError {
    if (category == null || category!.isEmpty) return null;
    if (category!.length > 50) return 'Category is too long (max 50 characters)';
    return null;
  }
}
