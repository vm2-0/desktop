// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_authorization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClaimAuthorizationImpl _$$ClaimAuthorizationImplFromJson(
        Map<String, dynamic> json) =>
    _$ClaimAuthorizationImpl(
      account: json['account'] as String,
      cumulativeAmount: json['cumulativeAmount'] as String,
      nonce: (json['nonce'] as num?)?.toInt(),
      deadline: (json['deadline'] as num?)?.toInt(),
      signature: json['signature'] as String,
      publisherUsed: json['publisherUsed'] as String,
      poolAddress: json['poolAddress'] as String,
      tokenAddress: json['tokenAddress'] as String,
      alreadyClaimed: DecimalJson.fromJson(json['alreadyClaimed']),
      newClaimableAmount: DecimalJson.fromJson(json['newClaimableAmount']),
      feePercentage: DecimalJson.fromJson(json['feePercentage']),
      referrals: (json['referrals'] as List<dynamic>?)
          ?.map((e) =>
              ClaimAuthorizationReferrals.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ClaimAuthorizationImplToJson(
        _$ClaimAuthorizationImpl instance) =>
    <String, dynamic>{
      'account': instance.account,
      'cumulativeAmount': instance.cumulativeAmount,
      'nonce': instance.nonce,
      'deadline': instance.deadline,
      'signature': instance.signature,
      'publisherUsed': instance.publisherUsed,
      'poolAddress': instance.poolAddress,
      'tokenAddress': instance.tokenAddress,
      'alreadyClaimed': DecimalJson.toJson(instance.alreadyClaimed),
      'newClaimableAmount': DecimalJson.toJson(instance.newClaimableAmount),
      'feePercentage': DecimalJson.toJson(instance.feePercentage),
      'referrals': instance.referrals,
    };
