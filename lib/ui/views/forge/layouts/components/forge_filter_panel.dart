import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgeFilterPanel extends ConsumerWidget {
  const ForgeFilterPanel({
    super.key,
    required this.searchController,
    required this.allSkills,
    required this.selectedSkills,
    required this.selectedStatus,
    required this.onSkillSelected,
    required this.onSelectAllSkills,
    required this.onStatusChanged,
    required this.onApplyFilters,
    required this.onResetFilters,
  });

  final TextEditingController searchController;
  final List<String> allSkills;
  final Set<String> selectedSkills;
  final FactoryStatus? selectedStatus;
  final Function(String, bool) onSkillSelected;
  final VoidCallback onSelectAllSkills;
  final ValueChanged<FactoryStatus?> onStatusChanged;
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
                      'Search factories',
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
                          hintText: 'Search by name or description...',
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
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
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
                      child: DropdownButtonFormField<FactoryStatus?>(
                        initialValue: selectedStatus,
                        onChanged: onStatusChanged,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                        ),
                        style: theme.textTheme.bodyMedium,
                        dropdownColor: Colors.black.withValues(alpha: 0.9),
                        items: [
                          DropdownMenuItem<FactoryStatus?>(
                            child: Text(
                              'All statuses',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          ...FactoryStatus.values.map(
                            (status) => DropdownMenuItem<FactoryStatus?>(
                              value: status,
                              child: Text(
                                _getStatusDisplayName(status),
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
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

  String _getStatusDisplayName(FactoryStatus status) {
    switch (status) {
      case FactoryStatus.active:
        return 'Active';
      case FactoryStatus.paused:
        return 'Paused';
      case FactoryStatus.error:
        return 'Error';
      case FactoryStatus.noFunds:
        return 'No Funds';
      case FactoryStatus.archived:
        return 'Archived';
    }
  }
}
