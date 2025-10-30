// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factory_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FactoryFilterImpl _$$FactoryFilterImplFromJson(Map<String, dynamic> json) =>
    _$FactoryFilterImpl(
      poolId: json['poolId'] as String?,
      query: json['query'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hideAdult: json['hideAdult'] as bool?,
    );

Map<String, dynamic> _$$FactoryFilterImplToJson(_$FactoryFilterImpl instance) =>
    <String, dynamic>{
      'poolId': instance.poolId,
      if (instance.query case final value?) 'query': value,
      if (instance.categories case final value?) 'categories': value,
      if (instance.hideAdult case final value?) 'hideAdult': value,
    };
