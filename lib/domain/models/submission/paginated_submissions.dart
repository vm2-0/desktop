// ignore_for_file: invalid_annotation_target

import 'package:clones_desktop/domain/models/submission/submission_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_submissions.freezed.dart';
part 'paginated_submissions.g.dart';

@freezed
class PaginatedSubmissions with _$PaginatedSubmissions {
  const factory PaginatedSubmissions({
    required List<SubmissionStatus> submissions,
    required int total,
    required int limit,
    required int offset,
    required bool hasMore,
  }) = _PaginatedSubmissions;

  factory PaginatedSubmissions.fromJson(Map<String, dynamic> json) =>
      _$PaginatedSubmissionsFromJson(json);
}
