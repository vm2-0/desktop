import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:clones_desktop/ui/views/manage_task/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTaskButtonWidget extends ConsumerWidget {

  const AddTaskButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        ref.read(forgeDetailNotifierProvider.notifier)
          ..setManageTaskModalType(ManageTaskModalType.create)
          ..setShowManageTaskModal(true);
      },
      child: SizedBox(
        height: 50,
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
    );
  }
}
