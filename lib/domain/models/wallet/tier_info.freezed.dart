// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tier_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TierInfo _$TierInfoFromJson(Map<String, dynamic> json) {
  return _TierInfo.fromJson(json);
}

/// @nodoc
mixin _$TierInfo {
  String get tierCode => throw _privateConstructorUsedError;
  String get tierName => throw _privateConstructorUsedError;
  double get commissionPercentage => throw _privateConstructorUsedError;
  double get clonesBalance => throw _privateConstructorUsedError;
  double get minHolding => throw _privateConstructorUsedError;
  double? get maxHolding => throw _privateConstructorUsedError;
  double? get nextTierMinHolding => throw _privateConstructorUsedError;

  /// Serializes this TierInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TierInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TierInfoCopyWith<TierInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TierInfoCopyWith<$Res> {
  factory $TierInfoCopyWith(TierInfo value, $Res Function(TierInfo) then) =
      _$TierInfoCopyWithImpl<$Res, TierInfo>;
  @useResult
  $Res call(
      {String tierCode,
      String tierName,
      double commissionPercentage,
      double clonesBalance,
      double minHolding,
      double? maxHolding,
      double? nextTierMinHolding});
}

/// @nodoc
class _$TierInfoCopyWithImpl<$Res, $Val extends TierInfo>
    implements $TierInfoCopyWith<$Res> {
  _$TierInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TierInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tierCode = null,
    Object? tierName = null,
    Object? commissionPercentage = null,
    Object? clonesBalance = null,
    Object? minHolding = null,
    Object? maxHolding = freezed,
    Object? nextTierMinHolding = freezed,
  }) {
    return _then(_value.copyWith(
      tierCode: null == tierCode
          ? _value.tierCode
          : tierCode // ignore: cast_nullable_to_non_nullable
              as String,
      tierName: null == tierName
          ? _value.tierName
          : tierName // ignore: cast_nullable_to_non_nullable
              as String,
      commissionPercentage: null == commissionPercentage
          ? _value.commissionPercentage
          : commissionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      clonesBalance: null == clonesBalance
          ? _value.clonesBalance
          : clonesBalance // ignore: cast_nullable_to_non_nullable
              as double,
      minHolding: null == minHolding
          ? _value.minHolding
          : minHolding // ignore: cast_nullable_to_non_nullable
              as double,
      maxHolding: freezed == maxHolding
          ? _value.maxHolding
          : maxHolding // ignore: cast_nullable_to_non_nullable
              as double?,
      nextTierMinHolding: freezed == nextTierMinHolding
          ? _value.nextTierMinHolding
          : nextTierMinHolding // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TierInfoImplCopyWith<$Res>
    implements $TierInfoCopyWith<$Res> {
  factory _$$TierInfoImplCopyWith(
          _$TierInfoImpl value, $Res Function(_$TierInfoImpl) then) =
      __$$TierInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String tierCode,
      String tierName,
      double commissionPercentage,
      double clonesBalance,
      double minHolding,
      double? maxHolding,
      double? nextTierMinHolding});
}

/// @nodoc
class __$$TierInfoImplCopyWithImpl<$Res>
    extends _$TierInfoCopyWithImpl<$Res, _$TierInfoImpl>
    implements _$$TierInfoImplCopyWith<$Res> {
  __$$TierInfoImplCopyWithImpl(
      _$TierInfoImpl _value, $Res Function(_$TierInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TierInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tierCode = null,
    Object? tierName = null,
    Object? commissionPercentage = null,
    Object? clonesBalance = null,
    Object? minHolding = null,
    Object? maxHolding = freezed,
    Object? nextTierMinHolding = freezed,
  }) {
    return _then(_$TierInfoImpl(
      tierCode: null == tierCode
          ? _value.tierCode
          : tierCode // ignore: cast_nullable_to_non_nullable
              as String,
      tierName: null == tierName
          ? _value.tierName
          : tierName // ignore: cast_nullable_to_non_nullable
              as String,
      commissionPercentage: null == commissionPercentage
          ? _value.commissionPercentage
          : commissionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      clonesBalance: null == clonesBalance
          ? _value.clonesBalance
          : clonesBalance // ignore: cast_nullable_to_non_nullable
              as double,
      minHolding: null == minHolding
          ? _value.minHolding
          : minHolding // ignore: cast_nullable_to_non_nullable
              as double,
      maxHolding: freezed == maxHolding
          ? _value.maxHolding
          : maxHolding // ignore: cast_nullable_to_non_nullable
              as double?,
      nextTierMinHolding: freezed == nextTierMinHolding
          ? _value.nextTierMinHolding
          : nextTierMinHolding // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TierInfoImpl extends _TierInfo {
  const _$TierInfoImpl(
      {required this.tierCode,
      required this.tierName,
      required this.commissionPercentage,
      required this.clonesBalance,
      required this.minHolding,
      this.maxHolding,
      this.nextTierMinHolding})
      : super._();

  factory _$TierInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TierInfoImplFromJson(json);

  @override
  final String tierCode;
  @override
  final String tierName;
  @override
  final double commissionPercentage;
  @override
  final double clonesBalance;
  @override
  final double minHolding;
  @override
  final double? maxHolding;
  @override
  final double? nextTierMinHolding;

  @override
  String toString() {
    return 'TierInfo(tierCode: $tierCode, tierName: $tierName, commissionPercentage: $commissionPercentage, clonesBalance: $clonesBalance, minHolding: $minHolding, maxHolding: $maxHolding, nextTierMinHolding: $nextTierMinHolding)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TierInfoImpl &&
            (identical(other.tierCode, tierCode) ||
                other.tierCode == tierCode) &&
            (identical(other.tierName, tierName) ||
                other.tierName == tierName) &&
            (identical(other.commissionPercentage, commissionPercentage) ||
                other.commissionPercentage == commissionPercentage) &&
            (identical(other.clonesBalance, clonesBalance) ||
                other.clonesBalance == clonesBalance) &&
            (identical(other.minHolding, minHolding) ||
                other.minHolding == minHolding) &&
            (identical(other.maxHolding, maxHolding) ||
                other.maxHolding == maxHolding) &&
            (identical(other.nextTierMinHolding, nextTierMinHolding) ||
                other.nextTierMinHolding == nextTierMinHolding));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      tierCode,
      tierName,
      commissionPercentage,
      clonesBalance,
      minHolding,
      maxHolding,
      nextTierMinHolding);

  /// Create a copy of TierInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TierInfoImplCopyWith<_$TierInfoImpl> get copyWith =>
      __$$TierInfoImplCopyWithImpl<_$TierInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TierInfoImplToJson(
      this,
    );
  }
}

abstract class _TierInfo extends TierInfo {
  const factory _TierInfo(
      {required final String tierCode,
      required final String tierName,
      required final double commissionPercentage,
      required final double clonesBalance,
      required final double minHolding,
      final double? maxHolding,
      final double? nextTierMinHolding}) = _$TierInfoImpl;
  const _TierInfo._() : super._();

  factory _TierInfo.fromJson(Map<String, dynamic> json) =
      _$TierInfoImpl.fromJson;

  @override
  String get tierCode;
  @override
  String get tierName;
  @override
  double get commissionPercentage;
  @override
  double get clonesBalance;
  @override
  double get minHolding;
  @override
  double? get maxHolding;
  @override
  double? get nextTierMinHolding;

  /// Create a copy of TierInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TierInfoImplCopyWith<_$TierInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
