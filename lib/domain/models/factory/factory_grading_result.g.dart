// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factory_grading_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FactoryGradingResultImpl _$$FactoryGradingResultImplFromJson(
        Map<String, dynamic> json) =>
    _$FactoryGradingResultImpl(
      submissionId: json['submissionId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      score: (json['score'] as num).toDouble(),
      confidence: (json['confidence'] as num?)?.toDouble(),
      outcomeAchievement: (json['outcomeAchievement'] as num?)?.toDouble(),
      processQuality: (json['processQuality'] as num?)?.toDouble(),
      efficiency: (json['efficiency'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$FactoryGradingResultImplToJson(
        _$FactoryGradingResultImpl instance) =>
    <String, dynamic>{
      'submissionId': instance.submissionId,
      'createdAt': instance.createdAt.toIso8601String(),
      'score': instance.score,
      'confidence': instance.confidence,
      'outcomeAchievement': instance.outcomeAchievement,
      'processQuality': instance.processQuality,
      'efficiency': instance.efficiency,
    };
