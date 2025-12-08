import 'package:auto_size_text/auto_size_text.dart';
import 'package:clones_desktop/application/apps.dart';
import 'package:clones_desktop/application/settings.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory_settings.dart';
import 'package:clones_desktop/domain/models/factory/workflow_task.dart';
import 'package:clones_desktop/domain/models/ui/factory_filter.dart';
import 'package:clones_desktop/ui/views/factory/layouts/components/filter_panel.dart';
import 'package:clones_desktop/ui/views/factory/layouts/components/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AvailableTasks extends ConsumerStatefulWidget {
  const AvailableTasks({
    super.key,
    this.poolId,
  });
  final String? poolId;
  @override
  ConsumerState<AvailableTasks> createState() => _AvailableTasksState();
}

class _AvailableTasksState extends ConsumerState<AvailableTasks>
    with AutomaticKeepAliveClientMixin {
  late FactoryFilter _filter;
  List<String> _allCategories = [];
  final Set<String> _selectedCategories = {};
  String _sort = 'htl';
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showFilters = false;
  String _currencyMode = 'crypto';

  List<WorkflowTask>? _cachedTasks;
  List<WorkflowTask>? _cachedSortedTasks;
  String? _cachedSort;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _filter = FactoryFilter(poolId: widget.poolId);
    _fetchCategories();
    _initSettings();
  }

  Future<void> _initSettings() async {
    final settings = await ref.read(factorySettingsNotifierProvider.future);
    _minPriceController.text = settings.minPrice.toString();
    _maxPriceController.text = settings.maxPrice.toString();
  }

  Future<void> _fetchCategories() async {
    final categories = await ref.read(getFactoryCategoriesProvider.future);
    setState(() {
      _allCategories = categories;
    });
  }

  void _applyFilters() {
    final settings = ref.read(factorySettingsNotifierProvider).value ??
        const FactorySettings();

    setState(() {
      _filter = FactoryFilter(
        poolId: widget.poolId,
        query:
            _searchController.text.isNotEmpty ? _searchController.text : null,
        categories: _selectedCategories.isNotEmpty
            ? _selectedCategories.toList()
            : null,
        hideAdult: settings.hideAdult,
      );
    });
  }

  double _getReward(WorkflowTask task) {
    return task.rewardLimit?.toDouble() ?? 0.0;
  }

  List<WorkflowTask> _getSortedTasks(List<WorkflowTask> tasks) {
    // Return cached sorted tasks if data hasn't changed
    if (identical(_cachedTasks, tasks) &&
        _cachedSort == _sort &&
        _cachedSortedTasks != null) {
      return _cachedSortedTasks!;
    }

    // Create new sorted list
    final sortedTasks = List<WorkflowTask>.from(tasks)
      ..sort((a, b) {
        final rewardA = _getReward(a);
        final rewardB = _getReward(b);
        return _sort == 'htl'
            ? rewardB.compareTo(rewardA)
            : rewardA.compareTo(rewardB);
      });

    // Cache the results
    _cachedTasks = tasks;
    _cachedSort = _sort;
    _cachedSortedTasks = sortedTasks;

    return sortedTasks;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tasksAsync = ref.watch(
      getTasksForFactoryProvider(filter: _filter),
    );
    final factorySettings =
        ref.watch(factorySettingsNotifierProvider).valueOrNull ??
            const FactorySettings();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AutoSizeText(
                'Your journey starts here: choose a task and record your demo.',
                maxLines: 2,
                textAlign: TextAlign.center,
                minFontSize: 14,
                style: theme.textTheme.titleLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildHeader(tasksAsync),
        if (_showFilters)
          FilterPanel(
            settings: factorySettings,
            searchController: _searchController,
            onSortChanged: (value) {
              if (value != null) {
                setState(() {
                  _sort = value;
                });
              }
            },
            allCategories: _allCategories,
            selectedCategories: _selectedCategories,
            onCategorySelected: (category, selected) {
              setState(() {
                if (selected) {
                  _selectedCategories.add(category);
                } else {
                  _selectedCategories.remove(category);
                }
              });
              _applyFilters();
            },
            onSelectAllCategories: () {
              setState(_selectedCategories.clear);
              _applyFilters();
            },
            onApplyFilters: () {
              final newSettings = factorySettings.copyWith(
                minPrice: int.tryParse(_minPriceController.text) ??
                    factorySettings.minPrice,
                maxPrice: int.tryParse(_maxPriceController.text) ??
                    factorySettings.maxPrice,
              );
              ref
                  .read(factorySettingsNotifierProvider.notifier)
                  .saveFactorySettings(newSettings);
              _applyFilters();
            },
            onResetFilters: () {
              _searchController.clear();
              _selectedCategories.clear();
              setState(() {
                _sort = 'htl';
              });
              ref
                  .read(factorySettingsNotifierProvider.notifier)
                  .saveFactorySettings(
                    const FactorySettings(),
                  );
              _applyFilters();
            },
          ),
        Expanded(
          child: _buildTasksList(tasksAsync),
        ),
      ],
    );
  }

  Widget _buildTasksList(AsyncValue<List<WorkflowTask>> tasksAsync) {
    final tasks = tasksAsync.valueOrNull;

    if (tasksAsync.isLoading && tasks == null) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 0.5),
      );
    }

    if (tasksAsync.hasError && tasks == null) {
      return Center(child: Text('Error: ${tasksAsync.error}'));
    }

    if (tasks == null || tasks.isEmpty) {
      return const Center(child: Text('No tasks found.'));
    }

    final sortedTasks = _getSortedTasks(tasks);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: sortedTasks.length,
      itemBuilder: (context, index) {
        final task = sortedTasks[index];
        return TaskCard(
          key: ValueKey(task.id),
          task: task,
          currencyMode: _currencyMode,
        );
      },
    );
  }

  Widget _buildHeader(AsyncValue<List<WorkflowTask>> tasksAsync) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Available Tasks',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ClonesColors.secondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${tasksAsync.asData?.value.length ?? 0} Available',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
                icon: Icon(
                  _showFilters ? Icons.keyboard_arrow_up : Icons.filter_list,
                  color: ClonesColors.secondary,
                ),
                label: Text(
                  'Filters',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: ClonesColors.secondary,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Crypto',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _currencyMode == 'crypto'
                          ? ClonesColors.secondary
                          : ClonesColors.secondary.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: _currencyMode == 'fiat',
                      onChanged: (bool value) {
                        setState(() {
                          _currencyMode = value ? 'fiat' : 'crypto';
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeThumbColor: ClonesColors.secondary,
                      inactiveThumbColor:
                          ClonesColors.secondary.withValues(alpha: 0.6),
                      inactiveTrackColor:
                          ClonesColors.secondary.withValues(alpha: 0.2),
                      activeTrackColor:
                          ClonesColors.secondary.withValues(alpha: 0.4),
                      trackOutlineColor:
                          WidgetStateProperty.all(Colors.transparent),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Fiat',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _currencyMode == 'fiat'
                          ? ClonesColors.secondary
                          : ClonesColors.secondary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
