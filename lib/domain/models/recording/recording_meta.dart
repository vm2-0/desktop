import 'package:clones_desktop/domain/models/demonstration/demonstration.dart';
import 'package:clones_desktop/domain/models/recording/monitor_info.dart';
import 'package:clones_desktop/domain/models/submission/schema_version.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recording_meta.freezed.dart';
part 'recording_meta.g.dart';

@freezed
class RecordingMeta with _$RecordingMeta {
  const factory RecordingMeta({
    @JsonKey(name: 'schema_version') SchemaVersion? schemaVersion,
    required String id,
    required String timestamp,
    @JsonKey(name: 'duration_seconds') required int durationSeconds,
    required String status,
    String? reason,
    required String title,
    required String description,
    required String platform,
    required String arch,
    required String version,
    required String locale,
    @JsonKey(name: 'keyboard_layout') String? keyboardLayout,
    @JsonKey(name: 'primary_monitor') MonitorInfo? primaryMonitor,
    @JsonKey(name: 'quest') required Demonstration demonstration,
  }) = _RecordingMeta;

  factory RecordingMeta.fromJson(Map<String, dynamic> json) =>
      _$RecordingMetaFromJson(json);
}
