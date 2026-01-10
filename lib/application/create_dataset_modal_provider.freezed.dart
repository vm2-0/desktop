// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_dataset_modal_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CreateDatasetModalState {
  bool get isShown => throw _privateConstructorUsedError;
  String? get factoryId => throw _privateConstructorUsedError;
  List<String>? get demoHashes => throw _privateConstructorUsedError;

  /// Create a copy of CreateDatasetModalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateDatasetModalStateCopyWith<CreateDatasetModalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateDatasetModalStateCopyWith<$Res> {
  factory $CreateDatasetModalStateCopyWith(CreateDatasetModalState value,
          $Res Function(CreateDatasetModalState) then) =
      _$CreateDatasetModalStateCopyWithImpl<$Res, CreateDatasetModalState>;
  @useResult
  $Res call({bool isShown, String? factoryId, List<String>? demoHashes});
}

/// @nodoc
class _$CreateDatasetModalStateCopyWithImpl<$Res,
        $Val extends CreateDatasetModalState>
    implements $CreateDatasetModalStateCopyWith<$Res> {
  _$CreateDatasetModalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateDatasetModalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isShown = null,
    Object? factoryId = freezed,
    Object? demoHashes = freezed,
  }) {
    return _then(_value.copyWith(
      isShown: null == isShown
          ? _value.isShown
          : isShown // ignore: cast_nullable_to_non_nullable
              as bool,
      factoryId: freezed == factoryId
          ? _value.factoryId
          : factoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      demoHashes: freezed == demoHashes
          ? _value.demoHashes
          : demoHashes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateDatasetModalStateImplCopyWith<$Res>
    implements $CreateDatasetModalStateCopyWith<$Res> {
  factory _$$CreateDatasetModalStateImplCopyWith(
          _$CreateDatasetModalStateImpl value,
          $Res Function(_$CreateDatasetModalStateImpl) then) =
      __$$CreateDatasetModalStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isShown, String? factoryId, List<String>? demoHashes});
}

/// @nodoc
class __$$CreateDatasetModalStateImplCopyWithImpl<$Res>
    extends _$CreateDatasetModalStateCopyWithImpl<$Res,
        _$CreateDatasetModalStateImpl>
    implements _$$CreateDatasetModalStateImplCopyWith<$Res> {
  __$$CreateDatasetModalStateImplCopyWithImpl(
      _$CreateDatasetModalStateImpl _value,
      $Res Function(_$CreateDatasetModalStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateDatasetModalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isShown = null,
    Object? factoryId = freezed,
    Object? demoHashes = freezed,
  }) {
    return _then(_$CreateDatasetModalStateImpl(
      isShown: null == isShown
          ? _value.isShown
          : isShown // ignore: cast_nullable_to_non_nullable
              as bool,
      factoryId: freezed == factoryId
          ? _value.factoryId
          : factoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      demoHashes: freezed == demoHashes
          ? _value._demoHashes
          : demoHashes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

class _$CreateDatasetModalStateImpl implements _CreateDatasetModalState {
  const _$CreateDatasetModalStateImpl(
      {this.isShown = false, this.factoryId, final List<String>? demoHashes})
      : _demoHashes = demoHashes;

  @override
  @JsonKey()
  final bool isShown;
  @override
  final String? factoryId;
  final List<String>? _demoHashes;
  @override
  List<String>? get demoHashes {
    final value = _demoHashes;
    if (value == null) return null;
    if (_demoHashes is EqualUnmodifiableListView) return _demoHashes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CreateDatasetModalState(isShown: $isShown, factoryId: $factoryId, demoHashes: $demoHashes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateDatasetModalStateImpl &&
            (identical(other.isShown, isShown) || other.isShown == isShown) &&
            (identical(other.factoryId, factoryId) ||
                other.factoryId == factoryId) &&
            const DeepCollectionEquality()
                .equals(other._demoHashes, _demoHashes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isShown, factoryId,
      const DeepCollectionEquality().hash(_demoHashes));

  /// Create a copy of CreateDatasetModalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateDatasetModalStateImplCopyWith<_$CreateDatasetModalStateImpl>
      get copyWith => __$$CreateDatasetModalStateImplCopyWithImpl<
          _$CreateDatasetModalStateImpl>(this, _$identity);
}

abstract class _CreateDatasetModalState implements CreateDatasetModalState {
  const factory _CreateDatasetModalState(
      {final bool isShown,
      final String? factoryId,
      final List<String>? demoHashes}) = _$CreateDatasetModalStateImpl;

  @override
  bool get isShown;
  @override
  String? get factoryId;
  @override
  List<String>? get demoHashes;

  /// Create a copy of CreateDatasetModalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateDatasetModalStateImplCopyWith<_$CreateDatasetModalStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
