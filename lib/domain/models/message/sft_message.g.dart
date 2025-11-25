// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sft_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WindowInfoImpl _$$WindowInfoImplFromJson(Map<String, dynamic> json) =>
    _$WindowInfoImpl(
      bbox: json['bbox'] as Map<String, dynamic>,
      children: json['children'] as List<dynamic>,
      description: json['description'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$$WindowInfoImplToJson(_$WindowInfoImpl instance) =>
    <String, dynamic>{
      'bbox': instance.bbox,
      'children': instance.children,
      'description': instance.description,
      'name': instance.name,
      'role': instance.role,
      'value': instance.value,
    };
