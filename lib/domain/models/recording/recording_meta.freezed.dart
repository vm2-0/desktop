// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recording_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecordingMeta _$RecordingMetaFromJson(Map<String, dynamic> json) {
  return _RecordingMeta.fromJson(json);
}

/// @nodoc
mixin _$RecordingMeta {
  @JsonKey(name: 'schema_version')
  SchemaVersion? get schemaVersion => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_seconds')
  int get durationSeconds => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  String get arch => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String get locale => throw _privateConstructorUsedError;
  @JsonKey(name: 'keyboard_layout')
  String? get keyboardLayout => throw _privateConstructorUsedError;
  @JsonKey(name: 'primary_monitor')
  MonitorInfo? get primaryMonitor => throw _privateConstructorUsedError;
  @JsonKey(name: 'quest')
  Demonstration get demonstration => throw _privateConstructorUsedError;

  /// Serializes this RecordingMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecordingMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordingMetaCopyWith<RecordingMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordingMetaCopyWith<$Res> {
  factory $RecordingMetaCopyWith(
          RecordingMeta value, $Res Function(RecordingMeta) then) =
      _$RecordingMetaCopyWithImpl<$Res, RecordingMeta>;
  @useResult
  $Res call(
      {@JsonKey(name: 'schema_version') SchemaVersion? schemaVersion,
      String id,
      String timestamp,
      @JsonKey(name: 'duration_seconds') int durationSeconds,
      String status,
      String? reason,
      String title,
      String description,
      String platform,
      String arch,
      String version,
      String locale,
      @JsonKey(name: 'keyboard_layout') String? keyboardLayout,
      @JsonKey(name: 'primary_monitor') MonitorInfo? primaryMonitor,
      @JsonKey(name: 'quest') Demonstration demonstration});

  $SchemaVersionCopyWith<$Res>? get schemaVersion;
  $MonitorInfoCopyWith<$Res>? get primaryMonitor;
  $DemonstrationCopyWith<$Res> get demonstration;
}

/// @nodoc
class _$RecordingMetaCopyWithImpl<$Res, $Val extends RecordingMeta>
    implements $RecordingMetaCopyWith<$Res> {
  _$RecordingMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecordingMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schemaVersion = freezed,
    Object? id = null,
    Object? timestamp = null,
    Object? durationSeconds = null,
    Object? status = null,
    Object? reason = freezed,
    Object? title = null,
    Object? description = null,
    Object? platform = null,
    Object? arch = null,
    Object? version = null,
    Object? locale = null,
    Object? keyboardLayout = freezed,
    Object? primaryMonitor = freezed,
    Object? demonstration = null,
  }) {
    return _then(_value.copyWith(
      schemaVersion: freezed == schemaVersion
          ? _value.schemaVersion
          : schemaVersion // ignore: cast_nullable_to_non_nullable
              as SchemaVersion?,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      arch: null == arch
          ? _value.arch
          : arch // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      keyboardLayout: freezed == keyboardLayout
          ? _value.keyboardLayout
          : keyboardLayout // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryMonitor: freezed == primaryMonitor
          ? _value.primaryMonitor
          : primaryMonitor // ignore: cast_nullable_to_non_nullable
              as MonitorInfo?,
      demonstration: null == demonstration
          ? _value.demonstration
          : demonstration // ignore: cast_nullable_to_non_nullable
              as Demonstration,
    ) as $Val);
  }

  /// Create a copy of RecordingMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SchemaVersionCopyWith<$Res>? get schemaVersion {
    if (_value.schemaVersion == null) {
      return null;
    }

    return $SchemaVersionCopyWith<$Res>(_value.schemaVersion!, (value) {
      return _then(_value.copyWith(schemaVersion: value) as $Val);
    });
  }

  /// Create a copy of RecordingMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MonitorInfoCopyWith<$Res>? get primaryMonitor {
    if (_value.primaryMonitor == null) {
      return null;
    }

    return $MonitorInfoCopyWith<$Res>(_value.primaryMonitor!, (value) {
      return _then(_value.copyWith(primaryMonitor: value) as $Val);
    });
  }

  /// Create a copy of RecordingMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DemonstrationCopyWith<$Res> get demonstration {
    return $DemonstrationCopyWith<$Res>(_value.demonstration, (value) {
      return _then(_value.copyWith(demonstration: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecordingMetaImplCopyWith<$Res>
    implements $RecordingMetaCopyWith<$Res> {
  factory _$$RecordingMetaImplCopyWith(
          _$RecordingMetaImpl value, $Res Function(_$RecordingMetaImpl) then) =
      __$$RecordingMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'schema_version') SchemaVersion? schemaVersion,
      String id,
      String timestamp,
      @JsonKey(name: 'duration_seconds') int durationSeconds,
      String status,
      String? reason,
      String title,
      String description,
      String platform,
      String arch,
      String version,
      String locale,
      @JsonKey(name: 'keyboard_layout') String? keyboardLayout,
      @JsonKey(name: 'primary_monitor') MonitorInfo? primaryMonitor,
      @JsonKey(name: 'quest') Demonstration demonstration});

  @override
  $SchemaVersionCopyWith<$Res>? get schemaVersion;
  @override
  $MonitorInfoCopyWith<$Res>? get primaryMonitor;
  @override
  $DemonstrationCopyWith<$Res> get demonstration;
}

/// @nodoc
class __$$RecordingMetaImplCopyWithImpl<$Res>
    extends _$RecordingMetaCopyWithImpl<$Res, _$RecordingMetaImpl>
    implements _$$RecordingMetaImplCopyWith<$Res> {
  __$$RecordingMetaImplCopyWithImpl(
      _$RecordingMetaImpl _value, $Res Function(_$RecordingMetaImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecordingMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schemaVersion = freezed,
    Object? id = null,
    Object? timestamp = null,
    Object? durationSeconds = null,
    Object? status = null,
    Object? reason = freezed,
    Object? title = null,
    Object? description = null,
    Object? platform = null,
    Object? arch = null,
    Object? version = null,
    Object? locale = null,
    Object? keyboardLayout = freezed,
    Object? primaryMonitor = freezed,
    Object? demonstration = null,
  }) {
    return _then(_$RecordingMetaImpl(
      schemaVersion: freezed == schemaVersion
          ? _value.schemaVersion
          : schemaVersion // ignore: cast_nullable_to_non_nullable
              as SchemaVersion?,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      arch: null == arch
          ? _value.arch
          : arch // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      keyboardLayout: freezed == keyboardLayout
          ? _value.keyboardLayout
          : keyboardLayout // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryMonitor: freezed == primaryMonitor
          ? _value.primaryMonitor
          : primaryMonitor // ignore: cast_nullable_to_non_nullable
              as MonitorInfo?,
      demonstration: null == demonstration
          ? _value.demonstration
          : demonstration // ignore: cast_nullable_to_non_nullable
              as Demonstration,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecordingMetaImpl implements _RecordingMeta {
  const _$RecordingMetaImpl(
      {@JsonKey(name: 'schema_version') this.schemaVersion,
      required this.id,
      required this.timestamp,
      @JsonKey(name: 'duration_seconds') required this.durationSeconds,
      required this.status,
      this.reason,
      required this.title,
      required this.description,
      required this.platform,
      required this.arch,
      required this.version,
      required this.locale,
      @JsonKey(name: 'keyboard_layout') this.keyboardLayout,
      @JsonKey(name: 'primary_monitor') this.primaryMonitor,
      @JsonKey(name: 'quest') required this.demonstration});

  factory _$RecordingMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecordingMetaImplFromJson(json);

  @override
  @JsonKey(name: 'schema_version')
  final SchemaVersion? schemaVersion;
  @override
  final String id;
  @override
  final String timestamp;
  @override
  @JsonKey(name: 'duration_seconds')
  final int durationSeconds;
  @override
  final String status;
  @override
  final String? reason;
  @override
  final String title;
  @override
  final String description;
  @override
  final String platform;
  @override
  final String arch;
  @override
  final String version;
  @override
  final String locale;
  @override
  @JsonKey(name: 'keyboard_layout')
  final String? keyboardLayout;
  @override
  @JsonKey(name: 'primary_monitor')
  final MonitorInfo? primaryMonitor;
  @override
  @JsonKey(name: 'quest')
  final Demonstration demonstration;

  @override
  String toString() {
    return 'RecordingMeta(schemaVersion: $schemaVersion, id: $id, timestamp: $timestamp, durationSeconds: $durationSeconds, status: $status, reason: $reason, title: $title, description: $description, platform: $platform, arch: $arch, version: $version, locale: $locale, keyboardLayout: $keyboardLayout, primaryMonitor: $primaryMonitor, demonstration: $demonstration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordingMetaImpl &&
            (identical(other.schemaVersion, schemaVersion) ||
                other.schemaVersion == schemaVersion) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.arch, arch) || other.arch == arch) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.keyboardLayout, keyboardLayout) ||
                other.keyboardLayout == keyboardLayout) &&
            (identical(other.primaryMonitor, primaryMonitor) ||
                other.primaryMonitor == primaryMonitor) &&
            (identical(other.demonstration, demonstration) ||
                other.demonstration == demonstration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      schemaVersion,
      id,
      timestamp,
      durationSeconds,
      status,
      reason,
      title,
      description,
      platform,
      arch,
      version,
      locale,
      keyboardLayout,
      primaryMonitor,
      demonstration);

  /// Create a copy of RecordingMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordingMetaImplCopyWith<_$RecordingMetaImpl> get copyWith =>
      __$$RecordingMetaImplCopyWithImpl<_$RecordingMetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecordingMetaImplToJson(
      this,
    );
  }
}

abstract class _RecordingMeta implements RecordingMeta {
  const factory _RecordingMeta(
          {@JsonKey(name: 'schema_version') final SchemaVersion? schemaVersion,
          required final String id,
          required final String timestamp,
          @JsonKey(name: 'duration_seconds') required final int durationSeconds,
          required final String status,
          final String? reason,
          required final String title,
          required final String description,
          required final String platform,
          required final String arch,
          required final String version,
          required final String locale,
          @JsonKey(name: 'keyboard_layout') final String? keyboardLayout,
          @JsonKey(name: 'primary_monitor') final MonitorInfo? primaryMonitor,
          @JsonKey(name: 'quest') required final Demonstration demonstration}) =
      _$RecordingMetaImpl;

  factory _RecordingMeta.fromJson(Map<String, dynamic> json) =
      _$RecordingMetaImpl.fromJson;

  @override
  @JsonKey(name: 'schema_version')
  SchemaVersion? get schemaVersion;
  @override
  String get id;
  @override
  String get timestamp;
  @override
  @JsonKey(name: 'duration_seconds')
  int get durationSeconds;
  @override
  String get status;
  @override
  String? get reason;
  @override
  String get title;
  @override
  String get description;
  @override
  String get platform;
  @override
  String get arch;
  @override
  String get version;
  @override
  String get locale;
  @override
  @JsonKey(name: 'keyboard_layout')
  String? get keyboardLayout;
  @override
  @JsonKey(name: 'primary_monitor')
  MonitorInfo? get primaryMonitor;
  @override
  @JsonKey(name: 'quest')
  Demonstration get demonstration;

  /// Create a copy of RecordingMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordingMetaImplCopyWith<_$RecordingMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
