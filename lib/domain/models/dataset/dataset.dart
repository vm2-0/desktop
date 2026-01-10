// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dataset.freezed.dart';
part 'dataset.g.dart';

/// Phase of a Dataset token
enum DatasetPhase {
  @JsonValue('draft')
  draft,
  @JsonValue('bonding')
  bonding,
  @JsonValue('graduated')
  graduated,
}

extension DatasetPhaseExtension on DatasetPhase {
  String get jsonValue {
    switch (this) {
      case DatasetPhase.draft:
        return 'draft';
      case DatasetPhase.bonding:
        return 'bonding';
      case DatasetPhase.graduated:
        return 'graduated';
    }
  }

  String get displayName {
    switch (this) {
      case DatasetPhase.draft:
        return 'Draft';
      case DatasetPhase.bonding:
        return 'Bonding';
      case DatasetPhase.graduated:
        return 'Graduated';
    }
  }
}

/// Bonding curve parameters
@freezed
class BondingCurve with _$BondingCurve {
  const factory BondingCurve({
    required double virtualETH,
    required double virtualTokens,
    required double k,
  }) = _BondingCurve;

  factory BondingCurve.fromJson(Map<String, dynamic> json) =>
      _$BondingCurveFromJson(json);
}

/// Graduation information
@freezed
class GraduationInfo with _$GraduationInfo {
  const factory GraduationInfo({
    required DateTime timestamp,
    required double finalPrice,
    String? lpPairAddress,
  }) = _GraduationInfo;

  factory GraduationInfo.fromJson(Map<String, dynamic> json) =>
      _$GraduationInfoFromJson(json);
}

/// Main Dataset model
@freezed
class Dataset with _$Dataset {
  const factory Dataset({
    required String id,
    required String name,
    required String symbol,
    String? description,
    String? category,
    required String contractAddress,
    required String creatorAddress,
    String? factoryId,

    // Token economics
    int? totalSupply,
    double? currentPrice,
    double? marketCap,
    @Default(0.0) double volume24h,

    // Quality metrics
    double? qualityScore,
    @Default(0) int demonstrationCount,

    // Burn mechanics
    required double burnThresholdPercentage,
    @Default(0.0) double totalBurned,
    @Default(0) int burnCount,

    // Lifecycle
    required DatasetPhase phase,

    // Bonding curve parameters
    BondingCurve? bondingCurve,

    // Graduation info (if applicable)
    GraduationInfo? graduationInfo,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Dataset;

  factory Dataset.fromJson(Map<String, dynamic> json) =>
      _$DatasetFromJson(json);
}

/// Request to create a dataset
@freezed
class CreateDatasetRequest with _$CreateDatasetRequest {
  const factory CreateDatasetRequest({
    required String name,
    required String symbol,
    String? description,
    String? category,
    @Default([]) List<String> demoHashes,
    String? factoryId,
    @Default(5.0) double burnThresholdPercentage,
  }) = _CreateDatasetRequest;

  factory CreateDatasetRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateDatasetRequestFromJson(json);

  Map<String, dynamic> toJson() => {
    'name': name,
    'symbol': symbol,
    if (description != null) 'description': description,
    if (category != null) 'category': category,
    if (demoHashes.isNotEmpty) 'demoHashes': demoHashes,
    if (factoryId != null) 'factoryId': factoryId,
    'burnThresholdPercentage': burnThresholdPercentage,
  };
}

/// Response from creating a dataset
@freezed
class CreateDatasetResponse with _$CreateDatasetResponse {
  const factory CreateDatasetResponse({
    required Dataset dataset,
  }) = _CreateDatasetResponse;

  factory CreateDatasetResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateDatasetResponseFromJson(json);
}
