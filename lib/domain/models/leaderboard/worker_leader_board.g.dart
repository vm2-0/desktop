// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_leader_board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkerTokenRewardImpl _$$WorkerTokenRewardImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkerTokenRewardImpl(
      token: FactoryToken.fromJson(json['token'] as Map<String, dynamic>),
      totalReward: (json['totalReward'] as num).toDouble(),
    );

Map<String, dynamic> _$$WorkerTokenRewardImplToJson(
        _$WorkerTokenRewardImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'totalReward': instance.totalReward,
    };

_$WorkerLeaderboardImpl _$$WorkerLeaderboardImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkerLeaderboardImpl(
      rank: (json['rank'] as num).toInt(),
      address: json['address'] as String,
      tasks: (json['tasks'] as num).toInt(),
      rewards: DecimalJson.fromJson(json['rewards']),
      avgScore: (json['avgScore'] as num).toDouble(),
      tokens: (json['tokens'] as List<dynamic>?)
              ?.map(
                  (e) => WorkerTokenReward.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WorkerTokenReward>[],
      totalUSD: (json['totalUSD'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$WorkerLeaderboardImplToJson(
        _$WorkerLeaderboardImpl instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'address': instance.address,
      'tasks': instance.tasks,
      'rewards': DecimalJson.toJson(instance.rewards),
      'avgScore': instance.avgScore,
      'tokens': instance.tokens,
      'totalUSD': instance.totalUSD,
    };
