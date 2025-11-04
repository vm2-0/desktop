// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factory_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FactoryTaskImpl _$$FactoryTaskImplFromJson(Map<String, dynamic> json) =>
    _$FactoryTaskImpl(
      id: json['_id'] as String?,
      prompt: json['prompt'] as String,
      uploadLimit: (json['uploadLimit'] as num?)?.toInt(),
      rewardLimit: DecimalJson.fromJson(json['rewardLimit']),
      limitReason: json['limitReason'] as String?,
    );

Map<String, dynamic> _$$FactoryTaskImplToJson(_$FactoryTaskImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'prompt': instance.prompt,
      'uploadLimit': instance.uploadLimit,
      'rewardLimit': DecimalJson.toJson(instance.rewardLimit),
      'limitReason': instance.limitReason,
    };
