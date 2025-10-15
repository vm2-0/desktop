// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'claim_authorization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClaimAuthorization _$ClaimAuthorizationFromJson(Map<String, dynamic> json) {
  return _ClaimAuthorization.fromJson(json);
}

/// @nodoc
mixin _$ClaimAuthorization {
  /// Account address (farmer who can claim)
  String get account => throw _privateConstructorUsedError;

  /// Cumulative amount in wei (string to preserve precision)
  String get cumulativeAmount => throw _privateConstructorUsedError;

  /// Nonce for replay protection
  int? get nonce => throw _privateConstructorUsedError;

  /// Signature deadline (unix timestamp)
  int? get deadline => throw _privateConstructorUsedError;

  /// EIP-712 signature for payWithSig()
  String get signature => throw _privateConstructorUsedError;

  /// Publisher address that signed this authorization
  String get publisherUsed => throw _privateConstructorUsedError;

  /// Pool contract address
  String get poolAddress => throw _privateConstructorUsedError;

  /// Token contract address
  String get tokenAddress => throw _privateConstructorUsedError;

  /// Already claimed amount
  double? get alreadyClaimed => throw _privateConstructorUsedError;

  /// New claimable amount
  double? get newClaimableAmount => throw _privateConstructorUsedError;

  /// Platform fee percentage (e.g. 10.0 for 10%)
  double? get feePercentage => throw _privateConstructorUsedError;

  /// Referrals
  List<ClaimAuthorizationReferrals>? get referrals =>
      throw _privateConstructorUsedError;

  /// Serializes this ClaimAuthorization to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClaimAuthorization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClaimAuthorizationCopyWith<ClaimAuthorization> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClaimAuthorizationCopyWith<$Res> {
  factory $ClaimAuthorizationCopyWith(
          ClaimAuthorization value, $Res Function(ClaimAuthorization) then) =
      _$ClaimAuthorizationCopyWithImpl<$Res, ClaimAuthorization>;
  @useResult
  $Res call(
      {String account,
      String cumulativeAmount,
      int? nonce,
      int? deadline,
      String signature,
      String publisherUsed,
      String poolAddress,
      String tokenAddress,
      double? alreadyClaimed,
      double? newClaimableAmount,
      double? feePercentage,
      List<ClaimAuthorizationReferrals>? referrals});
}

/// @nodoc
class _$ClaimAuthorizationCopyWithImpl<$Res, $Val extends ClaimAuthorization>
    implements $ClaimAuthorizationCopyWith<$Res> {
  _$ClaimAuthorizationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClaimAuthorization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? account = null,
    Object? cumulativeAmount = null,
    Object? nonce = freezed,
    Object? deadline = freezed,
    Object? signature = null,
    Object? publisherUsed = null,
    Object? poolAddress = null,
    Object? tokenAddress = null,
    Object? alreadyClaimed = freezed,
    Object? newClaimableAmount = freezed,
    Object? feePercentage = freezed,
    Object? referrals = freezed,
  }) {
    return _then(_value.copyWith(
      account: null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as String,
      cumulativeAmount: null == cumulativeAmount
          ? _value.cumulativeAmount
          : cumulativeAmount // ignore: cast_nullable_to_non_nullable
              as String,
      nonce: freezed == nonce
          ? _value.nonce
          : nonce // ignore: cast_nullable_to_non_nullable
              as int?,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as int?,
      signature: null == signature
          ? _value.signature
          : signature // ignore: cast_nullable_to_non_nullable
              as String,
      publisherUsed: null == publisherUsed
          ? _value.publisherUsed
          : publisherUsed // ignore: cast_nullable_to_non_nullable
              as String,
      poolAddress: null == poolAddress
          ? _value.poolAddress
          : poolAddress // ignore: cast_nullable_to_non_nullable
              as String,
      tokenAddress: null == tokenAddress
          ? _value.tokenAddress
          : tokenAddress // ignore: cast_nullable_to_non_nullable
              as String,
      alreadyClaimed: freezed == alreadyClaimed
          ? _value.alreadyClaimed
          : alreadyClaimed // ignore: cast_nullable_to_non_nullable
              as double?,
      newClaimableAmount: freezed == newClaimableAmount
          ? _value.newClaimableAmount
          : newClaimableAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      feePercentage: freezed == feePercentage
          ? _value.feePercentage
          : feePercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      referrals: freezed == referrals
          ? _value.referrals
          : referrals // ignore: cast_nullable_to_non_nullable
              as List<ClaimAuthorizationReferrals>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClaimAuthorizationImplCopyWith<$Res>
    implements $ClaimAuthorizationCopyWith<$Res> {
  factory _$$ClaimAuthorizationImplCopyWith(_$ClaimAuthorizationImpl value,
          $Res Function(_$ClaimAuthorizationImpl) then) =
      __$$ClaimAuthorizationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String account,
      String cumulativeAmount,
      int? nonce,
      int? deadline,
      String signature,
      String publisherUsed,
      String poolAddress,
      String tokenAddress,
      double? alreadyClaimed,
      double? newClaimableAmount,
      double? feePercentage,
      List<ClaimAuthorizationReferrals>? referrals});
}

/// @nodoc
class __$$ClaimAuthorizationImplCopyWithImpl<$Res>
    extends _$ClaimAuthorizationCopyWithImpl<$Res, _$ClaimAuthorizationImpl>
    implements _$$ClaimAuthorizationImplCopyWith<$Res> {
  __$$ClaimAuthorizationImplCopyWithImpl(_$ClaimAuthorizationImpl _value,
      $Res Function(_$ClaimAuthorizationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClaimAuthorization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? account = null,
    Object? cumulativeAmount = null,
    Object? nonce = freezed,
    Object? deadline = freezed,
    Object? signature = null,
    Object? publisherUsed = null,
    Object? poolAddress = null,
    Object? tokenAddress = null,
    Object? alreadyClaimed = freezed,
    Object? newClaimableAmount = freezed,
    Object? feePercentage = freezed,
    Object? referrals = freezed,
  }) {
    return _then(_$ClaimAuthorizationImpl(
      account: null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as String,
      cumulativeAmount: null == cumulativeAmount
          ? _value.cumulativeAmount
          : cumulativeAmount // ignore: cast_nullable_to_non_nullable
              as String,
      nonce: freezed == nonce
          ? _value.nonce
          : nonce // ignore: cast_nullable_to_non_nullable
              as int?,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as int?,
      signature: null == signature
          ? _value.signature
          : signature // ignore: cast_nullable_to_non_nullable
              as String,
      publisherUsed: null == publisherUsed
          ? _value.publisherUsed
          : publisherUsed // ignore: cast_nullable_to_non_nullable
              as String,
      poolAddress: null == poolAddress
          ? _value.poolAddress
          : poolAddress // ignore: cast_nullable_to_non_nullable
              as String,
      tokenAddress: null == tokenAddress
          ? _value.tokenAddress
          : tokenAddress // ignore: cast_nullable_to_non_nullable
              as String,
      alreadyClaimed: freezed == alreadyClaimed
          ? _value.alreadyClaimed
          : alreadyClaimed // ignore: cast_nullable_to_non_nullable
              as double?,
      newClaimableAmount: freezed == newClaimableAmount
          ? _value.newClaimableAmount
          : newClaimableAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      feePercentage: freezed == feePercentage
          ? _value.feePercentage
          : feePercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      referrals: freezed == referrals
          ? _value._referrals
          : referrals // ignore: cast_nullable_to_non_nullable
              as List<ClaimAuthorizationReferrals>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClaimAuthorizationImpl implements _ClaimAuthorization {
  const _$ClaimAuthorizationImpl(
      {required this.account,
      required this.cumulativeAmount,
      this.nonce,
      this.deadline,
      required this.signature,
      required this.publisherUsed,
      required this.poolAddress,
      required this.tokenAddress,
      this.alreadyClaimed,
      this.newClaimableAmount,
      this.feePercentage,
      final List<ClaimAuthorizationReferrals>? referrals})
      : _referrals = referrals;

  factory _$ClaimAuthorizationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClaimAuthorizationImplFromJson(json);

  /// Account address (farmer who can claim)
  @override
  final String account;

  /// Cumulative amount in wei (string to preserve precision)
  @override
  final String cumulativeAmount;

  /// Nonce for replay protection
  @override
  final int? nonce;

  /// Signature deadline (unix timestamp)
  @override
  final int? deadline;

  /// EIP-712 signature for payWithSig()
  @override
  final String signature;

  /// Publisher address that signed this authorization
  @override
  final String publisherUsed;

  /// Pool contract address
  @override
  final String poolAddress;

  /// Token contract address
  @override
  final String tokenAddress;

  /// Already claimed amount
  @override
  final double? alreadyClaimed;

  /// New claimable amount
  @override
  final double? newClaimableAmount;

  /// Platform fee percentage (e.g. 10.0 for 10%)
  @override
  final double? feePercentage;

  /// Referrals
  final List<ClaimAuthorizationReferrals>? _referrals;

  /// Referrals
  @override
  List<ClaimAuthorizationReferrals>? get referrals {
    final value = _referrals;
    if (value == null) return null;
    if (_referrals is EqualUnmodifiableListView) return _referrals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ClaimAuthorization(account: $account, cumulativeAmount: $cumulativeAmount, nonce: $nonce, deadline: $deadline, signature: $signature, publisherUsed: $publisherUsed, poolAddress: $poolAddress, tokenAddress: $tokenAddress, alreadyClaimed: $alreadyClaimed, newClaimableAmount: $newClaimableAmount, feePercentage: $feePercentage, referrals: $referrals)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClaimAuthorizationImpl &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.cumulativeAmount, cumulativeAmount) ||
                other.cumulativeAmount == cumulativeAmount) &&
            (identical(other.nonce, nonce) || other.nonce == nonce) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.signature, signature) ||
                other.signature == signature) &&
            (identical(other.publisherUsed, publisherUsed) ||
                other.publisherUsed == publisherUsed) &&
            (identical(other.poolAddress, poolAddress) ||
                other.poolAddress == poolAddress) &&
            (identical(other.tokenAddress, tokenAddress) ||
                other.tokenAddress == tokenAddress) &&
            (identical(other.alreadyClaimed, alreadyClaimed) ||
                other.alreadyClaimed == alreadyClaimed) &&
            (identical(other.newClaimableAmount, newClaimableAmount) ||
                other.newClaimableAmount == newClaimableAmount) &&
            (identical(other.feePercentage, feePercentage) ||
                other.feePercentage == feePercentage) &&
            const DeepCollectionEquality()
                .equals(other._referrals, _referrals));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      account,
      cumulativeAmount,
      nonce,
      deadline,
      signature,
      publisherUsed,
      poolAddress,
      tokenAddress,
      alreadyClaimed,
      newClaimableAmount,
      feePercentage,
      const DeepCollectionEquality().hash(_referrals));

  /// Create a copy of ClaimAuthorization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClaimAuthorizationImplCopyWith<_$ClaimAuthorizationImpl> get copyWith =>
      __$$ClaimAuthorizationImplCopyWithImpl<_$ClaimAuthorizationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClaimAuthorizationImplToJson(
      this,
    );
  }
}

abstract class _ClaimAuthorization implements ClaimAuthorization {
  const factory _ClaimAuthorization(
          {required final String account,
          required final String cumulativeAmount,
          final int? nonce,
          final int? deadline,
          required final String signature,
          required final String publisherUsed,
          required final String poolAddress,
          required final String tokenAddress,
          final double? alreadyClaimed,
          final double? newClaimableAmount,
          final double? feePercentage,
          final List<ClaimAuthorizationReferrals>? referrals}) =
      _$ClaimAuthorizationImpl;

  factory _ClaimAuthorization.fromJson(Map<String, dynamic> json) =
      _$ClaimAuthorizationImpl.fromJson;

  /// Account address (farmer who can claim)
  @override
  String get account;

  /// Cumulative amount in wei (string to preserve precision)
  @override
  String get cumulativeAmount;

  /// Nonce for replay protection
  @override
  int? get nonce;

  /// Signature deadline (unix timestamp)
  @override
  int? get deadline;

  /// EIP-712 signature for payWithSig()
  @override
  String get signature;

  /// Publisher address that signed this authorization
  @override
  String get publisherUsed;

  /// Pool contract address
  @override
  String get poolAddress;

  /// Token contract address
  @override
  String get tokenAddress;

  /// Already claimed amount
  @override
  double? get alreadyClaimed;

  /// New claimable amount
  @override
  double? get newClaimableAmount;

  /// Platform fee percentage (e.g. 10.0 for 10%)
  @override
  double? get feePercentage;

  /// Referrals
  @override
  List<ClaimAuthorizationReferrals>? get referrals;

  /// Create a copy of ClaimAuthorization
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClaimAuthorizationImplCopyWith<_$ClaimAuthorizationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
