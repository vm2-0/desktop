// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'factory_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FactoryTask _$FactoryTaskFromJson(Map<String, dynamic> json) {
  return _FactoryTask.fromJson(json);
}

/// @nodoc
mixin _$FactoryTask {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get prompt => throw _privateConstructorUsedError;
  int? get uploadLimit => throw _privateConstructorUsedError;
  int? get currentSubmissions => throw _privateConstructorUsedError;
  bool? get uploadLimitReached => throw _privateConstructorUsedError;
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get rewardLimit => throw _privateConstructorUsedError;
  String? get limitReason => throw _privateConstructorUsedError;

  /// Serializes this FactoryTask to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FactoryTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FactoryTaskCopyWith<FactoryTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FactoryTaskCopyWith<$Res> {
  factory $FactoryTaskCopyWith(
          FactoryTask value, $Res Function(FactoryTask) then) =
      _$FactoryTaskCopyWithImpl<$Res, FactoryTask>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String prompt,
      int? uploadLimit,
      int? currentSubmissions,
      bool? uploadLimitReached,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? rewardLimit,
      String? limitReason});
}

/// @nodoc
class _$FactoryTaskCopyWithImpl<$Res, $Val extends FactoryTask>
    implements $FactoryTaskCopyWith<$Res> {
  _$FactoryTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FactoryTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? prompt = null,
    Object? uploadLimit = freezed,
    Object? currentSubmissions = freezed,
    Object? uploadLimitReached = freezed,
    Object? rewardLimit = freezed,
    Object? limitReason = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      prompt: null == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      uploadLimit: freezed == uploadLimit
          ? _value.uploadLimit
          : uploadLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      currentSubmissions: freezed == currentSubmissions
          ? _value.currentSubmissions
          : currentSubmissions // ignore: cast_nullable_to_non_nullable
              as int?,
      uploadLimitReached: freezed == uploadLimitReached
          ? _value.uploadLimitReached
          : uploadLimitReached // ignore: cast_nullable_to_non_nullable
              as bool?,
      rewardLimit: freezed == rewardLimit
          ? _value.rewardLimit
          : rewardLimit // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      limitReason: freezed == limitReason
          ? _value.limitReason
          : limitReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FactoryTaskImplCopyWith<$Res>
    implements $FactoryTaskCopyWith<$Res> {
  factory _$$FactoryTaskImplCopyWith(
          _$FactoryTaskImpl value, $Res Function(_$FactoryTaskImpl) then) =
      __$$FactoryTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String prompt,
      int? uploadLimit,
      int? currentSubmissions,
      bool? uploadLimitReached,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? rewardLimit,
      String? limitReason});
}

/// @nodoc
class __$$FactoryTaskImplCopyWithImpl<$Res>
    extends _$FactoryTaskCopyWithImpl<$Res, _$FactoryTaskImpl>
    implements _$$FactoryTaskImplCopyWith<$Res> {
  __$$FactoryTaskImplCopyWithImpl(
      _$FactoryTaskImpl _value, $Res Function(_$FactoryTaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of FactoryTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? prompt = null,
    Object? uploadLimit = freezed,
    Object? currentSubmissions = freezed,
    Object? uploadLimitReached = freezed,
    Object? rewardLimit = freezed,
    Object? limitReason = freezed,
  }) {
    return _then(_$FactoryTaskImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      prompt: null == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      uploadLimit: freezed == uploadLimit
          ? _value.uploadLimit
          : uploadLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      currentSubmissions: freezed == currentSubmissions
          ? _value.currentSubmissions
          : currentSubmissions // ignore: cast_nullable_to_non_nullable
              as int?,
      uploadLimitReached: freezed == uploadLimitReached
          ? _value.uploadLimitReached
          : uploadLimitReached // ignore: cast_nullable_to_non_nullable
              as bool?,
      rewardLimit: freezed == rewardLimit
          ? _value.rewardLimit
          : rewardLimit // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      limitReason: freezed == limitReason
          ? _value.limitReason
          : limitReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FactoryTaskImpl implements _FactoryTask {
  const _$FactoryTaskImpl(
      {@JsonKey(name: '_id') this.id,
      required this.prompt,
      this.uploadLimit,
      this.currentSubmissions,
      this.uploadLimitReached,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      this.rewardLimit,
      this.limitReason});

  factory _$FactoryTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$FactoryTaskImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String prompt;
  @override
  final int? uploadLimit;
  @override
  final int? currentSubmissions;
  @override
  final bool? uploadLimitReached;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  final Decimal? rewardLimit;
  @override
  final String? limitReason;

  @override
  String toString() {
    return 'FactoryTask(id: $id, prompt: $prompt, uploadLimit: $uploadLimit, currentSubmissions: $currentSubmissions, uploadLimitReached: $uploadLimitReached, rewardLimit: $rewardLimit, limitReason: $limitReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FactoryTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.uploadLimit, uploadLimit) ||
                other.uploadLimit == uploadLimit) &&
            (identical(other.currentSubmissions, currentSubmissions) ||
                other.currentSubmissions == currentSubmissions) &&
            (identical(other.uploadLimitReached, uploadLimitReached) ||
                other.uploadLimitReached == uploadLimitReached) &&
            (identical(other.rewardLimit, rewardLimit) ||
                other.rewardLimit == rewardLimit) &&
            (identical(other.limitReason, limitReason) ||
                other.limitReason == limitReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, prompt, uploadLimit,
      currentSubmissions, uploadLimitReached, rewardLimit, limitReason);

  /// Create a copy of FactoryTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FactoryTaskImplCopyWith<_$FactoryTaskImpl> get copyWith =>
      __$$FactoryTaskImplCopyWithImpl<_$FactoryTaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FactoryTaskImplToJson(
      this,
    );
  }
}

abstract class _FactoryTask implements FactoryTask {
  const factory _FactoryTask(
      {@JsonKey(name: '_id') final String? id,
      required final String prompt,
      final int? uploadLimit,
      final int? currentSubmissions,
      final bool? uploadLimitReached,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      final Decimal? rewardLimit,
      final String? limitReason}) = _$FactoryTaskImpl;

  factory _FactoryTask.fromJson(Map<String, dynamic> json) =
      _$FactoryTaskImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get prompt;
  @override
  int? get uploadLimit;
  @override
  int? get currentSubmissions;
  @override
  bool? get uploadLimitReached;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get rewardLimit;
  @override
  String? get limitReason;

  /// Create a copy of FactoryTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FactoryTaskImplCopyWith<_$FactoryTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
