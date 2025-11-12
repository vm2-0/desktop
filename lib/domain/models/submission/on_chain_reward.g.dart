// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'on_chain_reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnChainRewardImpl _$$OnChainRewardImplFromJson(Map<String, dynamic> json) =>
    _$OnChainRewardImpl(
      poolAddress: json['poolAddress'] as String,
      amount: (json['amount'] as num).toDouble(),
      grossAmount: DecimalJson.fromJson(json['grossAmount']),
      feeAmount: DecimalJson.fromJson(json['feeAmount']),
      netAmount: DecimalJson.fromJson(json['netAmount']),
      submissionId: json['submissionId'] as String?,
      txHash: json['txHash'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt(),
      cumulativeAmount: DecimalJson.fromJson(json['cumulativeAmount']),
    );

Map<String, dynamic> _$$OnChainRewardImplToJson(_$OnChainRewardImpl instance) =>
    <String, dynamic>{
      'poolAddress': instance.poolAddress,
      'amount': instance.amount,
      'grossAmount': DecimalJson.toJson(instance.grossAmount),
      'feeAmount': DecimalJson.toJson(instance.feeAmount),
      'netAmount': DecimalJson.toJson(instance.netAmount),
      'submissionId': instance.submissionId,
      'txHash': instance.txHash,
      'timestamp': instance.timestamp,
      'cumulativeAmount': DecimalJson.toJson(instance.cumulativeAmount),
    };
