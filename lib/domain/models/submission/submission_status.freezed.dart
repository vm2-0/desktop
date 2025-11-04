// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submission_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubmissionStatus _$SubmissionStatusFromJson(Map<String, dynamic> json) {
  return _SubmissionStatus.fromJson(json);
}

/// @nodoc
mixin _$SubmissionStatus {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  SubmissionMeta get meta => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get demoHash => throw _privateConstructorUsedError;
  FileManifest? get fileManifest => throw _privateConstructorUsedError;
  bool? get integrityVerified => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  int? get clampedScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'grade_result')
  GradeResult? get gradeResult => throw _privateConstructorUsedError;
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get maxReward => throw _privateConstructorUsedError;
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get reward => throw _privateConstructorUsedError;
  ClaimAuthorization? get claimAuthorization =>
      throw _privateConstructorUsedError;
  OnChainReward? get onChainReward => throw _privateConstructorUsedError;

  /// Serializes this SubmissionStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubmissionStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubmissionStatusCopyWith<SubmissionStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmissionStatusCopyWith<$Res> {
  factory $SubmissionStatusCopyWith(
          SubmissionStatus value, $Res Function(SubmissionStatus) then) =
      _$SubmissionStatusCopyWithImpl<$Res, SubmissionStatus>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String? address,
      SubmissionMeta meta,
      String status,
      String? demoHash,
      FileManifest? fileManifest,
      bool? integrityVerified,
      String? error,
      String createdAt,
      String updatedAt,
      int? clampedScore,
      @JsonKey(name: 'grade_result') GradeResult? gradeResult,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? maxReward,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? reward,
      ClaimAuthorization? claimAuthorization,
      OnChainReward? onChainReward});

  $SubmissionMetaCopyWith<$Res> get meta;
  $FileManifestCopyWith<$Res>? get fileManifest;
  $GradeResultCopyWith<$Res>? get gradeResult;
  $ClaimAuthorizationCopyWith<$Res>? get claimAuthorization;
  $OnChainRewardCopyWith<$Res>? get onChainReward;
}

/// @nodoc
class _$SubmissionStatusCopyWithImpl<$Res, $Val extends SubmissionStatus>
    implements $SubmissionStatusCopyWith<$Res> {
  _$SubmissionStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubmissionStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? address = freezed,
    Object? meta = null,
    Object? status = null,
    Object? demoHash = freezed,
    Object? fileManifest = freezed,
    Object? integrityVerified = freezed,
    Object? error = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? clampedScore = freezed,
    Object? gradeResult = freezed,
    Object? maxReward = freezed,
    Object? reward = freezed,
    Object? claimAuthorization = freezed,
    Object? onChainReward = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as SubmissionMeta,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      demoHash: freezed == demoHash
          ? _value.demoHash
          : demoHash // ignore: cast_nullable_to_non_nullable
              as String?,
      fileManifest: freezed == fileManifest
          ? _value.fileManifest
          : fileManifest // ignore: cast_nullable_to_non_nullable
              as FileManifest?,
      integrityVerified: freezed == integrityVerified
          ? _value.integrityVerified
          : integrityVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      clampedScore: freezed == clampedScore
          ? _value.clampedScore
          : clampedScore // ignore: cast_nullable_to_non_nullable
              as int?,
      gradeResult: freezed == gradeResult
          ? _value.gradeResult
          : gradeResult // ignore: cast_nullable_to_non_nullable
              as GradeResult?,
      maxReward: freezed == maxReward
          ? _value.maxReward
          : maxReward // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      reward: freezed == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      claimAuthorization: freezed == claimAuthorization
          ? _value.claimAuthorization
          : claimAuthorization // ignore: cast_nullable_to_non_nullable
              as ClaimAuthorization?,
      onChainReward: freezed == onChainReward
          ? _value.onChainReward
          : onChainReward // ignore: cast_nullable_to_non_nullable
              as OnChainReward?,
    ) as $Val);
  }

  /// Create a copy of SubmissionStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubmissionMetaCopyWith<$Res> get meta {
    return $SubmissionMetaCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }

  /// Create a copy of SubmissionStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FileManifestCopyWith<$Res>? get fileManifest {
    if (_value.fileManifest == null) {
      return null;
    }

    return $FileManifestCopyWith<$Res>(_value.fileManifest!, (value) {
      return _then(_value.copyWith(fileManifest: value) as $Val);
    });
  }

  /// Create a copy of SubmissionStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GradeResultCopyWith<$Res>? get gradeResult {
    if (_value.gradeResult == null) {
      return null;
    }

    return $GradeResultCopyWith<$Res>(_value.gradeResult!, (value) {
      return _then(_value.copyWith(gradeResult: value) as $Val);
    });
  }

  /// Create a copy of SubmissionStatus
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

  /// Create a copy of SubmissionStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OnChainRewardCopyWith<$Res>? get onChainReward {
    if (_value.onChainReward == null) {
      return null;
    }

    return $OnChainRewardCopyWith<$Res>(_value.onChainReward!, (value) {
      return _then(_value.copyWith(onChainReward: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SubmissionStatusImplCopyWith<$Res>
    implements $SubmissionStatusCopyWith<$Res> {
  factory _$$SubmissionStatusImplCopyWith(_$SubmissionStatusImpl value,
          $Res Function(_$SubmissionStatusImpl) then) =
      __$$SubmissionStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String? address,
      SubmissionMeta meta,
      String status,
      String? demoHash,
      FileManifest? fileManifest,
      bool? integrityVerified,
      String? error,
      String createdAt,
      String updatedAt,
      int? clampedScore,
      @JsonKey(name: 'grade_result') GradeResult? gradeResult,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? maxReward,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? reward,
      ClaimAuthorization? claimAuthorization,
      OnChainReward? onChainReward});

  @override
  $SubmissionMetaCopyWith<$Res> get meta;
  @override
  $FileManifestCopyWith<$Res>? get fileManifest;
  @override
  $GradeResultCopyWith<$Res>? get gradeResult;
  @override
  $ClaimAuthorizationCopyWith<$Res>? get claimAuthorization;
  @override
  $OnChainRewardCopyWith<$Res>? get onChainReward;
}

/// @nodoc
class __$$SubmissionStatusImplCopyWithImpl<$Res>
    extends _$SubmissionStatusCopyWithImpl<$Res, _$SubmissionStatusImpl>
    implements _$$SubmissionStatusImplCopyWith<$Res> {
  __$$SubmissionStatusImplCopyWithImpl(_$SubmissionStatusImpl _value,
      $Res Function(_$SubmissionStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubmissionStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? address = freezed,
    Object? meta = null,
    Object? status = null,
    Object? demoHash = freezed,
    Object? fileManifest = freezed,
    Object? integrityVerified = freezed,
    Object? error = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? clampedScore = freezed,
    Object? gradeResult = freezed,
    Object? maxReward = freezed,
    Object? reward = freezed,
    Object? claimAuthorization = freezed,
    Object? onChainReward = freezed,
  }) {
    return _then(_$SubmissionStatusImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as SubmissionMeta,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      demoHash: freezed == demoHash
          ? _value.demoHash
          : demoHash // ignore: cast_nullable_to_non_nullable
              as String?,
      fileManifest: freezed == fileManifest
          ? _value.fileManifest
          : fileManifest // ignore: cast_nullable_to_non_nullable
              as FileManifest?,
      integrityVerified: freezed == integrityVerified
          ? _value.integrityVerified
          : integrityVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      clampedScore: freezed == clampedScore
          ? _value.clampedScore
          : clampedScore // ignore: cast_nullable_to_non_nullable
              as int?,
      gradeResult: freezed == gradeResult
          ? _value.gradeResult
          : gradeResult // ignore: cast_nullable_to_non_nullable
              as GradeResult?,
      maxReward: freezed == maxReward
          ? _value.maxReward
          : maxReward // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      reward: freezed == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      claimAuthorization: freezed == claimAuthorization
          ? _value.claimAuthorization
          : claimAuthorization // ignore: cast_nullable_to_non_nullable
              as ClaimAuthorization?,
      onChainReward: freezed == onChainReward
          ? _value.onChainReward
          : onChainReward // ignore: cast_nullable_to_non_nullable
              as OnChainReward?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubmissionStatusImpl implements _SubmissionStatus {
  const _$SubmissionStatusImpl(
      {@JsonKey(name: '_id') this.id,
      this.address,
      required this.meta,
      required this.status,
      this.demoHash,
      this.fileManifest,
      this.integrityVerified,
      this.error,
      required this.createdAt,
      required this.updatedAt,
      this.clampedScore,
      @JsonKey(name: 'grade_result') this.gradeResult,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      this.maxReward,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      this.reward,
      this.claimAuthorization,
      this.onChainReward});

  factory _$SubmissionStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubmissionStatusImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String? address;
  @override
  final SubmissionMeta meta;
  @override
  final String status;
  @override
  final String? demoHash;
  @override
  final FileManifest? fileManifest;
  @override
  final bool? integrityVerified;
  @override
  final String? error;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final int? clampedScore;
  @override
  @JsonKey(name: 'grade_result')
  final GradeResult? gradeResult;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  final Decimal? maxReward;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  final Decimal? reward;
  @override
  final ClaimAuthorization? claimAuthorization;
  @override
  final OnChainReward? onChainReward;

  @override
  String toString() {
    return 'SubmissionStatus(id: $id, address: $address, meta: $meta, status: $status, demoHash: $demoHash, fileManifest: $fileManifest, integrityVerified: $integrityVerified, error: $error, createdAt: $createdAt, updatedAt: $updatedAt, clampedScore: $clampedScore, gradeResult: $gradeResult, maxReward: $maxReward, reward: $reward, claimAuthorization: $claimAuthorization, onChainReward: $onChainReward)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmissionStatusImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.meta, meta) || other.meta == meta) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.demoHash, demoHash) ||
                other.demoHash == demoHash) &&
            (identical(other.fileManifest, fileManifest) ||
                other.fileManifest == fileManifest) &&
            (identical(other.integrityVerified, integrityVerified) ||
                other.integrityVerified == integrityVerified) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.clampedScore, clampedScore) ||
                other.clampedScore == clampedScore) &&
            (identical(other.gradeResult, gradeResult) ||
                other.gradeResult == gradeResult) &&
            (identical(other.maxReward, maxReward) ||
                other.maxReward == maxReward) &&
            (identical(other.reward, reward) || other.reward == reward) &&
            (identical(other.claimAuthorization, claimAuthorization) ||
                other.claimAuthorization == claimAuthorization) &&
            (identical(other.onChainReward, onChainReward) ||
                other.onChainReward == onChainReward));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      address,
      meta,
      status,
      demoHash,
      fileManifest,
      integrityVerified,
      error,
      createdAt,
      updatedAt,
      clampedScore,
      gradeResult,
      maxReward,
      reward,
      claimAuthorization,
      onChainReward);

  /// Create a copy of SubmissionStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmissionStatusImplCopyWith<_$SubmissionStatusImpl> get copyWith =>
      __$$SubmissionStatusImplCopyWithImpl<_$SubmissionStatusImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmissionStatusImplToJson(
      this,
    );
  }
}

abstract class _SubmissionStatus implements SubmissionStatus {
  const factory _SubmissionStatus(
      {@JsonKey(name: '_id') final String? id,
      final String? address,
      required final SubmissionMeta meta,
      required final String status,
      final String? demoHash,
      final FileManifest? fileManifest,
      final bool? integrityVerified,
      final String? error,
      required final String createdAt,
      required final String updatedAt,
      final int? clampedScore,
      @JsonKey(name: 'grade_result') final GradeResult? gradeResult,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      final Decimal? maxReward,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      final Decimal? reward,
      final ClaimAuthorization? claimAuthorization,
      final OnChainReward? onChainReward}) = _$SubmissionStatusImpl;

  factory _SubmissionStatus.fromJson(Map<String, dynamic> json) =
      _$SubmissionStatusImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String? get address;
  @override
  SubmissionMeta get meta;
  @override
  String get status;
  @override
  String? get demoHash;
  @override
  FileManifest? get fileManifest;
  @override
  bool? get integrityVerified;
  @override
  String? get error;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  int? get clampedScore;
  @override
  @JsonKey(name: 'grade_result')
  GradeResult? get gradeResult;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get maxReward;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get reward;
  @override
  ClaimAuthorization? get claimAuthorization;
  @override
  OnChainReward? get onChainReward;

  /// Create a copy of SubmissionStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmissionStatusImplCopyWith<_$SubmissionStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
