// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factory_search_criteria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FactorySearchCriteriaImpl _$$FactorySearchCriteriaImplFromJson(
        Map<String, dynamic> json) =>
    _$FactorySearchCriteriaImpl(
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      searchTerm: json['searchTerm'] as String?,
      creator: json['creator'] as String?,
      token: json['token'] as String?,
      minBalance: (json['minBalance'] as num?)?.toDouble(),
      maxBalance: (json['maxBalance'] as num?)?.toDouble(),
      status: $enumDecodeNullable(_$FactoryStatusEnumMap, json['status']),
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      sortBy: json['sortBy'] as String? ?? 'createdAt',
      sortOrder: json['sortOrder'] as String? ?? 'desc',
    );

Map<String, dynamic> _$$FactorySearchCriteriaImplToJson(
        _$FactorySearchCriteriaImpl instance) =>
    <String, dynamic>{
      'skills': instance.skills,
      'searchTerm': instance.searchTerm,
      'creator': instance.creator,
      'token': instance.token,
      'minBalance': instance.minBalance,
      'maxBalance': instance.maxBalance,
      'status': _$FactoryStatusEnumMap[instance.status],
      'limit': instance.limit,
      'offset': instance.offset,
      'sortBy': instance.sortBy,
      'sortOrder': instance.sortOrder,
    };

const _$FactoryStatusEnumMap = {
  FactoryStatus.active: 'active',
  FactoryStatus.paused: 'paused',
  FactoryStatus.error: 'error',
  FactoryStatus.noFunds: 'no-funds',
  FactoryStatus.archived: 'archived',
};
