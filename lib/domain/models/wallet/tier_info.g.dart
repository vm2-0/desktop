// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tier_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TierInfoImpl _$$TierInfoImplFromJson(Map<String, dynamic> json) =>
    _$TierInfoImpl(
      tierCode: json['tierCode'] as String,
      tierName: json['tierName'] as String,
      commissionPercentage: (json['commissionPercentage'] as num).toDouble(),
      clonesBalance: (json['clonesBalance'] as num).toDouble(),
      minHolding: (json['minHolding'] as num).toDouble(),
      maxHolding: (json['maxHolding'] as num?)?.toDouble(),
      nextTierMinHolding: (json['nextTierMinHolding'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TierInfoImplToJson(_$TierInfoImpl instance) =>
    <String, dynamic>{
      'tierCode': instance.tierCode,
      'tierName': instance.tierName,
      'commissionPercentage': instance.commissionPercentage,
      'clonesBalance': instance.clonesBalance,
      'minHolding': instance.minHolding,
      'maxHolding': instance.maxHolding,
      'nextTierMinHolding': instance.nextTierMinHolding,
    };
