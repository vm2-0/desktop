// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_referral_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateReferralResponseImpl _$$CreateReferralResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateReferralResponseImpl(
      referralCode: json['referralCode'] as String,
      walletAddress: json['walletAddress'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CreateReferralResponseImplToJson(
        _$CreateReferralResponseImpl instance) =>
    <String, dynamic>{
      'referralCode': instance.referralCode,
      'walletAddress': instance.walletAddress,
      'createdAt': instance.createdAt.toIso8601String(),
    };
