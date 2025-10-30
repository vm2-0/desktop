// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'factory_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FactoryFilter _$FactoryFilterFromJson(Map<String, dynamic> json) {
  return _FactoryFilter.fromJson(json);
}

/// @nodoc
mixin _$FactoryFilter {
  String? get poolId => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get query => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  List<String>? get categories => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  bool? get hideAdult => throw _privateConstructorUsedError;

  /// Serializes this FactoryFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FactoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FactoryFilterCopyWith<FactoryFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FactoryFilterCopyWith<$Res> {
  factory $FactoryFilterCopyWith(
          FactoryFilter value, $Res Function(FactoryFilter) then) =
      _$FactoryFilterCopyWithImpl<$Res, FactoryFilter>;
  @useResult
  $Res call(
      {String? poolId,
      @JsonKey(includeIfNull: false) String? query,
      @JsonKey(includeIfNull: false) List<String>? categories,
      @JsonKey(includeIfNull: false) bool? hideAdult});
}

/// @nodoc
class _$FactoryFilterCopyWithImpl<$Res, $Val extends FactoryFilter>
    implements $FactoryFilterCopyWith<$Res> {
  _$FactoryFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FactoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poolId = freezed,
    Object? query = freezed,
    Object? categories = freezed,
    Object? hideAdult = freezed,
  }) {
    return _then(_value.copyWith(
      poolId: freezed == poolId
          ? _value.poolId
          : poolId // ignore: cast_nullable_to_non_nullable
              as String?,
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: freezed == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hideAdult: freezed == hideAdult
          ? _value.hideAdult
          : hideAdult // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FactoryFilterImplCopyWith<$Res>
    implements $FactoryFilterCopyWith<$Res> {
  factory _$$FactoryFilterImplCopyWith(
          _$FactoryFilterImpl value, $Res Function(_$FactoryFilterImpl) then) =
      __$$FactoryFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? poolId,
      @JsonKey(includeIfNull: false) String? query,
      @JsonKey(includeIfNull: false) List<String>? categories,
      @JsonKey(includeIfNull: false) bool? hideAdult});
}

/// @nodoc
class __$$FactoryFilterImplCopyWithImpl<$Res>
    extends _$FactoryFilterCopyWithImpl<$Res, _$FactoryFilterImpl>
    implements _$$FactoryFilterImplCopyWith<$Res> {
  __$$FactoryFilterImplCopyWithImpl(
      _$FactoryFilterImpl _value, $Res Function(_$FactoryFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of FactoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poolId = freezed,
    Object? query = freezed,
    Object? categories = freezed,
    Object? hideAdult = freezed,
  }) {
    return _then(_$FactoryFilterImpl(
      poolId: freezed == poolId
          ? _value.poolId
          : poolId // ignore: cast_nullable_to_non_nullable
              as String?,
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: freezed == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hideAdult: freezed == hideAdult
          ? _value.hideAdult
          : hideAdult // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FactoryFilterImpl implements _FactoryFilter {
  const _$FactoryFilterImpl(
      {this.poolId,
      @JsonKey(includeIfNull: false) this.query,
      @JsonKey(includeIfNull: false) final List<String>? categories,
      @JsonKey(includeIfNull: false) this.hideAdult})
      : _categories = categories;

  factory _$FactoryFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$FactoryFilterImplFromJson(json);

  @override
  final String? poolId;
  @override
  @JsonKey(includeIfNull: false)
  final String? query;
  final List<String>? _categories;
  @override
  @JsonKey(includeIfNull: false)
  List<String>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(includeIfNull: false)
  final bool? hideAdult;

  @override
  String toString() {
    return 'FactoryFilter(poolId: $poolId, query: $query, categories: $categories, hideAdult: $hideAdult)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FactoryFilterImpl &&
            (identical(other.poolId, poolId) || other.poolId == poolId) &&
            (identical(other.query, query) || other.query == query) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.hideAdult, hideAdult) ||
                other.hideAdult == hideAdult));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, poolId, query,
      const DeepCollectionEquality().hash(_categories), hideAdult);

  /// Create a copy of FactoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FactoryFilterImplCopyWith<_$FactoryFilterImpl> get copyWith =>
      __$$FactoryFilterImplCopyWithImpl<_$FactoryFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FactoryFilterImplToJson(
      this,
    );
  }
}

abstract class _FactoryFilter implements FactoryFilter {
  const factory _FactoryFilter(
          {final String? poolId,
          @JsonKey(includeIfNull: false) final String? query,
          @JsonKey(includeIfNull: false) final List<String>? categories,
          @JsonKey(includeIfNull: false) final bool? hideAdult}) =
      _$FactoryFilterImpl;

  factory _FactoryFilter.fromJson(Map<String, dynamic> json) =
      _$FactoryFilterImpl.fromJson;

  @override
  String? get poolId;
  @override
  @JsonKey(includeIfNull: false)
  String? get query;
  @override
  @JsonKey(includeIfNull: false)
  List<String>? get categories;
  @override
  @JsonKey(includeIfNull: false)
  bool? get hideAdult;

  /// Create a copy of FactoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FactoryFilterImplCopyWith<_$FactoryFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
