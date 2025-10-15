// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'claim_authorization_referrals.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClaimAuthorizationReferrals _$ClaimAuthorizationReferralsFromJson(
    Map<String, dynamic> json) {
  return _ClaimAuthorizationReferrals.fromJson(json);
}

/// @nodoc
mixin _$ClaimAuthorizationReferrals {
  String get address => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this ClaimAuthorizationReferrals to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClaimAuthorizationReferrals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClaimAuthorizationReferralsCopyWith<ClaimAuthorizationReferrals>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClaimAuthorizationReferralsCopyWith<$Res> {
  factory $ClaimAuthorizationReferralsCopyWith(
          ClaimAuthorizationReferrals value,
          $Res Function(ClaimAuthorizationReferrals) then) =
      _$ClaimAuthorizationReferralsCopyWithImpl<$Res,
          ClaimAuthorizationReferrals>;
  @useResult
  $Res call({String address, double amount, String type});
}

/// @nodoc
class _$ClaimAuthorizationReferralsCopyWithImpl<$Res,
        $Val extends ClaimAuthorizationReferrals>
    implements $ClaimAuthorizationReferralsCopyWith<$Res> {
  _$ClaimAuthorizationReferralsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClaimAuthorizationReferrals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? amount = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClaimAuthorizationReferralsImplCopyWith<$Res>
    implements $ClaimAuthorizationReferralsCopyWith<$Res> {
  factory _$$ClaimAuthorizationReferralsImplCopyWith(
          _$ClaimAuthorizationReferralsImpl value,
          $Res Function(_$ClaimAuthorizationReferralsImpl) then) =
      __$$ClaimAuthorizationReferralsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String address, double amount, String type});
}

/// @nodoc
class __$$ClaimAuthorizationReferralsImplCopyWithImpl<$Res>
    extends _$ClaimAuthorizationReferralsCopyWithImpl<$Res,
        _$ClaimAuthorizationReferralsImpl>
    implements _$$ClaimAuthorizationReferralsImplCopyWith<$Res> {
  __$$ClaimAuthorizationReferralsImplCopyWithImpl(
      _$ClaimAuthorizationReferralsImpl _value,
      $Res Function(_$ClaimAuthorizationReferralsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClaimAuthorizationReferrals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? amount = null,
    Object? type = null,
  }) {
    return _then(_$ClaimAuthorizationReferralsImpl(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClaimAuthorizationReferralsImpl
    implements _ClaimAuthorizationReferrals {
  const _$ClaimAuthorizationReferralsImpl(
      {required this.address, required this.amount, required this.type});

  factory _$ClaimAuthorizationReferralsImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ClaimAuthorizationReferralsImplFromJson(json);

  @override
  final String address;
  @override
  final double amount;
  @override
  final String type;

  @override
  String toString() {
    return 'ClaimAuthorizationReferrals(address: $address, amount: $amount, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClaimAuthorizationReferralsImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, address, amount, type);

  /// Create a copy of ClaimAuthorizationReferrals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClaimAuthorizationReferralsImplCopyWith<_$ClaimAuthorizationReferralsImpl>
      get copyWith => __$$ClaimAuthorizationReferralsImplCopyWithImpl<
          _$ClaimAuthorizationReferralsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClaimAuthorizationReferralsImplToJson(
      this,
    );
  }
}

abstract class _ClaimAuthorizationReferrals
    implements ClaimAuthorizationReferrals {
  const factory _ClaimAuthorizationReferrals(
      {required final String address,
      required final double amount,
      required final String type}) = _$ClaimAuthorizationReferralsImpl;

  factory _ClaimAuthorizationReferrals.fromJson(Map<String, dynamic> json) =
      _$ClaimAuthorizationReferralsImpl.fromJson;

  @override
  String get address;
  @override
  double get amount;
  @override
  String get type;

  /// Create a copy of ClaimAuthorizationReferrals
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClaimAuthorizationReferralsImplCopyWith<_$ClaimAuthorizationReferralsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
