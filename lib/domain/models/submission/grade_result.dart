// ignore_for_file: invalid_annotation_target

import 'package:clones_desktop/utils/format_string.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'grade_result.freezed.dart';
part 'grade_result.g.dart';

@freezed
class GradeResult with _$GradeResult {
  const factory GradeResult({
    required String summary,
    required int score,
    required String reasoning,
    String? scratchpad,
    @JsonKey(name: '_id') required String id,
    String? version,
    String? observations,
    double? confidence,
    double? outcomeAchievement,
    double? processQuality,
    double? efficiency,
    String? confidenceReasoning,
    String? outcomeAchievementReasoning,
    String? processQualityReasoning,
    String? efficiencyReasoning,
    Map<String, dynamic>? programmaticResults,
  }) = _GradeResult;

  factory GradeResult.fromJson(Map<String, dynamic> json) =>
      _$GradeResultFromJson(json);
}

extension GradeResultExtension on GradeResult {
  static final regexGradeResult = RegExp(r'^\((.*)\)\s*(.*)$');
  String get reasoningSystem =>
      regexGradeResult
          .firstMatch(reasoning)
          ?.group(1)
          ?.replaceAll('system:', '')
          .trim()
          .capitalize() ??
      '';

  String get reasoningForUser =>
      regexGradeResult.firstMatch(reasoning)?.group(2)?.trim() ?? reasoning;

  List<Map<String, dynamic>> get videoTimeline {
    if (programmaticResults == null) return [];
    if (!programmaticResults!.containsKey('videoAnalysis')) return [];

    final analysis = programmaticResults!['videoAnalysis'];
    if (analysis is List) {
      return analysis.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return [];
  }
}
