import 'package:clones_desktop/domain/models/factory/factory_token.dart';
import 'package:clones_desktop/utils/decimal_json.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_leader_board.freezed.dart';
part 'worker_leader_board.g.dart';

@freezed
class WorkerTokenReward with _$WorkerTokenReward {
  const factory WorkerTokenReward({
    required FactoryToken token,
    required double totalReward,
  }) = _WorkerTokenReward;

  factory WorkerTokenReward.fromJson(Map<String, dynamic> json) =>
      _$WorkerTokenRewardFromJson(json);
}

@freezed
class WorkerLeaderboard with _$WorkerLeaderboard {
  const factory WorkerLeaderboard({
    required int rank,
    required String address,
    required int tasks,
    @JsonKey(
      toJson: DecimalJson.toJson,
      fromJson: DecimalJson.fromJson,
    )
    Decimal? rewards,
    required double avgScore,
    @Default(<WorkerTokenReward>[]) List<WorkerTokenReward> tokens,
    @Default(0.0) double totalUSD,
  }) = _WorkerLeaderboard;

  factory WorkerLeaderboard.fromJson(Map<String, dynamic> json) =>
      _$WorkerLeaderboardFromJson(json);
}
