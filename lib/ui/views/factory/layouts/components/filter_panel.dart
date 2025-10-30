import 'package:clones_desktop/application/settings.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory_settings.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterPanel extends ConsumerWidget {
  const FilterPanel({
    super.key,
    required this.settings,
    required this.searchController,
    required this.onSortChanged,
    required this.allCategories,
    required this.selectedCategories,
    required this.onCategorySelected,
    required this.onSelectAllCategories,
    required this.onApplyFilters,
    required this.onResetFilters,
  });

  final FactorySettings settings;
  final TextEditingController searchController;
  final ValueChanged<String?> onSortChanged;
  final List<String> allCategories;
  final Set<String> selectedCategories;
  final Function(String, bool) onCategorySelected;
  final VoidCallback onSelectAllCategories;
  final VoidCallback onApplyFilters;
  final VoidCallback onResetFilters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search tasks',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 6),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: theme.colorScheme.primaryContainer,
                          width: 0.5,
                        ),
                        gradient: ClonesColors.gradientInputFormBackground,
                      ),
                      child: TextField(
                        controller: searchController,
                        onSubmitted: (_) => onApplyFilters(),
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                          hintStyle:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color!
                                        .withValues(alpha: 0.2),
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Categories',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: selectedCategories.isEmpty
                        ? ClonesColors.tertiary
                        : ClonesColors.tertiary,
                    width: 0.1,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  backgroundColor: selectedCategories.isEmpty
                      ? ClonesColors.tertiary
                      : Colors.transparent,
                ),
                onPressed: onSelectAllCategories,
                child: Text(
                  'All',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              ...allCategories.map(
                (category) => OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: selectedCategories.contains(category)
                          ? ClonesColors.primary
                          : ClonesColors.tertiary,
                      width: 0.1,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    backgroundColor: selectedCategories.contains(category)
                        ? ClonesColors.tertiary
                        : Colors.transparent,
                  ),
                  onPressed: () => onCategorySelected(
                    category,
                    !selectedCategories.contains(category),
                  ),
                  child: Text(
                    category,
                    style: selectedCategories.contains(category)
                        ? Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ClonesColors.primaryText,
                            )
                        : Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                checkColor: ClonesColors.primaryText,
                value: !settings.hideAdult,
                onChanged: (value) {
                  ref
                      .read(factorySettingsNotifierProvider.notifier)
                      .saveFactorySettings(
                        settings.copyWith(hideAdult: !(value ?? false)),
                      );
                },
              ),
              Text(
                'Show adult content',
                style: theme.textTheme.titleSmall,
              ),
              const Spacer(),
              BtnPrimary(
                buttonText: 'Reset Filters',
                btnPrimaryType: BtnPrimaryType.outlinePrimary,
                onTap: onResetFilters,
              ),
              const SizedBox(width: 16),
              BtnPrimary(
                buttonText: 'Apply',
                onTap: onApplyFilters,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
