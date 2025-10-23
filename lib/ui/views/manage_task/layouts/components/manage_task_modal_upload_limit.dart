import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/views/manage_task/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageTaskModalUploadLimit extends ConsumerStatefulWidget {
  const ManageTaskModalUploadLimit({
    super.key,
    this.focusNode,
    this.onSubmitted,
  });
  final FocusNode? focusNode;
  final void Function(String)? onSubmitted;
  @override
  ConsumerState<ManageTaskModalUploadLimit> createState() =>
      _ManageTaskModalUploadLimitState();
}

class _ManageTaskModalUploadLimitState
    extends ConsumerState<ManageTaskModalUploadLimit> {
  late final TextEditingController uploadLimitValueController;

  @override
  void dispose() {
    uploadLimitValueController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final manageTask = ref.read(manageTaskNotifierProvider);
    uploadLimitValueController = TextEditingController(
      text: manageTask.uploadLimitValue == null
          ? ''
          : manageTask.uploadLimitValue.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final manageTask = ref.watch(manageTaskNotifierProvider);

    if (uploadLimitValueController.text !=
        manageTask.uploadLimitValue?.toString()) {
      uploadLimitValueController.text =
          manageTask.uploadLimitValue?.toString() ?? '';
    }
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Limit Value for this task',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.primaryContainer,
              width: 0.5,
            ),
            gradient: ClonesColors.gradientInputFormBackground,
          ),
          child: TextField(
            focusNode: widget.focusNode,
            onSubmitted: widget.onSubmitted,
            controller: uploadLimitValueController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: theme.textTheme.bodyMedium,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
              hintText: 'Number of demos maximum',
            ),
            onChanged: (val) {
              ref
                  .read(manageTaskNotifierProvider.notifier)
                  .setUploadLimitValue(int.tryParse(val));
            },
          ),
        ),
      ],
    );
  }
}
