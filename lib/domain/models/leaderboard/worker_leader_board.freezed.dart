// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_leader_board.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkerTokenReward _$WorkerTokenRewardFromJson(Map<String, dynamic> json) {
  return _WorkerTokenReward.fromJson(json);
}

/// @nodoc
mixin _$WorkerTokenReward {
  FactoryToken get token => throw _privateConstructorUsedError;
  double get totalReward => throw _privateConstructorUsedError;

  /// Serializes this WorkerTokenReward to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkerTokenReward
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkerTokenRewardCopyWith<WorkerTokenReward> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkerTokenRewardCopyWith<$Res> {
  factory $WorkerTokenRewardCopyWith(
          WorkerTokenReward value, $Res Function(WorkerTokenReward) then) =
      _$WorkerTokenRewardCopyWithImpl<$Res, WorkerTokenReward>;
  @useResult
  $Res call({FactoryToken token, double totalReward});

  $FactoryTokenCopyWith<$Res> get token;
}

/// @nodoc
class _$WorkerTokenRewardCopyWithImpl<$Res, $Val extends WorkerTokenReward>
    implements $WorkerTokenRewardCopyWith<$Res> {
  _$WorkerTokenRewardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkerTokenReward
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? totalReward = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as FactoryToken,
      totalReward: null == totalReward
          ? _value.totalReward
          : totalReward // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of WorkerTokenReward
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FactoryTokenCopyWith<$Res> get token {
    return $FactoryTokenCopyWith<$Res>(_value.token, (value) {
      return _then(_value.copyWith(token: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WorkerTokenRewardImplCopyWith<$Res>
    implements $WorkerTokenRewardCopyWith<$Res> {
  factory _$$WorkerTokenRewardImplCopyWith(_$WorkerTokenRewardImpl value,
          $Res Function(_$WorkerTokenRewardImpl) then) =
      __$$WorkerTokenRewardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FactoryToken token, double totalReward});

  @override
  $FactoryTokenCopyWith<$Res> get token;
}

/// @nodoc
class __$$WorkerTokenRewardImplCopyWithImpl<$Res>
    extends _$WorkerTokenRewardCopyWithImpl<$Res, _$WorkerTokenRewardImpl>
    implements _$$WorkerTokenRewardImplCopyWith<$Res> {
  __$$WorkerTokenRewardImplCopyWithImpl(_$WorkerTokenRewardImpl _value,
      $Res Function(_$WorkerTokenRewardImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkerTokenReward
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? totalReward = null,
  }) {
    return _then(_$WorkerTokenRewardImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as FactoryToken,
      totalReward: null == totalReward
          ? _value.totalReward
          : totalReward // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkerTokenRewardImpl implements _WorkerTokenReward {
  const _$WorkerTokenRewardImpl(
      {required this.token, required this.totalReward});

  factory _$WorkerTokenRewardImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkerTokenRewardImplFromJson(json);

  @override
  final FactoryToken token;
  @override
  final double totalReward;

  @override
  String toString() {
    return 'WorkerTokenReward(token: $token, totalReward: $totalReward)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkerTokenRewardImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.totalReward, totalReward) ||
                other.totalReward == totalReward));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token, totalReward);

  /// Create a copy of WorkerTokenReward
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkerTokenRewardImplCopyWith<_$WorkerTokenRewardImpl> get copyWith =>
      __$$WorkerTokenRewardImplCopyWithImpl<_$WorkerTokenRewardImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkerTokenRewardImplToJson(
      this,
    );
  }
}

abstract class _WorkerTokenReward implements WorkerTokenReward {
  const factory _WorkerTokenReward(
      {required final FactoryToken token,
      required final double totalReward}) = _$WorkerTokenRewardImpl;

  factory _WorkerTokenReward.fromJson(Map<String, dynamic> json) =
      _$WorkerTokenRewardImpl.fromJson;

  @override
  FactoryToken get token;
  @override
  double get totalReward;

  /// Create a copy of WorkerTokenReward
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkerTokenRewardImplCopyWith<_$WorkerTokenRewardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkerLeaderboard _$WorkerLeaderboardFromJson(Map<String, dynamic> json) {
  return _WorkerLeaderboard.fromJson(json);
}

/// @nodoc
mixin _$WorkerLeaderboard {
  int get rank => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  int get tasks => throw _privateConstructorUsedError;
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get rewards => throw _privateConstructorUsedError;
  double get avgScore => throw _privateConstructorUsedError;
  List<WorkerTokenReward> get tokens => throw _privateConstructorUsedError;
  double get totalUSD => throw _privateConstructorUsedError;

  /// Serializes this WorkerLeaderboard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkerLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkerLeaderboardCopyWith<WorkerLeaderboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkerLeaderboardCopyWith<$Res> {
  factory $WorkerLeaderboardCopyWith(
          WorkerLeaderboard value, $Res Function(WorkerLeaderboard) then) =
      _$WorkerLeaderboardCopyWithImpl<$Res, WorkerLeaderboard>;
  @useResult
  $Res call(
      {int rank,
      String address,
      int tasks,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? rewards,
      double avgScore,
      List<WorkerTokenReward> tokens,
      double totalUSD});
}

/// @nodoc
class _$WorkerLeaderboardCopyWithImpl<$Res, $Val extends WorkerLeaderboard>
    implements $WorkerLeaderboardCopyWith<$Res> {
  _$WorkerLeaderboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkerLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rank = null,
    Object? address = null,
    Object? tasks = null,
    Object? rewards = freezed,
    Object? avgScore = null,
    Object? tokens = null,
    Object? totalUSD = null,
  }) {
    return _then(_value.copyWith(
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as int,
      rewards: freezed == rewards
          ? _value.rewards
          : rewards // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      avgScore: null == avgScore
          ? _value.avgScore
          : avgScore // ignore: cast_nullable_to_non_nullable
              as double,
      tokens: null == tokens
          ? _value.tokens
          : tokens // ignore: cast_nullable_to_non_nullable
              as List<WorkerTokenReward>,
      totalUSD: null == totalUSD
          ? _value.totalUSD
          : totalUSD // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkerLeaderboardImplCopyWith<$Res>
    implements $WorkerLeaderboardCopyWith<$Res> {
  factory _$$WorkerLeaderboardImplCopyWith(_$WorkerLeaderboardImpl value,
          $Res Function(_$WorkerLeaderboardImpl) then) =
      __$$WorkerLeaderboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int rank,
      String address,
      int tasks,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      Decimal? rewards,
      double avgScore,
      List<WorkerTokenReward> tokens,
      double totalUSD});
}

/// @nodoc
class __$$WorkerLeaderboardImplCopyWithImpl<$Res>
    extends _$WorkerLeaderboardCopyWithImpl<$Res, _$WorkerLeaderboardImpl>
    implements _$$WorkerLeaderboardImplCopyWith<$Res> {
  __$$WorkerLeaderboardImplCopyWithImpl(_$WorkerLeaderboardImpl _value,
      $Res Function(_$WorkerLeaderboardImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkerLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rank = null,
    Object? address = null,
    Object? tasks = null,
    Object? rewards = freezed,
    Object? avgScore = null,
    Object? tokens = null,
    Object? totalUSD = null,
  }) {
    return _then(_$WorkerLeaderboardImpl(
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as int,
      rewards: freezed == rewards
          ? _value.rewards
          : rewards // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      avgScore: null == avgScore
          ? _value.avgScore
          : avgScore // ignore: cast_nullable_to_non_nullable
              as double,
      tokens: null == tokens
          ? _value._tokens
          : tokens // ignore: cast_nullable_to_non_nullable
              as List<WorkerTokenReward>,
      totalUSD: null == totalUSD
          ? _value.totalUSD
          : totalUSD // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkerLeaderboardImpl implements _WorkerLeaderboard {
  const _$WorkerLeaderboardImpl(
      {required this.rank,
      required this.address,
      required this.tasks,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      this.rewards,
      required this.avgScore,
      final List<WorkerTokenReward> tokens = const [],
      this.totalUSD = 0.0})
      : _tokens = tokens;

  factory _$WorkerLeaderboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkerLeaderboardImplFromJson(json);

  @override
  final int rank;
  @override
  final String address;
  @override
  final int tasks;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  final Decimal? rewards;
  @override
  final double avgScore;
  final List<WorkerTokenReward> _tokens;
  @override
  @JsonKey()
  List<WorkerTokenReward> get tokens {
    if (_tokens is EqualUnmodifiableListView) return _tokens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tokens);
  }

  @override
  @JsonKey()
  final double totalUSD;

  @override
  String toString() {
    return 'WorkerLeaderboard(rank: $rank, address: $address, tasks: $tasks, rewards: $rewards, avgScore: $avgScore, tokens: $tokens, totalUSD: $totalUSD)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkerLeaderboardImpl &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.tasks, tasks) || other.tasks == tasks) &&
            (identical(other.rewards, rewards) || other.rewards == rewards) &&
            (identical(other.avgScore, avgScore) ||
                other.avgScore == avgScore) &&
            const DeepCollectionEquality().equals(other._tokens, _tokens) &&
            (identical(other.totalUSD, totalUSD) ||
                other.totalUSD == totalUSD));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, rank, address, tasks, rewards,
      avgScore, const DeepCollectionEquality().hash(_tokens), totalUSD);

  /// Create a copy of WorkerLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkerLeaderboardImplCopyWith<_$WorkerLeaderboardImpl> get copyWith =>
      __$$WorkerLeaderboardImplCopyWithImpl<_$WorkerLeaderboardImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkerLeaderboardImplToJson(
      this,
    );
  }
}

abstract class _WorkerLeaderboard implements WorkerLeaderboard {
  const factory _WorkerLeaderboard(
      {required final int rank,
      required final String address,
      required final int tasks,
      @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
      final Decimal? rewards,
      required final double avgScore,
      final List<WorkerTokenReward> tokens,
      final double totalUSD}) = _$WorkerLeaderboardImpl;

  factory _WorkerLeaderboard.fromJson(Map<String, dynamic> json) =
      _$WorkerLeaderboardImpl.fromJson;

  @override
  int get rank;
  @override
  String get address;
  @override
  int get tasks;
  @override
  @JsonKey(toJson: DecimalJson.toJson, fromJson: DecimalJson.fromJson)
  Decimal? get rewards;
  @override
  double get avgScore;
  @override
  List<WorkerTokenReward> get tokens;
  @override
  double get totalUSD;

  /// Create a copy of WorkerLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkerLeaderboardImplCopyWith<_$WorkerLeaderboardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
