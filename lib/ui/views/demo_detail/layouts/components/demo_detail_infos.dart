import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/message_box/message_box.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DemoDetailInfos extends ConsumerStatefulWidget {
  const DemoDetailInfos({super.key});

  @override
  ConsumerState<DemoDetailInfos> createState() => _DemoDetailInfosState();
}

class _DemoDetailInfosState extends ConsumerState<DemoDetailInfos> {
  bool _isInfoGridExpanded = false;

  @override
  Widget build(BuildContext context) {
    final demoDetail = ref.watch(demoDetailNotifierProvider);
    final recording = demoDetail.recording;

    if (recording == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    return CardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            recording.title,
                            style: theme.textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isInfoGridExpanded = !_isInfoGridExpanded;
                            });
                          },
                          icon: Icon(
                            _isInfoGridExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                          ),
                        ),
                      ],
                    ),
                    if (_isInfoGridExpanded) ...[
                      const SizedBox(height: 8),
                      _buildInfoGrid(context, ref),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (demoDetail.uploadError != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: MessageBox(
                messageBoxType: MessageBoxType.warning,
                content: Text(
                  'Upload Error: ${demoDetail.uploadError}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
          if (demoDetail.exportPath != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: MessageBox(
                messageBoxType: MessageBoxType.success,
                content: Text(
                  'Zip successfully exported: ${demoDetail.exportPath}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
          if (demoDetail.exportError != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: MessageBox(
                messageBoxType: MessageBoxType.warning,
                content: Text(
                  'Export Error: ${demoDetail.exportError}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(BuildContext context, WidgetRef ref) {
    final demoDetail = ref.watch(demoDetailNotifierProvider);
    final recording = demoDetail.recording;

    if (recording == null) {
      return const SizedBox.shrink();
    }

    final submittedAt = DateTime.parse(recording.timestamp);
    final formattedDate = DateFormat.yMd().add_jm().format(submittedAt);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('ID: ', recording.id, context),
              const SizedBox(height: 4),
              _buildInfoRow(
                'OS: ',
                '${recording.platform} ${recording.version} (${recording.arch})',
                context,
              ),
              const SizedBox(height: 4),
              _buildInfoRow('Locale: ', recording.locale, context),
              if (recording.demonstration != null) ...[
                const SizedBox(height: 4),
                _buildInfoRow('App: ', recording.demonstration!.app, context),
              ],
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Submitted: ', formattedDate, context),
              const SizedBox(height: 4),
              _buildInfoRow(
                'Resolution: ',
                '${recording.primaryMonitor.width}x${recording.primaryMonitor.height}',
                context,
              ),
              if (recording.keyboardLayout != null) ...[
                const SizedBox(height: 4),
                _buildInfoRow(
                  'Keyboard: ',
                  recording.keyboardLayout!,
                  context,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: recording.demonstration != null &&
                  recording.demonstration!.objectives.isNotEmpty
              ? _buildObjectivesSection(
                  context,
                  recording.demonstration!.objectives,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildObjectivesSection(
    BuildContext context,
    List<String> objectives,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Objectives:',
          style:
              theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        ...objectives.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final objective = entry.value;
          // Remove HTML tags if present (like <app> tags in the objectives)
          final cleanObjective = objective.replaceAll(RegExp('<[^>]*>'), '');
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$index. ',
                  style: theme.textTheme.bodySmall,
                ),
                Expanded(
                  child: Text(
                    cleanObjective,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: Text(
            label,
            style: theme.textTheme.bodySmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(value, style: theme.textTheme.bodySmall),
        ),
      ],
    );
  }
}
