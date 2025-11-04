import 'package:clones_desktop/domain/models/referral/referral.dart';
import 'package:clones_desktop/utils/decimal_json.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_referral_info_response.freezed.dart';
part 'get_referral_info_response.g.dart';

@freezed
class GetReferralInfoResponse with _$GetReferralInfoResponse {
  const factory GetReferralInfoResponse({
    required String walletAddress,
    required String referralCode,
    required bool isActive,
    required int totalReferrals,
    @JsonKey(
      toJson: DecimalJson.toJson,
      fromJson: DecimalJson.fromJson,
    )
    required Decimal? totalRewards,
    required DateTime createdAt,
    DateTime? lastUpdated,
    DateTime? expiresAt,
    List<Referral>? referrals,
  }) = _GetReferralInfoResponse;

  factory GetReferralInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$GetReferralInfoResponseFromJson(json);
}
