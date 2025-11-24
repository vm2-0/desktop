import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/domain/models/factory/factory_search_criteria.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class ForgeState with _$ForgeState {
  const factory ForgeState({
    @Default(false) bool showGenerateFactoryModal,
    @Default(20) int pageSize,
    @Default(0) int currentOffset,
    @Default([]) List<Factory> allFactories,
    @Default(false) bool hasMoreFactories,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool showFilters,
    @Default([]) List<String> allSkills,
    @Default({}) Set<String> selectedSkills,
    FactoryStatus? selectedStatus,
    @Default('') String searchTerm,
    @Default(FactorySearchCriteria()) FactorySearchCriteria currentFilter,
  }) = _ForgeState;
  const ForgeState._();
}
