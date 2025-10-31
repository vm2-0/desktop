import 'package:freezed_annotation/freezed_annotation.dart';

part 'factory_grading_result.freezed.dart';
part 'factory_grading_result.g.dart';

@freezed
class FactoryGradingResult with _$FactoryGradingResult {
  const factory FactoryGradingResult({
    required String submissionId,
    required DateTime createdAt,
    required double score,
    double? confidence,
    double? outcomeAchievement,
    double? processQuality,
    double? efficiency,
  }) = _FactoryGradingResult;

  factory FactoryGradingResult.fromJson(Map<String, dynamic> json) =>
      _$FactoryGradingResultFromJson(json);
}
