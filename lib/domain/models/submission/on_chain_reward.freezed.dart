// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'on_chain_reward.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OnChainReward _$OnChainRewardFromJson(Map<String, dynamic> json) {
  return _OnChainReward.fromJson(json);
}

/// @nodoc
mixin _$OnChainReward {
  String get poolAddress => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get grossAmount => throw _privateConstructorUsedError;
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get feeAmount => throw _privateConstructorUsedError;
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get netAmount => throw _privateConstructorUsedError;
  String? get submissionId => throw _privateConstructorUsedError;
  String? get txHash => throw _privateConstructorUsedError;
  int? get timestamp => throw _privateConstructorUsedError;
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get cumulativeAmount => throw _privateConstructorUsedError;

  /// Serializes this OnChainReward to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OnChainReward
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnChainRewardCopyWith<OnChainReward> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnChainRewardCopyWith<$Res> {
  factory $OnChainRewardCopyWith(
          OnChainReward value, $Res Function(OnChainReward) then) =
      _$OnChainRewardCopyWithImpl<$Res, OnChainReward>;
  @useResult
  $Res call(
      {String poolAddress,
      double amount,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? grossAmount,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? feeAmount,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? netAmount,
      String? submissionId,
      String? txHash,
      int? timestamp,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? cumulativeAmount});
}

/// @nodoc
class _$OnChainRewardCopyWithImpl<$Res, $Val extends OnChainReward>
    implements $OnChainRewardCopyWith<$Res> {
  _$OnChainRewardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnChainReward
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poolAddress = null,
    Object? amount = null,
    Object? grossAmount = freezed,
    Object? feeAmount = freezed,
    Object? netAmount = freezed,
    Object? submissionId = freezed,
    Object? txHash = freezed,
    Object? timestamp = freezed,
    Object? cumulativeAmount = freezed,
  }) {
    return _then(_value.copyWith(
      poolAddress: null == poolAddress
          ? _value.poolAddress
          : poolAddress // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      grossAmount: freezed == grossAmount
          ? _value.grossAmount
          : grossAmount // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      feeAmount: freezed == feeAmount
          ? _value.feeAmount
          : feeAmount // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      netAmount: freezed == netAmount
          ? _value.netAmount
          : netAmount // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      submissionId: freezed == submissionId
          ? _value.submissionId
          : submissionId // ignore: cast_nullable_to_non_nullable
              as String?,
      txHash: freezed == txHash
          ? _value.txHash
          : txHash // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      cumulativeAmount: freezed == cumulativeAmount
          ? _value.cumulativeAmount
          : cumulativeAmount // ignore: cast_nullable_to_non_nullable
              as Decimal?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnChainRewardImplCopyWith<$Res>
    implements $OnChainRewardCopyWith<$Res> {
  factory _$$OnChainRewardImplCopyWith(
          _$OnChainRewardImpl value, $Res Function(_$OnChainRewardImpl) then) =
      __$$OnChainRewardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String poolAddress,
      double amount,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? grossAmount,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? feeAmount,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? netAmount,
      String? submissionId,
      String? txHash,
      int? timestamp,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? cumulativeAmount});
}

/// @nodoc
class __$$OnChainRewardImplCopyWithImpl<$Res>
    extends _$OnChainRewardCopyWithImpl<$Res, _$OnChainRewardImpl>
    implements _$$OnChainRewardImplCopyWith<$Res> {
  __$$OnChainRewardImplCopyWithImpl(
      _$OnChainRewardImpl _value, $Res Function(_$OnChainRewardImpl) _then)
      : super(_value, _then);

  /// Create a copy of OnChainReward
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poolAddress = null,
    Object? amount = null,
    Object? grossAmount = freezed,
    Object? feeAmount = freezed,
    Object? netAmount = freezed,
    Object? submissionId = freezed,
    Object? txHash = freezed,
    Object? timestamp = freezed,
    Object? cumulativeAmount = freezed,
  }) {
    return _then(_$OnChainRewardImpl(
      poolAddress: null == poolAddress
          ? _value.poolAddress
          : poolAddress // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      grossAmount: freezed == grossAmount
          ? _value.grossAmount
          : grossAmount // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      feeAmount: freezed == feeAmount
          ? _value.feeAmount
          : feeAmount // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      netAmount: freezed == netAmount
          ? _value.netAmount
          : netAmount // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      submissionId: freezed == submissionId
          ? _value.submissionId
          : submissionId // ignore: cast_nullable_to_non_nullable
              as String?,
      txHash: freezed == txHash
          ? _value.txHash
          : txHash // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      cumulativeAmount: freezed == cumulativeAmount
          ? _value.cumulativeAmount
          : cumulativeAmount // ignore: cast_nullable_to_non_nullable
              as Decimal?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OnChainRewardImpl implements _OnChainReward {
  const _$OnChainRewardImpl(
      {required this.poolAddress,
      required this.amount,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      this.grossAmount,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      this.feeAmount,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      this.netAmount,
      this.submissionId,
      this.txHash,
      this.timestamp,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      this.cumulativeAmount});

  factory _$OnChainRewardImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnChainRewardImplFromJson(json);

  @override
  final String poolAddress;
  @override
  final double amount;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  final Decimal? grossAmount;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  final Decimal? feeAmount;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  final Decimal? netAmount;
  @override
  final String? submissionId;
  @override
  final String? txHash;
  @override
  final int? timestamp;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  final Decimal? cumulativeAmount;

  @override
  String toString() {
    return 'OnChainReward(poolAddress: $poolAddress, amount: $amount, grossAmount: $grossAmount, feeAmount: $feeAmount, netAmount: $netAmount, submissionId: $submissionId, txHash: $txHash, timestamp: $timestamp, cumulativeAmount: $cumulativeAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnChainRewardImpl &&
            (identical(other.poolAddress, poolAddress) ||
                other.poolAddress == poolAddress) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.grossAmount, grossAmount) ||
                other.grossAmount == grossAmount) &&
            (identical(other.feeAmount, feeAmount) ||
                other.feeAmount == feeAmount) &&
            (identical(other.netAmount, netAmount) ||
                other.netAmount == netAmount) &&
            (identical(other.submissionId, submissionId) ||
                other.submissionId == submissionId) &&
            (identical(other.txHash, txHash) || other.txHash == txHash) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.cumulativeAmount, cumulativeAmount) ||
                other.cumulativeAmount == cumulativeAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, poolAddress, amount, grossAmount,
      feeAmount, netAmount, submissionId, txHash, timestamp, cumulativeAmount);

  /// Create a copy of OnChainReward
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnChainRewardImplCopyWith<_$OnChainRewardImpl> get copyWith =>
      __$$OnChainRewardImplCopyWithImpl<_$OnChainRewardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OnChainRewardImplToJson(
      this,
    );
  }
}

abstract class _OnChainReward implements OnChainReward {
  const factory _OnChainReward(
      {required final String poolAddress,
      required final double amount,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      final Decimal? grossAmount,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      final Decimal? feeAmount,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      final Decimal? netAmount,
      final String? submissionId,
      final String? txHash,
      final int? timestamp,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      final Decimal? cumulativeAmount}) = _$OnChainRewardImpl;

  factory _OnChainReward.fromJson(Map<String, dynamic> json) =
      _$OnChainRewardImpl.fromJson;

  @override
  String get poolAddress;
  @override
  double get amount;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get grossAmount;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get feeAmount;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get netAmount;
  @override
  String? get submissionId;
  @override
  String? get txHash;
  @override
  int? get timestamp;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get cumulativeAmount;

  /// Create a copy of OnChainReward
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnChainRewardImplCopyWith<_$OnChainRewardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
