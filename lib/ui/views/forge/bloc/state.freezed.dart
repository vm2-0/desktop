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
mixin _$ForgeState {
  bool get showGenerateFactoryModal => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get currentOffset => throw _privateConstructorUsedError;
  List<Factory> get allFactories => throw _privateConstructorUsedError;
  bool get hasMoreFactories => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  bool get showFilters => throw _privateConstructorUsedError;
  List<String> get allSkills => throw _privateConstructorUsedError;
  Set<String> get selectedSkills => throw _privateConstructorUsedError;
  FactoryStatus? get selectedStatus => throw _privateConstructorUsedError;
  String get searchTerm => throw _privateConstructorUsedError;
  FactorySearchCriteria get currentFilter => throw _privateConstructorUsedError;

  /// Create a copy of ForgeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForgeStateCopyWith<ForgeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgeStateCopyWith<$Res> {
  factory $ForgeStateCopyWith(
          ForgeState value, $Res Function(ForgeState) then) =
      _$ForgeStateCopyWithImpl<$Res, ForgeState>;
  @useResult
  $Res call(
      {bool showGenerateFactoryModal,
      int pageSize,
      int currentOffset,
      List<Factory> allFactories,
      bool hasMoreFactories,
      bool isLoading,
      bool isLoadingMore,
      bool showFilters,
      List<String> allSkills,
      Set<String> selectedSkills,
      FactoryStatus? selectedStatus,
      String searchTerm,
      FactorySearchCriteria currentFilter});

  $FactorySearchCriteriaCopyWith<$Res> get currentFilter;
}

/// @nodoc
class _$ForgeStateCopyWithImpl<$Res, $Val extends ForgeState>
    implements $ForgeStateCopyWith<$Res> {
  _$ForgeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showGenerateFactoryModal = null,
    Object? pageSize = null,
    Object? currentOffset = null,
    Object? allFactories = null,
    Object? hasMoreFactories = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? showFilters = null,
    Object? allSkills = null,
    Object? selectedSkills = null,
    Object? selectedStatus = freezed,
    Object? searchTerm = null,
    Object? currentFilter = null,
  }) {
    return _then(_value.copyWith(
      showGenerateFactoryModal: null == showGenerateFactoryModal
          ? _value.showGenerateFactoryModal
          : showGenerateFactoryModal // ignore: cast_nullable_to_non_nullable
              as bool,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      currentOffset: null == currentOffset
          ? _value.currentOffset
          : currentOffset // ignore: cast_nullable_to_non_nullable
              as int,
      allFactories: null == allFactories
          ? _value.allFactories
          : allFactories // ignore: cast_nullable_to_non_nullable
              as List<Factory>,
      hasMoreFactories: null == hasMoreFactories
          ? _value.hasMoreFactories
          : hasMoreFactories // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      showFilters: null == showFilters
          ? _value.showFilters
          : showFilters // ignore: cast_nullable_to_non_nullable
              as bool,
      allSkills: null == allSkills
          ? _value.allSkills
          : allSkills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedSkills: null == selectedSkills
          ? _value.selectedSkills
          : selectedSkills // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      selectedStatus: freezed == selectedStatus
          ? _value.selectedStatus
          : selectedStatus // ignore: cast_nullable_to_non_nullable
              as FactoryStatus?,
      searchTerm: null == searchTerm
          ? _value.searchTerm
          : searchTerm // ignore: cast_nullable_to_non_nullable
              as String,
      currentFilter: null == currentFilter
          ? _value.currentFilter
          : currentFilter // ignore: cast_nullable_to_non_nullable
              as FactorySearchCriteria,
    ) as $Val);
  }

  /// Create a copy of ForgeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FactorySearchCriteriaCopyWith<$Res> get currentFilter {
    return $FactorySearchCriteriaCopyWith<$Res>(_value.currentFilter, (value) {
      return _then(_value.copyWith(currentFilter: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ForgeStateImplCopyWith<$Res>
    implements $ForgeStateCopyWith<$Res> {
  factory _$$ForgeStateImplCopyWith(
          _$ForgeStateImpl value, $Res Function(_$ForgeStateImpl) then) =
      __$$ForgeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool showGenerateFactoryModal,
      int pageSize,
      int currentOffset,
      List<Factory> allFactories,
      bool hasMoreFactories,
      bool isLoading,
      bool isLoadingMore,
      bool showFilters,
      List<String> allSkills,
      Set<String> selectedSkills,
      FactoryStatus? selectedStatus,
      String searchTerm,
      FactorySearchCriteria currentFilter});

  @override
  $FactorySearchCriteriaCopyWith<$Res> get currentFilter;
}

/// @nodoc
class __$$ForgeStateImplCopyWithImpl<$Res>
    extends _$ForgeStateCopyWithImpl<$Res, _$ForgeStateImpl>
    implements _$$ForgeStateImplCopyWith<$Res> {
  __$$ForgeStateImplCopyWithImpl(
      _$ForgeStateImpl _value, $Res Function(_$ForgeStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ForgeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showGenerateFactoryModal = null,
    Object? pageSize = null,
    Object? currentOffset = null,
    Object? allFactories = null,
    Object? hasMoreFactories = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? showFilters = null,
    Object? allSkills = null,
    Object? selectedSkills = null,
    Object? selectedStatus = freezed,
    Object? searchTerm = null,
    Object? currentFilter = null,
  }) {
    return _then(_$ForgeStateImpl(
      showGenerateFactoryModal: null == showGenerateFactoryModal
          ? _value.showGenerateFactoryModal
          : showGenerateFactoryModal // ignore: cast_nullable_to_non_nullable
              as bool,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      currentOffset: null == currentOffset
          ? _value.currentOffset
          : currentOffset // ignore: cast_nullable_to_non_nullable
              as int,
      allFactories: null == allFactories
          ? _value._allFactories
          : allFactories // ignore: cast_nullable_to_non_nullable
              as List<Factory>,
      hasMoreFactories: null == hasMoreFactories
          ? _value.hasMoreFactories
          : hasMoreFactories // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      showFilters: null == showFilters
          ? _value.showFilters
          : showFilters // ignore: cast_nullable_to_non_nullable
              as bool,
      allSkills: null == allSkills
          ? _value._allSkills
          : allSkills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedSkills: null == selectedSkills
          ? _value._selectedSkills
          : selectedSkills // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      selectedStatus: freezed == selectedStatus
          ? _value.selectedStatus
          : selectedStatus // ignore: cast_nullable_to_non_nullable
              as FactoryStatus?,
      searchTerm: null == searchTerm
          ? _value.searchTerm
          : searchTerm // ignore: cast_nullable_to_non_nullable
              as String,
      currentFilter: null == currentFilter
          ? _value.currentFilter
          : currentFilter // ignore: cast_nullable_to_non_nullable
              as FactorySearchCriteria,
    ));
  }
}

/// @nodoc

class _$ForgeStateImpl extends _ForgeState {
  const _$ForgeStateImpl(
      {this.showGenerateFactoryModal = false,
      this.pageSize = 20,
      this.currentOffset = 0,
      final List<Factory> allFactories = const [],
      this.hasMoreFactories = false,
      this.isLoading = false,
      this.isLoadingMore = false,
      this.showFilters = false,
      final List<String> allSkills = const [],
      final Set<String> selectedSkills = const {},
      this.selectedStatus,
      this.searchTerm = '',
      this.currentFilter = const FactorySearchCriteria()})
      : _allFactories = allFactories,
        _allSkills = allSkills,
        _selectedSkills = selectedSkills,
        super._();

  @override
  @JsonKey()
  final bool showGenerateFactoryModal;
  @override
  @JsonKey()
  final int pageSize;
  @override
  @JsonKey()
  final int currentOffset;
  final List<Factory> _allFactories;
  @override
  @JsonKey()
  List<Factory> get allFactories {
    if (_allFactories is EqualUnmodifiableListView) return _allFactories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allFactories);
  }

  @override
  @JsonKey()
  final bool hasMoreFactories;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final bool showFilters;
  final List<String> _allSkills;
  @override
  @JsonKey()
  List<String> get allSkills {
    if (_allSkills is EqualUnmodifiableListView) return _allSkills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allSkills);
  }

  final Set<String> _selectedSkills;
  @override
  @JsonKey()
  Set<String> get selectedSkills {
    if (_selectedSkills is EqualUnmodifiableSetView) return _selectedSkills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedSkills);
  }

  @override
  final FactoryStatus? selectedStatus;
  @override
  @JsonKey()
  final String searchTerm;
  @override
  @JsonKey()
  final FactorySearchCriteria currentFilter;

  @override
  String toString() {
    return 'ForgeState(showGenerateFactoryModal: $showGenerateFactoryModal, pageSize: $pageSize, currentOffset: $currentOffset, allFactories: $allFactories, hasMoreFactories: $hasMoreFactories, isLoading: $isLoading, isLoadingMore: $isLoadingMore, showFilters: $showFilters, allSkills: $allSkills, selectedSkills: $selectedSkills, selectedStatus: $selectedStatus, searchTerm: $searchTerm, currentFilter: $currentFilter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgeStateImpl &&
            (identical(
                    other.showGenerateFactoryModal, showGenerateFactoryModal) ||
                other.showGenerateFactoryModal == showGenerateFactoryModal) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.currentOffset, currentOffset) ||
                other.currentOffset == currentOffset) &&
            const DeepCollectionEquality()
                .equals(other._allFactories, _allFactories) &&
            (identical(other.hasMoreFactories, hasMoreFactories) ||
                other.hasMoreFactories == hasMoreFactories) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.showFilters, showFilters) ||
                other.showFilters == showFilters) &&
            const DeepCollectionEquality()
                .equals(other._allSkills, _allSkills) &&
            const DeepCollectionEquality()
                .equals(other._selectedSkills, _selectedSkills) &&
            (identical(other.selectedStatus, selectedStatus) ||
                other.selectedStatus == selectedStatus) &&
            (identical(other.searchTerm, searchTerm) ||
                other.searchTerm == searchTerm) &&
            (identical(other.currentFilter, currentFilter) ||
                other.currentFilter == currentFilter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      showGenerateFactoryModal,
      pageSize,
      currentOffset,
      const DeepCollectionEquality().hash(_allFactories),
      hasMoreFactories,
      isLoading,
      isLoadingMore,
      showFilters,
      const DeepCollectionEquality().hash(_allSkills),
      const DeepCollectionEquality().hash(_selectedSkills),
      selectedStatus,
      searchTerm,
      currentFilter);

  /// Create a copy of ForgeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgeStateImplCopyWith<_$ForgeStateImpl> get copyWith =>
      __$$ForgeStateImplCopyWithImpl<_$ForgeStateImpl>(this, _$identity);
}

abstract class _ForgeState extends ForgeState {
  const factory _ForgeState(
      {final bool showGenerateFactoryModal,
      final int pageSize,
      final int currentOffset,
      final List<Factory> allFactories,
      final bool hasMoreFactories,
      final bool isLoading,
      final bool isLoadingMore,
      final bool showFilters,
      final List<String> allSkills,
      final Set<String> selectedSkills,
      final FactoryStatus? selectedStatus,
      final String searchTerm,
      final FactorySearchCriteria currentFilter}) = _$ForgeStateImpl;
  const _ForgeState._() : super._();

  @override
  bool get showGenerateFactoryModal;
  @override
  int get pageSize;
  @override
  int get currentOffset;
  @override
  List<Factory> get allFactories;
  @override
  bool get hasMoreFactories;
  @override
  bool get isLoading;
  @override
  bool get isLoadingMore;
  @override
  bool get showFilters;
  @override
  List<String> get allSkills;
  @override
  Set<String> get selectedSkills;
  @override
  FactoryStatus? get selectedStatus;
  @override
  String get searchTerm;
  @override
  FactorySearchCriteria get currentFilter;

  /// Create a copy of ForgeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgeStateImplCopyWith<_$ForgeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
