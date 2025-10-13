// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'schema_version.freezed.dart';
part 'schema_version.g.dart';

@freezed
class SchemaVersion with _$SchemaVersion {
  const factory SchemaVersion({
    required int major,
    required int minor,
    required int patch,
  }) = _SchemaVersion;

  factory SchemaVersion.fromJson(Map<String, dynamic> json) =>
      _$SchemaVersionFromJson(json);
}
