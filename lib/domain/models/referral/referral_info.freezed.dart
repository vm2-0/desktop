// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'referral_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReferralInfo _$ReferralInfoFromJson(Map<String, dynamic> json) {
  return _ReferralInfo.fromJson(json);
}

/// @nodoc
mixin _$ReferralInfo {
  String get referralCode => throw _privateConstructorUsedError;
  String get walletAddress => throw _privateConstructorUsedError;
  int get totalReferrals => throw _privateConstructorUsedError;
  double get totalRewards => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this ReferralInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReferralInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReferralInfoCopyWith<ReferralInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReferralInfoCopyWith<$Res> {
  factory $ReferralInfoCopyWith(
          ReferralInfo value, $Res Function(ReferralInfo) then) =
      _$ReferralInfoCopyWithImpl<$Res, ReferralInfo>;
  @useResult
  $Res call(
      {String referralCode,
      String walletAddress,
      int totalReferrals,
      double totalRewards,
      bool isActive,
      DateTime createdAt,
      DateTime? lastUpdated,
      DateTime? expiresAt});
}

/// @nodoc
class _$ReferralInfoCopyWithImpl<$Res, $Val extends ReferralInfo>
    implements $ReferralInfoCopyWith<$Res> {
  _$ReferralInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReferralInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? referralCode = null,
    Object? walletAddress = null,
    Object? totalReferrals = null,
    Object? totalRewards = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? lastUpdated = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      referralCode: null == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String,
      walletAddress: null == walletAddress
          ? _value.walletAddress
          : walletAddress // ignore: cast_nullable_to_non_nullable
              as String,
      totalReferrals: null == totalReferrals
          ? _value.totalReferrals
          : totalReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      totalRewards: null == totalRewards
          ? _value.totalRewards
          : totalRewards // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReferralInfoImplCopyWith<$Res>
    implements $ReferralInfoCopyWith<$Res> {
  factory _$$ReferralInfoImplCopyWith(
          _$ReferralInfoImpl value, $Res Function(_$ReferralInfoImpl) then) =
      __$$ReferralInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String referralCode,
      String walletAddress,
      int totalReferrals,
      double totalRewards,
      bool isActive,
      DateTime createdAt,
      DateTime? lastUpdated,
      DateTime? expiresAt});
}

/// @nodoc
class __$$ReferralInfoImplCopyWithImpl<$Res>
    extends _$ReferralInfoCopyWithImpl<$Res, _$ReferralInfoImpl>
    implements _$$ReferralInfoImplCopyWith<$Res> {
  __$$ReferralInfoImplCopyWithImpl(
      _$ReferralInfoImpl _value, $Res Function(_$ReferralInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReferralInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? referralCode = null,
    Object? walletAddress = null,
    Object? totalReferrals = null,
    Object? totalRewards = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? lastUpdated = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_$ReferralInfoImpl(
      referralCode: null == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String,
      walletAddress: null == walletAddress
          ? _value.walletAddress
          : walletAddress // ignore: cast_nullable_to_non_nullable
              as String,
      totalReferrals: null == totalReferrals
          ? _value.totalReferrals
          : totalReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      totalRewards: null == totalRewards
          ? _value.totalRewards
          : totalRewards // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReferralInfoImpl implements _ReferralInfo {
  const _$ReferralInfoImpl(
      {required this.referralCode,
      required this.walletAddress,
      required this.totalReferrals,
      required this.totalRewards,
      required this.isActive,
      required this.createdAt,
      this.lastUpdated,
      this.expiresAt});

  factory _$ReferralInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReferralInfoImplFromJson(json);

  @override
  final String referralCode;
  @override
  final String walletAddress;
  @override
  final int totalReferrals;
  @override
  final double totalRewards;
  @override
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime? lastUpdated;
  @override
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'ReferralInfo(referralCode: $referralCode, walletAddress: $walletAddress, totalReferrals: $totalReferrals, totalRewards: $totalRewards, isActive: $isActive, createdAt: $createdAt, lastUpdated: $lastUpdated, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReferralInfoImpl &&
            (identical(other.referralCode, referralCode) ||
                other.referralCode == referralCode) &&
            (identical(other.walletAddress, walletAddress) ||
                other.walletAddress == walletAddress) &&
            (identical(other.totalReferrals, totalReferrals) ||
                other.totalReferrals == totalReferrals) &&
            (identical(other.totalRewards, totalRewards) ||
                other.totalRewards == totalRewards) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      referralCode,
      walletAddress,
      totalReferrals,
      totalRewards,
      isActive,
      createdAt,
      lastUpdated,
      expiresAt);

  /// Create a copy of ReferralInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReferralInfoImplCopyWith<_$ReferralInfoImpl> get copyWith =>
      __$$ReferralInfoImplCopyWithImpl<_$ReferralInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReferralInfoImplToJson(
      this,
    );
  }
}

abstract class _ReferralInfo implements ReferralInfo {
  const factory _ReferralInfo(
      {required final String referralCode,
      required final String walletAddress,
      required final int totalReferrals,
      required final double totalRewards,
      required final bool isActive,
      required final DateTime createdAt,
      final DateTime? lastUpdated,
      final DateTime? expiresAt}) = _$ReferralInfoImpl;

  factory _ReferralInfo.fromJson(Map<String, dynamic> json) =
      _$ReferralInfoImpl.fromJson;

  @override
  String get referralCode;
  @override
  String get walletAddress;
  @override
  int get totalReferrals;
  @override
  double get totalRewards;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime? get lastUpdated;
  @override
  DateTime? get expiresAt;

  /// Create a copy of ReferralInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReferralInfoImplCopyWith<_$ReferralInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
