// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_referral_info_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetReferralInfoResponse _$GetReferralInfoResponseFromJson(
    Map<String, dynamic> json) {
  return _GetReferralInfoResponse.fromJson(json);
}

/// @nodoc
mixin _$GetReferralInfoResponse {
  String get walletAddress => throw _privateConstructorUsedError;
  String get referralCode => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get totalReferrals => throw _privateConstructorUsedError;
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get totalRewards => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  List<Referral>? get referrals => throw _privateConstructorUsedError;

  /// Serializes this GetReferralInfoResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetReferralInfoResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetReferralInfoResponseCopyWith<GetReferralInfoResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetReferralInfoResponseCopyWith<$Res> {
  factory $GetReferralInfoResponseCopyWith(GetReferralInfoResponse value,
          $Res Function(GetReferralInfoResponse) then) =
      _$GetReferralInfoResponseCopyWithImpl<$Res, GetReferralInfoResponse>;
  @useResult
  $Res call(
      {String walletAddress,
      String referralCode,
      bool isActive,
      int totalReferrals,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? totalRewards,
      DateTime createdAt,
      DateTime? lastUpdated,
      DateTime? expiresAt,
      List<Referral>? referrals});
}

/// @nodoc
class _$GetReferralInfoResponseCopyWithImpl<$Res,
        $Val extends GetReferralInfoResponse>
    implements $GetReferralInfoResponseCopyWith<$Res> {
  _$GetReferralInfoResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetReferralInfoResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walletAddress = null,
    Object? referralCode = null,
    Object? isActive = null,
    Object? totalReferrals = null,
    Object? totalRewards = freezed,
    Object? createdAt = null,
    Object? lastUpdated = freezed,
    Object? expiresAt = freezed,
    Object? referrals = freezed,
  }) {
    return _then(_value.copyWith(
      walletAddress: null == walletAddress
          ? _value.walletAddress
          : walletAddress // ignore: cast_nullable_to_non_nullable
              as String,
      referralCode: null == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      totalReferrals: null == totalReferrals
          ? _value.totalReferrals
          : totalReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      totalRewards: freezed == totalRewards
          ? _value.totalRewards
          : totalRewards // ignore: cast_nullable_to_non_nullable
              as Decimal?,
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
      referrals: freezed == referrals
          ? _value.referrals
          : referrals // ignore: cast_nullable_to_non_nullable
              as List<Referral>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetReferralInfoResponseImplCopyWith<$Res>
    implements $GetReferralInfoResponseCopyWith<$Res> {
  factory _$$GetReferralInfoResponseImplCopyWith(
          _$GetReferralInfoResponseImpl value,
          $Res Function(_$GetReferralInfoResponseImpl) then) =
      __$$GetReferralInfoResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String walletAddress,
      String referralCode,
      bool isActive,
      int totalReferrals,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? totalRewards,
      DateTime createdAt,
      DateTime? lastUpdated,
      DateTime? expiresAt,
      List<Referral>? referrals});
}

/// @nodoc
class __$$GetReferralInfoResponseImplCopyWithImpl<$Res>
    extends _$GetReferralInfoResponseCopyWithImpl<$Res,
        _$GetReferralInfoResponseImpl>
    implements _$$GetReferralInfoResponseImplCopyWith<$Res> {
  __$$GetReferralInfoResponseImplCopyWithImpl(
      _$GetReferralInfoResponseImpl _value,
      $Res Function(_$GetReferralInfoResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetReferralInfoResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walletAddress = null,
    Object? referralCode = null,
    Object? isActive = null,
    Object? totalReferrals = null,
    Object? totalRewards = freezed,
    Object? createdAt = null,
    Object? lastUpdated = freezed,
    Object? expiresAt = freezed,
    Object? referrals = freezed,
  }) {
    return _then(_$GetReferralInfoResponseImpl(
      walletAddress: null == walletAddress
          ? _value.walletAddress
          : walletAddress // ignore: cast_nullable_to_non_nullable
              as String,
      referralCode: null == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      totalReferrals: null == totalReferrals
          ? _value.totalReferrals
          : totalReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      totalRewards: freezed == totalRewards
          ? _value.totalRewards
          : totalRewards // ignore: cast_nullable_to_non_nullable
              as Decimal?,
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
      referrals: freezed == referrals
          ? _value._referrals
          : referrals // ignore: cast_nullable_to_non_nullable
              as List<Referral>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetReferralInfoResponseImpl implements _GetReferralInfoResponse {
  const _$GetReferralInfoResponseImpl(
      {required this.walletAddress,
      required this.referralCode,
      required this.isActive,
      required this.totalReferrals,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      required this.totalRewards,
      required this.createdAt,
      this.lastUpdated,
      this.expiresAt,
      final List<Referral>? referrals})
      : _referrals = referrals;

  factory _$GetReferralInfoResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetReferralInfoResponseImplFromJson(json);

  @override
  final String walletAddress;
  @override
  final String referralCode;
  @override
  final bool isActive;
  @override
  final int totalReferrals;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  final Decimal? totalRewards;
  @override
  final DateTime createdAt;
  @override
  final DateTime? lastUpdated;
  @override
  final DateTime? expiresAt;
  final List<Referral>? _referrals;
  @override
  List<Referral>? get referrals {
    final value = _referrals;
    if (value == null) return null;
    if (_referrals is EqualUnmodifiableListView) return _referrals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'GetReferralInfoResponse(walletAddress: $walletAddress, referralCode: $referralCode, isActive: $isActive, totalReferrals: $totalReferrals, totalRewards: $totalRewards, createdAt: $createdAt, lastUpdated: $lastUpdated, expiresAt: $expiresAt, referrals: $referrals)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetReferralInfoResponseImpl &&
            (identical(other.walletAddress, walletAddress) ||
                other.walletAddress == walletAddress) &&
            (identical(other.referralCode, referralCode) ||
                other.referralCode == referralCode) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.totalReferrals, totalReferrals) ||
                other.totalReferrals == totalReferrals) &&
            (identical(other.totalRewards, totalRewards) ||
                other.totalRewards == totalRewards) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            const DeepCollectionEquality()
                .equals(other._referrals, _referrals));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      walletAddress,
      referralCode,
      isActive,
      totalReferrals,
      totalRewards,
      createdAt,
      lastUpdated,
      expiresAt,
      const DeepCollectionEquality().hash(_referrals));

  /// Create a copy of GetReferralInfoResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetReferralInfoResponseImplCopyWith<_$GetReferralInfoResponseImpl>
      get copyWith => __$$GetReferralInfoResponseImplCopyWithImpl<
          _$GetReferralInfoResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetReferralInfoResponseImplToJson(
      this,
    );
  }
}

abstract class _GetReferralInfoResponse implements GetReferralInfoResponse {
  const factory _GetReferralInfoResponse(
      {required final String walletAddress,
      required final String referralCode,
      required final bool isActive,
      required final int totalReferrals,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      required final Decimal? totalRewards,
      required final DateTime createdAt,
      final DateTime? lastUpdated,
      final DateTime? expiresAt,
      final List<Referral>? referrals}) = _$GetReferralInfoResponseImpl;

  factory _GetReferralInfoResponse.fromJson(Map<String, dynamic> json) =
      _$GetReferralInfoResponseImpl.fromJson;

  @override
  String get walletAddress;
  @override
  String get referralCode;
  @override
  bool get isActive;
  @override
  int get totalReferrals;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get totalRewards;
  @override
  DateTime get createdAt;
  @override
  DateTime? get lastUpdated;
  @override
  DateTime? get expiresAt;
  @override
  List<Referral>? get referrals;

  /// Create a copy of GetReferralInfoResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetReferralInfoResponseImplCopyWith<_$GetReferralInfoResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
