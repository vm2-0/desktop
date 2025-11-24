// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demonstration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DemonstrationImpl _$$DemonstrationImplFromJson(Map<String, dynamic> json) =>
    _$DemonstrationImpl(
      title: json['title'] as String,
      app: json['app'] as String,
      objectives: (json['objectives'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      content: json['content'] as String,
      poolId: json['pool_id'] as String?,
      reward: json['reward'] == null
          ? null
          : DemonstrationReward.fromJson(
              json['reward'] as Map<String, dynamic>),
      taskId: json['task_id'] as String?,
    );

Map<String, dynamic> _$$DemonstrationImplToJson(_$DemonstrationImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'app': instance.app,
      'objectives': instance.objectives,
      'content': instance.content,
      'pool_id': instance.poolId,
      'reward': instance.reward,
      'task_id': instance.taskId,
    };
