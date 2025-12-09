// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_submissions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaginatedSubmissions _$PaginatedSubmissionsFromJson(Map<String, dynamic> json) {
  return _PaginatedSubmissions.fromJson(json);
}

/// @nodoc
mixin _$PaginatedSubmissions {
  List<SubmissionStatus> get submissions => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  /// Serializes this PaginatedSubmissions to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedSubmissions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedSubmissionsCopyWith<PaginatedSubmissions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedSubmissionsCopyWith<$Res> {
  factory $PaginatedSubmissionsCopyWith(PaginatedSubmissions value,
          $Res Function(PaginatedSubmissions) then) =
      _$PaginatedSubmissionsCopyWithImpl<$Res, PaginatedSubmissions>;
  @useResult
  $Res call(
      {List<SubmissionStatus> submissions,
      int total,
      int limit,
      int offset,
      bool hasMore});
}

/// @nodoc
class _$PaginatedSubmissionsCopyWithImpl<$Res,
        $Val extends PaginatedSubmissions>
    implements $PaginatedSubmissionsCopyWith<$Res> {
  _$PaginatedSubmissionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedSubmissions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? submissions = null,
    Object? total = null,
    Object? limit = null,
    Object? offset = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      submissions: null == submissions
          ? _value.submissions
          : submissions // ignore: cast_nullable_to_non_nullable
              as List<SubmissionStatus>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginatedSubmissionsImplCopyWith<$Res>
    implements $PaginatedSubmissionsCopyWith<$Res> {
  factory _$$PaginatedSubmissionsImplCopyWith(_$PaginatedSubmissionsImpl value,
          $Res Function(_$PaginatedSubmissionsImpl) then) =
      __$$PaginatedSubmissionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SubmissionStatus> submissions,
      int total,
      int limit,
      int offset,
      bool hasMore});
}

/// @nodoc
class __$$PaginatedSubmissionsImplCopyWithImpl<$Res>
    extends _$PaginatedSubmissionsCopyWithImpl<$Res, _$PaginatedSubmissionsImpl>
    implements _$$PaginatedSubmissionsImplCopyWith<$Res> {
  __$$PaginatedSubmissionsImplCopyWithImpl(_$PaginatedSubmissionsImpl _value,
      $Res Function(_$PaginatedSubmissionsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginatedSubmissions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? submissions = null,
    Object? total = null,
    Object? limit = null,
    Object? offset = null,
    Object? hasMore = null,
  }) {
    return _then(_$PaginatedSubmissionsImpl(
      submissions: null == submissions
          ? _value._submissions
          : submissions // ignore: cast_nullable_to_non_nullable
              as List<SubmissionStatus>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedSubmissionsImpl implements _PaginatedSubmissions {
  const _$PaginatedSubmissionsImpl(
      {required final List<SubmissionStatus> submissions,
      required this.total,
      required this.limit,
      required this.offset,
      required this.hasMore})
      : _submissions = submissions;

  factory _$PaginatedSubmissionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginatedSubmissionsImplFromJson(json);

  final List<SubmissionStatus> _submissions;
  @override
  List<SubmissionStatus> get submissions {
    if (_submissions is EqualUnmodifiableListView) return _submissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_submissions);
  }

  @override
  final int total;
  @override
  final int limit;
  @override
  final int offset;
  @override
  final bool hasMore;

  @override
  String toString() {
    return 'PaginatedSubmissions(submissions: $submissions, total: $total, limit: $limit, offset: $offset, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedSubmissionsImpl &&
            const DeepCollectionEquality()
                .equals(other._submissions, _submissions) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_submissions),
      total,
      limit,
      offset,
      hasMore);

  /// Create a copy of PaginatedSubmissions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedSubmissionsImplCopyWith<_$PaginatedSubmissionsImpl>
      get copyWith =>
          __$$PaginatedSubmissionsImplCopyWithImpl<_$PaginatedSubmissionsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedSubmissionsImplToJson(
      this,
    );
  }
}

abstract class _PaginatedSubmissions implements PaginatedSubmissions {
  const factory _PaginatedSubmissions(
      {required final List<SubmissionStatus> submissions,
      required final int total,
      required final int limit,
      required final int offset,
      required final bool hasMore}) = _$PaginatedSubmissionsImpl;

  factory _PaginatedSubmissions.fromJson(Map<String, dynamic> json) =
      _$PaginatedSubmissionsImpl.fromJson;

  @override
  List<SubmissionStatus> get submissions;
  @override
  int get total;
  @override
  int get limit;
  @override
  int get offset;
  @override
  bool get hasMore;

  /// Create a copy of PaginatedSubmissions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedSubmissionsImplCopyWith<_$PaginatedSubmissionsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
