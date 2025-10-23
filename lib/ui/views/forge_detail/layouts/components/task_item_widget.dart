import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/domain/models/factory/factory_app.dart';
import 'package:clones_desktop/domain/models/factory/factory_task.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/task_actions_widget.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/task_limits_widget.dart';
import 'package:flutter/material.dart';

class TaskItemWidget extends StatelessWidget {
  const TaskItemWidget({
    super.key,
    required this.task,
    required this.app,
    required this.appIdx,
    required this.taskIdx,
    required this.factory,
  });
  final FactoryTask task;
  final FactoryApp app;
  final int appIdx;
  final int taskIdx;
  final Factory factory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CardWidget(
        padding: CardPadding.small,
        variant: CardVariant.secondary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.prompt,
                  style: theme.textTheme.bodyMedium,
                ),
                TaskLimitsWidget(
                  factory: factory,
                  task: task,
                  factoryToken: factory.token,
                ),
              ],
            ),
            TaskActionsWidget(
              task: task,
              app: app,
              appIdx: appIdx,
              taskIdx: taskIdx,
              forgeId: factory.id,
            ),
          ],
        ),
      ),
    );
  }
}
