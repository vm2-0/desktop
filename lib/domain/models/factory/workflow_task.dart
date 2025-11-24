// ignore_for_file: invalid_annotation_target

import 'package:clones_desktop/domain/models/factory/task_app.dart';
import 'package:clones_desktop/utils/decimal_json.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workflow_task.freezed.dart';
part 'workflow_task.g.dart';

/// Workflow task definition
@freezed
class WorkflowTask with _$WorkflowTask {
  const factory WorkflowTask({
    @JsonKey(name: '_id') String? id,
    required String prompt,
    @Default([]) List<String> categories,
    @JsonKey(name: 'apps_used') required List<TaskApp> appsUsed,
    @JsonKey(name: 'task_name') required String taskName,
    int? uploadLimit,
    int? currentSubmissions,
    bool? uploadLimitReached,
    @JsonKey(
      toJson: DecimalJson.toJson,
      fromJson: DecimalJson.fromJson,
    )
    Decimal? rewardLimit,
    String? limitReason,
    @JsonKey(name: 'pool_id') String? poolId,
  }) = _WorkflowTask;

  factory WorkflowTask.fromJson(Map<String, dynamic> json) =>
      _$WorkflowTaskFromJson(json);
}
