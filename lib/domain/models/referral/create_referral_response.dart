import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_referral_response.freezed.dart';
part 'create_referral_response.g.dart';

@freezed
class CreateReferralResponse with _$CreateReferralResponse {
  const factory CreateReferralResponse({
    required String referralCode,
    required String walletAddress,
    required DateTime createdAt,
  }) = _CreateReferralResponse;

  factory CreateReferralResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateReferralResponseFromJson(json);
}
