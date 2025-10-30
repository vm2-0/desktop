// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskFilter _$TaskFilterFromJson(Map<String, dynamic> json) {
  return _TaskFilter.fromJson(json);
}

/// @nodoc
mixin _$TaskFilter {
  String? get poolId => throw _privateConstructorUsedError;
  List<String>? get categories => throw _privateConstructorUsedError;
  String? get query => throw _privateConstructorUsedError;
  bool get hideAdult => throw _privateConstructorUsedError;

  /// Serializes this TaskFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskFilterCopyWith<TaskFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskFilterCopyWith<$Res> {
  factory $TaskFilterCopyWith(
          TaskFilter value, $Res Function(TaskFilter) then) =
      _$TaskFilterCopyWithImpl<$Res, TaskFilter>;
  @useResult
  $Res call(
      {String? poolId,
      List<String>? categories,
      String? query,
      bool hideAdult});
}

/// @nodoc
class _$TaskFilterCopyWithImpl<$Res, $Val extends TaskFilter>
    implements $TaskFilterCopyWith<$Res> {
  _$TaskFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poolId = freezed,
    Object? categories = freezed,
    Object? query = freezed,
    Object? hideAdult = null,
  }) {
    return _then(_value.copyWith(
      poolId: freezed == poolId
          ? _value.poolId
          : poolId // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: freezed == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      hideAdult: null == hideAdult
          ? _value.hideAdult
          : hideAdult // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskFilterImplCopyWith<$Res>
    implements $TaskFilterCopyWith<$Res> {
  factory _$$TaskFilterImplCopyWith(
          _$TaskFilterImpl value, $Res Function(_$TaskFilterImpl) then) =
      __$$TaskFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? poolId,
      List<String>? categories,
      String? query,
      bool hideAdult});
}

/// @nodoc
class __$$TaskFilterImplCopyWithImpl<$Res>
    extends _$TaskFilterCopyWithImpl<$Res, _$TaskFilterImpl>
    implements _$$TaskFilterImplCopyWith<$Res> {
  __$$TaskFilterImplCopyWithImpl(
      _$TaskFilterImpl _value, $Res Function(_$TaskFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poolId = freezed,
    Object? categories = freezed,
    Object? query = freezed,
    Object? hideAdult = null,
  }) {
    return _then(_$TaskFilterImpl(
      poolId: freezed == poolId
          ? _value.poolId
          : poolId // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: freezed == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      hideAdult: null == hideAdult
          ? _value.hideAdult
          : hideAdult // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskFilterImpl implements _TaskFilter {
  const _$TaskFilterImpl(
      {this.poolId,
      final List<String>? categories,
      this.query,
      this.hideAdult = true})
      : _categories = categories;

  factory _$TaskFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskFilterImplFromJson(json);

  @override
  final String? poolId;
  final List<String>? _categories;
  @override
  List<String>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? query;
  @override
  @JsonKey()
  final bool hideAdult;

  @override
  String toString() {
    return 'TaskFilter(poolId: $poolId, categories: $categories, query: $query, hideAdult: $hideAdult)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskFilterImpl &&
            (identical(other.poolId, poolId) || other.poolId == poolId) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.hideAdult, hideAdult) ||
                other.hideAdult == hideAdult));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, poolId,
      const DeepCollectionEquality().hash(_categories), query, hideAdult);

  /// Create a copy of TaskFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskFilterImplCopyWith<_$TaskFilterImpl> get copyWith =>
      __$$TaskFilterImplCopyWithImpl<_$TaskFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskFilterImplToJson(
      this,
    );
  }
}

abstract class _TaskFilter implements TaskFilter {
  const factory _TaskFilter(
      {final String? poolId,
      final List<String>? categories,
      final String? query,
      final bool hideAdult}) = _$TaskFilterImpl;

  factory _TaskFilter.fromJson(Map<String, dynamic> json) =
      _$TaskFilterImpl.fromJson;

  @override
  String? get poolId;
  @override
  List<String>? get categories;
  @override
  String? get query;
  @override
  bool get hideAdult;

  /// Create a copy of TaskFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskFilterImplCopyWith<_$TaskFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
