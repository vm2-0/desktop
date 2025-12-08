import 'package:clones_desktop/ui/views/factory/layouts/available_tasks.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/state.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/forge_factory_header.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/task_card_widget.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/tasks_view_mode_buttons_widget.dart';
import 'package:clones_desktop/ui/views/manage_task/bloc/state.dart';
import 'package:clones_desktop/ui/views/manage_task/layouts/manage_task_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgeFactoryTasksTab extends ConsumerStatefulWidget {
  const ForgeFactoryTasksTab({
    super.key,
  });

  @override
  ConsumerState<ForgeFactoryTasksTab> createState() =>
      _ForgeFactoryTasksTabState();
}

class _ForgeFactoryTasksTabState extends ConsumerState<ForgeFactoryTasksTab> {
  @override
  Widget build(BuildContext context) {
    final forgeDetail = ref.watch(forgeDetailNotifierProvider);
    final theme = Theme.of(context);
    if (forgeDetail.factory == null) return const SizedBox.shrink();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ForgeFactoryHeader(),
              Row(
                children: [
                  Text(
                    '2. Tasks',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TasksViewModeButtonsWidget(),
                    // TODO(reddwarf03): Add regenerate tasks and new app button if needed
                  ],
                ),
              ),
              // NewAppForm removed - no longer needed in tasks-first architecture
              if (forgeDetail.viewModeTasks == ViewModeTasks.preview)
                Expanded(
                  child: AvailableTasks(
                    poolId: forgeDetail.factory!.id,
                  ),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      if (forgeDetail.factory!.tasks.isEmpty)
                        Center(
                          child: Text(
                            'No tasks available.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: forgeDetail.factory!.tasks.length,
                            itemBuilder: (context, taskIdx) {
                              final task = forgeDetail.factory!.tasks[taskIdx];
                              return TaskCardWidget(
                                task: task,
                                taskIdx: taskIdx,
                                factory: forgeDetail.factory!,
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (forgeDetail.showManageTaskModal)
          ManageTaskModal(
            tokenSymbol: forgeDetail.factory!.token?.symbol ?? '',
            modalType: forgeDetail.manageTaskModalType,
            task: forgeDetail.manageTaskModalType == ManageTaskModalType.create
                ? null
                : forgeDetail.factory!.tasks[forgeDetail.editingTaskIdx!],
            factory: forgeDetail.factory,
            onClose: () {
              ref
                  .read(forgeDetailNotifierProvider.notifier)
                  .setShowManageTaskModal(false);
            },
            onDone: (task) {
              if (task != null) {
                if (forgeDetail.manageTaskModalType ==
                    ManageTaskModalType.create) {
                  ref
                      .read(forgeDetailNotifierProvider.notifier)
                      .createTask(task);
                } else {
                  ref.read(forgeDetailNotifierProvider.notifier).updateTask(
                        forgeDetail.editingTaskIdx!,
                        task,
                      );
                }
                ref
                    .read(forgeDetailNotifierProvider.notifier)
                    .setShowManageTaskModal(false);
              }
            },
          ),
      ],
    );
  }
}
