// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tool_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ToolStatusImpl _$$ToolStatusImplFromJson(Map<String, dynamic> json) =>
    _$ToolStatusImpl(
      status: _statusFromJson(json['status']),
      message: json['message'] as String,
      progress: (json['progress'] as num).toInt(),
    );

Map<String, dynamic> _$$ToolStatusImplToJson(_$ToolStatusImpl instance) =>
    <String, dynamic>{
      'status': _statusToString(instance.status),
      'message': instance.message,
      'progress': instance.progress,
    };
