// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BondingCurveImpl _$$BondingCurveImplFromJson(Map<String, dynamic> json) =>
    _$BondingCurveImpl(
      virtualETH: (json['virtualETH'] as num).toDouble(),
      virtualTokens: (json['virtualTokens'] as num).toDouble(),
      k: (json['k'] as num).toDouble(),
    );

Map<String, dynamic> _$$BondingCurveImplToJson(_$BondingCurveImpl instance) =>
    <String, dynamic>{
      'virtualETH': instance.virtualETH,
      'virtualTokens': instance.virtualTokens,
      'k': instance.k,
    };

_$GraduationInfoImpl _$$GraduationInfoImplFromJson(Map<String, dynamic> json) =>
    _$GraduationInfoImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      finalPrice: (json['finalPrice'] as num).toDouble(),
      lpPairAddress: json['lpPairAddress'] as String?,
    );

Map<String, dynamic> _$$GraduationInfoImplToJson(
        _$GraduationInfoImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'finalPrice': instance.finalPrice,
      'lpPairAddress': instance.lpPairAddress,
    };

_$DatasetImpl _$$DatasetImplFromJson(Map<String, dynamic> json) =>
    _$DatasetImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      contractAddress: json['contractAddress'] as String,
      creatorAddress: json['creatorAddress'] as String,
      factoryId: json['factoryId'] as String?,
      totalSupply: (json['totalSupply'] as num?)?.toInt(),
      currentPrice: (json['currentPrice'] as num?)?.toDouble(),
      marketCap: (json['marketCap'] as num?)?.toDouble(),
      volume24h: (json['volume24h'] as num?)?.toDouble() ?? 0.0,
      qualityScore: (json['qualityScore'] as num?)?.toDouble(),
      demonstrationCount: (json['demonstrationCount'] as num?)?.toInt() ?? 0,
      burnThresholdPercentage:
          (json['burnThresholdPercentage'] as num).toDouble(),
      totalBurned: (json['totalBurned'] as num?)?.toDouble() ?? 0.0,
      burnCount: (json['burnCount'] as num?)?.toInt() ?? 0,
      phase: $enumDecode(_$DatasetPhaseEnumMap, json['phase']),
      bondingCurve: json['bondingCurve'] == null
          ? null
          : BondingCurve.fromJson(json['bondingCurve'] as Map<String, dynamic>),
      graduationInfo: json['graduationInfo'] == null
          ? null
          : GraduationInfo.fromJson(
              json['graduationInfo'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$DatasetImplToJson(_$DatasetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'symbol': instance.symbol,
      'description': instance.description,
      'category': instance.category,
      'contractAddress': instance.contractAddress,
      'creatorAddress': instance.creatorAddress,
      'factoryId': instance.factoryId,
      'totalSupply': instance.totalSupply,
      'currentPrice': instance.currentPrice,
      'marketCap': instance.marketCap,
      'volume24h': instance.volume24h,
      'qualityScore': instance.qualityScore,
      'demonstrationCount': instance.demonstrationCount,
      'burnThresholdPercentage': instance.burnThresholdPercentage,
      'totalBurned': instance.totalBurned,
      'burnCount': instance.burnCount,
      'phase': _$DatasetPhaseEnumMap[instance.phase]!,
      'bondingCurve': instance.bondingCurve,
      'graduationInfo': instance.graduationInfo,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$DatasetPhaseEnumMap = {
  DatasetPhase.draft: 'draft',
  DatasetPhase.bonding: 'bonding',
  DatasetPhase.graduated: 'graduated',
};

_$CreateDatasetRequestImpl _$$CreateDatasetRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateDatasetRequestImpl(
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      demoHashes: (json['demoHashes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      factoryId: json['factoryId'] as String?,
      burnThresholdPercentage:
          (json['burnThresholdPercentage'] as num?)?.toDouble() ?? 5.0,
    );

Map<String, dynamic> _$$CreateDatasetRequestImplToJson(
        _$CreateDatasetRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'symbol': instance.symbol,
      'description': instance.description,
      'category': instance.category,
      'demoHashes': instance.demoHashes,
      'factoryId': instance.factoryId,
      'burnThresholdPercentage': instance.burnThresholdPercentage,
    };

_$CreateDatasetResponseImpl _$$CreateDatasetResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateDatasetResponseImpl(
      dataset: Dataset.fromJson(json['dataset'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CreateDatasetResponseImplToJson(
        _$CreateDatasetResponseImpl instance) =>
    <String, dynamic>{
      'dataset': instance.dataset,
    };
