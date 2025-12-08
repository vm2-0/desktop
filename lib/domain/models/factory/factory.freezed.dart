// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'factory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Factory _$FactoryFromJson(Map<String, dynamic> json) {
  return _Factory.fromJson(json);
}

/// @nodoc
mixin _$Factory {
// Core identity
  String get id => throw _privateConstructorUsedError;
  String? get poolAddress => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError; // Ownership
  String get ownerAddress =>
      throw _privateConstructorUsedError; // Status & lifecycle
  FactoryStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Skills & categorization
  List<String> get skills =>
      throw _privateConstructorUsedError; // Economic model
  FactoryToken? get token => throw _privateConstructorUsedError;
  double get balance =>
      throw _privateConstructorUsedError; // Keep for backward compatibility
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get totalEarned => throw _privateConstructorUsedError; // Statistics
  int get demonstrations => throw _privateConstructorUsedError;
  List<FactoryGradingResult> get gradingResults =>
      throw _privateConstructorUsedError; // Tasks (tasks-first architecture)
  List<WorkflowTask> get tasks =>
      throw _privateConstructorUsedError; // Search optimization
  String get searchText =>
      throw _privateConstructorUsedError; // UI state (not stored on backend)
  bool get expanded => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Serializes this Factory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Factory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FactoryCopyWith<Factory> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FactoryCopyWith<$Res> {
  factory $FactoryCopyWith(Factory value, $Res Function(Factory) then) =
      _$FactoryCopyWithImpl<$Res, Factory>;
  @useResult
  $Res call(
      {String id,
      String? poolAddress,
      String name,
      String? description,
      String ownerAddress,
      FactoryStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      List<String> skills,
      FactoryToken? token,
      double balance,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? totalEarned,
      int demonstrations,
      List<FactoryGradingResult> gradingResults,
      List<WorkflowTask> tasks,
      String searchText,
      bool expanded,
      bool isLoading});

  $FactoryTokenCopyWith<$Res>? get token;
}

/// @nodoc
class _$FactoryCopyWithImpl<$Res, $Val extends Factory>
    implements $FactoryCopyWith<$Res> {
  _$FactoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Factory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? poolAddress = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? ownerAddress = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? skills = null,
    Object? token = freezed,
    Object? balance = null,
    Object? totalEarned = freezed,
    Object? demonstrations = null,
    Object? gradingResults = null,
    Object? tasks = null,
    Object? searchText = null,
    Object? expanded = null,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      poolAddress: freezed == poolAddress
          ? _value.poolAddress
          : poolAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerAddress: null == ownerAddress
          ? _value.ownerAddress
          : ownerAddress // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FactoryStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      skills: null == skills
          ? _value.skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as FactoryToken?,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      totalEarned: freezed == totalEarned
          ? _value.totalEarned
          : totalEarned // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      demonstrations: null == demonstrations
          ? _value.demonstrations
          : demonstrations // ignore: cast_nullable_to_non_nullable
              as int,
      gradingResults: null == gradingResults
          ? _value.gradingResults
          : gradingResults // ignore: cast_nullable_to_non_nullable
              as List<FactoryGradingResult>,
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<WorkflowTask>,
      searchText: null == searchText
          ? _value.searchText
          : searchText // ignore: cast_nullable_to_non_nullable
              as String,
      expanded: null == expanded
          ? _value.expanded
          : expanded // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of Factory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FactoryTokenCopyWith<$Res>? get token {
    if (_value.token == null) {
      return null;
    }

    return $FactoryTokenCopyWith<$Res>(_value.token!, (value) {
      return _then(_value.copyWith(token: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FactoryImplCopyWith<$Res> implements $FactoryCopyWith<$Res> {
  factory _$$FactoryImplCopyWith(
          _$FactoryImpl value, $Res Function(_$FactoryImpl) then) =
      __$$FactoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? poolAddress,
      String name,
      String? description,
      String ownerAddress,
      FactoryStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      List<String> skills,
      FactoryToken? token,
      double balance,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? totalEarned,
      int demonstrations,
      List<FactoryGradingResult> gradingResults,
      List<WorkflowTask> tasks,
      String searchText,
      bool expanded,
      bool isLoading});

  @override
  $FactoryTokenCopyWith<$Res>? get token;
}

/// @nodoc
class __$$FactoryImplCopyWithImpl<$Res>
    extends _$FactoryCopyWithImpl<$Res, _$FactoryImpl>
    implements _$$FactoryImplCopyWith<$Res> {
  __$$FactoryImplCopyWithImpl(
      _$FactoryImpl _value, $Res Function(_$FactoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of Factory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? poolAddress = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? ownerAddress = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? skills = null,
    Object? token = freezed,
    Object? balance = null,
    Object? totalEarned = freezed,
    Object? demonstrations = null,
    Object? gradingResults = null,
    Object? tasks = null,
    Object? searchText = null,
    Object? expanded = null,
    Object? isLoading = null,
  }) {
    return _then(_$FactoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      poolAddress: freezed == poolAddress
          ? _value.poolAddress
          : poolAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerAddress: null == ownerAddress
          ? _value.ownerAddress
          : ownerAddress // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FactoryStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      skills: null == skills
          ? _value._skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as FactoryToken?,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      totalEarned: freezed == totalEarned
          ? _value.totalEarned
          : totalEarned // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      demonstrations: null == demonstrations
          ? _value.demonstrations
          : demonstrations // ignore: cast_nullable_to_non_nullable
              as int,
      gradingResults: null == gradingResults
          ? _value._gradingResults
          : gradingResults // ignore: cast_nullable_to_non_nullable
              as List<FactoryGradingResult>,
      tasks: null == tasks
          ? _value._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<WorkflowTask>,
      searchText: null == searchText
          ? _value.searchText
          : searchText // ignore: cast_nullable_to_non_nullable
              as String,
      expanded: null == expanded
          ? _value.expanded
          : expanded // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FactoryImpl implements _Factory {
  const _$FactoryImpl(
      {required this.id,
      this.poolAddress,
      required this.name,
      this.description,
      required this.ownerAddress,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      final List<String> skills = const [],
      this.token,
      this.balance = 0.0,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      this.totalEarned,
      this.demonstrations = 0,
      final List<FactoryGradingResult> gradingResults = const [],
      final List<WorkflowTask> tasks = const [],
      this.searchText = '',
      this.expanded = false,
      this.isLoading = false})
      : _skills = skills,
        _gradingResults = gradingResults,
        _tasks = tasks;

  factory _$FactoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$FactoryImplFromJson(json);

// Core identity
  @override
  final String id;
  @override
  final String? poolAddress;
  @override
  final String name;
  @override
  final String? description;
// Ownership
  @override
  final String ownerAddress;
// Status & lifecycle
  @override
  final FactoryStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
// Skills & categorization
  final List<String> _skills;
// Skills & categorization
  @override
  @JsonKey()
  List<String> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

// Economic model
  @override
  final FactoryToken? token;
  @override
  @JsonKey()
  final double balance;
// Keep for backward compatibility
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  final Decimal? totalEarned;
// Statistics
  @override
  @JsonKey()
  final int demonstrations;
  final List<FactoryGradingResult> _gradingResults;
  @override
  @JsonKey()
  List<FactoryGradingResult> get gradingResults {
    if (_gradingResults is EqualUnmodifiableListView) return _gradingResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gradingResults);
  }

// Tasks (tasks-first architecture)
  final List<WorkflowTask> _tasks;
// Tasks (tasks-first architecture)
  @override
  @JsonKey()
  List<WorkflowTask> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

// Search optimization
  @override
  @JsonKey()
  final String searchText;
// UI state (not stored on backend)
  @override
  @JsonKey()
  final bool expanded;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'Factory(id: $id, poolAddress: $poolAddress, name: $name, description: $description, ownerAddress: $ownerAddress, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, skills: $skills, token: $token, balance: $balance, totalEarned: $totalEarned, demonstrations: $demonstrations, gradingResults: $gradingResults, tasks: $tasks, searchText: $searchText, expanded: $expanded, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FactoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.poolAddress, poolAddress) ||
                other.poolAddress == poolAddress) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.ownerAddress, ownerAddress) ||
                other.ownerAddress == ownerAddress) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.totalEarned, totalEarned) ||
                other.totalEarned == totalEarned) &&
            (identical(other.demonstrations, demonstrations) ||
                other.demonstrations == demonstrations) &&
            const DeepCollectionEquality()
                .equals(other._gradingResults, _gradingResults) &&
            const DeepCollectionEquality().equals(other._tasks, _tasks) &&
            (identical(other.searchText, searchText) ||
                other.searchText == searchText) &&
            (identical(other.expanded, expanded) ||
                other.expanded == expanded) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      poolAddress,
      name,
      description,
      ownerAddress,
      status,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_skills),
      token,
      balance,
      totalEarned,
      demonstrations,
      const DeepCollectionEquality().hash(_gradingResults),
      const DeepCollectionEquality().hash(_tasks),
      searchText,
      expanded,
      isLoading);

  /// Create a copy of Factory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FactoryImplCopyWith<_$FactoryImpl> get copyWith =>
      __$$FactoryImplCopyWithImpl<_$FactoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FactoryImplToJson(
      this,
    );
  }
}

abstract class _Factory implements Factory {
  const factory _Factory(
      {required final String id,
      final String? poolAddress,
      required final String name,
      final String? description,
      required final String ownerAddress,
      required final FactoryStatus status,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final List<String> skills,
      final FactoryToken? token,
      final double balance,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      final Decimal? totalEarned,
      final int demonstrations,
      final List<FactoryGradingResult> gradingResults,
      final List<WorkflowTask> tasks,
      final String searchText,
      final bool expanded,
      final bool isLoading}) = _$FactoryImpl;

  factory _Factory.fromJson(Map<String, dynamic> json) = _$FactoryImpl.fromJson;

// Core identity
  @override
  String get id;
  @override
  String? get poolAddress;
  @override
  String get name;
  @override
  String? get description; // Ownership
  @override
  String get ownerAddress; // Status & lifecycle
  @override
  FactoryStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt; // Skills & categorization
  @override
  List<String> get skills; // Economic model
  @override
  FactoryToken? get token;
  @override
  double get balance; // Keep for backward compatibility
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get totalEarned; // Statistics
  @override
  int get demonstrations;
  @override
  List<FactoryGradingResult>
      get gradingResults; // Tasks (tasks-first architecture)
  @override
  List<WorkflowTask> get tasks; // Search optimization
  @override
  String get searchText; // UI state (not stored on backend)
  @override
  bool get expanded;
  @override
  bool get isLoading;

  /// Create a copy of Factory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FactoryImplCopyWith<_$FactoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
