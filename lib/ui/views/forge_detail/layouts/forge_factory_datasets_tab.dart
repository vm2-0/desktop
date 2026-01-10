import 'package:clones_desktop/application/datasets.dart';
import 'package:clones_desktop/application/submissions.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/dataset/dataset.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/views/create_dataset/bloc/provider.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/forge_factory_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ForgeFactoryDatasetsTab extends ConsumerWidget {
  const ForgeFactoryDatasetsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final factory = ref.watch(forgeDetailNotifierProvider).factory;
    if (factory == null) return const SizedBox.shrink();

    final datasetsAsync = ref.watch(getFactoryDatasetsProvider(factory.id));

    return datasetsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(strokeWidth: 0.5),
      ),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (datasets) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const ForgeFactoryHeader(),
              _PageHeader(factoryId: factory.id),
              const SizedBox(height: 24),
              if (datasets.isEmpty)
                _EmptyState()
              else
                _DatasetsTable(datasets: datasets),
            ],
          ),
        );
      },
    );
  }
}

class _PageHeader extends ConsumerWidget {
  const _PageHeader({required this.factoryId});
  final String factoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final submissionsAsync = ref.watch(getFactorySubmissionsProvider(factoryId));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '4. Datasets',
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
        submissionsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (submissions) {
            if (submissions.isEmpty) return const SizedBox.shrink();

            return BtnPrimary(
              onTap: () {
                // Get all completed demo hashes from submission IDs
                final completedDemoIds = submissions
                    .where((s) => s.status.toLowerCase() == 'completed')
                    .map((s) => s.id)
                    .toList();

                ref.read(createDatasetNotifierProvider.notifier).setFactoryContext(
                      factoryId: factoryId,
                      demoHashes: completedDemoIds,
                    );
              },
              buttonText: 'Create Dataset',
              icon: Icons.add,
            );
          },
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.dataset_outlined,
              size: 64,
              color: ClonesColors.secondaryText.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No datasets yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: ClonesColors.secondaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first dataset from factory demonstrations',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ClonesColors.secondaryText.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DatasetsTable extends StatelessWidget {
  const _DatasetsTable({required this.datasets});
  final List<Dataset> datasets;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CardWidget(
      padding: CardPadding.none,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: false,
                dividerThickness: 0,
                headingRowColor: WidgetStateProperty.all(
                  ClonesColors.tertiary.withValues(alpha: 0.1),
                ),
                columns: [
                  DataColumn(
                    label: Text('Name', style: theme.textTheme.titleSmall),
                  ),
                  DataColumn(
                    label: Text('Symbol', style: theme.textTheme.titleSmall),
                  ),
                  DataColumn(
                    label: Text('Demos', style: theme.textTheme.titleSmall),
                  ),
                  DataColumn(
                    label: Text('Quality', style: theme.textTheme.titleSmall),
                  ),
                  DataColumn(
                    label: Text('Phase', style: theme.textTheme.titleSmall),
                  ),
                  DataColumn(
                    label: Text('Created', style: theme.textTheme.titleSmall),
                  ),
                ],
                rows: datasets
                    .map(
                      (dataset) => _buildDataRow(dataset, context, theme),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(
    Dataset dataset,
    BuildContext context,
    ThemeData theme,
  ) {
    return DataRow(
      onSelectChanged: (_) {
        // TODO(datasets): Navigate to dataset detail
      },
      color: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return ClonesColors.tertiary.withValues(alpha: 0.05);
          }
          return null;
        },
      ),
      cells: [
        DataCell(
          Text(
            dataset.name,
            style: theme.textTheme.bodySmall,
          ),
        ),
        DataCell(
          Text(
            dataset.symbol,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              color: ClonesColors.tertiary,
            ),
          ),
        ),
        DataCell(
          Text(
            dataset.demonstrationCount.toString(),
            style: theme.textTheme.bodySmall,
          ),
        ),
        DataCell(_QualityCell(dataset: dataset)),
        DataCell(_PhaseCell(dataset: dataset)),
        DataCell(
          Text(
            DateFormat('MMM d, y').format(dataset.createdAt),
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _QualityCell extends StatelessWidget {
  const _QualityCell({required this.dataset});
  final Dataset dataset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = dataset.qualityScore;

    if (score == null) return const Text('-');

    return Text(
      '${score.toStringAsFixed(1)}%',
      style: theme.textTheme.bodySmall?.copyWith(
        color: ClonesColors.getScoreColor(score.round()),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _PhaseCell extends StatelessWidget {
  const _PhaseCell({required this.dataset});
  final Dataset dataset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color color;
    String label;

    switch (dataset.phase) {
      case DatasetPhase.draft:
        color = Colors.grey;
        label = 'Draft';
        break;
      case DatasetPhase.bonding:
        color = Colors.orange;
        label = 'Bonding';
        break;
      case DatasetPhase.graduated:
        color = Colors.green;
        label = 'Graduated';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
