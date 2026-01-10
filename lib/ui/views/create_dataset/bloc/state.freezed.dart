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
mixin _$CreateDatasetState {
  String? get name => throw _privateConstructorUsedError;
  String? get symbol => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  int get burnThresholdPercentage => throw _privateConstructorUsedError;
  String? get factoryId => throw _privateConstructorUsedError;
  List<String>? get demoHashes => throw _privateConstructorUsedError;
  String? get predictedTokenAddress => throw _privateConstructorUsedError;
  String? get predictedBondingCurveAddress =>
      throw _privateConstructorUsedError;
  String? get estimatedEthFee => throw _privateConstructorUsedError;
  String? get estimatedClonesFee => throw _privateConstructorUsedError;
  CreateDatasetStep get currentStep => throw _privateConstructorUsedError;
  bool get isCreating => throw _privateConstructorUsedError;
  bool get isCreated => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get createdDatasetId => throw _privateConstructorUsedError;
  String? get transactionStatus => throw _privateConstructorUsedError;
  double? get calculatedQualityScore => throw _privateConstructorUsedError;
  int? get demonstrationCount => throw _privateConstructorUsedError;

  /// Create a copy of CreateDatasetState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateDatasetStateCopyWith<CreateDatasetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateDatasetStateCopyWith<$Res> {
  factory $CreateDatasetStateCopyWith(
          CreateDatasetState value, $Res Function(CreateDatasetState) then) =
      _$CreateDatasetStateCopyWithImpl<$Res, CreateDatasetState>;
  @useResult
  $Res call(
      {String? name,
      String? symbol,
      String? description,
      String? category,
      int burnThresholdPercentage,
      String? factoryId,
      List<String>? demoHashes,
      String? predictedTokenAddress,
      String? predictedBondingCurveAddress,
      String? estimatedEthFee,
      String? estimatedClonesFee,
      CreateDatasetStep currentStep,
      bool isCreating,
      bool isCreated,
      String? error,
      String? createdDatasetId,
      String? transactionStatus,
      double? calculatedQualityScore,
      int? demonstrationCount});
}

/// @nodoc
class _$CreateDatasetStateCopyWithImpl<$Res, $Val extends CreateDatasetState>
    implements $CreateDatasetStateCopyWith<$Res> {
  _$CreateDatasetStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateDatasetState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? symbol = freezed,
    Object? description = freezed,
    Object? category = freezed,
    Object? burnThresholdPercentage = null,
    Object? factoryId = freezed,
    Object? demoHashes = freezed,
    Object? predictedTokenAddress = freezed,
    Object? predictedBondingCurveAddress = freezed,
    Object? estimatedEthFee = freezed,
    Object? estimatedClonesFee = freezed,
    Object? currentStep = null,
    Object? isCreating = null,
    Object? isCreated = null,
    Object? error = freezed,
    Object? createdDatasetId = freezed,
    Object? transactionStatus = freezed,
    Object? calculatedQualityScore = freezed,
    Object? demonstrationCount = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      symbol: freezed == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      burnThresholdPercentage: null == burnThresholdPercentage
          ? _value.burnThresholdPercentage
          : burnThresholdPercentage // ignore: cast_nullable_to_non_nullable
              as int,
      factoryId: freezed == factoryId
          ? _value.factoryId
          : factoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      demoHashes: freezed == demoHashes
          ? _value.demoHashes
          : demoHashes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      predictedTokenAddress: freezed == predictedTokenAddress
          ? _value.predictedTokenAddress
          : predictedTokenAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      predictedBondingCurveAddress: freezed == predictedBondingCurveAddress
          ? _value.predictedBondingCurveAddress
          : predictedBondingCurveAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedEthFee: freezed == estimatedEthFee
          ? _value.estimatedEthFee
          : estimatedEthFee // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedClonesFee: freezed == estimatedClonesFee
          ? _value.estimatedClonesFee
          : estimatedClonesFee // ignore: cast_nullable_to_non_nullable
              as String?,
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as CreateDatasetStep,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreated: null == isCreated
          ? _value.isCreated
          : isCreated // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      createdDatasetId: freezed == createdDatasetId
          ? _value.createdDatasetId
          : createdDatasetId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionStatus: freezed == transactionStatus
          ? _value.transactionStatus
          : transactionStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      calculatedQualityScore: freezed == calculatedQualityScore
          ? _value.calculatedQualityScore
          : calculatedQualityScore // ignore: cast_nullable_to_non_nullable
              as double?,
      demonstrationCount: freezed == demonstrationCount
          ? _value.demonstrationCount
          : demonstrationCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateDatasetStateImplCopyWith<$Res>
    implements $CreateDatasetStateCopyWith<$Res> {
  factory _$$CreateDatasetStateImplCopyWith(_$CreateDatasetStateImpl value,
          $Res Function(_$CreateDatasetStateImpl) then) =
      __$$CreateDatasetStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? name,
      String? symbol,
      String? description,
      String? category,
      int burnThresholdPercentage,
      String? factoryId,
      List<String>? demoHashes,
      String? predictedTokenAddress,
      String? predictedBondingCurveAddress,
      String? estimatedEthFee,
      String? estimatedClonesFee,
      CreateDatasetStep currentStep,
      bool isCreating,
      bool isCreated,
      String? error,
      String? createdDatasetId,
      String? transactionStatus,
      double? calculatedQualityScore,
      int? demonstrationCount});
}

/// @nodoc
class __$$CreateDatasetStateImplCopyWithImpl<$Res>
    extends _$CreateDatasetStateCopyWithImpl<$Res, _$CreateDatasetStateImpl>
    implements _$$CreateDatasetStateImplCopyWith<$Res> {
  __$$CreateDatasetStateImplCopyWithImpl(_$CreateDatasetStateImpl _value,
      $Res Function(_$CreateDatasetStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateDatasetState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? symbol = freezed,
    Object? description = freezed,
    Object? category = freezed,
    Object? burnThresholdPercentage = null,
    Object? factoryId = freezed,
    Object? demoHashes = freezed,
    Object? predictedTokenAddress = freezed,
    Object? predictedBondingCurveAddress = freezed,
    Object? estimatedEthFee = freezed,
    Object? estimatedClonesFee = freezed,
    Object? currentStep = null,
    Object? isCreating = null,
    Object? isCreated = null,
    Object? error = freezed,
    Object? createdDatasetId = freezed,
    Object? transactionStatus = freezed,
    Object? calculatedQualityScore = freezed,
    Object? demonstrationCount = freezed,
  }) {
    return _then(_$CreateDatasetStateImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      symbol: freezed == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      burnThresholdPercentage: null == burnThresholdPercentage
          ? _value.burnThresholdPercentage
          : burnThresholdPercentage // ignore: cast_nullable_to_non_nullable
              as int,
      factoryId: freezed == factoryId
          ? _value.factoryId
          : factoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      demoHashes: freezed == demoHashes
          ? _value._demoHashes
          : demoHashes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      predictedTokenAddress: freezed == predictedTokenAddress
          ? _value.predictedTokenAddress
          : predictedTokenAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      predictedBondingCurveAddress: freezed == predictedBondingCurveAddress
          ? _value.predictedBondingCurveAddress
          : predictedBondingCurveAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedEthFee: freezed == estimatedEthFee
          ? _value.estimatedEthFee
          : estimatedEthFee // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedClonesFee: freezed == estimatedClonesFee
          ? _value.estimatedClonesFee
          : estimatedClonesFee // ignore: cast_nullable_to_non_nullable
              as String?,
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as CreateDatasetStep,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreated: null == isCreated
          ? _value.isCreated
          : isCreated // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      createdDatasetId: freezed == createdDatasetId
          ? _value.createdDatasetId
          : createdDatasetId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionStatus: freezed == transactionStatus
          ? _value.transactionStatus
          : transactionStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      calculatedQualityScore: freezed == calculatedQualityScore
          ? _value.calculatedQualityScore
          : calculatedQualityScore // ignore: cast_nullable_to_non_nullable
              as double?,
      demonstrationCount: freezed == demonstrationCount
          ? _value.demonstrationCount
          : demonstrationCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$CreateDatasetStateImpl extends _CreateDatasetState {
  const _$CreateDatasetStateImpl(
      {this.name,
      this.symbol,
      this.description,
      this.category,
      this.burnThresholdPercentage = 5,
      this.factoryId,
      final List<String>? demoHashes,
      this.predictedTokenAddress,
      this.predictedBondingCurveAddress,
      this.estimatedEthFee,
      this.estimatedClonesFee,
      this.currentStep = CreateDatasetStep.input,
      this.isCreating = false,
      this.isCreated = false,
      this.error,
      this.createdDatasetId,
      this.transactionStatus,
      this.calculatedQualityScore,
      this.demonstrationCount})
      : _demoHashes = demoHashes,
        super._();

  @override
  final String? name;
  @override
  final String? symbol;
  @override
  final String? description;
  @override
  final String? category;
  @override
  @JsonKey()
  final int burnThresholdPercentage;
  @override
  final String? factoryId;
  final List<String>? _demoHashes;
  @override
  List<String>? get demoHashes {
    final value = _demoHashes;
    if (value == null) return null;
    if (_demoHashes is EqualUnmodifiableListView) return _demoHashes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? predictedTokenAddress;
  @override
  final String? predictedBondingCurveAddress;
  @override
  final String? estimatedEthFee;
  @override
  final String? estimatedClonesFee;
  @override
  @JsonKey()
  final CreateDatasetStep currentStep;
  @override
  @JsonKey()
  final bool isCreating;
  @override
  @JsonKey()
  final bool isCreated;
  @override
  final String? error;
  @override
  final String? createdDatasetId;
  @override
  final String? transactionStatus;
  @override
  final double? calculatedQualityScore;
  @override
  final int? demonstrationCount;

  @override
  String toString() {
    return 'CreateDatasetState(name: $name, symbol: $symbol, description: $description, category: $category, burnThresholdPercentage: $burnThresholdPercentage, factoryId: $factoryId, demoHashes: $demoHashes, predictedTokenAddress: $predictedTokenAddress, predictedBondingCurveAddress: $predictedBondingCurveAddress, estimatedEthFee: $estimatedEthFee, estimatedClonesFee: $estimatedClonesFee, currentStep: $currentStep, isCreating: $isCreating, isCreated: $isCreated, error: $error, createdDatasetId: $createdDatasetId, transactionStatus: $transactionStatus, calculatedQualityScore: $calculatedQualityScore, demonstrationCount: $demonstrationCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateDatasetStateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(
                    other.burnThresholdPercentage, burnThresholdPercentage) ||
                other.burnThresholdPercentage == burnThresholdPercentage) &&
            (identical(other.factoryId, factoryId) ||
                other.factoryId == factoryId) &&
            const DeepCollectionEquality()
                .equals(other._demoHashes, _demoHashes) &&
            (identical(other.predictedTokenAddress, predictedTokenAddress) ||
                other.predictedTokenAddress == predictedTokenAddress) &&
            (identical(other.predictedBondingCurveAddress,
                    predictedBondingCurveAddress) ||
                other.predictedBondingCurveAddress ==
                    predictedBondingCurveAddress) &&
            (identical(other.estimatedEthFee, estimatedEthFee) ||
                other.estimatedEthFee == estimatedEthFee) &&
            (identical(other.estimatedClonesFee, estimatedClonesFee) ||
                other.estimatedClonesFee == estimatedClonesFee) &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.isCreating, isCreating) ||
                other.isCreating == isCreating) &&
            (identical(other.isCreated, isCreated) ||
                other.isCreated == isCreated) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.createdDatasetId, createdDatasetId) ||
                other.createdDatasetId == createdDatasetId) &&
            (identical(other.transactionStatus, transactionStatus) ||
                other.transactionStatus == transactionStatus) &&
            (identical(other.calculatedQualityScore, calculatedQualityScore) ||
                other.calculatedQualityScore == calculatedQualityScore) &&
            (identical(other.demonstrationCount, demonstrationCount) ||
                other.demonstrationCount == demonstrationCount));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        name,
        symbol,
        description,
        category,
        burnThresholdPercentage,
        factoryId,
        const DeepCollectionEquality().hash(_demoHashes),
        predictedTokenAddress,
        predictedBondingCurveAddress,
        estimatedEthFee,
        estimatedClonesFee,
        currentStep,
        isCreating,
        isCreated,
        error,
        createdDatasetId,
        transactionStatus,
        calculatedQualityScore,
        demonstrationCount
      ]);

  /// Create a copy of CreateDatasetState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateDatasetStateImplCopyWith<_$CreateDatasetStateImpl> get copyWith =>
      __$$CreateDatasetStateImplCopyWithImpl<_$CreateDatasetStateImpl>(
          this, _$identity);
}

abstract class _CreateDatasetState extends CreateDatasetState {
  const factory _CreateDatasetState(
      {final String? name,
      final String? symbol,
      final String? description,
      final String? category,
      final int burnThresholdPercentage,
      final String? factoryId,
      final List<String>? demoHashes,
      final String? predictedTokenAddress,
      final String? predictedBondingCurveAddress,
      final String? estimatedEthFee,
      final String? estimatedClonesFee,
      final CreateDatasetStep currentStep,
      final bool isCreating,
      final bool isCreated,
      final String? error,
      final String? createdDatasetId,
      final String? transactionStatus,
      final double? calculatedQualityScore,
      final int? demonstrationCount}) = _$CreateDatasetStateImpl;
  const _CreateDatasetState._() : super._();

  @override
  String? get name;
  @override
  String? get symbol;
  @override
  String? get description;
  @override
  String? get category;
  @override
  int get burnThresholdPercentage;
  @override
  String? get factoryId;
  @override
  List<String>? get demoHashes;
  @override
  String? get predictedTokenAddress;
  @override
  String? get predictedBondingCurveAddress;
  @override
  String? get estimatedEthFee;
  @override
  String? get estimatedClonesFee;
  @override
  CreateDatasetStep get currentStep;
  @override
  bool get isCreating;
  @override
  bool get isCreated;
  @override
  String? get error;
  @override
  String? get createdDatasetId;
  @override
  String? get transactionStatus;
  @override
  double? get calculatedQualityScore;
  @override
  int? get demonstrationCount;

  /// Create a copy of CreateDatasetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateDatasetStateImplCopyWith<_$CreateDatasetStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
