// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FactoryImpl _$$FactoryImplFromJson(Map<String, dynamic> json) =>
    _$FactoryImpl(
      id: json['id'] as String,
      poolAddress: json['poolAddress'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      ownerAddress: json['ownerAddress'] as String,
      status: $enumDecode(_$FactoryStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      token: FactoryToken.fromJson(json['token'] as Map<String, dynamic>),
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      totalEarned: DecimalJson.fromJson(json['totalEarned']),
      demonstrations: (json['demonstrations'] as num?)?.toInt() ?? 0,
      uploadLimit: json['uploadLimit'] == null
          ? null
          : FactoryUploadLimit.fromJson(
              json['uploadLimit'] as Map<String, dynamic>),
      apps: (json['apps'] as List<dynamic>?)
              ?.map((e) => FactoryApp.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      searchText: json['searchText'] as String? ?? '',
      expanded: json['expanded'] as bool? ?? false,
      isLoading: json['isLoading'] as bool? ?? false,
    );

Map<String, dynamic> _$$FactoryImplToJson(_$FactoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'poolAddress': instance.poolAddress,
      'name': instance.name,
      'description': instance.description,
      'ownerAddress': instance.ownerAddress,
      'status': _$FactoryStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'skills': instance.skills,
      'token': instance.token,
      'balance': instance.balance,
      'totalEarned': DecimalJson.toJson(instance.totalEarned),
      'demonstrations': instance.demonstrations,
      'uploadLimit': instance.uploadLimit,
      'apps': instance.apps,
      'searchText': instance.searchText,
      'expanded': instance.expanded,
      'isLoading': instance.isLoading,
    };

const _$FactoryStatusEnumMap = {
  FactoryStatus.active: 'active',
  FactoryStatus.paused: 'paused',
  FactoryStatus.error: 'error',
  FactoryStatus.noFunds: 'no-funds',
};
