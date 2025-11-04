import 'package:clones_desktop/utils/decimal_json.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_chain_reward.freezed.dart';
part 'on_chain_reward.g.dart';

@freezed
class OnChainReward with _$OnChainReward {
  const factory OnChainReward({
    required String tokenAddress,
    required String poolAddress,
    required double amount,
    @JsonKey(
      toJson: DecimalJson.toJson,
      fromJson: DecimalJson.fromJson,
    )
    Decimal? grossAmount,
    @JsonKey(
      toJson: DecimalJson.toJson,
      fromJson: DecimalJson.fromJson,
    )
    Decimal? feeAmount,
    @JsonKey(
      toJson: DecimalJson.toJson,
      fromJson: DecimalJson.fromJson,
    )
    Decimal? netAmount,
    String? submissionId,
    String? txHash,
    int? timestamp,
    @JsonKey(
      toJson: DecimalJson.toJson,
      fromJson: DecimalJson.fromJson,
    )
    Decimal? cumulativeAmount,
  }) = _OnChainReward;

  factory OnChainReward.fromJson(Map<String, dynamic> json) =>
      _$OnChainRewardFromJson(json);
}
