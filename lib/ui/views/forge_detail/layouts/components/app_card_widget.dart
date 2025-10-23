import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/domain/models/factory/factory_app.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/add_task_button_widget.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/app_header_widget.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/task_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppCardWidget extends ConsumerWidget {
  const AppCardWidget({
    super.key,
    required this.app,
    required this.appIdx,
    required this.factory,
  });
  final FactoryApp app;
  final int appIdx;
  final Factory factory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return CardWidget(
      padding: CardPadding.small,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App header (icon, name, domain, delete button)
            AppHeaderWidget(
              app: app,
              appIdx: appIdx,
            ),
            // App description
            if (app.description != null && app.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  app.description!,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            const SizedBox(height: 20),
            // Tasks section
            if (app.tasks.isEmpty)
              Text(
                'No tasks for this app.',
                style: theme.textTheme.bodyMedium,
              )
            else
              // Tasks list
              ...List.generate(
                app.tasks.length,
                (taskIdx) {
                  final task = app.tasks[taskIdx];
                  return TaskItemWidget(
                    task: task,
                    app: app,
                    appIdx: appIdx,
                    taskIdx: taskIdx,
                    factory: factory,
                  );
                },
              ),
            const SizedBox(height: 10),
            // Add task button
            AddTaskButtonWidget(appIdx: appIdx),
          ],
        ),
      ),
    );
  }
}
