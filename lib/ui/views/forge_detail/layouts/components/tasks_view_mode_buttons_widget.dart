import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksViewModeButtonsWidget extends ConsumerWidget {
  const TasksViewModeButtonsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forgeDetail = ref.watch(forgeDetailNotifierProvider);

    return Row(
      children: [
        BtnPrimary(
          buttonText: 'Edit',
          onTap: () => forgeDetail.viewModeTasks == ViewModeTasks.preview
              ? ref
                  .read(forgeDetailNotifierProvider.notifier)
                  .setViewModeTasks(ViewModeTasks.edit)
              : null,
          btnPrimaryType: forgeDetail.viewModeTasks == ViewModeTasks.edit
              ? BtnPrimaryType.primary
              : BtnPrimaryType.dark,
        ),
        const SizedBox(width: 10),
        BtnPrimary(
          buttonText: 'Preview',
          onTap: () => forgeDetail.viewModeTasks == ViewModeTasks.edit
              ? ref
                  .read(forgeDetailNotifierProvider.notifier)
                  .setViewModeTasks(ViewModeTasks.preview)
              : null,
          btnPrimaryType: forgeDetail.viewModeTasks == ViewModeTasks.preview
              ? BtnPrimaryType.primary
              : BtnPrimaryType.dark,
        ),
      ],
    );
  }
}
