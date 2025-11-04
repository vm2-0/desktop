// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tool_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ToolStatus _$ToolStatusFromJson(Map<String, dynamic> json) {
  return _ToolStatus.fromJson(json);
}

/// @nodoc
mixin _$ToolStatus {
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToString)
  ToolInitStatus get status => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  int get progress => throw _privateConstructorUsedError;

  /// Serializes this ToolStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ToolStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ToolStatusCopyWith<ToolStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolStatusCopyWith<$Res> {
  factory $ToolStatusCopyWith(
          ToolStatus value, $Res Function(ToolStatus) then) =
      _$ToolStatusCopyWithImpl<$Res, ToolStatus>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _statusFromJson, toJson: _statusToString)
      ToolInitStatus status,
      String message,
      int progress});

  $ToolInitStatusCopyWith<$Res> get status;
}

/// @nodoc
class _$ToolStatusCopyWithImpl<$Res, $Val extends ToolStatus>
    implements $ToolStatusCopyWith<$Res> {
  _$ToolStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ToolStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
    Object? progress = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ToolInitStatus,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of ToolStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ToolInitStatusCopyWith<$Res> get status {
    return $ToolInitStatusCopyWith<$Res>(_value.status, (value) {
      return _then(_value.copyWith(status: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ToolStatusImplCopyWith<$Res>
    implements $ToolStatusCopyWith<$Res> {
  factory _$$ToolStatusImplCopyWith(
          _$ToolStatusImpl value, $Res Function(_$ToolStatusImpl) then) =
      __$$ToolStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _statusFromJson, toJson: _statusToString)
      ToolInitStatus status,
      String message,
      int progress});

  @override
  $ToolInitStatusCopyWith<$Res> get status;
}

/// @nodoc
class __$$ToolStatusImplCopyWithImpl<$Res>
    extends _$ToolStatusCopyWithImpl<$Res, _$ToolStatusImpl>
    implements _$$ToolStatusImplCopyWith<$Res> {
  __$$ToolStatusImplCopyWithImpl(
      _$ToolStatusImpl _value, $Res Function(_$ToolStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of ToolStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
    Object? progress = null,
  }) {
    return _then(_$ToolStatusImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ToolInitStatus,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolStatusImpl implements _ToolStatus {
  const _$ToolStatusImpl(
      {@JsonKey(fromJson: _statusFromJson, toJson: _statusToString)
      required this.status,
      required this.message,
      required this.progress});

  factory _$ToolStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolStatusImplFromJson(json);

  @override
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToString)
  final ToolInitStatus status;
  @override
  final String message;
  @override
  final int progress;

  @override
  String toString() {
    return 'ToolStatus(status: $status, message: $message, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolStatusImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, message, progress);

  /// Create a copy of ToolStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolStatusImplCopyWith<_$ToolStatusImpl> get copyWith =>
      __$$ToolStatusImplCopyWithImpl<_$ToolStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolStatusImplToJson(
      this,
    );
  }
}

abstract class _ToolStatus implements ToolStatus {
  const factory _ToolStatus(
      {@JsonKey(fromJson: _statusFromJson, toJson: _statusToString)
      required final ToolInitStatus status,
      required final String message,
      required final int progress}) = _$ToolStatusImpl;

  factory _ToolStatus.fromJson(Map<String, dynamic> json) =
      _$ToolStatusImpl.fromJson;

  @override
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToString)
  ToolInitStatus get status;
  @override
  String get message;
  @override
  int get progress;

  /// Create a copy of ToolStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToolStatusImplCopyWith<_$ToolStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ToolInitStatus {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() starting,
    required TResult Function() downloading,
    required TResult Function() completed,
    required TResult Function() error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? starting,
    TResult? Function()? downloading,
    TResult? Function()? completed,
    TResult? Function()? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? starting,
    TResult Function()? downloading,
    TResult Function()? completed,
    TResult Function()? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Starting value) starting,
    required TResult Function(_Downloading value) downloading,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Starting value)? starting,
    TResult? Function(_Downloading value)? downloading,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Starting value)? starting,
    TResult Function(_Downloading value)? downloading,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolInitStatusCopyWith<$Res> {
  factory $ToolInitStatusCopyWith(
          ToolInitStatus value, $Res Function(ToolInitStatus) then) =
      _$ToolInitStatusCopyWithImpl<$Res, ToolInitStatus>;
}

/// @nodoc
class _$ToolInitStatusCopyWithImpl<$Res, $Val extends ToolInitStatus>
    implements $ToolInitStatusCopyWith<$Res> {
  _$ToolInitStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ToolInitStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$IdleImplCopyWith<$Res> {
  factory _$$IdleImplCopyWith(
          _$IdleImpl value, $Res Function(_$IdleImpl) then) =
      __$$IdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$IdleImplCopyWithImpl<$Res>
    extends _$ToolInitStatusCopyWithImpl<$Res, _$IdleImpl>
    implements _$$IdleImplCopyWith<$Res> {
  __$$IdleImplCopyWithImpl(_$IdleImpl _value, $Res Function(_$IdleImpl) _then)
      : super(_value, _then);

  /// Create a copy of ToolInitStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$IdleImpl implements _Idle {
  const _$IdleImpl();

  @override
  String toString() {
    return 'ToolInitStatus.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$IdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() starting,
    required TResult Function() downloading,
    required TResult Function() completed,
    required TResult Function() error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? starting,
    TResult? Function()? downloading,
    TResult? Function()? completed,
    TResult? Function()? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? starting,
    TResult Function()? downloading,
    TResult Function()? completed,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Starting value) starting,
    required TResult Function(_Downloading value) downloading,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Starting value)? starting,
    TResult? Function(_Downloading value)? downloading,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Starting value)? starting,
    TResult Function(_Downloading value)? downloading,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class _Idle implements ToolInitStatus {
  const factory _Idle() = _$IdleImpl;
}

/// @nodoc
abstract class _$$StartingImplCopyWith<$Res> {
  factory _$$StartingImplCopyWith(
          _$StartingImpl value, $Res Function(_$StartingImpl) then) =
      __$$StartingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StartingImplCopyWithImpl<$Res>
    extends _$ToolInitStatusCopyWithImpl<$Res, _$StartingImpl>
    implements _$$StartingImplCopyWith<$Res> {
  __$$StartingImplCopyWithImpl(
      _$StartingImpl _value, $Res Function(_$StartingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ToolInitStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StartingImpl implements _Starting {
  const _$StartingImpl();

  @override
  String toString() {
    return 'ToolInitStatus.starting()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StartingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() starting,
    required TResult Function() downloading,
    required TResult Function() completed,
    required TResult Function() error,
  }) {
    return starting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? starting,
    TResult? Function()? downloading,
    TResult? Function()? completed,
    TResult? Function()? error,
  }) {
    return starting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? starting,
    TResult Function()? downloading,
    TResult Function()? completed,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (starting != null) {
      return starting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Starting value) starting,
    required TResult Function(_Downloading value) downloading,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return starting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Starting value)? starting,
    TResult? Function(_Downloading value)? downloading,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return starting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Starting value)? starting,
    TResult Function(_Downloading value)? downloading,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (starting != null) {
      return starting(this);
    }
    return orElse();
  }
}

abstract class _Starting implements ToolInitStatus {
  const factory _Starting() = _$StartingImpl;
}

/// @nodoc
abstract class _$$DownloadingImplCopyWith<$Res> {
  factory _$$DownloadingImplCopyWith(
          _$DownloadingImpl value, $Res Function(_$DownloadingImpl) then) =
      __$$DownloadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DownloadingImplCopyWithImpl<$Res>
    extends _$ToolInitStatusCopyWithImpl<$Res, _$DownloadingImpl>
    implements _$$DownloadingImplCopyWith<$Res> {
  __$$DownloadingImplCopyWithImpl(
      _$DownloadingImpl _value, $Res Function(_$DownloadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ToolInitStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DownloadingImpl implements _Downloading {
  const _$DownloadingImpl();

  @override
  String toString() {
    return 'ToolInitStatus.downloading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DownloadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() starting,
    required TResult Function() downloading,
    required TResult Function() completed,
    required TResult Function() error,
  }) {
    return downloading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? starting,
    TResult? Function()? downloading,
    TResult? Function()? completed,
    TResult? Function()? error,
  }) {
    return downloading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? starting,
    TResult Function()? downloading,
    TResult Function()? completed,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (downloading != null) {
      return downloading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Starting value) starting,
    required TResult Function(_Downloading value) downloading,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return downloading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Starting value)? starting,
    TResult? Function(_Downloading value)? downloading,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return downloading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Starting value)? starting,
    TResult Function(_Downloading value)? downloading,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (downloading != null) {
      return downloading(this);
    }
    return orElse();
  }
}

abstract class _Downloading implements ToolInitStatus {
  const factory _Downloading() = _$DownloadingImpl;
}

/// @nodoc
abstract class _$$CompletedImplCopyWith<$Res> {
  factory _$$CompletedImplCopyWith(
          _$CompletedImpl value, $Res Function(_$CompletedImpl) then) =
      __$$CompletedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CompletedImplCopyWithImpl<$Res>
    extends _$ToolInitStatusCopyWithImpl<$Res, _$CompletedImpl>
    implements _$$CompletedImplCopyWith<$Res> {
  __$$CompletedImplCopyWithImpl(
      _$CompletedImpl _value, $Res Function(_$CompletedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ToolInitStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CompletedImpl implements _Completed {
  const _$CompletedImpl();

  @override
  String toString() {
    return 'ToolInitStatus.completed()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CompletedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() starting,
    required TResult Function() downloading,
    required TResult Function() completed,
    required TResult Function() error,
  }) {
    return completed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? starting,
    TResult? Function()? downloading,
    TResult? Function()? completed,
    TResult? Function()? error,
  }) {
    return completed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? starting,
    TResult Function()? downloading,
    TResult Function()? completed,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Starting value) starting,
    required TResult Function(_Downloading value) downloading,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Starting value)? starting,
    TResult? Function(_Downloading value)? downloading,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return completed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Starting value)? starting,
    TResult Function(_Downloading value)? downloading,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class _Completed implements ToolInitStatus {
  const factory _Completed() = _$CompletedImpl;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$ToolInitStatusCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ToolInitStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl();

  @override
  String toString() {
    return 'ToolInitStatus.error()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ErrorImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() starting,
    required TResult Function() downloading,
    required TResult Function() completed,
    required TResult Function() error,
  }) {
    return error();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? starting,
    TResult? Function()? downloading,
    TResult? Function()? completed,
    TResult? Function()? error,
  }) {
    return error?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? starting,
    TResult Function()? downloading,
    TResult Function()? completed,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Starting value) starting,
    required TResult Function(_Downloading value) downloading,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Starting value)? starting,
    TResult? Function(_Downloading value)? downloading,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Starting value)? starting,
    TResult Function(_Downloading value)? downloading,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements ToolInitStatus {
  const factory _Error() = _$ErrorImpl;
}
