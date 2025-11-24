import 'package:clones_desktop/domain/models/demonstration/demonstration_reward.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'demonstration.freezed.dart';
part 'demonstration.g.dart';

@freezed
class Demonstration with _$Demonstration {
  const factory Demonstration({
    required String title,
    required String app,
    required List<String> objectives,
    required String content,
    @JsonKey(name: 'pool_id') String? poolId,
    DemonstrationReward? reward,
    @JsonKey(name: 'task_id') String? taskId,
  }) = _Demonstration;

  factory Demonstration.fromJson(Map<String, dynamic> json) =>
      _$DemonstrationFromJson(json);
}
