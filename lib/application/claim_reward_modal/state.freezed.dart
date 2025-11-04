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
mixin _$ClaimRewardModalState {
  bool get isShown => throw _privateConstructorUsedError;
  bool get isClaiming => throw _privateConstructorUsedError;
  ClaimAuthorization? get claimAuthorization =>
      throw _privateConstructorUsedError;
  @JsonKey(fromJson: DecimalJson.fromJson, toJson: DecimalJson.toJson)
  Decimal? get rewardAmount => throw _privateConstructorUsedError;
  String? get tokenSymbol => throw _privateConstructorUsedError;
  String? get submissionId => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get estimatedGasCost => throw _privateConstructorUsedError;
  bool get gasExceedsReward => throw _privateConstructorUsedError;

  /// Create a copy of ClaimRewardModalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClaimRewardModalStateCopyWith<ClaimRewardModalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClaimRewardModalStateCopyWith<$Res> {
  factory $ClaimRewardModalStateCopyWith(ClaimRewardModalState value,
          $Res Function(ClaimRewardModalState) then) =
      _$ClaimRewardModalStateCopyWithImpl<$Res, ClaimRewardModalState>;
  @useResult
  $Res call(
      {bool isShown,
      bool isClaiming,
      ClaimAuthorization? claimAuthorization,
      @JsonKey(fromJson: DecimalJson.fromJson, toJson: DecimalJson.toJson)
      Decimal? rewardAmount,
      String? tokenSymbol,
      String? submissionId,
      String? error,
      String? estimatedGasCost,
      bool gasExceedsReward});

  $ClaimAuthorizationCopyWith<$Res>? get claimAuthorization;
}

/// @nodoc
class _$ClaimRewardModalStateCopyWithImpl<$Res,
        $Val extends ClaimRewardModalState>
    implements $ClaimRewardModalStateCopyWith<$Res> {
  _$ClaimRewardModalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClaimRewardModalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isShown = null,
    Object? isClaiming = null,
    Object? claimAuthorization = freezed,
    Object? rewardAmount = freezed,
    Object? tokenSymbol = freezed,
    Object? submissionId = freezed,
    Object? error = freezed,
    Object? estimatedGasCost = freezed,
    Object? gasExceedsReward = null,
  }) {
    return _then(_value.copyWith(
      isShown: null == isShown
          ? _value.isShown
          : isShown // ignore: cast_nullable_to_non_nullable
              as bool,
      isClaiming: null == isClaiming
          ? _value.isClaiming
          : isClaiming // ignore: cast_nullable_to_non_nullable
              as bool,
      claimAuthorization: freezed == claimAuthorization
          ? _value.claimAuthorization
          : claimAuthorization // ignore: cast_nullable_to_non_nullable
              as ClaimAuthorization?,
      rewardAmount: freezed == rewardAmount
          ? _value.rewardAmount
          : rewardAmount // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      tokenSymbol: freezed == tokenSymbol
          ? _value.tokenSymbol
          : tokenSymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      submissionId: freezed == submissionId
          ? _value.submissionId
          : submissionId // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedGasCost: freezed == estimatedGasCost
          ? _value.estimatedGasCost
          : estimatedGasCost // ignore: cast_nullable_to_non_nullable
              as String?,
      gasExceedsReward: null == gasExceedsReward
          ? _value.gasExceedsReward
          : gasExceedsReward // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of ClaimRewardModalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClaimAuthorizationCopyWith<$Res>? get claimAuthorization {
    if (_value.claimAuthorization == null) {
      return null;
    }

    return $ClaimAuthorizationCopyWith<$Res>(_value.claimAuthorization!,
        (value) {
      return _then(_value.copyWith(claimAuthorization: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ClaimRewardModalStateImplCopyWith<$Res>
    implements $ClaimRewardModalStateCopyWith<$Res> {
  factory _$$ClaimRewardModalStateImplCopyWith(
          _$ClaimRewardModalStateImpl value,
          $Res Function(_$ClaimRewardModalStateImpl) then) =
      __$$ClaimRewardModalStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isShown,
      bool isClaiming,
      ClaimAuthorization? claimAuthorization,
      @JsonKey(fromJson: DecimalJson.fromJson, toJson: DecimalJson.toJson)
      Decimal? rewardAmount,
      String? tokenSymbol,
      String? submissionId,
      String? error,
      String? estimatedGasCost,
      bool gasExceedsReward});

  @override
  $ClaimAuthorizationCopyWith<$Res>? get claimAuthorization;
}

/// @nodoc
class __$$ClaimRewardModalStateImplCopyWithImpl<$Res>
    extends _$ClaimRewardModalStateCopyWithImpl<$Res,
        _$ClaimRewardModalStateImpl>
    implements _$$ClaimRewardModalStateImplCopyWith<$Res> {
  __$$ClaimRewardModalStateImplCopyWithImpl(_$ClaimRewardModalStateImpl _value,
      $Res Function(_$ClaimRewardModalStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClaimRewardModalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isShown = null,
    Object? isClaiming = null,
    Object? claimAuthorization = freezed,
    Object? rewardAmount = freezed,
    Object? tokenSymbol = freezed,
    Object? submissionId = freezed,
    Object? error = freezed,
    Object? estimatedGasCost = freezed,
    Object? gasExceedsReward = null,
  }) {
    return _then(_$ClaimRewardModalStateImpl(
      isShown: null == isShown
          ? _value.isShown
          : isShown // ignore: cast_nullable_to_non_nullable
              as bool,
      isClaiming: null == isClaiming
          ? _value.isClaiming
          : isClaiming // ignore: cast_nullable_to_non_nullable
              as bool,
      claimAuthorization: freezed == claimAuthorization
          ? _value.claimAuthorization
          : claimAuthorization // ignore: cast_nullable_to_non_nullable
              as ClaimAuthorization?,
      rewardAmount: freezed == rewardAmount
          ? _value.rewardAmount
          : rewardAmount // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      tokenSymbol: freezed == tokenSymbol
          ? _value.tokenSymbol
          : tokenSymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      submissionId: freezed == submissionId
          ? _value.submissionId
          : submissionId // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedGasCost: freezed == estimatedGasCost
          ? _value.estimatedGasCost
          : estimatedGasCost // ignore: cast_nullable_to_non_nullable
              as String?,
      gasExceedsReward: null == gasExceedsReward
          ? _value.gasExceedsReward
          : gasExceedsReward // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ClaimRewardModalStateImpl implements _ClaimRewardModalState {
  const _$ClaimRewardModalStateImpl(
      {this.isShown = false,
      this.isClaiming = false,
      this.claimAuthorization,
      @JsonKey(fromJson: DecimalJson.fromJson, toJson: DecimalJson.toJson)
      this.rewardAmount,
      this.tokenSymbol,
      this.submissionId,
      this.error,
      this.estimatedGasCost,
      this.gasExceedsReward = false});

  @override
  @JsonKey()
  final bool isShown;
  @override
  @JsonKey()
  final bool isClaiming;
  @override
  final ClaimAuthorization? claimAuthorization;
  @override
  @JsonKey(fromJson: DecimalJson.fromJson, toJson: DecimalJson.toJson)
  final Decimal? rewardAmount;
  @override
  final String? tokenSymbol;
  @override
  final String? submissionId;
  @override
  final String? error;
  @override
  final String? estimatedGasCost;
  @override
  @JsonKey()
  final bool gasExceedsReward;

  @override
  String toString() {
    return 'ClaimRewardModalState(isShown: $isShown, isClaiming: $isClaiming, claimAuthorization: $claimAuthorization, rewardAmount: $rewardAmount, tokenSymbol: $tokenSymbol, submissionId: $submissionId, error: $error, estimatedGasCost: $estimatedGasCost, gasExceedsReward: $gasExceedsReward)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClaimRewardModalStateImpl &&
            (identical(other.isShown, isShown) || other.isShown == isShown) &&
            (identical(other.isClaiming, isClaiming) ||
                other.isClaiming == isClaiming) &&
            (identical(other.claimAuthorization, claimAuthorization) ||
                other.claimAuthorization == claimAuthorization) &&
            (identical(other.rewardAmount, rewardAmount) ||
                other.rewardAmount == rewardAmount) &&
            (identical(other.tokenSymbol, tokenSymbol) ||
                other.tokenSymbol == tokenSymbol) &&
            (identical(other.submissionId, submissionId) ||
                other.submissionId == submissionId) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.estimatedGasCost, estimatedGasCost) ||
                other.estimatedGasCost == estimatedGasCost) &&
            (identical(other.gasExceedsReward, gasExceedsReward) ||
                other.gasExceedsReward == gasExceedsReward));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isShown,
      isClaiming,
      claimAuthorization,
      rewardAmount,
      tokenSymbol,
      submissionId,
      error,
      estimatedGasCost,
      gasExceedsReward);

  /// Create a copy of ClaimRewardModalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClaimRewardModalStateImplCopyWith<_$ClaimRewardModalStateImpl>
      get copyWith => __$$ClaimRewardModalStateImplCopyWithImpl<
          _$ClaimRewardModalStateImpl>(this, _$identity);
}

abstract class _ClaimRewardModalState implements ClaimRewardModalState {
  const factory _ClaimRewardModalState(
      {final bool isShown,
      final bool isClaiming,
      final ClaimAuthorization? claimAuthorization,
      @JsonKey(fromJson: DecimalJson.fromJson, toJson: DecimalJson.toJson)
      final Decimal? rewardAmount,
      final String? tokenSymbol,
      final String? submissionId,
      final String? error,
      final String? estimatedGasCost,
      final bool gasExceedsReward}) = _$ClaimRewardModalStateImpl;

  @override
  bool get isShown;
  @override
  bool get isClaiming;
  @override
  ClaimAuthorization? get claimAuthorization;
  @override
  @JsonKey(fromJson: DecimalJson.fromJson, toJson: DecimalJson.toJson)
  Decimal? get rewardAmount;
  @override
  String? get tokenSymbol;
  @override
  String? get submissionId;
  @override
  String? get error;
  @override
  String? get estimatedGasCost;
  @override
  bool get gasExceedsReward;

  /// Create a copy of ClaimRewardModalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClaimRewardModalStateImplCopyWith<_$ClaimRewardModalStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
