// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecordingMetaImpl _$$RecordingMetaImplFromJson(Map<String, dynamic> json) =>
    _$RecordingMetaImpl(
      schemaVersion: json['schema_version'] == null
          ? null
          : SchemaVersion.fromJson(
              json['schema_version'] as Map<String, dynamic>),
      id: json['id'] as String,
      timestamp: json['timestamp'] as String,
      durationSeconds: (json['duration_seconds'] as num).toInt(),
      status: json['status'] as String,
      reason: json['reason'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      platform: json['platform'] as String,
      arch: json['arch'] as String,
      version: json['version'] as String,
      locale: json['locale'] as String,
      keyboardLayout: json['keyboard_layout'] as String?,
      primaryMonitor: json['primary_monitor'] == null
          ? null
          : MonitorInfo.fromJson(
              json['primary_monitor'] as Map<String, dynamic>),
      demonstration:
          Demonstration.fromJson(json['quest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RecordingMetaImplToJson(_$RecordingMetaImpl instance) =>
    <String, dynamic>{
      'schema_version': instance.schemaVersion,
      'id': instance.id,
      'timestamp': instance.timestamp,
      'duration_seconds': instance.durationSeconds,
      'status': instance.status,
      'reason': instance.reason,
      'title': instance.title,
      'description': instance.description,
      'platform': instance.platform,
      'arch': instance.arch,
      'version': instance.version,
      'locale': instance.locale,
      'keyboard_layout': instance.keyboardLayout,
      'primary_monitor': instance.primaryMonitor,
      'quest': instance.demonstration,
    };
