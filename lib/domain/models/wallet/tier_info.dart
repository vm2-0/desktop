import 'package:freezed_annotation/freezed_annotation.dart';

part 'tier_info.freezed.dart';
part 'tier_info.g.dart';

@freezed
class TierInfo with _$TierInfo {
  const factory TierInfo({
    required String tierCode,
    required String tierName,
    required double commissionPercentage,
    required double clonesBalance,
    required double minHolding,
    double? maxHolding,
    double? nextTierMinHolding,
  }) = _TierInfo;
  const TierInfo._();

  factory TierInfo.fromJson(Map<String, dynamic> json) =>
      _$TierInfoFromJson(json);

  /// Get formatted commission percentage (e.g., "3.5%")
  String get formattedCommissionPercentage =>
      '${commissionPercentage.toStringAsFixed(1)}%';

  /// Get tokens needed for next tier
  double? get tokensNeededForNextTier {
    if (nextTierMinHolding == null) return null;
    return nextTierMinHolding! - clonesBalance;
  }

  /// Get formatted tokens needed for next tier
  String? get formattedTokensNeededForNextTier {
    final tokensNeeded = tokensNeededForNextTier;
    if (tokensNeeded == null || tokensNeeded <= 0) return null;

    if (tokensNeeded >= 1000000) {
      return '${(tokensNeeded / 1000000).toStringAsFixed(1)}M';
    } else if (tokensNeeded >= 1000) {
      return '${(tokensNeeded / 1000).toStringAsFixed(1)}K';
    } else {
      return tokensNeeded.toStringAsFixed(0);
    }
  }

  /// Get formatted tokens needed for next tier
  String? get formattedNextTierMinHolding {
    final nextTiersAmount = nextTierMinHolding;
    if (nextTiersAmount == null || nextTiersAmount <= 0) return null;

    if (nextTiersAmount >= 1000000) {
      return '${(nextTiersAmount / 1000000).toStringAsFixed(1)}M';
    } else if (nextTiersAmount >= 1000) {
      return '${(nextTiersAmount / 1000).toStringAsFixed(1)}K';
    } else {
      return nextTiersAmount.toStringAsFixed(0);
    }
  }

  /// Check if user is at max tier
  bool get isMaxTier => nextTierMinHolding == null;
}
