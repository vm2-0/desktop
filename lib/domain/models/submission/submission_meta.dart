// ignore_for_file: invalid_annotation_target

import 'package:clones_desktop/domain/models/demonstration/demonstration.dart';
import 'package:clones_desktop/domain/models/recording/monitor_info.dart';
import 'package:clones_desktop/domain/models/submission/schema_version.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'submission_meta.freezed.dart';
part 'submission_meta.g.dart';

@freezed
class SubmissionMeta with _$SubmissionMeta {
  const factory SubmissionMeta({
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
    @JsonKey(name: 'primary_monitor') required MonitorInfo primaryMonitor,
    @JsonKey(name: 'quest') required Demonstration demonstration,
    String? poolId,
  }) = _SubmissionMeta;

  factory SubmissionMeta.fromJson(Map<String, dynamic> json) =>
      _$SubmissionMetaFromJson(json);
}
