// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkflowTask _$WorkflowTaskFromJson(Map<String, dynamic> json) {
  return _WorkflowTask.fromJson(json);
}

/// @nodoc
mixin _$WorkflowTask {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get prompt => throw _privateConstructorUsedError;
  List<String> get categories => throw _privateConstructorUsedError;
  @JsonKey(name: 'apps_used')
  List<TaskApp> get appsUsed => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_name')
  String get taskName => throw _privateConstructorUsedError;
  int? get uploadLimit => throw _privateConstructorUsedError;
  int? get currentSubmissions => throw _privateConstructorUsedError;
  bool? get uploadLimitReached => throw _privateConstructorUsedError;
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get rewardLimit => throw _privateConstructorUsedError;
  String? get limitReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'pool_id')
  String? get poolId => throw _privateConstructorUsedError;
  List<String>? get objectives => throw _privateConstructorUsedError;

  /// Serializes this WorkflowTask to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkflowTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkflowTaskCopyWith<WorkflowTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowTaskCopyWith<$Res> {
  factory $WorkflowTaskCopyWith(
          WorkflowTask value, $Res Function(WorkflowTask) then) =
      _$WorkflowTaskCopyWithImpl<$Res, WorkflowTask>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String prompt,
      List<String> categories,
      @JsonKey(name: 'apps_used') List<TaskApp> appsUsed,
      @JsonKey(name: 'task_name') String taskName,
      int? uploadLimit,
      int? currentSubmissions,
      bool? uploadLimitReached,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? rewardLimit,
      String? limitReason,
      @JsonKey(name: 'pool_id') String? poolId,
      List<String>? objectives});
}

/// @nodoc
class _$WorkflowTaskCopyWithImpl<$Res, $Val extends WorkflowTask>
    implements $WorkflowTaskCopyWith<$Res> {
  _$WorkflowTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkflowTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? prompt = null,
    Object? categories = null,
    Object? appsUsed = null,
    Object? taskName = null,
    Object? uploadLimit = freezed,
    Object? currentSubmissions = freezed,
    Object? uploadLimitReached = freezed,
    Object? rewardLimit = freezed,
    Object? limitReason = freezed,
    Object? poolId = freezed,
    Object? objectives = freezed,
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
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      appsUsed: null == appsUsed
          ? _value.appsUsed
          : appsUsed // ignore: cast_nullable_to_non_nullable
              as List<TaskApp>,
      taskName: null == taskName
          ? _value.taskName
          : taskName // ignore: cast_nullable_to_non_nullable
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
      poolId: freezed == poolId
          ? _value.poolId
          : poolId // ignore: cast_nullable_to_non_nullable
              as String?,
      objectives: freezed == objectives
          ? _value.objectives
          : objectives // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowTaskImplCopyWith<$Res>
    implements $WorkflowTaskCopyWith<$Res> {
  factory _$$WorkflowTaskImplCopyWith(
          _$WorkflowTaskImpl value, $Res Function(_$WorkflowTaskImpl) then) =
      __$$WorkflowTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String prompt,
      List<String> categories,
      @JsonKey(name: 'apps_used') List<TaskApp> appsUsed,
      @JsonKey(name: 'task_name') String taskName,
      int? uploadLimit,
      int? currentSubmissions,
      bool? uploadLimitReached,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? rewardLimit,
      String? limitReason,
      @JsonKey(name: 'pool_id') String? poolId,
      List<String>? objectives});
}

/// @nodoc
class __$$WorkflowTaskImplCopyWithImpl<$Res>
    extends _$WorkflowTaskCopyWithImpl<$Res, _$WorkflowTaskImpl>
    implements _$$WorkflowTaskImplCopyWith<$Res> {
  __$$WorkflowTaskImplCopyWithImpl(
      _$WorkflowTaskImpl _value, $Res Function(_$WorkflowTaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkflowTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? prompt = null,
    Object? categories = null,
    Object? appsUsed = null,
    Object? taskName = null,
    Object? uploadLimit = freezed,
    Object? currentSubmissions = freezed,
    Object? uploadLimitReached = freezed,
    Object? rewardLimit = freezed,
    Object? limitReason = freezed,
    Object? poolId = freezed,
    Object? objectives = freezed,
  }) {
    return _then(_$WorkflowTaskImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      prompt: null == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      appsUsed: null == appsUsed
          ? _value._appsUsed
          : appsUsed // ignore: cast_nullable_to_non_nullable
              as List<TaskApp>,
      taskName: null == taskName
          ? _value.taskName
          : taskName // ignore: cast_nullable_to_non_nullable
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
      poolId: freezed == poolId
          ? _value.poolId
          : poolId // ignore: cast_nullable_to_non_nullable
              as String?,
      objectives: freezed == objectives
          ? _value._objectives
          : objectives // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowTaskImpl implements _WorkflowTask {
  const _$WorkflowTaskImpl(
      {@JsonKey(name: '_id') this.id,
      required this.prompt,
      final List<String> categories = const [],
      @JsonKey(name: 'apps_used') required final List<TaskApp> appsUsed,
      @JsonKey(name: 'task_name') required this.taskName,
      this.uploadLimit,
      this.currentSubmissions,
      this.uploadLimitReached,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      this.rewardLimit,
      this.limitReason,
      @JsonKey(name: 'pool_id') this.poolId,
      final List<String>? objectives})
      : _categories = categories,
        _appsUsed = appsUsed,
        _objectives = objectives;

  factory _$WorkflowTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowTaskImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String prompt;
  final List<String> _categories;
  @override
  @JsonKey()
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<TaskApp> _appsUsed;
  @override
  @JsonKey(name: 'apps_used')
  List<TaskApp> get appsUsed {
    if (_appsUsed is EqualUnmodifiableListView) return _appsUsed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appsUsed);
  }

  @override
  @JsonKey(name: 'task_name')
  final String taskName;
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
  @JsonKey(name: 'pool_id')
  final String? poolId;
  final List<String>? _objectives;
  @override
  List<String>? get objectives {
    final value = _objectives;
    if (value == null) return null;
    if (_objectives is EqualUnmodifiableListView) return _objectives;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'WorkflowTask(id: $id, prompt: $prompt, categories: $categories, appsUsed: $appsUsed, taskName: $taskName, uploadLimit: $uploadLimit, currentSubmissions: $currentSubmissions, uploadLimitReached: $uploadLimitReached, rewardLimit: $rewardLimit, limitReason: $limitReason, poolId: $poolId, objectives: $objectives)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality().equals(other._appsUsed, _appsUsed) &&
            (identical(other.taskName, taskName) ||
                other.taskName == taskName) &&
            (identical(other.uploadLimit, uploadLimit) ||
                other.uploadLimit == uploadLimit) &&
            (identical(other.currentSubmissions, currentSubmissions) ||
                other.currentSubmissions == currentSubmissions) &&
            (identical(other.uploadLimitReached, uploadLimitReached) ||
                other.uploadLimitReached == uploadLimitReached) &&
            (identical(other.rewardLimit, rewardLimit) ||
                other.rewardLimit == rewardLimit) &&
            (identical(other.limitReason, limitReason) ||
                other.limitReason == limitReason) &&
            (identical(other.poolId, poolId) || other.poolId == poolId) &&
            const DeepCollectionEquality()
                .equals(other._objectives, _objectives));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      prompt,
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_appsUsed),
      taskName,
      uploadLimit,
      currentSubmissions,
      uploadLimitReached,
      rewardLimit,
      limitReason,
      poolId,
      const DeepCollectionEquality().hash(_objectives));

  /// Create a copy of WorkflowTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowTaskImplCopyWith<_$WorkflowTaskImpl> get copyWith =>
      __$$WorkflowTaskImplCopyWithImpl<_$WorkflowTaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowTaskImplToJson(
      this,
    );
  }
}

abstract class _WorkflowTask implements WorkflowTask {
  const factory _WorkflowTask(
      {@JsonKey(name: '_id') final String? id,
      required final String prompt,
      final List<String> categories,
      @JsonKey(name: 'apps_used') required final List<TaskApp> appsUsed,
      @JsonKey(name: 'task_name') required final String taskName,
      final int? uploadLimit,
      final int? currentSubmissions,
      final bool? uploadLimitReached,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      final Decimal? rewardLimit,
      final String? limitReason,
      @JsonKey(name: 'pool_id') final String? poolId,
      final List<String>? objectives}) = _$WorkflowTaskImpl;

  factory _WorkflowTask.fromJson(Map<String, dynamic> json) =
      _$WorkflowTaskImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get prompt;
  @override
  List<String> get categories;
  @override
  @JsonKey(name: 'apps_used')
  List<TaskApp> get appsUsed;
  @override
  @JsonKey(name: 'task_name')
  String get taskName;
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
  @override
  @JsonKey(name: 'pool_id')
  String? get poolId;
  @override
  List<String>? get objectives;

  /// Create a copy of WorkflowTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkflowTaskImplCopyWith<_$WorkflowTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
