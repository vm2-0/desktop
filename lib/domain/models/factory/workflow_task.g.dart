// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkflowTaskImpl _$$WorkflowTaskImplFromJson(Map<String, dynamic> json) =>
    _$WorkflowTaskImpl(
      id: json['_id'] as String?,
      prompt: json['prompt'] as String,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      appsUsed: (json['apps_used'] as List<dynamic>)
          .map((e) => TaskApp.fromJson(e as Map<String, dynamic>))
          .toList(),
      taskName: json['task_name'] as String,
      uploadLimit: (json['uploadLimit'] as num?)?.toInt(),
      currentSubmissions: (json['currentSubmissions'] as num?)?.toInt(),
      uploadLimitReached: json['uploadLimitReached'] as bool?,
      rewardLimit: DecimalJson.fromJson(json['rewardLimit']),
      limitReason: json['limitReason'] as String?,
      poolId: json['pool_id'] as String?,
      objectives: (json['objectives'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$WorkflowTaskImplToJson(_$WorkflowTaskImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'prompt': instance.prompt,
      'categories': instance.categories,
      'apps_used': instance.appsUsed,
      'task_name': instance.taskName,
      'uploadLimit': instance.uploadLimit,
      'currentSubmissions': instance.currentSubmissions,
      'uploadLimitReached': instance.uploadLimitReached,
      'rewardLimit': DecimalJson.toJson(instance.rewardLimit),
      'limitReason': instance.limitReason,
      'pool_id': instance.poolId,
      'objectives': instance.objectives,
    };
