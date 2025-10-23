import 'package:clones_desktop/application/submissions.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/submission/pool_submission.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/demo_detail_view.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/forge_factory_header.dart';
import 'package:clones_desktop/utils/format_num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ForgeFactoryDemonstrationsTab extends ConsumerWidget {
  const ForgeFactoryDemonstrationsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final factory = ref.watch(forgeDetailNotifierProvider).factory;
    if (factory == null) return const SizedBox.shrink();

    final submissionsAsync =
        ref.watch(getFactorySubmissionsProvider(factory.id));

    return submissionsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          strokeWidth: 0.5,
        ),
      ),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (submissions) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const ForgeFactoryHeader(),
              _PageHeader(submissions: submissions),
              const SizedBox(height: 24),
              _UploadsTable(submissions: submissions),
            ],
          ),
        );
      },
    );
  }
}

class _PageHeader extends ConsumerWidget {
  const _PageHeader({required this.submissions});
  final List<PoolSubmission> submissions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '3. Demonstrations',
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}

class _UploadsTable extends ConsumerWidget {
  const _UploadsTable({required this.submissions});
  final List<PoolSubmission> submissions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    label: Text('Platform', style: theme.textTheme.titleSmall),
                  ),
                  DataColumn(
                    label: Text('Task', style: theme.textTheme.titleSmall),
                  ),
                  DataColumn(
                    label: Text('Status', style: theme.textTheme.titleSmall),
                  ),
                  DataColumn(
                    label: Text('Duration', style: theme.textTheme.titleSmall),
                  ),
                  DataColumn(
                    label: Text('Size', style: theme.textTheme.titleSmall),
                  ),
                  DataColumn(
                    label: Text('Date', style: theme.textTheme.titleSmall),
                  ),
                  DataColumn(
                    label: Text('Quality', style: theme.textTheme.titleSmall),
                  ),
                  DataColumn(
                    label: Text('Reward', style: theme.textTheme.titleSmall),
                  ),
                  DataColumn(
                    label: Text('Actions', style: theme.textTheme.titleSmall),
                  ),
                ],
                rows: submissions
                    .map(
                      (submission) => _buildDataRow(
                        submission,
                        context,
                        ref,
                      ),
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
    PoolSubmission submission,
    BuildContext context,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);
    final factory = ref.watch(forgeDetailNotifierProvider).factory;

    return DataRow(
      onSelectChanged: (_) {
        context.push(
          DemoDetailView.routeName,
          extra: {
            'submissionId': submission.id,
            'metaId': submission.meta.id,
            'factoryAddress': factory?.id,
            'isFactorySubmission': true,
          },
        );
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
        DataCell(_PlatformCell(submission: submission)),
        DataCell(
          Text(
            _getTitle(submission),
            style: theme.textTheme.bodySmall,
          ),
        ),
        DataCell(_StatusCell(submission: submission)),
        DataCell(
          Text(
            _formatDuration(submission),
            style: theme.textTheme.bodySmall,
          ),
        ),
        DataCell(
          Text(
            _getTotalFileSize(submission),
            style: theme.textTheme.bodySmall,
          ),
        ),
        DataCell(
          Text(
            _formatDate(submission.createdAt),
            style: theme.textTheme.bodySmall,
          ),
        ),
        DataCell(_QualityCell(submission: submission)),
        DataCell(_RewardCell(submission: submission)),
        DataCell(
          Icon(
            Icons.visibility,
            size: 16,
            color: ClonesColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

String _formatDate(String dateStr) {
  try {
    final dt = DateTime.parse(dateStr);
    return DateFormat.yMMMd().format(dt);
  } catch (_) {
    return dateStr;
  }
}

String _getTitle(PoolSubmission submission) {
  if (submission.meta.demonstration.title.isNotEmpty) {
    return submission.meta.demonstration.title;
  } else if (submission.meta.demonstration.app.isNotEmpty) {
    return submission.meta.demonstration.app;
  }
  return 'Untitled Submission';
}

String _getTotalFileSize(PoolSubmission submission) {
  if (submission.files == null || submission.files!.isEmpty) {
    return '-';
  }
  final totalSize =
      submission.files!.fold<int>(0, (prev, file) => prev + file.size);

  return '${(totalSize / (1024 * 1024)).toStringAsFixed(2)} MB';
}

String _formatDuration(PoolSubmission submission) {
  final seconds = submission.meta.durationSeconds;
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;
  return minutes > 0
      ? '${minutes}m ${remainingSeconds}s'
      : '${remainingSeconds}s';
}

class _PlatformCell extends StatelessWidget {
  const _PlatformCell({required this.submission});
  final PoolSubmission submission;

  String _getOSName(PoolSubmission submission) {
    final platform = submission.meta.platform.toLowerCase();
    if (platform.contains('windows')) return 'Windows';
    if (platform.contains('mac') || platform.contains('darwin')) {
      return 'macOS';
    }
    if (platform.contains('linux')) return 'Linux';
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          _getOSName(submission),
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _StatusCell extends StatelessWidget {
  const _StatusCell({required this.submission});
  final PoolSubmission submission;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color textColor;

    switch (submission.status.toLowerCase()) {
      case 'completed':
        textColor = const Color(0xFF10b981);
        break;
      case 'failed':
        textColor = const Color(0xFFf87171);
        break;
      case 'pending':
        textColor = const Color(0xFFfacc15);
        break;
      case 'processing':
        textColor = const Color(0xFFfb923c);
        break;
      default:
        textColor = Colors.grey;
    }

    return Text(
      submission.status,
      style: theme.textTheme.bodySmall?.copyWith(
        color: textColor,
      ),
    );
  }
}

class _QualityCell extends StatelessWidget {
  const _QualityCell({required this.submission});
  final PoolSubmission submission;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = submission.gradeResult?.score;
    if (score == null) return const Text('-');

    Color color;
    if (score >= 50) {
      color = Colors.green;
    } else if (score >= 25) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Text(
      '${score.toStringAsFixed(0)}%',
      style: theme.textTheme.bodySmall?.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _RewardCell extends ConsumerWidget {
  const _RewardCell({required this.submission});
  final PoolSubmission submission;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final reward = submission.reward;

    if (reward != null && reward > 0) {
      final factory = ref.watch(forgeDetailNotifierProvider).factory;
      return Text(
        '${reward.toStringAsFixedLowValue(4, 5)} ${factory?.token.symbol}',
        style: theme.textTheme.bodySmall,
      );
    }
    return const SizedBox.shrink();
  }
}
