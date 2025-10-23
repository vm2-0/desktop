import 'dart:convert';

import 'package:clones_desktop/application/feature_flags.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/app_info.dart';
import 'package:clones_desktop/domain/models/factory/factory_app.dart';
import 'package:clones_desktop/domain/models/factory/factory_task.dart';
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
    required this.app,
    required this.appIdx,
    required this.taskIdx,
    required this.forgeId,
  });
  final FactoryTask task;
  final FactoryApp app;
  final int appIdx;
  final int taskIdx;
  final String forgeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Record/Training session button
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

            final appInfo = AppInfo(
              type: 'website',
              name: app.name,
              url: 'https://${app.domain}',
              taskId: task.id,
            );
            final appParam = Uri.encodeComponent(
              jsonEncode(appInfo.toJson()),
            );

            context.go(
              DemoDetailView.routeName,
              extra: {
                'prompt': task.prompt,
                'appParam': appParam,
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
              ..setEditingTaskAppIdx(appIdx)
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
                    .removeTask(appIdx, taskIdx);
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
