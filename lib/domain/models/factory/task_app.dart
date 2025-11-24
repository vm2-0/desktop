// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_app.freezed.dart';
part 'task_app.g.dart';

/// App used in a workflow task
@freezed
class TaskApp with _$TaskApp {
  const factory TaskApp({
    required String name,
    required String domain,
    required String description,
  }) = _TaskApp;

  factory TaskApp.fromJson(Map<String, dynamic> json) =>
      _$TaskAppFromJson(json);
}
