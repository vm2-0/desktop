// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Session {
  String? get address => throw _privateConstructorUsedError;
  String? get connectionToken => throw _privateConstructorUsedError;
  List<TokenBalance>? get balances => throw _privateConstructorUsedError;
  String? get referralCode => throw _privateConstructorUsedError;
  String? get referrerAddress => throw _privateConstructorUsedError;
  String? get referrerCode => throw _privateConstructorUsedError;
  TierInfo? get tier => throw _privateConstructorUsedError;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionCopyWith<Session> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionCopyWith<$Res> {
  factory $SessionCopyWith(Session value, $Res Function(Session) then) =
      _$SessionCopyWithImpl<$Res, Session>;
  @useResult
  $Res call(
      {String? address,
      String? connectionToken,
      List<TokenBalance>? balances,
      String? referralCode,
      String? referrerAddress,
      String? referrerCode,
      TierInfo? tier});

  $TierInfoCopyWith<$Res>? get tier;
}

/// @nodoc
class _$SessionCopyWithImpl<$Res, $Val extends Session>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? connectionToken = freezed,
    Object? balances = freezed,
    Object? referralCode = freezed,
    Object? referrerAddress = freezed,
    Object? referrerCode = freezed,
    Object? tier = freezed,
  }) {
    return _then(_value.copyWith(
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      connectionToken: freezed == connectionToken
          ? _value.connectionToken
          : connectionToken // ignore: cast_nullable_to_non_nullable
              as String?,
      balances: freezed == balances
          ? _value.balances
          : balances // ignore: cast_nullable_to_non_nullable
              as List<TokenBalance>?,
      referralCode: freezed == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String?,
      referrerAddress: freezed == referrerAddress
          ? _value.referrerAddress
          : referrerAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      referrerCode: freezed == referrerCode
          ? _value.referrerCode
          : referrerCode // ignore: cast_nullable_to_non_nullable
              as String?,
      tier: freezed == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as TierInfo?,
    ) as $Val);
  }

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TierInfoCopyWith<$Res>? get tier {
    if (_value.tier == null) {
      return null;
    }

    return $TierInfoCopyWith<$Res>(_value.tier!, (value) {
      return _then(_value.copyWith(tier: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionImplCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$$SessionImplCopyWith(
          _$SessionImpl value, $Res Function(_$SessionImpl) then) =
      __$$SessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? address,
      String? connectionToken,
      List<TokenBalance>? balances,
      String? referralCode,
      String? referrerAddress,
      String? referrerCode,
      TierInfo? tier});

  @override
  $TierInfoCopyWith<$Res>? get tier;
}

/// @nodoc
class __$$SessionImplCopyWithImpl<$Res>
    extends _$SessionCopyWithImpl<$Res, _$SessionImpl>
    implements _$$SessionImplCopyWith<$Res> {
  __$$SessionImplCopyWithImpl(
      _$SessionImpl _value, $Res Function(_$SessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? connectionToken = freezed,
    Object? balances = freezed,
    Object? referralCode = freezed,
    Object? referrerAddress = freezed,
    Object? referrerCode = freezed,
    Object? tier = freezed,
  }) {
    return _then(_$SessionImpl(
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      connectionToken: freezed == connectionToken
          ? _value.connectionToken
          : connectionToken // ignore: cast_nullable_to_non_nullable
              as String?,
      balances: freezed == balances
          ? _value._balances
          : balances // ignore: cast_nullable_to_non_nullable
              as List<TokenBalance>?,
      referralCode: freezed == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String?,
      referrerAddress: freezed == referrerAddress
          ? _value.referrerAddress
          : referrerAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      referrerCode: freezed == referrerCode
          ? _value.referrerCode
          : referrerCode // ignore: cast_nullable_to_non_nullable
              as String?,
      tier: freezed == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as TierInfo?,
    ));
  }
}

/// @nodoc

class _$SessionImpl extends _Session {
  const _$SessionImpl(
      {this.address,
      this.connectionToken,
      final List<TokenBalance>? balances,
      this.referralCode,
      this.referrerAddress,
      this.referrerCode,
      this.tier})
      : _balances = balances,
        super._();

  @override
  final String? address;
  @override
  final String? connectionToken;
  final List<TokenBalance>? _balances;
  @override
  List<TokenBalance>? get balances {
    final value = _balances;
    if (value == null) return null;
    if (_balances is EqualUnmodifiableListView) return _balances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? referralCode;
  @override
  final String? referrerAddress;
  @override
  final String? referrerCode;
  @override
  final TierInfo? tier;

  @override
  String toString() {
    return 'Session(address: $address, connectionToken: $connectionToken, balances: $balances, referralCode: $referralCode, referrerAddress: $referrerAddress, referrerCode: $referrerCode, tier: $tier)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.connectionToken, connectionToken) ||
                other.connectionToken == connectionToken) &&
            const DeepCollectionEquality().equals(other._balances, _balances) &&
            (identical(other.referralCode, referralCode) ||
                other.referralCode == referralCode) &&
            (identical(other.referrerAddress, referrerAddress) ||
                other.referrerAddress == referrerAddress) &&
            (identical(other.referrerCode, referrerCode) ||
                other.referrerCode == referrerCode) &&
            (identical(other.tier, tier) || other.tier == tier));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      address,
      connectionToken,
      const DeepCollectionEquality().hash(_balances),
      referralCode,
      referrerAddress,
      referrerCode,
      tier);

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionImplCopyWith<_$SessionImpl> get copyWith =>
      __$$SessionImplCopyWithImpl<_$SessionImpl>(this, _$identity);
}

abstract class _Session extends Session {
  const factory _Session(
      {final String? address,
      final String? connectionToken,
      final List<TokenBalance>? balances,
      final String? referralCode,
      final String? referrerAddress,
      final String? referrerCode,
      final TierInfo? tier}) = _$SessionImpl;
  const _Session._() : super._();

  @override
  String? get address;
  @override
  String? get connectionToken;
  @override
  List<TokenBalance>? get balances;
  @override
  String? get referralCode;
  @override
  String? get referrerAddress;
  @override
  String? get referrerCode;
  @override
  TierInfo? get tier;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionImplCopyWith<_$SessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
