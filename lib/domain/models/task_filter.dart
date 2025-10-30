import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_filter.freezed.dart';
part 'task_filter.g.dart';

@freezed
class TaskFilter with _$TaskFilter {
  const factory TaskFilter({
    String? poolId,
    List<String>? categories,
    String? query,
    @Default(true) bool hideAdult,
  }) = _TaskFilter;

  factory TaskFilter.fromJson(Map<String, dynamic> json) =>
      _$TaskFilterFromJson(json);
}
