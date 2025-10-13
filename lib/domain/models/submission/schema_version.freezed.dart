// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schema_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SchemaVersion _$SchemaVersionFromJson(Map<String, dynamic> json) {
  return _SchemaVersion.fromJson(json);
}

/// @nodoc
mixin _$SchemaVersion {
  int get major => throw _privateConstructorUsedError;
  int get minor => throw _privateConstructorUsedError;
  int get patch => throw _privateConstructorUsedError;

  /// Serializes this SchemaVersion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SchemaVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SchemaVersionCopyWith<SchemaVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchemaVersionCopyWith<$Res> {
  factory $SchemaVersionCopyWith(
          SchemaVersion value, $Res Function(SchemaVersion) then) =
      _$SchemaVersionCopyWithImpl<$Res, SchemaVersion>;
  @useResult
  $Res call({int major, int minor, int patch});
}

/// @nodoc
class _$SchemaVersionCopyWithImpl<$Res, $Val extends SchemaVersion>
    implements $SchemaVersionCopyWith<$Res> {
  _$SchemaVersionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SchemaVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? major = null,
    Object? minor = null,
    Object? patch = null,
  }) {
    return _then(_value.copyWith(
      major: null == major
          ? _value.major
          : major // ignore: cast_nullable_to_non_nullable
              as int,
      minor: null == minor
          ? _value.minor
          : minor // ignore: cast_nullable_to_non_nullable
              as int,
      patch: null == patch
          ? _value.patch
          : patch // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SchemaVersionImplCopyWith<$Res>
    implements $SchemaVersionCopyWith<$Res> {
  factory _$$SchemaVersionImplCopyWith(
          _$SchemaVersionImpl value, $Res Function(_$SchemaVersionImpl) then) =
      __$$SchemaVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int major, int minor, int patch});
}

/// @nodoc
class __$$SchemaVersionImplCopyWithImpl<$Res>
    extends _$SchemaVersionCopyWithImpl<$Res, _$SchemaVersionImpl>
    implements _$$SchemaVersionImplCopyWith<$Res> {
  __$$SchemaVersionImplCopyWithImpl(
      _$SchemaVersionImpl _value, $Res Function(_$SchemaVersionImpl) _then)
      : super(_value, _then);

  /// Create a copy of SchemaVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? major = null,
    Object? minor = null,
    Object? patch = null,
  }) {
    return _then(_$SchemaVersionImpl(
      major: null == major
          ? _value.major
          : major // ignore: cast_nullable_to_non_nullable
              as int,
      minor: null == minor
          ? _value.minor
          : minor // ignore: cast_nullable_to_non_nullable
              as int,
      patch: null == patch
          ? _value.patch
          : patch // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchemaVersionImpl implements _SchemaVersion {
  const _$SchemaVersionImpl(
      {required this.major, required this.minor, required this.patch});

  factory _$SchemaVersionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchemaVersionImplFromJson(json);

  @override
  final int major;
  @override
  final int minor;
  @override
  final int patch;

  @override
  String toString() {
    return 'SchemaVersion(major: $major, minor: $minor, patch: $patch)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchemaVersionImpl &&
            (identical(other.major, major) || other.major == major) &&
            (identical(other.minor, minor) || other.minor == minor) &&
            (identical(other.patch, patch) || other.patch == patch));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, major, minor, patch);

  /// Create a copy of SchemaVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SchemaVersionImplCopyWith<_$SchemaVersionImpl> get copyWith =>
      __$$SchemaVersionImplCopyWithImpl<_$SchemaVersionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchemaVersionImplToJson(
      this,
    );
  }
}

abstract class _SchemaVersion implements SchemaVersion {
  const factory _SchemaVersion(
      {required final int major,
      required final int minor,
      required final int patch}) = _$SchemaVersionImpl;

  factory _SchemaVersion.fromJson(Map<String, dynamic> json) =
      _$SchemaVersionImpl.fromJson;

  @override
  int get major;
  @override
  int get minor;
  @override
  int get patch;

  /// Create a copy of SchemaVersion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SchemaVersionImplCopyWith<_$SchemaVersionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
