// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'demonstration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Demonstration _$DemonstrationFromJson(Map<String, dynamic> json) {
  return _Demonstration.fromJson(json);
}

/// @nodoc
mixin _$Demonstration {
  String get title => throw _privateConstructorUsedError;
  String get app => throw _privateConstructorUsedError;
  List<String> get objectives => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'pool_id')
  String? get poolId => throw _privateConstructorUsedError;
  DemonstrationReward? get reward => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_id')
  String? get taskId => throw _privateConstructorUsedError;

  /// Serializes this Demonstration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Demonstration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DemonstrationCopyWith<Demonstration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DemonstrationCopyWith<$Res> {
  factory $DemonstrationCopyWith(
          Demonstration value, $Res Function(Demonstration) then) =
      _$DemonstrationCopyWithImpl<$Res, Demonstration>;
  @useResult
  $Res call(
      {String title,
      String app,
      List<String> objectives,
      String content,
      @JsonKey(name: 'pool_id') String? poolId,
      DemonstrationReward? reward,
      @JsonKey(name: 'task_id') String? taskId});

  $DemonstrationRewardCopyWith<$Res>? get reward;
}

/// @nodoc
class _$DemonstrationCopyWithImpl<$Res, $Val extends Demonstration>
    implements $DemonstrationCopyWith<$Res> {
  _$DemonstrationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Demonstration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? app = null,
    Object? objectives = null,
    Object? content = null,
    Object? poolId = freezed,
    Object? reward = freezed,
    Object? taskId = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      app: null == app
          ? _value.app
          : app // ignore: cast_nullable_to_non_nullable
              as String,
      objectives: null == objectives
          ? _value.objectives
          : objectives // ignore: cast_nullable_to_non_nullable
              as List<String>,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      poolId: freezed == poolId
          ? _value.poolId
          : poolId // ignore: cast_nullable_to_non_nullable
              as String?,
      reward: freezed == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as DemonstrationReward?,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of Demonstration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DemonstrationRewardCopyWith<$Res>? get reward {
    if (_value.reward == null) {
      return null;
    }

    return $DemonstrationRewardCopyWith<$Res>(_value.reward!, (value) {
      return _then(_value.copyWith(reward: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DemonstrationImplCopyWith<$Res>
    implements $DemonstrationCopyWith<$Res> {
  factory _$$DemonstrationImplCopyWith(
          _$DemonstrationImpl value, $Res Function(_$DemonstrationImpl) then) =
      __$$DemonstrationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String app,
      List<String> objectives,
      String content,
      @JsonKey(name: 'pool_id') String? poolId,
      DemonstrationReward? reward,
      @JsonKey(name: 'task_id') String? taskId});

  @override
  $DemonstrationRewardCopyWith<$Res>? get reward;
}

/// @nodoc
class __$$DemonstrationImplCopyWithImpl<$Res>
    extends _$DemonstrationCopyWithImpl<$Res, _$DemonstrationImpl>
    implements _$$DemonstrationImplCopyWith<$Res> {
  __$$DemonstrationImplCopyWithImpl(
      _$DemonstrationImpl _value, $Res Function(_$DemonstrationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Demonstration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? app = null,
    Object? objectives = null,
    Object? content = null,
    Object? poolId = freezed,
    Object? reward = freezed,
    Object? taskId = freezed,
  }) {
    return _then(_$DemonstrationImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      app: null == app
          ? _value.app
          : app // ignore: cast_nullable_to_non_nullable
              as String,
      objectives: null == objectives
          ? _value._objectives
          : objectives // ignore: cast_nullable_to_non_nullable
              as List<String>,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      poolId: freezed == poolId
          ? _value.poolId
          : poolId // ignore: cast_nullable_to_non_nullable
              as String?,
      reward: freezed == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as DemonstrationReward?,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DemonstrationImpl implements _Demonstration {
  const _$DemonstrationImpl(
      {required this.title,
      required this.app,
      required final List<String> objectives,
      required this.content,
      @JsonKey(name: 'pool_id') this.poolId,
      this.reward,
      @JsonKey(name: 'task_id') this.taskId})
      : _objectives = objectives;

  factory _$DemonstrationImpl.fromJson(Map<String, dynamic> json) =>
      _$$DemonstrationImplFromJson(json);

  @override
  final String title;
  @override
  final String app;
  final List<String> _objectives;
  @override
  List<String> get objectives {
    if (_objectives is EqualUnmodifiableListView) return _objectives;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_objectives);
  }

  @override
  final String content;
  @override
  @JsonKey(name: 'pool_id')
  final String? poolId;
  @override
  final DemonstrationReward? reward;
  @override
  @JsonKey(name: 'task_id')
  final String? taskId;

  @override
  String toString() {
    return 'Demonstration(title: $title, app: $app, objectives: $objectives, content: $content, poolId: $poolId, reward: $reward, taskId: $taskId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DemonstrationImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.app, app) || other.app == app) &&
            const DeepCollectionEquality()
                .equals(other._objectives, _objectives) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.poolId, poolId) || other.poolId == poolId) &&
            (identical(other.reward, reward) || other.reward == reward) &&
            (identical(other.taskId, taskId) || other.taskId == taskId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      app,
      const DeepCollectionEquality().hash(_objectives),
      content,
      poolId,
      reward,
      taskId);

  /// Create a copy of Demonstration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DemonstrationImplCopyWith<_$DemonstrationImpl> get copyWith =>
      __$$DemonstrationImplCopyWithImpl<_$DemonstrationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DemonstrationImplToJson(
      this,
    );
  }
}

abstract class _Demonstration implements Demonstration {
  const factory _Demonstration(
      {required final String title,
      required final String app,
      required final List<String> objectives,
      required final String content,
      @JsonKey(name: 'pool_id') final String? poolId,
      final DemonstrationReward? reward,
      @JsonKey(name: 'task_id') final String? taskId}) = _$DemonstrationImpl;

  factory _Demonstration.fromJson(Map<String, dynamic> json) =
      _$DemonstrationImpl.fromJson;

  @override
  String get title;
  @override
  String get app;
  @override
  List<String> get objectives;
  @override
  String get content;
  @override
  @JsonKey(name: 'pool_id')
  String? get poolId;
  @override
  DemonstrationReward? get reward;
  @override
  @JsonKey(name: 'task_id')
  String? get taskId;

  /// Create a copy of Demonstration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DemonstrationImplCopyWith<_$DemonstrationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
