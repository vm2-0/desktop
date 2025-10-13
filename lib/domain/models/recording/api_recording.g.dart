// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_recording.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiRecordingImpl _$$ApiRecordingImplFromJson(Map<String, dynamic> json) =>
    _$ApiRecordingImpl(
      schemaVersion: json['schema_version'] == null
          ? null
          : SchemaVersion.fromJson(
              json['schema_version'] as Map<String, dynamic>),
      id: json['id'] as String,
      timestamp: json['timestamp'] as String,
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      status: json['status'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      platform: json['platform'] as String,
      arch: json['arch'] as String,
      version: json['version'] as String,
      locale: json['locale'] as String,
      keyboardLayout: json['keyboard_layout'] as String?,
      primaryMonitor:
          MonitorInfo.fromJson(json['primaryMonitor'] as Map<String, dynamic>),
      demonstration: json['quest'] == null
          ? null
          : Demonstration.fromJson(json['quest'] as Map<String, dynamic>),
      location: json['location'] as String?,
      submission: json['submission'] == null
          ? null
          : SubmissionStatus.fromJson(
              json['submission'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ApiRecordingImplToJson(_$ApiRecordingImpl instance) =>
    <String, dynamic>{
      'schema_version': instance.schemaVersion,
      'id': instance.id,
      'timestamp': instance.timestamp,
      'durationSeconds': instance.durationSeconds,
      'status': instance.status,
      'title': instance.title,
      'description': instance.description,
      'platform': instance.platform,
      'arch': instance.arch,
      'version': instance.version,
      'locale': instance.locale,
      'keyboard_layout': instance.keyboardLayout,
      'primaryMonitor': instance.primaryMonitor,
      'quest': instance.demonstration,
      'location': instance.location,
      'submission': instance.submission,
    };
