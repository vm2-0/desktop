import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/views/manage_task/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageTaskModalPricePerDemo extends ConsumerStatefulWidget {
  const ManageTaskModalPricePerDemo({
    super.key,
    required this.tokenSymbol,
    this.focusNode,
    this.onSubmitted,
  });
  final String tokenSymbol;
  final FocusNode? focusNode;
  final void Function(String)? onSubmitted;

  @override
  ConsumerState<ManageTaskModalPricePerDemo> createState() =>
      _ManageTaskModalPricePerDemoState();
}

class _ManageTaskModalPricePerDemoState
    extends ConsumerState<ManageTaskModalPricePerDemo> {
  late final TextEditingController controller;
  bool _isUserEditing = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final manageTask = ref.read(manageTaskNotifierProvider);
    controller = TextEditingController(
      text: manageTask.pricePerDemo == null
          ? ''
          : manageTask.pricePerDemo.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final manageTask = ref.watch(manageTaskNotifierProvider);
    
    // Don't update controller text while user is actively editing
    if (!_isUserEditing) {
      final expectedText = manageTask.pricePerDemo?.toString() ?? '';
      if (controller.text != expectedText) {
        controller.text = expectedText;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Max reward per demonstration for this task.',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        Stack(
          alignment: Alignment.centerRight,
          children: [
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
                onSubmitted: (value) {
                  _isUserEditing = false;
                  widget.onSubmitted?.call(value);
                },
                focusNode: widget.focusNode,
                onTap: () {
                  _isUserEditing = true;
                },
                onChanged: (value) {
                  _isUserEditing = true;
                  ref
                      .read(
                        manageTaskNotifierProvider.notifier,
                      )
                      .setPricePerDemo(
                        double.tryParse(value),
                      );
                },
                onEditingComplete: () {
                  _isUserEditing = false;
                },
                controller: controller,
                textInputAction: TextInputAction.next,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: theme.textTheme.bodyMedium,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d{0,18}$'),
                  ),
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  hintText: 'Reward per demo',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color!
                            .withValues(alpha: 0.2),
                      ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  widget.tokenSymbol,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
