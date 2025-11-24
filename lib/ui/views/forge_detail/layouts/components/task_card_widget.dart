import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/domain/models/factory/workflow_task.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/task_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskCardWidget extends ConsumerWidget {
  const TaskCardWidget({
    super.key,
    required this.task,
    required this.taskIdx,
    required this.factory,
  });
  final WorkflowTask task;
  final int taskIdx;
  final Factory factory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final orderedCategories = task.categories.toSet().toList()
      ..sort((a, b) => a.compareTo(b));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CardWidget(
        padding: CardPadding.small,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Task header with categories
              if (task.categories.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: orderedCategories
                      .map(
                        (category) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: ClonesColors.primary.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            category,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              // Task details
              TaskItemWidget(
                task: task,
                taskIdx: taskIdx,
                factory: factory,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
