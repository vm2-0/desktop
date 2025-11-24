import 'package:clones_desktop/application/feature_flags.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/domain/models/factory/workflow_task.dart';
import 'package:clones_desktop/ui/components/design_widget/dialog/dialog.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/referral_required_dialog.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/demo_detail_view.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:clones_desktop/ui/views/manage_task/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TaskActionsWidget extends ConsumerWidget {
  const TaskActionsWidget({
    super.key,
    required this.task,
    required this.taskIdx,
    required this.forgeId,
    required this.factoryStatus,
  });

  final WorkflowTask task;
  final int taskIdx;
  final String forgeId;
  final FactoryStatus factoryStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (factoryStatus == FactoryStatus.archived) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Record/Training session button
        if (task.uploadLimit != null &&
            task.currentSubmissions != null &&
            task.currentSubmissions! >= task.uploadLimit!)
          const SizedBox(width: 20)
        else
          InkWell(
            onTap: () async {
              // Check if farming is locked without referral code
              if (FeatureFlags.lockFarmingWithoutReferral) {
                final session = ref.read(sessionNotifierProvider);
                if (session.referrerCode == null ||
                    session.referrerCode!.isEmpty) {
                  await ReferralRequiredDialog.show(context, ref);
                  return;
                }
              }

              context.go(
                DemoDetailView.routeName,
                extra: {
                  'prompt': task.prompt,
                  'poolId': forgeId,
                  'taskId': task.id,
                },
              );
            },
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.blue.withValues(alpha: 0.8),
                BlendMode.srcATop,
              ),
              child: Image.asset(
                Assets.recordIcon,
                width: 24,
                height: 24,
              ),
            ),
          ),
        const SizedBox(width: 20),
        // Edit button

        InkWell(
          onTap: () {
            ref.read(forgeDetailNotifierProvider.notifier)
              ..setManageTaskModalType(ManageTaskModalType.edit)
              ..setShowManageTaskModal(true)
              ..setEditingTaskIdx(taskIdx);
          },
          child: Image.asset(
            Assets.editIcon,
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(width: 20),

        // Delete button
        InkWell(
          onTap: () async {
            await AppDialogs.showConfirmDialog(
              context,
              ref,
              'Confirm Deletion',
              'Are you sure you want to delete this task?',
              'Delete',
              () async {
                ref
                    .read(forgeDetailNotifierProvider.notifier)
                    .removeTask(taskIdx);
              },
            );
          },
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.red.withValues(alpha: 0.8),
              BlendMode.srcATop,
            ),
            child: Image.asset(
              Assets.deleteIcon,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
    );
  }
}
