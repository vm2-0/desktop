import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/domain/models/factory/workflow_task.dart';
import 'package:clones_desktop/ui/components/app_chip_widget.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/task_actions_widget.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/task_limits_widget.dart';
import 'package:flutter/material.dart';

class TaskItemWidget extends StatelessWidget {
  const TaskItemWidget({
    super.key,
    required this.task,
    required this.taskIdx,
    required this.factory,
  });
  final WorkflowTask task;
  final int taskIdx;
  final Factory factory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          CardWidget(
            padding: CardPadding.small,
            variant: CardVariant.secondary,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final promptWidth = constraints.maxWidth * 0.8;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: promptWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                task.prompt,
                                style: theme.textTheme.bodyMedium,
                              ),
                              if (task.appsUsed.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Apps to be used:',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: task.appsUsed
                                            .asMap()
                                            .entries
                                            .map(
                                              (entry) => AppChipWidget(
                                                appName: entry.value.name,
                                                domain: entry.value.domain,
                                                index: entry.key,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (factory.token != null) ...[
                          TaskLimitsWidget(
                            factory: factory,
                            task: task,
                            factoryToken: factory.token!,
                          ),
                        ],
                      ],
                    ),
                    TaskActionsWidget(
                      task: task,
                      taskIdx: taskIdx,
                      forgeId: factory.id,
                      factoryStatus: factory.status,
                    ),
                  ],
                );
              },
            ),
          ),
          if (task.id != null)
            Positioned(
              bottom: 3,
              right: 10,
              child: Opacity(
                opacity: 0.2,
                child: SelectableText(
                  '${task.id}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
