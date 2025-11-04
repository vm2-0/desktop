// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubmissionStatusImpl _$$SubmissionStatusImplFromJson(
        Map<String, dynamic> json) =>
    _$SubmissionStatusImpl(
      id: json['_id'] as String?,
      address: json['address'] as String?,
      meta: SubmissionMeta.fromJson(json['meta'] as Map<String, dynamic>),
      status: json['status'] as String,
      demoHash: json['demoHash'] as String?,
      fileManifest: json['fileManifest'] == null
          ? null
          : FileManifest.fromJson(json['fileManifest'] as Map<String, dynamic>),
      integrityVerified: json['integrityVerified'] as bool?,
      error: json['error'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      clampedScore: (json['clampedScore'] as num?)?.toInt(),
      gradeResult: json['grade_result'] == null
          ? null
          : GradeResult.fromJson(json['grade_result'] as Map<String, dynamic>),
      maxReward: DecimalJson.fromJson(json['maxReward']),
      reward: DecimalJson.fromJson(json['reward']),
      claimAuthorization: json['claimAuthorization'] == null
          ? null
          : ClaimAuthorization.fromJson(
              json['claimAuthorization'] as Map<String, dynamic>),
      onChainReward: json['onChainReward'] == null
          ? null
          : OnChainReward.fromJson(
              json['onChainReward'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SubmissionStatusImplToJson(
        _$SubmissionStatusImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'address': instance.address,
      'meta': instance.meta,
      'status': instance.status,
      'demoHash': instance.demoHash,
      'fileManifest': instance.fileManifest,
      'integrityVerified': instance.integrityVerified,
      'error': instance.error,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'clampedScore': instance.clampedScore,
      'grade_result': instance.gradeResult,
      'maxReward': DecimalJson.toJson(instance.maxReward),
      'reward': DecimalJson.toJson(instance.reward),
      'claimAuthorization': instance.claimAuthorization,
      'onChainReward': instance.onChainReward,
    };
