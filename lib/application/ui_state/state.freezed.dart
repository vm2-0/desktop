// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UiState {
  bool get isVideoFullscreen => throw _privateConstructorUsedError;

  /// Create a copy of UiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UiStateCopyWith<UiState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UiStateCopyWith<$Res> {
  factory $UiStateCopyWith(UiState value, $Res Function(UiState) then) =
      _$UiStateCopyWithImpl<$Res, UiState>;
  @useResult
  $Res call({bool isVideoFullscreen});
}

/// @nodoc
class _$UiStateCopyWithImpl<$Res, $Val extends UiState>
    implements $UiStateCopyWith<$Res> {
  _$UiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isVideoFullscreen = null,
  }) {
    return _then(_value.copyWith(
      isVideoFullscreen: null == isVideoFullscreen
          ? _value.isVideoFullscreen
          : isVideoFullscreen // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UiStateImplCopyWith<$Res> implements $UiStateCopyWith<$Res> {
  factory _$$UiStateImplCopyWith(
          _$UiStateImpl value, $Res Function(_$UiStateImpl) then) =
      __$$UiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isVideoFullscreen});
}

/// @nodoc
class __$$UiStateImplCopyWithImpl<$Res>
    extends _$UiStateCopyWithImpl<$Res, _$UiStateImpl>
    implements _$$UiStateImplCopyWith<$Res> {
  __$$UiStateImplCopyWithImpl(
      _$UiStateImpl _value, $Res Function(_$UiStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of UiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isVideoFullscreen = null,
  }) {
    return _then(_$UiStateImpl(
      isVideoFullscreen: null == isVideoFullscreen
          ? _value.isVideoFullscreen
          : isVideoFullscreen // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$UiStateImpl implements _UiState {
  const _$UiStateImpl({this.isVideoFullscreen = false});

  @override
  @JsonKey()
  final bool isVideoFullscreen;

  @override
  String toString() {
    return 'UiState(isVideoFullscreen: $isVideoFullscreen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UiStateImpl &&
            (identical(other.isVideoFullscreen, isVideoFullscreen) ||
                other.isVideoFullscreen == isVideoFullscreen));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isVideoFullscreen);

  /// Create a copy of UiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UiStateImplCopyWith<_$UiStateImpl> get copyWith =>
      __$$UiStateImplCopyWithImpl<_$UiStateImpl>(this, _$identity);
}

abstract class _UiState implements UiState {
  const factory _UiState({final bool isVideoFullscreen}) = _$UiStateImpl;

  @override
  bool get isVideoFullscreen;

  /// Create a copy of UiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UiStateImplCopyWith<_$UiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
