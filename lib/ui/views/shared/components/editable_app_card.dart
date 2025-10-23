import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/shared/components/app_input_field.dart';
import 'package:clones_desktop/ui/views/shared/components/task_input_field.dart';
import 'package:flutter/material.dart';

class EditableAppCard extends StatelessWidget {
  const EditableAppCard({
    super.key,
    required this.appName,
    required this.appDomain,
    required this.tasks,
    required this.onAppNameChanged,
    required this.onTaskChanged,
    required this.onTaskAdded,
    required this.onTaskRemoved,
    this.onAppRemoved,
    this.showTaskActions = true,
    this.showAppActions = true,
    this.enabled = true,
    this.showLimits = false,
    this.tokenSymbol,
    this.defaultRewardPerTask,
    this.taskRewardLimits,
    this.taskUploadLimits,
    this.onTaskRewardLimitChanged,
    this.onTaskUploadLimitChanged,
  });

  final String? appName;
  final String? appDomain;
  final List<String> tasks;
  final ValueChanged<String> onAppNameChanged;
  final ValueChanged<TaskChangeEvent> onTaskChanged;
  final VoidCallback? onTaskAdded;
  final ValueChanged<int>? onTaskRemoved;
  final VoidCallback? onAppRemoved;
  final bool showTaskActions;
  final bool showAppActions;
  final bool enabled;
  final bool showLimits;
  final String? tokenSymbol;
  final double? defaultRewardPerTask;
  final List<double?>? taskRewardLimits;
  final List<int?>? taskUploadLimits;
  final void Function(int taskIndex, double? rewardLimit)? onTaskRewardLimitChanged;
  final void Function(int taskIndex, int? uploadLimit)? onTaskUploadLimitChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppInputField(
                    initialValue: appName,
                    onChanged: onAppNameChanged,
                    showIcon: appDomain != null,
                    iconUrl: appDomain,
                    enabled: enabled,
                  ),
                ),
                if (showAppActions && enabled && onAppRemoved != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    iconSize: 20,
                    color: Colors.red.withValues(alpha: 0.7),
                    onPressed: onAppRemoved,
                    tooltip: 'Delete app',
                  ),
                ],
              ],
            ),
            if (tasks.isNotEmpty) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Column(
                  children: List.generate(
                    tasks.length,
                    (taskIdx) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: TaskInputField(
                              initialValue: tasks[taskIdx],
                              onChanged: (value) => onTaskChanged(
                                TaskChangeEvent(taskIdx, value),
                              ),
                              enabled: enabled,
                              showLimits: showLimits,
                              tokenSymbol: tokenSymbol,
                              defaultRewardLimit: defaultRewardPerTask,
                              rewardLimit: taskRewardLimits?[taskIdx],
                              uploadLimit: taskUploadLimits?[taskIdx],
                              onRewardLimitChanged: (rewardLimit) =>
                                  onTaskRewardLimitChanged?.call(taskIdx, rewardLimit),
                              onUploadLimitChanged: (uploadLimit) =>
                                  onTaskUploadLimitChanged?.call(taskIdx, uploadLimit),
                            ),
                          ),
                          if (showTaskActions && enabled) ...[
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              iconSize: 20,
                              color: Colors.red.withValues(alpha: 0.7),
                              onPressed: () => onTaskRemoved?.call(taskIdx),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            if (showTaskActions && enabled && onTaskAdded != null) ...[
              const SizedBox(height: 8),
              InkWell(
                onTap: onTaskAdded,
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: CardWidget(
                    padding: CardPadding.small,
                    variant: CardVariant.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '+ Add a task',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class TaskChangeEvent {
  const TaskChangeEvent(this.taskIndex, this.newValue);

  final int taskIndex;
  final String newValue;
}
