import 'package:clones_desktop/domain/models/submission/claim_authorization_referrals.dart';
import 'package:clones_desktop/utils/decimal_json.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'claim_authorization.freezed.dart';
part 'claim_authorization.g.dart';

/// EIP-712 claim authorization data for smart contract interaction
@freezed
class ClaimAuthorization with _$ClaimAuthorization {
  const factory ClaimAuthorization({
    /// Account address (farmer who can claim)
    required String account,

    /// Cumulative amount in wei (string to preserve precision)
    required String cumulativeAmount,

    /// Nonce for replay protection
    int? nonce,

    /// Signature deadline (unix timestamp)
    int? deadline,

    /// EIP-712 signature for payWithSig()
    required String signature,

    /// Publisher address that signed this authorization
    required String publisherUsed,

    /// Pool contract address
    required String poolAddress,

    /// Token contract address
    required String tokenAddress,

    /// Already claimed amount
    @JsonKey(
      toJson: DecimalJson.toJson,
      fromJson: DecimalJson.fromJson,
    )
    Decimal? alreadyClaimed,

    /// New claimable amount
    @JsonKey(
      toJson: DecimalJson.toJson,
      fromJson: DecimalJson.fromJson,
    )
    Decimal? newClaimableAmount,

    /// Platform fee percentage (e.g. 10.0 for 10%)
    @JsonKey(
      toJson: DecimalJson.toJson,
      fromJson: DecimalJson.fromJson,
    )
    Decimal? feePercentage,

    /// Referrals
    List<ClaimAuthorizationReferrals>? referrals,
  }) = _ClaimAuthorization;

  factory ClaimAuthorization.fromJson(Map<String, dynamic> json) =>
      _$ClaimAuthorizationFromJson(json);
}
