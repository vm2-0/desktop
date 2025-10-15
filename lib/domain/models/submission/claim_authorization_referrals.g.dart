// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_authorization_referrals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClaimAuthorizationReferralsImpl _$$ClaimAuthorizationReferralsImplFromJson(
        Map<String, dynamic> json) =>
    _$ClaimAuthorizationReferralsImpl(
      address: json['address'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$$ClaimAuthorizationReferralsImplToJson(
        _$ClaimAuthorizationReferralsImpl instance) =>
    <String, dynamic>{
      'address': instance.address,
      'amount': instance.amount,
      'type': instance.type,
    };
