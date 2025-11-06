import 'package:clones_desktop/infrastructure/subgraph.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for SubgraphRepository instance
final subgraphRepositoryProvider = Provider<SubgraphRepository>((ref) {
  // TODO(reddwarf03): Configure network based on app settings/environment
// Default to Sepolia for testing
  return SubgraphRepository();
});

/// Provider for factory overview statistics
final factoryOverviewProvider = FutureProvider<FactoryOverview>((ref) async {
  final repository = ref.read(subgraphRepositoryProvider);
  return repository.getFactoryOverview();
});

/// Provider for pool search with filters
final poolSearchProvider = StateNotifierProvider.family<PoolSearchNotifier,
    AsyncValue<List<PoolSearchResult>>, PoolSearchFilters>((ref, filters) {
  final repository = ref.read(subgraphRepositoryProvider);
  return PoolSearchNotifier(repository, filters);
});

/// Provider for user claim history
final userClaimHistoryProvider =
    FutureProvider.family<UserClaimHistory?, String>((ref, userAddress) async {
  final repository = ref.read(subgraphRepositoryProvider);
  return repository.getUserClaimHistory(userAddress);
});

/// Provider for creator pools management
final creatorPoolsProvider = FutureProvider.family<List<CreatorPool>, String>(
    (ref, creatorAddress) async {
  final repository = ref.read(subgraphRepositoryProvider);
  return repository.getCreatorPools(creatorAddress);
});

/// Provider for pool details
final poolDetailsProvider =
    FutureProvider.family<PoolDetails?, String>((ref, poolId) async {
  final repository = ref.read(subgraphRepositoryProvider);
  return repository.getPoolDetails(poolId);
});

/// Provider for token analytics
final tokenAnalyticsProvider =
    FutureProvider<List<TokenAnalytics>>((ref) async {
  final repository = ref.read(subgraphRepositoryProvider);
  return repository.getTokenAnalytics();
});

/// Provider for daily statistics with date range
final dailyStatsProvider =
    FutureProvider.family<List<DailyStats>, DateRange>((ref, dateRange) async {
  final repository = ref.read(subgraphRepositoryProvider);
  return repository.getDailyStats(
    startDate: dateRange.startDate,
    endDate: dateRange.endDate,
  );
});

/// Provider for subgraph health monitoring
final subgraphHealthProvider = FutureProvider<SubgraphHealth>((ref) async {
  final repository = ref.read(subgraphRepositoryProvider);
  return repository.checkHealth();
});

/// Provider for skills-based search
final skillsSearchProvider = StateNotifierProvider.family<SkillsSearchNotifier,
    AsyncValue<List<PoolMetadataResult>>, SkillsSearchFilters>((ref, filters) {
  final repository = ref.read(subgraphRepositoryProvider);
  return SkillsSearchNotifier(repository, filters);
});

// =====================================
// STATE NOTIFIERS
// =====================================

/// State notifier for pool search with dynamic filtering
class PoolSearchNotifier
    extends StateNotifier<AsyncValue<List<PoolSearchResult>>> {
  PoolSearchNotifier(this._repository, this._initialFilters)
      : super(const AsyncValue.loading()) {
    _search(_initialFilters);
  }
  final SubgraphRepository _repository;
  final PoolSearchFilters _initialFilters;

  Future<void> search(PoolSearchFilters filters) async {
    state = const AsyncValue.loading();
    await _search(filters);
  }

  Future<void> _search(PoolSearchFilters filters) async {
    try {
      final results = await _repository.searchPools(
        searchText: filters.searchText,
        tokenAddress: filters.tokenAddress,
        creatorAddress: filters.creatorAddress,
        minFunding: filters.minFunding,
        limit: filters.limit,
        skip: filters.skip,
      );
      state = AsyncValue.data(results);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is AsyncData<List<PoolSearchResult>>) {
      try {
        final moreResults = await _repository.searchPools(
          searchText: _initialFilters.searchText,
          tokenAddress: _initialFilters.tokenAddress,
          creatorAddress: _initialFilters.creatorAddress,
          minFunding: _initialFilters.minFunding,
          limit: _initialFilters.limit,
          skip: currentState.value.length,
        );

        if (moreResults.isNotEmpty) {
          state = AsyncValue.data([...currentState.value, ...moreResults]);
        }
      } catch (error, stackTrace) {
        // Keep current data, but could show loading indicator error
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }
}

/// State notifier for skills-based search
class SkillsSearchNotifier
    extends StateNotifier<AsyncValue<List<PoolMetadataResult>>> {
  SkillsSearchNotifier(this._repository, this._initialFilters)
      : super(const AsyncValue.loading()) {
    _search(_initialFilters);
  }
  final SubgraphRepository _repository;
  final SkillsSearchFilters _initialFilters;

  Future<void> search(SkillsSearchFilters filters) async {
    state = const AsyncValue.loading();
    await _search(filters);
  }

  Future<void> _search(SkillsSearchFilters filters) async {
    try {
      final results = await _repository.searchBySkills(
        skills: filters.skills,
        limit: filters.limit,
      );
      state = AsyncValue.data(results);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// =====================================
// FILTER MODELS
// =====================================

class PoolSearchFilters {
  const PoolSearchFilters({
    this.searchText,
    this.tokenAddress,
    this.creatorAddress,
    this.minFunding,
    this.limit = 25,
    this.skip = 0,
  });
  final String? searchText;
  final String? tokenAddress;
  final String? creatorAddress;
  final String? minFunding;
  final int limit;
  final int skip;

  PoolSearchFilters copyWith({
    String? searchText,
    String? tokenAddress,
    String? creatorAddress,
    String? minFunding,
    int? limit,
    int? skip,
  }) {
    return PoolSearchFilters(
      searchText: searchText ?? this.searchText,
      tokenAddress: tokenAddress ?? this.tokenAddress,
      creatorAddress: creatorAddress ?? this.creatorAddress,
      minFunding: minFunding ?? this.minFunding,
      limit: limit ?? this.limit,
      skip: skip ?? this.skip,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PoolSearchFilters &&
        other.searchText == searchText &&
        other.tokenAddress == tokenAddress &&
        other.creatorAddress == creatorAddress &&
        other.minFunding == minFunding &&
        other.limit == limit &&
        other.skip == skip;
  }

  @override
  int get hashCode {
    return searchText.hashCode ^
        tokenAddress.hashCode ^
        creatorAddress.hashCode ^
        minFunding.hashCode ^
        limit.hashCode ^
        skip.hashCode;
  }
}

class SkillsSearchFilters {
  const SkillsSearchFilters({
    required this.skills,
    this.limit = 20,
  });
  final List<String> skills;
  final int limit;

  SkillsSearchFilters copyWith({
    List<String>? skills,
    int? limit,
  }) {
    return SkillsSearchFilters(
      skills: skills ?? this.skills,
      limit: limit ?? this.limit,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SkillsSearchFilters &&
        listEquals(other.skills, skills) &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    return skills.hashCode ^ limit.hashCode;
  }
}

class DateRange {
  const DateRange({
    required this.startDate,
    required this.endDate,
  });

  factory DateRange.lastNDays(int days) {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));
    return DateRange(
      startDate: start.toIso8601String().split('T')[0],
      endDate: now.toIso8601String().split('T')[0],
    );
  }
  final String startDate;
  final String endDate;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DateRange &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode => startDate.hashCode ^ endDate.hashCode;
}

// Helper function for list equality (Flutter foundation doesn't include this by default)
bool listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (var index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) return false;
  }
  return true;
}
