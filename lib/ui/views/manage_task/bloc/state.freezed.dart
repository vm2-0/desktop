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
mixin _$ManageTaskState {
  ManageTaskModalType get modalType => throw _privateConstructorUsedError;
  String get prompt => throw _privateConstructorUsedError;
  double? get pricePerDemo => throw _privateConstructorUsedError;
  int? get uploadLimitValue => throw _privateConstructorUsedError;

  /// Create a copy of ManageTaskState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManageTaskStateCopyWith<ManageTaskState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManageTaskStateCopyWith<$Res> {
  factory $ManageTaskStateCopyWith(
          ManageTaskState value, $Res Function(ManageTaskState) then) =
      _$ManageTaskStateCopyWithImpl<$Res, ManageTaskState>;
  @useResult
  $Res call(
      {ManageTaskModalType modalType,
      String prompt,
      double? pricePerDemo,
      int? uploadLimitValue});
}

/// @nodoc
class _$ManageTaskStateCopyWithImpl<$Res, $Val extends ManageTaskState>
    implements $ManageTaskStateCopyWith<$Res> {
  _$ManageTaskStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManageTaskState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modalType = null,
    Object? prompt = null,
    Object? pricePerDemo = freezed,
    Object? uploadLimitValue = freezed,
  }) {
    return _then(_value.copyWith(
      modalType: null == modalType
          ? _value.modalType
          : modalType // ignore: cast_nullable_to_non_nullable
              as ManageTaskModalType,
      prompt: null == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      pricePerDemo: freezed == pricePerDemo
          ? _value.pricePerDemo
          : pricePerDemo // ignore: cast_nullable_to_non_nullable
              as double?,
      uploadLimitValue: freezed == uploadLimitValue
          ? _value.uploadLimitValue
          : uploadLimitValue // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManageTaskStateImplCopyWith<$Res>
    implements $ManageTaskStateCopyWith<$Res> {
  factory _$$ManageTaskStateImplCopyWith(_$ManageTaskStateImpl value,
          $Res Function(_$ManageTaskStateImpl) then) =
      __$$ManageTaskStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ManageTaskModalType modalType,
      String prompt,
      double? pricePerDemo,
      int? uploadLimitValue});
}

/// @nodoc
class __$$ManageTaskStateImplCopyWithImpl<$Res>
    extends _$ManageTaskStateCopyWithImpl<$Res, _$ManageTaskStateImpl>
    implements _$$ManageTaskStateImplCopyWith<$Res> {
  __$$ManageTaskStateImplCopyWithImpl(
      _$ManageTaskStateImpl _value, $Res Function(_$ManageTaskStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ManageTaskState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modalType = null,
    Object? prompt = null,
    Object? pricePerDemo = freezed,
    Object? uploadLimitValue = freezed,
  }) {
    return _then(_$ManageTaskStateImpl(
      modalType: null == modalType
          ? _value.modalType
          : modalType // ignore: cast_nullable_to_non_nullable
              as ManageTaskModalType,
      prompt: null == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      pricePerDemo: freezed == pricePerDemo
          ? _value.pricePerDemo
          : pricePerDemo // ignore: cast_nullable_to_non_nullable
              as double?,
      uploadLimitValue: freezed == uploadLimitValue
          ? _value.uploadLimitValue
          : uploadLimitValue // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$ManageTaskStateImpl extends _ManageTaskState {
  const _$ManageTaskStateImpl(
      {this.modalType = ManageTaskModalType.create,
      this.prompt = '',
      this.pricePerDemo,
      this.uploadLimitValue})
      : super._();

  @override
  @JsonKey()
  final ManageTaskModalType modalType;
  @override
  @JsonKey()
  final String prompt;
  @override
  final double? pricePerDemo;
  @override
  final int? uploadLimitValue;

  @override
  String toString() {
    return 'ManageTaskState(modalType: $modalType, prompt: $prompt, pricePerDemo: $pricePerDemo, uploadLimitValue: $uploadLimitValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManageTaskStateImpl &&
            (identical(other.modalType, modalType) ||
                other.modalType == modalType) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.pricePerDemo, pricePerDemo) ||
                other.pricePerDemo == pricePerDemo) &&
            (identical(other.uploadLimitValue, uploadLimitValue) ||
                other.uploadLimitValue == uploadLimitValue));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, modalType, prompt, pricePerDemo, uploadLimitValue);

  /// Create a copy of ManageTaskState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManageTaskStateImplCopyWith<_$ManageTaskStateImpl> get copyWith =>
      __$$ManageTaskStateImplCopyWithImpl<_$ManageTaskStateImpl>(
          this, _$identity);
}

abstract class _ManageTaskState extends ManageTaskState {
  const factory _ManageTaskState(
      {final ManageTaskModalType modalType,
      final String prompt,
      final double? pricePerDemo,
      final int? uploadLimitValue}) = _$ManageTaskStateImpl;
  const _ManageTaskState._() : super._();

  @override
  ManageTaskModalType get modalType;
  @override
  String get prompt;
  @override
  double? get pricePerDemo;
  @override
  int? get uploadLimitValue;

  /// Create a copy of ManageTaskState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManageTaskStateImplCopyWith<_$ManageTaskStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
