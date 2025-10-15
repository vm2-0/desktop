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
      alreadyClaimed: (json['alreadyClaimed'] as num?)?.toDouble(),
      newClaimableAmount: (json['newClaimableAmount'] as num?)?.toDouble(),
      feePercentage: (json['feePercentage'] as num?)?.toDouble(),
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
      'alreadyClaimed': instance.alreadyClaimed,
      'newClaimableAmount': instance.newClaimableAmount,
      'feePercentage': instance.feePercentage,
      'referrals': instance.referrals,
    };
