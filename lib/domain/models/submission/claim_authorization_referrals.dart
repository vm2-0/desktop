// ignore_for_file: invalid_annotation_target

import 'package:clones_desktop/utils/decimal_json.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'claim_authorization_referrals.freezed.dart';
part 'claim_authorization_referrals.g.dart';

@freezed
class ClaimAuthorizationReferrals with _$ClaimAuthorizationReferrals {
  const factory ClaimAuthorizationReferrals({
    required String address,
    @JsonKey(
      toJson: DecimalJson.toJson,
      fromJson: DecimalJson.fromJson,
    )
    required Decimal? amount,
    required String type,
  }) = _ClaimAuthorizationReferrals;

  factory ClaimAuthorizationReferrals.fromJson(Map<String, dynamic> json) =>
      _$ClaimAuthorizationReferralsFromJson(json);
}
