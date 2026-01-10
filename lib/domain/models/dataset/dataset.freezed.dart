// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dataset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BondingCurve _$BondingCurveFromJson(Map<String, dynamic> json) {
  return _BondingCurve.fromJson(json);
}

/// @nodoc
mixin _$BondingCurve {
  double get virtualETH => throw _privateConstructorUsedError;
  double get virtualTokens => throw _privateConstructorUsedError;
  double get k => throw _privateConstructorUsedError;

  /// Serializes this BondingCurve to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BondingCurve
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BondingCurveCopyWith<BondingCurve> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BondingCurveCopyWith<$Res> {
  factory $BondingCurveCopyWith(
          BondingCurve value, $Res Function(BondingCurve) then) =
      _$BondingCurveCopyWithImpl<$Res, BondingCurve>;
  @useResult
  $Res call({double virtualETH, double virtualTokens, double k});
}

/// @nodoc
class _$BondingCurveCopyWithImpl<$Res, $Val extends BondingCurve>
    implements $BondingCurveCopyWith<$Res> {
  _$BondingCurveCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BondingCurve
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? virtualETH = null,
    Object? virtualTokens = null,
    Object? k = null,
  }) {
    return _then(_value.copyWith(
      virtualETH: null == virtualETH
          ? _value.virtualETH
          : virtualETH // ignore: cast_nullable_to_non_nullable
              as double,
      virtualTokens: null == virtualTokens
          ? _value.virtualTokens
          : virtualTokens // ignore: cast_nullable_to_non_nullable
              as double,
      k: null == k
          ? _value.k
          : k // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BondingCurveImplCopyWith<$Res>
    implements $BondingCurveCopyWith<$Res> {
  factory _$$BondingCurveImplCopyWith(
          _$BondingCurveImpl value, $Res Function(_$BondingCurveImpl) then) =
      __$$BondingCurveImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double virtualETH, double virtualTokens, double k});
}

/// @nodoc
class __$$BondingCurveImplCopyWithImpl<$Res>
    extends _$BondingCurveCopyWithImpl<$Res, _$BondingCurveImpl>
    implements _$$BondingCurveImplCopyWith<$Res> {
  __$$BondingCurveImplCopyWithImpl(
      _$BondingCurveImpl _value, $Res Function(_$BondingCurveImpl) _then)
      : super(_value, _then);

  /// Create a copy of BondingCurve
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? virtualETH = null,
    Object? virtualTokens = null,
    Object? k = null,
  }) {
    return _then(_$BondingCurveImpl(
      virtualETH: null == virtualETH
          ? _value.virtualETH
          : virtualETH // ignore: cast_nullable_to_non_nullable
              as double,
      virtualTokens: null == virtualTokens
          ? _value.virtualTokens
          : virtualTokens // ignore: cast_nullable_to_non_nullable
              as double,
      k: null == k
          ? _value.k
          : k // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BondingCurveImpl implements _BondingCurve {
  const _$BondingCurveImpl(
      {required this.virtualETH, required this.virtualTokens, required this.k});

  factory _$BondingCurveImpl.fromJson(Map<String, dynamic> json) =>
      _$$BondingCurveImplFromJson(json);

  @override
  final double virtualETH;
  @override
  final double virtualTokens;
  @override
  final double k;

  @override
  String toString() {
    return 'BondingCurve(virtualETH: $virtualETH, virtualTokens: $virtualTokens, k: $k)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BondingCurveImpl &&
            (identical(other.virtualETH, virtualETH) ||
                other.virtualETH == virtualETH) &&
            (identical(other.virtualTokens, virtualTokens) ||
                other.virtualTokens == virtualTokens) &&
            (identical(other.k, k) || other.k == k));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, virtualETH, virtualTokens, k);

  /// Create a copy of BondingCurve
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BondingCurveImplCopyWith<_$BondingCurveImpl> get copyWith =>
      __$$BondingCurveImplCopyWithImpl<_$BondingCurveImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BondingCurveImplToJson(
      this,
    );
  }
}

abstract class _BondingCurve implements BondingCurve {
  const factory _BondingCurve(
      {required final double virtualETH,
      required final double virtualTokens,
      required final double k}) = _$BondingCurveImpl;

  factory _BondingCurve.fromJson(Map<String, dynamic> json) =
      _$BondingCurveImpl.fromJson;

  @override
  double get virtualETH;
  @override
  double get virtualTokens;
  @override
  double get k;

  /// Create a copy of BondingCurve
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BondingCurveImplCopyWith<_$BondingCurveImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GraduationInfo _$GraduationInfoFromJson(Map<String, dynamic> json) {
  return _GraduationInfo.fromJson(json);
}

/// @nodoc
mixin _$GraduationInfo {
  DateTime get timestamp => throw _privateConstructorUsedError;
  double get finalPrice => throw _privateConstructorUsedError;
  String? get lpPairAddress => throw _privateConstructorUsedError;

  /// Serializes this GraduationInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GraduationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GraduationInfoCopyWith<GraduationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraduationInfoCopyWith<$Res> {
  factory $GraduationInfoCopyWith(
          GraduationInfo value, $Res Function(GraduationInfo) then) =
      _$GraduationInfoCopyWithImpl<$Res, GraduationInfo>;
  @useResult
  $Res call({DateTime timestamp, double finalPrice, String? lpPairAddress});
}

/// @nodoc
class _$GraduationInfoCopyWithImpl<$Res, $Val extends GraduationInfo>
    implements $GraduationInfoCopyWith<$Res> {
  _$GraduationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GraduationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? finalPrice = null,
    Object? lpPairAddress = freezed,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      finalPrice: null == finalPrice
          ? _value.finalPrice
          : finalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      lpPairAddress: freezed == lpPairAddress
          ? _value.lpPairAddress
          : lpPairAddress // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GraduationInfoImplCopyWith<$Res>
    implements $GraduationInfoCopyWith<$Res> {
  factory _$$GraduationInfoImplCopyWith(_$GraduationInfoImpl value,
          $Res Function(_$GraduationInfoImpl) then) =
      __$$GraduationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime timestamp, double finalPrice, String? lpPairAddress});
}

/// @nodoc
class __$$GraduationInfoImplCopyWithImpl<$Res>
    extends _$GraduationInfoCopyWithImpl<$Res, _$GraduationInfoImpl>
    implements _$$GraduationInfoImplCopyWith<$Res> {
  __$$GraduationInfoImplCopyWithImpl(
      _$GraduationInfoImpl _value, $Res Function(_$GraduationInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of GraduationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? finalPrice = null,
    Object? lpPairAddress = freezed,
  }) {
    return _then(_$GraduationInfoImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      finalPrice: null == finalPrice
          ? _value.finalPrice
          : finalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      lpPairAddress: freezed == lpPairAddress
          ? _value.lpPairAddress
          : lpPairAddress // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GraduationInfoImpl implements _GraduationInfo {
  const _$GraduationInfoImpl(
      {required this.timestamp, required this.finalPrice, this.lpPairAddress});

  factory _$GraduationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraduationInfoImplFromJson(json);

  @override
  final DateTime timestamp;
  @override
  final double finalPrice;
  @override
  final String? lpPairAddress;

  @override
  String toString() {
    return 'GraduationInfo(timestamp: $timestamp, finalPrice: $finalPrice, lpPairAddress: $lpPairAddress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraduationInfoImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.finalPrice, finalPrice) ||
                other.finalPrice == finalPrice) &&
            (identical(other.lpPairAddress, lpPairAddress) ||
                other.lpPairAddress == lpPairAddress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, timestamp, finalPrice, lpPairAddress);

  /// Create a copy of GraduationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GraduationInfoImplCopyWith<_$GraduationInfoImpl> get copyWith =>
      __$$GraduationInfoImplCopyWithImpl<_$GraduationInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraduationInfoImplToJson(
      this,
    );
  }
}

abstract class _GraduationInfo implements GraduationInfo {
  const factory _GraduationInfo(
      {required final DateTime timestamp,
      required final double finalPrice,
      final String? lpPairAddress}) = _$GraduationInfoImpl;

  factory _GraduationInfo.fromJson(Map<String, dynamic> json) =
      _$GraduationInfoImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  double get finalPrice;
  @override
  String? get lpPairAddress;

  /// Create a copy of GraduationInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GraduationInfoImplCopyWith<_$GraduationInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Dataset _$DatasetFromJson(Map<String, dynamic> json) {
  return _Dataset.fromJson(json);
}

/// @nodoc
mixin _$Dataset {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String get contractAddress => throw _privateConstructorUsedError;
  String get creatorAddress => throw _privateConstructorUsedError;
  String? get factoryId =>
      throw _privateConstructorUsedError; // Token economics
  int? get totalSupply => throw _privateConstructorUsedError;
  double? get currentPrice => throw _privateConstructorUsedError;
  double? get marketCap => throw _privateConstructorUsedError;
  double get volume24h => throw _privateConstructorUsedError; // Quality metrics
  double? get qualityScore => throw _privateConstructorUsedError;
  int get demonstrationCount =>
      throw _privateConstructorUsedError; // Burn mechanics
  double get burnThresholdPercentage => throw _privateConstructorUsedError;
  double get totalBurned => throw _privateConstructorUsedError;
  int get burnCount => throw _privateConstructorUsedError; // Lifecycle
  DatasetPhase get phase =>
      throw _privateConstructorUsedError; // Bonding curve parameters
  BondingCurve? get bondingCurve =>
      throw _privateConstructorUsedError; // Graduation info (if applicable)
  GraduationInfo? get graduationInfo => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Dataset to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DatasetCopyWith<Dataset> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DatasetCopyWith<$Res> {
  factory $DatasetCopyWith(Dataset value, $Res Function(Dataset) then) =
      _$DatasetCopyWithImpl<$Res, Dataset>;
  @useResult
  $Res call(
      {String id,
      String name,
      String symbol,
      String? description,
      String? category,
      String contractAddress,
      String creatorAddress,
      String? factoryId,
      int? totalSupply,
      double? currentPrice,
      double? marketCap,
      double volume24h,
      double? qualityScore,
      int demonstrationCount,
      double burnThresholdPercentage,
      double totalBurned,
      int burnCount,
      DatasetPhase phase,
      BondingCurve? bondingCurve,
      GraduationInfo? graduationInfo,
      DateTime createdAt,
      DateTime updatedAt});

  $BondingCurveCopyWith<$Res>? get bondingCurve;
  $GraduationInfoCopyWith<$Res>? get graduationInfo;
}

/// @nodoc
class _$DatasetCopyWithImpl<$Res, $Val extends Dataset>
    implements $DatasetCopyWith<$Res> {
  _$DatasetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? symbol = null,
    Object? description = freezed,
    Object? category = freezed,
    Object? contractAddress = null,
    Object? creatorAddress = null,
    Object? factoryId = freezed,
    Object? totalSupply = freezed,
    Object? currentPrice = freezed,
    Object? marketCap = freezed,
    Object? volume24h = null,
    Object? qualityScore = freezed,
    Object? demonstrationCount = null,
    Object? burnThresholdPercentage = null,
    Object? totalBurned = null,
    Object? burnCount = null,
    Object? phase = null,
    Object? bondingCurve = freezed,
    Object? graduationInfo = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      contractAddress: null == contractAddress
          ? _value.contractAddress
          : contractAddress // ignore: cast_nullable_to_non_nullable
              as String,
      creatorAddress: null == creatorAddress
          ? _value.creatorAddress
          : creatorAddress // ignore: cast_nullable_to_non_nullable
              as String,
      factoryId: freezed == factoryId
          ? _value.factoryId
          : factoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalSupply: freezed == totalSupply
          ? _value.totalSupply
          : totalSupply // ignore: cast_nullable_to_non_nullable
              as int?,
      currentPrice: freezed == currentPrice
          ? _value.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      marketCap: freezed == marketCap
          ? _value.marketCap
          : marketCap // ignore: cast_nullable_to_non_nullable
              as double?,
      volume24h: null == volume24h
          ? _value.volume24h
          : volume24h // ignore: cast_nullable_to_non_nullable
              as double,
      qualityScore: freezed == qualityScore
          ? _value.qualityScore
          : qualityScore // ignore: cast_nullable_to_non_nullable
              as double?,
      demonstrationCount: null == demonstrationCount
          ? _value.demonstrationCount
          : demonstrationCount // ignore: cast_nullable_to_non_nullable
              as int,
      burnThresholdPercentage: null == burnThresholdPercentage
          ? _value.burnThresholdPercentage
          : burnThresholdPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      totalBurned: null == totalBurned
          ? _value.totalBurned
          : totalBurned // ignore: cast_nullable_to_non_nullable
              as double,
      burnCount: null == burnCount
          ? _value.burnCount
          : burnCount // ignore: cast_nullable_to_non_nullable
              as int,
      phase: null == phase
          ? _value.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as DatasetPhase,
      bondingCurve: freezed == bondingCurve
          ? _value.bondingCurve
          : bondingCurve // ignore: cast_nullable_to_non_nullable
              as BondingCurve?,
      graduationInfo: freezed == graduationInfo
          ? _value.graduationInfo
          : graduationInfo // ignore: cast_nullable_to_non_nullable
              as GraduationInfo?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BondingCurveCopyWith<$Res>? get bondingCurve {
    if (_value.bondingCurve == null) {
      return null;
    }

    return $BondingCurveCopyWith<$Res>(_value.bondingCurve!, (value) {
      return _then(_value.copyWith(bondingCurve: value) as $Val);
    });
  }

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GraduationInfoCopyWith<$Res>? get graduationInfo {
    if (_value.graduationInfo == null) {
      return null;
    }

    return $GraduationInfoCopyWith<$Res>(_value.graduationInfo!, (value) {
      return _then(_value.copyWith(graduationInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DatasetImplCopyWith<$Res> implements $DatasetCopyWith<$Res> {
  factory _$$DatasetImplCopyWith(
          _$DatasetImpl value, $Res Function(_$DatasetImpl) then) =
      __$$DatasetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String symbol,
      String? description,
      String? category,
      String contractAddress,
      String creatorAddress,
      String? factoryId,
      int? totalSupply,
      double? currentPrice,
      double? marketCap,
      double volume24h,
      double? qualityScore,
      int demonstrationCount,
      double burnThresholdPercentage,
      double totalBurned,
      int burnCount,
      DatasetPhase phase,
      BondingCurve? bondingCurve,
      GraduationInfo? graduationInfo,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $BondingCurveCopyWith<$Res>? get bondingCurve;
  @override
  $GraduationInfoCopyWith<$Res>? get graduationInfo;
}

/// @nodoc
class __$$DatasetImplCopyWithImpl<$Res>
    extends _$DatasetCopyWithImpl<$Res, _$DatasetImpl>
    implements _$$DatasetImplCopyWith<$Res> {
  __$$DatasetImplCopyWithImpl(
      _$DatasetImpl _value, $Res Function(_$DatasetImpl) _then)
      : super(_value, _then);

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? symbol = null,
    Object? description = freezed,
    Object? category = freezed,
    Object? contractAddress = null,
    Object? creatorAddress = null,
    Object? factoryId = freezed,
    Object? totalSupply = freezed,
    Object? currentPrice = freezed,
    Object? marketCap = freezed,
    Object? volume24h = null,
    Object? qualityScore = freezed,
    Object? demonstrationCount = null,
    Object? burnThresholdPercentage = null,
    Object? totalBurned = null,
    Object? burnCount = null,
    Object? phase = null,
    Object? bondingCurve = freezed,
    Object? graduationInfo = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$DatasetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      contractAddress: null == contractAddress
          ? _value.contractAddress
          : contractAddress // ignore: cast_nullable_to_non_nullable
              as String,
      creatorAddress: null == creatorAddress
          ? _value.creatorAddress
          : creatorAddress // ignore: cast_nullable_to_non_nullable
              as String,
      factoryId: freezed == factoryId
          ? _value.factoryId
          : factoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalSupply: freezed == totalSupply
          ? _value.totalSupply
          : totalSupply // ignore: cast_nullable_to_non_nullable
              as int?,
      currentPrice: freezed == currentPrice
          ? _value.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      marketCap: freezed == marketCap
          ? _value.marketCap
          : marketCap // ignore: cast_nullable_to_non_nullable
              as double?,
      volume24h: null == volume24h
          ? _value.volume24h
          : volume24h // ignore: cast_nullable_to_non_nullable
              as double,
      qualityScore: freezed == qualityScore
          ? _value.qualityScore
          : qualityScore // ignore: cast_nullable_to_non_nullable
              as double?,
      demonstrationCount: null == demonstrationCount
          ? _value.demonstrationCount
          : demonstrationCount // ignore: cast_nullable_to_non_nullable
              as int,
      burnThresholdPercentage: null == burnThresholdPercentage
          ? _value.burnThresholdPercentage
          : burnThresholdPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      totalBurned: null == totalBurned
          ? _value.totalBurned
          : totalBurned // ignore: cast_nullable_to_non_nullable
              as double,
      burnCount: null == burnCount
          ? _value.burnCount
          : burnCount // ignore: cast_nullable_to_non_nullable
              as int,
      phase: null == phase
          ? _value.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as DatasetPhase,
      bondingCurve: freezed == bondingCurve
          ? _value.bondingCurve
          : bondingCurve // ignore: cast_nullable_to_non_nullable
              as BondingCurve?,
      graduationInfo: freezed == graduationInfo
          ? _value.graduationInfo
          : graduationInfo // ignore: cast_nullable_to_non_nullable
              as GraduationInfo?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DatasetImpl implements _Dataset {
  const _$DatasetImpl(
      {required this.id,
      required this.name,
      required this.symbol,
      this.description,
      this.category,
      required this.contractAddress,
      required this.creatorAddress,
      this.factoryId,
      this.totalSupply,
      this.currentPrice,
      this.marketCap,
      this.volume24h = 0.0,
      this.qualityScore,
      this.demonstrationCount = 0,
      required this.burnThresholdPercentage,
      this.totalBurned = 0.0,
      this.burnCount = 0,
      required this.phase,
      this.bondingCurve,
      this.graduationInfo,
      required this.createdAt,
      required this.updatedAt});

  factory _$DatasetImpl.fromJson(Map<String, dynamic> json) =>
      _$$DatasetImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String symbol;
  @override
  final String? description;
  @override
  final String? category;
  @override
  final String contractAddress;
  @override
  final String creatorAddress;
  @override
  final String? factoryId;
// Token economics
  @override
  final int? totalSupply;
  @override
  final double? currentPrice;
  @override
  final double? marketCap;
  @override
  @JsonKey()
  final double volume24h;
// Quality metrics
  @override
  final double? qualityScore;
  @override
  @JsonKey()
  final int demonstrationCount;
// Burn mechanics
  @override
  final double burnThresholdPercentage;
  @override
  @JsonKey()
  final double totalBurned;
  @override
  @JsonKey()
  final int burnCount;
// Lifecycle
  @override
  final DatasetPhase phase;
// Bonding curve parameters
  @override
  final BondingCurve? bondingCurve;
// Graduation info (if applicable)
  @override
  final GraduationInfo? graduationInfo;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Dataset(id: $id, name: $name, symbol: $symbol, description: $description, category: $category, contractAddress: $contractAddress, creatorAddress: $creatorAddress, factoryId: $factoryId, totalSupply: $totalSupply, currentPrice: $currentPrice, marketCap: $marketCap, volume24h: $volume24h, qualityScore: $qualityScore, demonstrationCount: $demonstrationCount, burnThresholdPercentage: $burnThresholdPercentage, totalBurned: $totalBurned, burnCount: $burnCount, phase: $phase, bondingCurve: $bondingCurve, graduationInfo: $graduationInfo, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DatasetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.contractAddress, contractAddress) ||
                other.contractAddress == contractAddress) &&
            (identical(other.creatorAddress, creatorAddress) ||
                other.creatorAddress == creatorAddress) &&
            (identical(other.factoryId, factoryId) ||
                other.factoryId == factoryId) &&
            (identical(other.totalSupply, totalSupply) ||
                other.totalSupply == totalSupply) &&
            (identical(other.currentPrice, currentPrice) ||
                other.currentPrice == currentPrice) &&
            (identical(other.marketCap, marketCap) ||
                other.marketCap == marketCap) &&
            (identical(other.volume24h, volume24h) ||
                other.volume24h == volume24h) &&
            (identical(other.qualityScore, qualityScore) ||
                other.qualityScore == qualityScore) &&
            (identical(other.demonstrationCount, demonstrationCount) ||
                other.demonstrationCount == demonstrationCount) &&
            (identical(
                    other.burnThresholdPercentage, burnThresholdPercentage) ||
                other.burnThresholdPercentage == burnThresholdPercentage) &&
            (identical(other.totalBurned, totalBurned) ||
                other.totalBurned == totalBurned) &&
            (identical(other.burnCount, burnCount) ||
                other.burnCount == burnCount) &&
            (identical(other.phase, phase) || other.phase == phase) &&
            (identical(other.bondingCurve, bondingCurve) ||
                other.bondingCurve == bondingCurve) &&
            (identical(other.graduationInfo, graduationInfo) ||
                other.graduationInfo == graduationInfo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        symbol,
        description,
        category,
        contractAddress,
        creatorAddress,
        factoryId,
        totalSupply,
        currentPrice,
        marketCap,
        volume24h,
        qualityScore,
        demonstrationCount,
        burnThresholdPercentage,
        totalBurned,
        burnCount,
        phase,
        bondingCurve,
        graduationInfo,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DatasetImplCopyWith<_$DatasetImpl> get copyWith =>
      __$$DatasetImplCopyWithImpl<_$DatasetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DatasetImplToJson(
      this,
    );
  }
}

abstract class _Dataset implements Dataset {
  const factory _Dataset(
      {required final String id,
      required final String name,
      required final String symbol,
      final String? description,
      final String? category,
      required final String contractAddress,
      required final String creatorAddress,
      final String? factoryId,
      final int? totalSupply,
      final double? currentPrice,
      final double? marketCap,
      final double volume24h,
      final double? qualityScore,
      final int demonstrationCount,
      required final double burnThresholdPercentage,
      final double totalBurned,
      final int burnCount,
      required final DatasetPhase phase,
      final BondingCurve? bondingCurve,
      final GraduationInfo? graduationInfo,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$DatasetImpl;

  factory _Dataset.fromJson(Map<String, dynamic> json) = _$DatasetImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get symbol;
  @override
  String? get description;
  @override
  String? get category;
  @override
  String get contractAddress;
  @override
  String get creatorAddress;
  @override
  String? get factoryId; // Token economics
  @override
  int? get totalSupply;
  @override
  double? get currentPrice;
  @override
  double? get marketCap;
  @override
  double get volume24h; // Quality metrics
  @override
  double? get qualityScore;
  @override
  int get demonstrationCount; // Burn mechanics
  @override
  double get burnThresholdPercentage;
  @override
  double get totalBurned;
  @override
  int get burnCount; // Lifecycle
  @override
  DatasetPhase get phase; // Bonding curve parameters
  @override
  BondingCurve? get bondingCurve; // Graduation info (if applicable)
  @override
  GraduationInfo? get graduationInfo;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DatasetImplCopyWith<_$DatasetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateDatasetRequest _$CreateDatasetRequestFromJson(Map<String, dynamic> json) {
  return _CreateDatasetRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateDatasetRequest {
  String get name => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  List<String> get demoHashes => throw _privateConstructorUsedError;
  String? get factoryId => throw _privateConstructorUsedError;
  double get burnThresholdPercentage => throw _privateConstructorUsedError;

  /// Serializes this CreateDatasetRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateDatasetRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateDatasetRequestCopyWith<CreateDatasetRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateDatasetRequestCopyWith<$Res> {
  factory $CreateDatasetRequestCopyWith(CreateDatasetRequest value,
          $Res Function(CreateDatasetRequest) then) =
      _$CreateDatasetRequestCopyWithImpl<$Res, CreateDatasetRequest>;
  @useResult
  $Res call(
      {String name,
      String symbol,
      String? description,
      String? category,
      List<String> demoHashes,
      String? factoryId,
      double burnThresholdPercentage});
}

/// @nodoc
class _$CreateDatasetRequestCopyWithImpl<$Res,
        $Val extends CreateDatasetRequest>
    implements $CreateDatasetRequestCopyWith<$Res> {
  _$CreateDatasetRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateDatasetRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? symbol = null,
    Object? description = freezed,
    Object? category = freezed,
    Object? demoHashes = null,
    Object? factoryId = freezed,
    Object? burnThresholdPercentage = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      demoHashes: null == demoHashes
          ? _value.demoHashes
          : demoHashes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      factoryId: freezed == factoryId
          ? _value.factoryId
          : factoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      burnThresholdPercentage: null == burnThresholdPercentage
          ? _value.burnThresholdPercentage
          : burnThresholdPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateDatasetRequestImplCopyWith<$Res>
    implements $CreateDatasetRequestCopyWith<$Res> {
  factory _$$CreateDatasetRequestImplCopyWith(_$CreateDatasetRequestImpl value,
          $Res Function(_$CreateDatasetRequestImpl) then) =
      __$$CreateDatasetRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String symbol,
      String? description,
      String? category,
      List<String> demoHashes,
      String? factoryId,
      double burnThresholdPercentage});
}

/// @nodoc
class __$$CreateDatasetRequestImplCopyWithImpl<$Res>
    extends _$CreateDatasetRequestCopyWithImpl<$Res, _$CreateDatasetRequestImpl>
    implements _$$CreateDatasetRequestImplCopyWith<$Res> {
  __$$CreateDatasetRequestImplCopyWithImpl(_$CreateDatasetRequestImpl _value,
      $Res Function(_$CreateDatasetRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateDatasetRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? symbol = null,
    Object? description = freezed,
    Object? category = freezed,
    Object? demoHashes = null,
    Object? factoryId = freezed,
    Object? burnThresholdPercentage = null,
  }) {
    return _then(_$CreateDatasetRequestImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      demoHashes: null == demoHashes
          ? _value._demoHashes
          : demoHashes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      factoryId: freezed == factoryId
          ? _value.factoryId
          : factoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      burnThresholdPercentage: null == burnThresholdPercentage
          ? _value.burnThresholdPercentage
          : burnThresholdPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateDatasetRequestImpl implements _CreateDatasetRequest {
  const _$CreateDatasetRequestImpl(
      {required this.name,
      required this.symbol,
      this.description,
      this.category,
      final List<String> demoHashes = const [],
      this.factoryId,
      this.burnThresholdPercentage = 5.0})
      : _demoHashes = demoHashes;

  factory _$CreateDatasetRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateDatasetRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String symbol;
  @override
  final String? description;
  @override
  final String? category;
  final List<String> _demoHashes;
  @override
  @JsonKey()
  List<String> get demoHashes {
    if (_demoHashes is EqualUnmodifiableListView) return _demoHashes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_demoHashes);
  }

  @override
  final String? factoryId;
  @override
  @JsonKey()
  final double burnThresholdPercentage;

  @override
  String toString() {
    return 'CreateDatasetRequest(name: $name, symbol: $symbol, description: $description, category: $category, demoHashes: $demoHashes, factoryId: $factoryId, burnThresholdPercentage: $burnThresholdPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateDatasetRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality()
                .equals(other._demoHashes, _demoHashes) &&
            (identical(other.factoryId, factoryId) ||
                other.factoryId == factoryId) &&
            (identical(
                    other.burnThresholdPercentage, burnThresholdPercentage) ||
                other.burnThresholdPercentage == burnThresholdPercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      symbol,
      description,
      category,
      const DeepCollectionEquality().hash(_demoHashes),
      factoryId,
      burnThresholdPercentage);

  /// Create a copy of CreateDatasetRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateDatasetRequestImplCopyWith<_$CreateDatasetRequestImpl>
      get copyWith =>
          __$$CreateDatasetRequestImplCopyWithImpl<_$CreateDatasetRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateDatasetRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateDatasetRequest implements CreateDatasetRequest {
  const factory _CreateDatasetRequest(
      {required final String name,
      required final String symbol,
      final String? description,
      final String? category,
      final List<String> demoHashes,
      final String? factoryId,
      final double burnThresholdPercentage}) = _$CreateDatasetRequestImpl;

  factory _CreateDatasetRequest.fromJson(Map<String, dynamic> json) =
      _$CreateDatasetRequestImpl.fromJson;

  @override
  String get name;
  @override
  String get symbol;
  @override
  String? get description;
  @override
  String? get category;
  @override
  List<String> get demoHashes;
  @override
  String? get factoryId;
  @override
  double get burnThresholdPercentage;

  /// Create a copy of CreateDatasetRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateDatasetRequestImplCopyWith<_$CreateDatasetRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CreateDatasetResponse _$CreateDatasetResponseFromJson(
    Map<String, dynamic> json) {
  return _CreateDatasetResponse.fromJson(json);
}

/// @nodoc
mixin _$CreateDatasetResponse {
  Dataset get dataset => throw _privateConstructorUsedError;

  /// Serializes this CreateDatasetResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateDatasetResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateDatasetResponseCopyWith<CreateDatasetResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateDatasetResponseCopyWith<$Res> {
  factory $CreateDatasetResponseCopyWith(CreateDatasetResponse value,
          $Res Function(CreateDatasetResponse) then) =
      _$CreateDatasetResponseCopyWithImpl<$Res, CreateDatasetResponse>;
  @useResult
  $Res call({Dataset dataset});

  $DatasetCopyWith<$Res> get dataset;
}

/// @nodoc
class _$CreateDatasetResponseCopyWithImpl<$Res,
        $Val extends CreateDatasetResponse>
    implements $CreateDatasetResponseCopyWith<$Res> {
  _$CreateDatasetResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateDatasetResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataset = null,
  }) {
    return _then(_value.copyWith(
      dataset: null == dataset
          ? _value.dataset
          : dataset // ignore: cast_nullable_to_non_nullable
              as Dataset,
    ) as $Val);
  }

  /// Create a copy of CreateDatasetResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DatasetCopyWith<$Res> get dataset {
    return $DatasetCopyWith<$Res>(_value.dataset, (value) {
      return _then(_value.copyWith(dataset: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateDatasetResponseImplCopyWith<$Res>
    implements $CreateDatasetResponseCopyWith<$Res> {
  factory _$$CreateDatasetResponseImplCopyWith(
          _$CreateDatasetResponseImpl value,
          $Res Function(_$CreateDatasetResponseImpl) then) =
      __$$CreateDatasetResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Dataset dataset});

  @override
  $DatasetCopyWith<$Res> get dataset;
}

/// @nodoc
class __$$CreateDatasetResponseImplCopyWithImpl<$Res>
    extends _$CreateDatasetResponseCopyWithImpl<$Res,
        _$CreateDatasetResponseImpl>
    implements _$$CreateDatasetResponseImplCopyWith<$Res> {
  __$$CreateDatasetResponseImplCopyWithImpl(_$CreateDatasetResponseImpl _value,
      $Res Function(_$CreateDatasetResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateDatasetResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataset = null,
  }) {
    return _then(_$CreateDatasetResponseImpl(
      dataset: null == dataset
          ? _value.dataset
          : dataset // ignore: cast_nullable_to_non_nullable
              as Dataset,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateDatasetResponseImpl implements _CreateDatasetResponse {
  const _$CreateDatasetResponseImpl({required this.dataset});

  factory _$CreateDatasetResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateDatasetResponseImplFromJson(json);

  @override
  final Dataset dataset;

  @override
  String toString() {
    return 'CreateDatasetResponse(dataset: $dataset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateDatasetResponseImpl &&
            (identical(other.dataset, dataset) || other.dataset == dataset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dataset);

  /// Create a copy of CreateDatasetResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateDatasetResponseImplCopyWith<_$CreateDatasetResponseImpl>
      get copyWith => __$$CreateDatasetResponseImplCopyWithImpl<
          _$CreateDatasetResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateDatasetResponseImplToJson(
      this,
    );
  }
}

abstract class _CreateDatasetResponse implements CreateDatasetResponse {
  const factory _CreateDatasetResponse({required final Dataset dataset}) =
      _$CreateDatasetResponseImpl;

  factory _CreateDatasetResponse.fromJson(Map<String, dynamic> json) =
      _$CreateDatasetResponseImpl.fromJson;

  @override
  Dataset get dataset;

  /// Create a copy of CreateDatasetResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateDatasetResponseImplCopyWith<_$CreateDatasetResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
