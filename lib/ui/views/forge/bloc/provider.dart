import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/domain/models/factory/factory_search_criteria.dart';
import 'package:clones_desktop/ui/views/forge/bloc/state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class ForgeNotifier extends _$ForgeNotifier {
  ForgeNotifier();

  @override
  ForgeState build() {
    return const ForgeState();
  }

  void setShowGenerateFactoryModal(bool show) {
    state = state.copyWith(showGenerateFactoryModal: show);
  }

  Future<void> loadFactories({bool loadMore = false}) async {
    final session = ref.read(sessionNotifierProvider);
    if (session.address == null) return;

    // Initialize default filter if not set
    if (state.currentFilter.creator == null) {
      final defaultCriteria = FactorySearchCriteria(
        creator: session.address,
        limit: state.pageSize,
      );

      state = state.copyWith(currentFilter: defaultCriteria);
    }

    await _loadFactoriesWithFilter(loadMore: loadMore);
  }

  Future<void> loadMoreFactories() async {
    if (state.hasMoreFactories && !state.isLoadingMore) {
      await loadFactories(loadMore: true);
    }
  }

  void setShowFilters(bool show) {
    state = state.copyWith(showFilters: show);
  }

  void setSearchTerm(String term) {
    state = state.copyWith(searchTerm: term);
  }

  void setSelectedStatus(FactoryStatus? status) {
    state = state.copyWith(selectedStatus: status);
  }

  void onSkillSelected(String skill, bool selected) {
    final newSelected = Set<String>.from(state.selectedSkills);
    if (selected) {
      newSelected.add(skill);
    } else {
      newSelected.remove(skill);
    }
    state = state.copyWith(selectedSkills: newSelected);
  }

  void selectAllSkills() {
    state = state.copyWith(selectedSkills: {});
  }

  void applyFilters() {
    final session = ref.read(sessionNotifierProvider);
    if (session.address == null) return;

    final criteria = FactorySearchCriteria(
      creator: session.address,
      searchTerm: state.searchTerm.isNotEmpty ? state.searchTerm : null,
      skills: state.selectedSkills.isNotEmpty
          ? state.selectedSkills.toList()
          : null,
      status: state.selectedStatus,
      limit: state.pageSize,
      offset: 0,
    );

    state = state.copyWith(
      currentFilter: criteria,
      currentOffset: 0,
      allFactories: [],
      hasMoreFactories: false,
      isLoading: false,
    );

    _loadFactoriesWithFilter();
  }

  void resetFilters() {
    state = state.copyWith(
      searchTerm: '',
      selectedSkills: {},
      selectedStatus: null,
    );
    applyFilters();
  }

  Future<void> _loadFactoriesWithFilter({bool loadMore = false}) async {
    if (state.isLoadingMore || (state.isLoading && !loadMore)) return;

    if (loadMore) {
      state = state.copyWith(isLoadingMore: true);
    } else {
      state = state.copyWith(isLoading: true);
    }

    try {
      final criteria = state.currentFilter.copyWith(
        offset: loadMore ? state.currentOffset : 0,
      );

      final result =
          await ref.read(searchFactoriesProvider(criteria: criteria).future);

      final newFactories = loadMore
          ? [...state.allFactories, ...result.factories]
          : result.factories;

      state = state.copyWith(
        allFactories: newFactories,
        currentOffset:
            (loadMore ? state.currentOffset : 0) + result.factories.length,
        hasMoreFactories: result.hasMore,
        isLoading: false,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
      );
      rethrow;
    }
  }
}
