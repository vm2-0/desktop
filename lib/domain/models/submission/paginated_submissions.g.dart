// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_submissions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedSubmissionsImpl _$$PaginatedSubmissionsImplFromJson(
        Map<String, dynamic> json) =>
    _$PaginatedSubmissionsImpl(
      submissions: (json['submissions'] as List<dynamic>)
          .map((e) => SubmissionStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
      hasMore: json['hasMore'] as bool,
    );

Map<String, dynamic> _$$PaginatedSubmissionsImplToJson(
        _$PaginatedSubmissionsImpl instance) =>
    <String, dynamic>{
      'submissions': instance.submissions,
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
      'hasMore': instance.hasMore,
    };
