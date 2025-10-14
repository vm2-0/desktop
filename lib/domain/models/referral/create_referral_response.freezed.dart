// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_referral_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateReferralResponse _$CreateReferralResponseFromJson(
    Map<String, dynamic> json) {
  return _CreateReferralResponse.fromJson(json);
}

/// @nodoc
mixin _$CreateReferralResponse {
  String get referralCode => throw _privateConstructorUsedError;
  String get walletAddress => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CreateReferralResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateReferralResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateReferralResponseCopyWith<CreateReferralResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateReferralResponseCopyWith<$Res> {
  factory $CreateReferralResponseCopyWith(CreateReferralResponse value,
          $Res Function(CreateReferralResponse) then) =
      _$CreateReferralResponseCopyWithImpl<$Res, CreateReferralResponse>;
  @useResult
  $Res call({String referralCode, String walletAddress, DateTime createdAt});
}

/// @nodoc
class _$CreateReferralResponseCopyWithImpl<$Res,
        $Val extends CreateReferralResponse>
    implements $CreateReferralResponseCopyWith<$Res> {
  _$CreateReferralResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateReferralResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? referralCode = null,
    Object? walletAddress = null,
    Object? createdAt = null,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateReferralResponseImplCopyWith<$Res>
    implements $CreateReferralResponseCopyWith<$Res> {
  factory _$$CreateReferralResponseImplCopyWith(
          _$CreateReferralResponseImpl value,
          $Res Function(_$CreateReferralResponseImpl) then) =
      __$$CreateReferralResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String referralCode, String walletAddress, DateTime createdAt});
}

/// @nodoc
class __$$CreateReferralResponseImplCopyWithImpl<$Res>
    extends _$CreateReferralResponseCopyWithImpl<$Res,
        _$CreateReferralResponseImpl>
    implements _$$CreateReferralResponseImplCopyWith<$Res> {
  __$$CreateReferralResponseImplCopyWithImpl(
      _$CreateReferralResponseImpl _value,
      $Res Function(_$CreateReferralResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateReferralResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? referralCode = null,
    Object? walletAddress = null,
    Object? createdAt = null,
  }) {
    return _then(_$CreateReferralResponseImpl(
      referralCode: null == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String,
      walletAddress: null == walletAddress
          ? _value.walletAddress
          : walletAddress // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateReferralResponseImpl implements _CreateReferralResponse {
  const _$CreateReferralResponseImpl(
      {required this.referralCode,
      required this.walletAddress,
      required this.createdAt});

  factory _$CreateReferralResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateReferralResponseImplFromJson(json);

  @override
  final String referralCode;
  @override
  final String walletAddress;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CreateReferralResponse(referralCode: $referralCode, walletAddress: $walletAddress, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateReferralResponseImpl &&
            (identical(other.referralCode, referralCode) ||
                other.referralCode == referralCode) &&
            (identical(other.walletAddress, walletAddress) ||
                other.walletAddress == walletAddress) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, referralCode, walletAddress, createdAt);

  /// Create a copy of CreateReferralResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateReferralResponseImplCopyWith<_$CreateReferralResponseImpl>
      get copyWith => __$$CreateReferralResponseImplCopyWithImpl<
          _$CreateReferralResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateReferralResponseImplToJson(
      this,
    );
  }
}

abstract class _CreateReferralResponse implements CreateReferralResponse {
  const factory _CreateReferralResponse(
      {required final String referralCode,
      required final String walletAddress,
      required final DateTime createdAt}) = _$CreateReferralResponseImpl;

  factory _CreateReferralResponse.fromJson(Map<String, dynamic> json) =
      _$CreateReferralResponseImpl.fromJson;

  @override
  String get referralCode;
  @override
  String get walletAddress;
  @override
  DateTime get createdAt;

  /// Create a copy of CreateReferralResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateReferralResponseImplCopyWith<_$CreateReferralResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
