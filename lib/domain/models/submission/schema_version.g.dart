// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SchemaVersionImpl _$$SchemaVersionImplFromJson(Map<String, dynamic> json) =>
    _$SchemaVersionImpl(
      major: (json['major'] as num).toInt(),
      minor: (json['minor'] as num).toInt(),
      patch: (json['patch'] as num).toInt(),
    );

Map<String, dynamic> _$$SchemaVersionImplToJson(_$SchemaVersionImpl instance) =>
    <String, dynamic>{
      'major': instance.major,
      'minor': instance.minor,
      'patch': instance.patch,
    };
