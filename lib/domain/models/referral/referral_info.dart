import 'package:clones_desktop/utils/decimal_json.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral_info.freezed.dart';
part 'referral_info.g.dart';

const int referrerCodeLength = 6;

@freezed
class ReferralInfo with _$ReferralInfo {
  const factory ReferralInfo({
    required String referralCode,
    required String walletAddress,
    required int totalReferrals,
    @JsonKey(
      toJson: DecimalJson.toJson,
      fromJson: DecimalJson.fromJson,
    )
    required Decimal? totalRewards,
    required bool isActive,
    required DateTime createdAt,
    DateTime? lastUpdated,
    DateTime? expiresAt,
  }) = _ReferralInfo;

  factory ReferralInfo.fromJson(Map<String, dynamic> json) =>
      _$ReferralInfoFromJson(json);
}
