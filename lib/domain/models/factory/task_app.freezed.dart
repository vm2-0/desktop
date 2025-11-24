// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_app.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskApp _$TaskAppFromJson(Map<String, dynamic> json) {
  return _TaskApp.fromJson(json);
}

/// @nodoc
mixin _$TaskApp {
  String get name => throw _privateConstructorUsedError;
  String get domain => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this TaskApp to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskApp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskAppCopyWith<TaskApp> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskAppCopyWith<$Res> {
  factory $TaskAppCopyWith(TaskApp value, $Res Function(TaskApp) then) =
      _$TaskAppCopyWithImpl<$Res, TaskApp>;
  @useResult
  $Res call({String name, String domain, String description});
}

/// @nodoc
class _$TaskAppCopyWithImpl<$Res, $Val extends TaskApp>
    implements $TaskAppCopyWith<$Res> {
  _$TaskAppCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskApp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? domain = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      domain: null == domain
          ? _value.domain
          : domain // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskAppImplCopyWith<$Res> implements $TaskAppCopyWith<$Res> {
  factory _$$TaskAppImplCopyWith(
          _$TaskAppImpl value, $Res Function(_$TaskAppImpl) then) =
      __$$TaskAppImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String domain, String description});
}

/// @nodoc
class __$$TaskAppImplCopyWithImpl<$Res>
    extends _$TaskAppCopyWithImpl<$Res, _$TaskAppImpl>
    implements _$$TaskAppImplCopyWith<$Res> {
  __$$TaskAppImplCopyWithImpl(
      _$TaskAppImpl _value, $Res Function(_$TaskAppImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskApp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? domain = null,
    Object? description = null,
  }) {
    return _then(_$TaskAppImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      domain: null == domain
          ? _value.domain
          : domain // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskAppImpl implements _TaskApp {
  const _$TaskAppImpl(
      {required this.name, required this.domain, required this.description});

  factory _$TaskAppImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskAppImplFromJson(json);

  @override
  final String name;
  @override
  final String domain;
  @override
  final String description;

  @override
  String toString() {
    return 'TaskApp(name: $name, domain: $domain, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskAppImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.domain, domain) || other.domain == domain) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, domain, description);

  /// Create a copy of TaskApp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskAppImplCopyWith<_$TaskAppImpl> get copyWith =>
      __$$TaskAppImplCopyWithImpl<_$TaskAppImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskAppImplToJson(
      this,
    );
  }
}

abstract class _TaskApp implements TaskApp {
  const factory _TaskApp(
      {required final String name,
      required final String domain,
      required final String description}) = _$TaskAppImpl;

  factory _TaskApp.fromJson(Map<String, dynamic> json) = _$TaskAppImpl.fromJson;

  @override
  String get name;
  @override
  String get domain;
  @override
  String get description;

  /// Create a copy of TaskApp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskAppImplCopyWith<_$TaskAppImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
