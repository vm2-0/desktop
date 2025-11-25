// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sft_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SftMessage {
  int get timestamp => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String content, int timestamp, String? type,
            Map<String, dynamic>? data)
        assistant,
    required TResult Function(SftMessageContent content, int timestamp) user,
    required TResult Function(int timestamp, Map<String, dynamic> data)
        contextAnnotation,
    required TResult Function(int timestamp, Map<String, dynamic>? rawData)
        unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String content, int timestamp, String? type,
            Map<String, dynamic>? data)?
        assistant,
    TResult? Function(SftMessageContent content, int timestamp)? user,
    TResult? Function(int timestamp, Map<String, dynamic> data)?
        contextAnnotation,
    TResult? Function(int timestamp, Map<String, dynamic>? rawData)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String content, int timestamp, String? type,
            Map<String, dynamic>? data)?
        assistant,
    TResult Function(SftMessageContent content, int timestamp)? user,
    TResult Function(int timestamp, Map<String, dynamic> data)?
        contextAnnotation,
    TResult Function(int timestamp, Map<String, dynamic>? rawData)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AssistantSftMessage value) assistant,
    required TResult Function(UserSftMessage value) user,
    required TResult Function(ContextAnnotationSftMessage value)
        contextAnnotation,
    required TResult Function(UnknownSftMessage value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AssistantSftMessage value)? assistant,
    TResult? Function(UserSftMessage value)? user,
    TResult? Function(ContextAnnotationSftMessage value)? contextAnnotation,
    TResult? Function(UnknownSftMessage value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AssistantSftMessage value)? assistant,
    TResult Function(UserSftMessage value)? user,
    TResult Function(ContextAnnotationSftMessage value)? contextAnnotation,
    TResult Function(UnknownSftMessage value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of SftMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SftMessageCopyWith<SftMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SftMessageCopyWith<$Res> {
  factory $SftMessageCopyWith(
          SftMessage value, $Res Function(SftMessage) then) =
      _$SftMessageCopyWithImpl<$Res, SftMessage>;
  @useResult
  $Res call({int timestamp});
}

/// @nodoc
class _$SftMessageCopyWithImpl<$Res, $Val extends SftMessage>
    implements $SftMessageCopyWith<$Res> {
  _$SftMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SftMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssistantSftMessageImplCopyWith<$Res>
    implements $SftMessageCopyWith<$Res> {
  factory _$$AssistantSftMessageImplCopyWith(_$AssistantSftMessageImpl value,
          $Res Function(_$AssistantSftMessageImpl) then) =
      __$$AssistantSftMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String content,
      int timestamp,
      String? type,
      Map<String, dynamic>? data});
}

/// @nodoc
class __$$AssistantSftMessageImplCopyWithImpl<$Res>
    extends _$SftMessageCopyWithImpl<$Res, _$AssistantSftMessageImpl>
    implements _$$AssistantSftMessageImplCopyWith<$Res> {
  __$$AssistantSftMessageImplCopyWithImpl(_$AssistantSftMessageImpl _value,
      $Res Function(_$AssistantSftMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of SftMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? timestamp = null,
    Object? type = freezed,
    Object? data = freezed,
  }) {
    return _then(_$AssistantSftMessageImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$AssistantSftMessageImpl implements AssistantSftMessage {
  const _$AssistantSftMessageImpl(
      {required this.content,
      required this.timestamp,
      this.type,
      final Map<String, dynamic>? data})
      : _data = data;

  @override
  final String content;
  @override
  final int timestamp;
  @override
  final String? type;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SftMessage.assistant(content: $content, timestamp: $timestamp, type: $type, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssistantSftMessageImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, content, timestamp, type,
      const DeepCollectionEquality().hash(_data));

  /// Create a copy of SftMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssistantSftMessageImplCopyWith<_$AssistantSftMessageImpl> get copyWith =>
      __$$AssistantSftMessageImplCopyWithImpl<_$AssistantSftMessageImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String content, int timestamp, String? type,
            Map<String, dynamic>? data)
        assistant,
    required TResult Function(SftMessageContent content, int timestamp) user,
    required TResult Function(int timestamp, Map<String, dynamic> data)
        contextAnnotation,
    required TResult Function(int timestamp, Map<String, dynamic>? rawData)
        unknown,
  }) {
    return assistant(content, timestamp, type, data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String content, int timestamp, String? type,
            Map<String, dynamic>? data)?
        assistant,
    TResult? Function(SftMessageContent content, int timestamp)? user,
    TResult? Function(int timestamp, Map<String, dynamic> data)?
        contextAnnotation,
    TResult? Function(int timestamp, Map<String, dynamic>? rawData)? unknown,
  }) {
    return assistant?.call(content, timestamp, type, data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String content, int timestamp, String? type,
            Map<String, dynamic>? data)?
        assistant,
    TResult Function(SftMessageContent content, int timestamp)? user,
    TResult Function(int timestamp, Map<String, dynamic> data)?
        contextAnnotation,
    TResult Function(int timestamp, Map<String, dynamic>? rawData)? unknown,
    required TResult orElse(),
  }) {
    if (assistant != null) {
      return assistant(content, timestamp, type, data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AssistantSftMessage value) assistant,
    required TResult Function(UserSftMessage value) user,
    required TResult Function(ContextAnnotationSftMessage value)
        contextAnnotation,
    required TResult Function(UnknownSftMessage value) unknown,
  }) {
    return assistant(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AssistantSftMessage value)? assistant,
    TResult? Function(UserSftMessage value)? user,
    TResult? Function(ContextAnnotationSftMessage value)? contextAnnotation,
    TResult? Function(UnknownSftMessage value)? unknown,
  }) {
    return assistant?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AssistantSftMessage value)? assistant,
    TResult Function(UserSftMessage value)? user,
    TResult Function(ContextAnnotationSftMessage value)? contextAnnotation,
    TResult Function(UnknownSftMessage value)? unknown,
    required TResult orElse(),
  }) {
    if (assistant != null) {
      return assistant(this);
    }
    return orElse();
  }
}

abstract class AssistantSftMessage implements SftMessage {
  const factory AssistantSftMessage(
      {required final String content,
      required final int timestamp,
      final String? type,
      final Map<String, dynamic>? data}) = _$AssistantSftMessageImpl;

  String get content;
  @override
  int get timestamp;
  String? get type;
  Map<String, dynamic>? get data;

  /// Create a copy of SftMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssistantSftMessageImplCopyWith<_$AssistantSftMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UserSftMessageImplCopyWith<$Res>
    implements $SftMessageCopyWith<$Res> {
  factory _$$UserSftMessageImplCopyWith(_$UserSftMessageImpl value,
          $Res Function(_$UserSftMessageImpl) then) =
      __$$UserSftMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SftMessageContent content, int timestamp});

  $SftMessageContentCopyWith<$Res> get content;
}

/// @nodoc
class __$$UserSftMessageImplCopyWithImpl<$Res>
    extends _$SftMessageCopyWithImpl<$Res, _$UserSftMessageImpl>
    implements _$$UserSftMessageImplCopyWith<$Res> {
  __$$UserSftMessageImplCopyWithImpl(
      _$UserSftMessageImpl _value, $Res Function(_$UserSftMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of SftMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? timestamp = null,
  }) {
    return _then(_$UserSftMessageImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as SftMessageContent,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of SftMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SftMessageContentCopyWith<$Res> get content {
    return $SftMessageContentCopyWith<$Res>(_value.content, (value) {
      return _then(_value.copyWith(content: value));
    });
  }
}

/// @nodoc

class _$UserSftMessageImpl implements UserSftMessage {
  const _$UserSftMessageImpl({required this.content, required this.timestamp});

  @override
  final SftMessageContent content;
  @override
  final int timestamp;

  @override
  String toString() {
    return 'SftMessage.user(content: $content, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSftMessageImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, content, timestamp);

  /// Create a copy of SftMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSftMessageImplCopyWith<_$UserSftMessageImpl> get copyWith =>
      __$$UserSftMessageImplCopyWithImpl<_$UserSftMessageImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String content, int timestamp, String? type,
            Map<String, dynamic>? data)
        assistant,
    required TResult Function(SftMessageContent content, int timestamp) user,
    required TResult Function(int timestamp, Map<String, dynamic> data)
        contextAnnotation,
    required TResult Function(int timestamp, Map<String, dynamic>? rawData)
        unknown,
  }) {
    return user(content, timestamp);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String content, int timestamp, String? type,
            Map<String, dynamic>? data)?
        assistant,
    TResult? Function(SftMessageContent content, int timestamp)? user,
    TResult? Function(int timestamp, Map<String, dynamic> data)?
        contextAnnotation,
    TResult? Function(int timestamp, Map<String, dynamic>? rawData)? unknown,
  }) {
    return user?.call(content, timestamp);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String content, int timestamp, String? type,
            Map<String, dynamic>? data)?
        assistant,
    TResult Function(SftMessageContent content, int timestamp)? user,
    TResult Function(int timestamp, Map<String, dynamic> data)?
        contextAnnotation,
    TResult Function(int timestamp, Map<String, dynamic>? rawData)? unknown,
    required TResult orElse(),
  }) {
    if (user != null) {
      return user(content, timestamp);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AssistantSftMessage value) assistant,
    required TResult Function(UserSftMessage value) user,
    required TResult Function(ContextAnnotationSftMessage value)
        contextAnnotation,
    required TResult Function(UnknownSftMessage value) unknown,
  }) {
    return user(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AssistantSftMessage value)? assistant,
    TResult? Function(UserSftMessage value)? user,
    TResult? Function(ContextAnnotationSftMessage value)? contextAnnotation,
    TResult? Function(UnknownSftMessage value)? unknown,
  }) {
    return user?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AssistantSftMessage value)? assistant,
    TResult Function(UserSftMessage value)? user,
    TResult Function(ContextAnnotationSftMessage value)? contextAnnotation,
    TResult Function(UnknownSftMessage value)? unknown,
    required TResult orElse(),
  }) {
    if (user != null) {
      return user(this);
    }
    return orElse();
  }
}

abstract class UserSftMessage implements SftMessage {
  const factory UserSftMessage(
      {required final SftMessageContent content,
      required final int timestamp}) = _$UserSftMessageImpl;

  SftMessageContent get content;
  @override
  int get timestamp;

  /// Create a copy of SftMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSftMessageImplCopyWith<_$UserSftMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ContextAnnotationSftMessageImplCopyWith<$Res>
    implements $SftMessageCopyWith<$Res> {
  factory _$$ContextAnnotationSftMessageImplCopyWith(
          _$ContextAnnotationSftMessageImpl value,
          $Res Function(_$ContextAnnotationSftMessageImpl) then) =
      __$$ContextAnnotationSftMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int timestamp, Map<String, dynamic> data});
}

/// @nodoc
class __$$ContextAnnotationSftMessageImplCopyWithImpl<$Res>
    extends _$SftMessageCopyWithImpl<$Res, _$ContextAnnotationSftMessageImpl>
    implements _$$ContextAnnotationSftMessageImplCopyWith<$Res> {
  __$$ContextAnnotationSftMessageImplCopyWithImpl(
      _$ContextAnnotationSftMessageImpl _value,
      $Res Function(_$ContextAnnotationSftMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of SftMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? data = null,
  }) {
    return _then(_$ContextAnnotationSftMessageImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$ContextAnnotationSftMessageImpl implements ContextAnnotationSftMessage {
  const _$ContextAnnotationSftMessageImpl(
      {required this.timestamp, required final Map<String, dynamic> data})
      : _data = data;

  @override
  final int timestamp;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  String toString() {
    return 'SftMessage.contextAnnotation(timestamp: $timestamp, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContextAnnotationSftMessageImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, timestamp, const DeepCollectionEquality().hash(_data));

  /// Create a copy of SftMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContextAnnotationSftMessageImplCopyWith<_$ContextAnnotationSftMessageImpl>
      get copyWith => __$$ContextAnnotationSftMessageImplCopyWithImpl<
          _$ContextAnnotationSftMessageImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String content, int timestamp, String? type,
            Map<String, dynamic>? data)
        assistant,
    required TResult Function(SftMessageContent content, int timestamp) user,
    required TResult Function(int timestamp, Map<String, dynamic> data)
        contextAnnotation,
    required TResult Function(int timestamp, Map<String, dynamic>? rawData)
        unknown,
  }) {
    return contextAnnotation(timestamp, data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String content, int timestamp, String? type,
            Map<String, dynamic>? data)?
        assistant,
    TResult? Function(SftMessageContent content, int timestamp)? user,
    TResult? Function(int timestamp, Map<String, dynamic> data)?
        contextAnnotation,
    TResult? Function(int timestamp, Map<String, dynamic>? rawData)? unknown,
  }) {
    return contextAnnotation?.call(timestamp, data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String content, int timestamp, String? type,
            Map<String, dynamic>? data)?
        assistant,
    TResult Function(SftMessageContent content, int timestamp)? user,
    TResult Function(int timestamp, Map<String, dynamic> data)?
        contextAnnotation,
    TResult Function(int timestamp, Map<String, dynamic>? rawData)? unknown,
    required TResult orElse(),
  }) {
    if (contextAnnotation != null) {
      return contextAnnotation(timestamp, data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AssistantSftMessage value) assistant,
    required TResult Function(UserSftMessage value) user,
    required TResult Function(ContextAnnotationSftMessage value)
        contextAnnotation,
    required TResult Function(UnknownSftMessage value) unknown,
  }) {
    return contextAnnotation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AssistantSftMessage value)? assistant,
    TResult? Function(UserSftMessage value)? user,
    TResult? Function(ContextAnnotationSftMessage value)? contextAnnotation,
    TResult? Function(UnknownSftMessage value)? unknown,
  }) {
    return contextAnnotation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AssistantSftMessage value)? assistant,
    TResult Function(UserSftMessage value)? user,
    TResult Function(ContextAnnotationSftMessage value)? contextAnnotation,
    TResult Function(UnknownSftMessage value)? unknown,
    required TResult orElse(),
  }) {
    if (contextAnnotation != null) {
      return contextAnnotation(this);
    }
    return orElse();
  }
}

abstract class ContextAnnotationSftMessage implements SftMessage {
  const factory ContextAnnotationSftMessage(
          {required final int timestamp,
          required final Map<String, dynamic> data}) =
      _$ContextAnnotationSftMessageImpl;

  @override
  int get timestamp;
  Map<String, dynamic> get data;

  /// Create a copy of SftMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContextAnnotationSftMessageImplCopyWith<_$ContextAnnotationSftMessageImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownSftMessageImplCopyWith<$Res>
    implements $SftMessageCopyWith<$Res> {
  factory _$$UnknownSftMessageImplCopyWith(_$UnknownSftMessageImpl value,
          $Res Function(_$UnknownSftMessageImpl) then) =
      __$$UnknownSftMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int timestamp, Map<String, dynamic>? rawData});
}

/// @nodoc
class __$$UnknownSftMessageImplCopyWithImpl<$Res>
    extends _$SftMessageCopyWithImpl<$Res, _$UnknownSftMessageImpl>
    implements _$$UnknownSftMessageImplCopyWith<$Res> {
  __$$UnknownSftMessageImplCopyWithImpl(_$UnknownSftMessageImpl _value,
      $Res Function(_$UnknownSftMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of SftMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? rawData = freezed,
  }) {
    return _then(_$UnknownSftMessageImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      rawData: freezed == rawData
          ? _value._rawData
          : rawData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$UnknownSftMessageImpl implements UnknownSftMessage {
  const _$UnknownSftMessageImpl(
      {required this.timestamp, final Map<String, dynamic>? rawData})
      : _rawData = rawData;

  @override
  final int timestamp;
  final Map<String, dynamic>? _rawData;
  @override
  Map<String, dynamic>? get rawData {
    final value = _rawData;
    if (value == null) return null;
    if (_rawData is EqualUnmodifiableMapView) return _rawData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SftMessage.unknown(timestamp: $timestamp, rawData: $rawData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownSftMessageImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._rawData, _rawData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, timestamp, const DeepCollectionEquality().hash(_rawData));

  /// Create a copy of SftMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownSftMessageImplCopyWith<_$UnknownSftMessageImpl> get copyWith =>
      __$$UnknownSftMessageImplCopyWithImpl<_$UnknownSftMessageImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String content, int timestamp, String? type,
            Map<String, dynamic>? data)
        assistant,
    required TResult Function(SftMessageContent content, int timestamp) user,
    required TResult Function(int timestamp, Map<String, dynamic> data)
        contextAnnotation,
    required TResult Function(int timestamp, Map<String, dynamic>? rawData)
        unknown,
  }) {
    return unknown(timestamp, rawData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String content, int timestamp, String? type,
            Map<String, dynamic>? data)?
        assistant,
    TResult? Function(SftMessageContent content, int timestamp)? user,
    TResult? Function(int timestamp, Map<String, dynamic> data)?
        contextAnnotation,
    TResult? Function(int timestamp, Map<String, dynamic>? rawData)? unknown,
  }) {
    return unknown?.call(timestamp, rawData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String content, int timestamp, String? type,
            Map<String, dynamic>? data)?
        assistant,
    TResult Function(SftMessageContent content, int timestamp)? user,
    TResult Function(int timestamp, Map<String, dynamic> data)?
        contextAnnotation,
    TResult Function(int timestamp, Map<String, dynamic>? rawData)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(timestamp, rawData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AssistantSftMessage value) assistant,
    required TResult Function(UserSftMessage value) user,
    required TResult Function(ContextAnnotationSftMessage value)
        contextAnnotation,
    required TResult Function(UnknownSftMessage value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AssistantSftMessage value)? assistant,
    TResult? Function(UserSftMessage value)? user,
    TResult? Function(ContextAnnotationSftMessage value)? contextAnnotation,
    TResult? Function(UnknownSftMessage value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AssistantSftMessage value)? assistant,
    TResult Function(UserSftMessage value)? user,
    TResult Function(ContextAnnotationSftMessage value)? contextAnnotation,
    TResult Function(UnknownSftMessage value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownSftMessage implements SftMessage {
  const factory UnknownSftMessage(
      {required final int timestamp,
      final Map<String, dynamic>? rawData}) = _$UnknownSftMessageImpl;

  @override
  int get timestamp;
  Map<String, dynamic>? get rawData;

  /// Create a copy of SftMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnknownSftMessageImplCopyWith<_$UnknownSftMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SftMessageContent {
  String get data => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String data) image,
    required TResult Function(String data) text,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String data)? image,
    TResult? Function(String data)? text,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String data)? image,
    TResult Function(String data)? text,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImageContent value) image,
    required TResult Function(TextContent value) text,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImageContent value)? image,
    TResult? Function(TextContent value)? text,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImageContent value)? image,
    TResult Function(TextContent value)? text,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of SftMessageContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SftMessageContentCopyWith<SftMessageContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SftMessageContentCopyWith<$Res> {
  factory $SftMessageContentCopyWith(
          SftMessageContent value, $Res Function(SftMessageContent) then) =
      _$SftMessageContentCopyWithImpl<$Res, SftMessageContent>;
  @useResult
  $Res call({String data});
}

/// @nodoc
class _$SftMessageContentCopyWithImpl<$Res, $Val extends SftMessageContent>
    implements $SftMessageContentCopyWith<$Res> {
  _$SftMessageContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SftMessageContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImageContentImplCopyWith<$Res>
    implements $SftMessageContentCopyWith<$Res> {
  factory _$$ImageContentImplCopyWith(
          _$ImageContentImpl value, $Res Function(_$ImageContentImpl) then) =
      __$$ImageContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String data});
}

/// @nodoc
class __$$ImageContentImplCopyWithImpl<$Res>
    extends _$SftMessageContentCopyWithImpl<$Res, _$ImageContentImpl>
    implements _$$ImageContentImplCopyWith<$Res> {
  __$$ImageContentImplCopyWithImpl(
      _$ImageContentImpl _value, $Res Function(_$ImageContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of SftMessageContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$ImageContentImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ImageContentImpl implements ImageContent {
  const _$ImageContentImpl({required this.data});

  @override
  final String data;

  @override
  String toString() {
    return 'SftMessageContent.image(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageContentImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of SftMessageContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageContentImplCopyWith<_$ImageContentImpl> get copyWith =>
      __$$ImageContentImplCopyWithImpl<_$ImageContentImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String data) image,
    required TResult Function(String data) text,
  }) {
    return image(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String data)? image,
    TResult? Function(String data)? text,
  }) {
    return image?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String data)? image,
    TResult Function(String data)? text,
    required TResult orElse(),
  }) {
    if (image != null) {
      return image(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImageContent value) image,
    required TResult Function(TextContent value) text,
  }) {
    return image(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImageContent value)? image,
    TResult? Function(TextContent value)? text,
  }) {
    return image?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImageContent value)? image,
    TResult Function(TextContent value)? text,
    required TResult orElse(),
  }) {
    if (image != null) {
      return image(this);
    }
    return orElse();
  }
}

abstract class ImageContent implements SftMessageContent {
  const factory ImageContent({required final String data}) = _$ImageContentImpl;

  @override
  String get data;

  /// Create a copy of SftMessageContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageContentImplCopyWith<_$ImageContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TextContentImplCopyWith<$Res>
    implements $SftMessageContentCopyWith<$Res> {
  factory _$$TextContentImplCopyWith(
          _$TextContentImpl value, $Res Function(_$TextContentImpl) then) =
      __$$TextContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String data});
}

/// @nodoc
class __$$TextContentImplCopyWithImpl<$Res>
    extends _$SftMessageContentCopyWithImpl<$Res, _$TextContentImpl>
    implements _$$TextContentImplCopyWith<$Res> {
  __$$TextContentImplCopyWithImpl(
      _$TextContentImpl _value, $Res Function(_$TextContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of SftMessageContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$TextContentImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TextContentImpl implements TextContent {
  const _$TextContentImpl({required this.data});

  @override
  final String data;

  @override
  String toString() {
    return 'SftMessageContent.text(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TextContentImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of SftMessageContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TextContentImplCopyWith<_$TextContentImpl> get copyWith =>
      __$$TextContentImplCopyWithImpl<_$TextContentImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String data) image,
    required TResult Function(String data) text,
  }) {
    return text(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String data)? image,
    TResult? Function(String data)? text,
  }) {
    return text?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String data)? image,
    TResult Function(String data)? text,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImageContent value) image,
    required TResult Function(TextContent value) text,
  }) {
    return text(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImageContent value)? image,
    TResult? Function(TextContent value)? text,
  }) {
    return text?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImageContent value)? image,
    TResult Function(TextContent value)? text,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(this);
    }
    return orElse();
  }
}

abstract class TextContent implements SftMessageContent {
  const factory TextContent({required final String data}) = _$TextContentImpl;

  @override
  String get data;

  /// Create a copy of SftMessageContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TextContentImplCopyWith<_$TextContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AppFocusData {
  String get focusedApp => throw _privateConstructorUsedError;
  List<String> get availableApps => throw _privateConstructorUsedError;
  String get appStatus => throw _privateConstructorUsedError;
  List<WindowInfo> get allWindows => throw _privateConstructorUsedError;

  /// Create a copy of AppFocusData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppFocusDataCopyWith<AppFocusData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppFocusDataCopyWith<$Res> {
  factory $AppFocusDataCopyWith(
          AppFocusData value, $Res Function(AppFocusData) then) =
      _$AppFocusDataCopyWithImpl<$Res, AppFocusData>;
  @useResult
  $Res call(
      {String focusedApp,
      List<String> availableApps,
      String appStatus,
      List<WindowInfo> allWindows});
}

/// @nodoc
class _$AppFocusDataCopyWithImpl<$Res, $Val extends AppFocusData>
    implements $AppFocusDataCopyWith<$Res> {
  _$AppFocusDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppFocusData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? focusedApp = null,
    Object? availableApps = null,
    Object? appStatus = null,
    Object? allWindows = null,
  }) {
    return _then(_value.copyWith(
      focusedApp: null == focusedApp
          ? _value.focusedApp
          : focusedApp // ignore: cast_nullable_to_non_nullable
              as String,
      availableApps: null == availableApps
          ? _value.availableApps
          : availableApps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      appStatus: null == appStatus
          ? _value.appStatus
          : appStatus // ignore: cast_nullable_to_non_nullable
              as String,
      allWindows: null == allWindows
          ? _value.allWindows
          : allWindows // ignore: cast_nullable_to_non_nullable
              as List<WindowInfo>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppFocusDataImplCopyWith<$Res>
    implements $AppFocusDataCopyWith<$Res> {
  factory _$$AppFocusDataImplCopyWith(
          _$AppFocusDataImpl value, $Res Function(_$AppFocusDataImpl) then) =
      __$$AppFocusDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String focusedApp,
      List<String> availableApps,
      String appStatus,
      List<WindowInfo> allWindows});
}

/// @nodoc
class __$$AppFocusDataImplCopyWithImpl<$Res>
    extends _$AppFocusDataCopyWithImpl<$Res, _$AppFocusDataImpl>
    implements _$$AppFocusDataImplCopyWith<$Res> {
  __$$AppFocusDataImplCopyWithImpl(
      _$AppFocusDataImpl _value, $Res Function(_$AppFocusDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppFocusData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? focusedApp = null,
    Object? availableApps = null,
    Object? appStatus = null,
    Object? allWindows = null,
  }) {
    return _then(_$AppFocusDataImpl(
      focusedApp: null == focusedApp
          ? _value.focusedApp
          : focusedApp // ignore: cast_nullable_to_non_nullable
              as String,
      availableApps: null == availableApps
          ? _value._availableApps
          : availableApps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      appStatus: null == appStatus
          ? _value.appStatus
          : appStatus // ignore: cast_nullable_to_non_nullable
              as String,
      allWindows: null == allWindows
          ? _value._allWindows
          : allWindows // ignore: cast_nullable_to_non_nullable
              as List<WindowInfo>,
    ));
  }
}

/// @nodoc

class _$AppFocusDataImpl implements _AppFocusData {
  const _$AppFocusDataImpl(
      {required this.focusedApp,
      required final List<String> availableApps,
      required this.appStatus,
      required final List<WindowInfo> allWindows})
      : _availableApps = availableApps,
        _allWindows = allWindows;

  @override
  final String focusedApp;
  final List<String> _availableApps;
  @override
  List<String> get availableApps {
    if (_availableApps is EqualUnmodifiableListView) return _availableApps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableApps);
  }

  @override
  final String appStatus;
  final List<WindowInfo> _allWindows;
  @override
  List<WindowInfo> get allWindows {
    if (_allWindows is EqualUnmodifiableListView) return _allWindows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allWindows);
  }

  @override
  String toString() {
    return 'AppFocusData(focusedApp: $focusedApp, availableApps: $availableApps, appStatus: $appStatus, allWindows: $allWindows)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppFocusDataImpl &&
            (identical(other.focusedApp, focusedApp) ||
                other.focusedApp == focusedApp) &&
            const DeepCollectionEquality()
                .equals(other._availableApps, _availableApps) &&
            (identical(other.appStatus, appStatus) ||
                other.appStatus == appStatus) &&
            const DeepCollectionEquality()
                .equals(other._allWindows, _allWindows));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      focusedApp,
      const DeepCollectionEquality().hash(_availableApps),
      appStatus,
      const DeepCollectionEquality().hash(_allWindows));

  /// Create a copy of AppFocusData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppFocusDataImplCopyWith<_$AppFocusDataImpl> get copyWith =>
      __$$AppFocusDataImplCopyWithImpl<_$AppFocusDataImpl>(this, _$identity);
}

abstract class _AppFocusData implements AppFocusData {
  const factory _AppFocusData(
      {required final String focusedApp,
      required final List<String> availableApps,
      required final String appStatus,
      required final List<WindowInfo> allWindows}) = _$AppFocusDataImpl;

  @override
  String get focusedApp;
  @override
  List<String> get availableApps;
  @override
  String get appStatus;
  @override
  List<WindowInfo> get allWindows;

  /// Create a copy of AppFocusData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppFocusDataImplCopyWith<_$AppFocusDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WindowInfo _$WindowInfoFromJson(Map<String, dynamic> json) {
  return _WindowInfo.fromJson(json);
}

/// @nodoc
mixin _$WindowInfo {
  Map<String, dynamic> get bbox => throw _privateConstructorUsedError;
  List<dynamic> get children => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  /// Serializes this WindowInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WindowInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WindowInfoCopyWith<WindowInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WindowInfoCopyWith<$Res> {
  factory $WindowInfoCopyWith(
          WindowInfo value, $Res Function(WindowInfo) then) =
      _$WindowInfoCopyWithImpl<$Res, WindowInfo>;
  @useResult
  $Res call(
      {Map<String, dynamic> bbox,
      List<dynamic> children,
      String description,
      String name,
      String role,
      String value});
}

/// @nodoc
class _$WindowInfoCopyWithImpl<$Res, $Val extends WindowInfo>
    implements $WindowInfoCopyWith<$Res> {
  _$WindowInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WindowInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bbox = null,
    Object? children = null,
    Object? description = null,
    Object? name = null,
    Object? role = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      bbox: null == bbox
          ? _value.bbox
          : bbox // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WindowInfoImplCopyWith<$Res>
    implements $WindowInfoCopyWith<$Res> {
  factory _$$WindowInfoImplCopyWith(
          _$WindowInfoImpl value, $Res Function(_$WindowInfoImpl) then) =
      __$$WindowInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, dynamic> bbox,
      List<dynamic> children,
      String description,
      String name,
      String role,
      String value});
}

/// @nodoc
class __$$WindowInfoImplCopyWithImpl<$Res>
    extends _$WindowInfoCopyWithImpl<$Res, _$WindowInfoImpl>
    implements _$$WindowInfoImplCopyWith<$Res> {
  __$$WindowInfoImplCopyWithImpl(
      _$WindowInfoImpl _value, $Res Function(_$WindowInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of WindowInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bbox = null,
    Object? children = null,
    Object? description = null,
    Object? name = null,
    Object? role = null,
    Object? value = null,
  }) {
    return _then(_$WindowInfoImpl(
      bbox: null == bbox
          ? _value._bbox
          : bbox // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      children: null == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WindowInfoImpl implements _WindowInfo {
  const _$WindowInfoImpl(
      {required final Map<String, dynamic> bbox,
      required final List<dynamic> children,
      required this.description,
      required this.name,
      required this.role,
      required this.value})
      : _bbox = bbox,
        _children = children;

  factory _$WindowInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WindowInfoImplFromJson(json);

  final Map<String, dynamic> _bbox;
  @override
  Map<String, dynamic> get bbox {
    if (_bbox is EqualUnmodifiableMapView) return _bbox;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_bbox);
  }

  final List<dynamic> _children;
  @override
  List<dynamic> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  final String description;
  @override
  final String name;
  @override
  final String role;
  @override
  final String value;

  @override
  String toString() {
    return 'WindowInfo(bbox: $bbox, children: $children, description: $description, name: $name, role: $role, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WindowInfoImpl &&
            const DeepCollectionEquality().equals(other._bbox, _bbox) &&
            const DeepCollectionEquality().equals(other._children, _children) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_bbox),
      const DeepCollectionEquality().hash(_children),
      description,
      name,
      role,
      value);

  /// Create a copy of WindowInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WindowInfoImplCopyWith<_$WindowInfoImpl> get copyWith =>
      __$$WindowInfoImplCopyWithImpl<_$WindowInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WindowInfoImplToJson(
      this,
    );
  }
}

abstract class _WindowInfo implements WindowInfo {
  const factory _WindowInfo(
      {required final Map<String, dynamic> bbox,
      required final List<dynamic> children,
      required final String description,
      required final String name,
      required final String role,
      required final String value}) = _$WindowInfoImpl;

  factory _WindowInfo.fromJson(Map<String, dynamic> json) =
      _$WindowInfoImpl.fromJson;

  @override
  Map<String, dynamic> get bbox;
  @override
  List<dynamic> get children;
  @override
  String get description;
  @override
  String get name;
  @override
  String get role;
  @override
  String get value;

  /// Create a copy of WindowInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WindowInfoImplCopyWith<_$WindowInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
