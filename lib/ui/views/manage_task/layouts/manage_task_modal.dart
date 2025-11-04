import 'dart:ui';

import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/domain/models/factory/factory_task.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/views/manage_task/bloc/provider.dart';
import 'package:clones_desktop/ui/views/manage_task/bloc/state.dart';
import 'package:clones_desktop/ui/views/manage_task/layouts/components/manage_task_modal_price_per_demo.dart';
import 'package:clones_desktop/ui/views/manage_task/layouts/components/manage_task_modal_prompt.dart';
import 'package:clones_desktop/ui/views/manage_task/layouts/components/manage_task_modal_upload_limit.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageTaskModal extends ConsumerStatefulWidget {
  const ManageTaskModal({
    super.key,
    required this.tokenSymbol,
    required this.onDone,
    required this.onClose,
    required this.modalType,
    required this.task,
    required this.factory,
  });
  final String tokenSymbol;
  final void Function(FactoryTask? task) onDone;
  final VoidCallback onClose;
  final ManageTaskModalType modalType;
  final FactoryTask? task;
  final Factory? factory;

  @override
  ConsumerState<ManageTaskModal> createState() => _ManageTaskModalState();
}

class _ManageTaskModalState extends ConsumerState<ManageTaskModal> {
  late final FocusNode _promptFocusNode;
  late final FocusNode _pricePerDemoFocusNode;
  late final FocusNode _uploadLimitFocusNode;

  @override
  void initState() {
    super.initState();
    _promptFocusNode = FocusNode();
    _pricePerDemoFocusNode = FocusNode();
    _uploadLimitFocusNode = FocusNode();
    Future(() async {
      ref
          .read(manageTaskNotifierProvider.notifier)
          .setModalType(widget.modalType);
      if (widget.task != null) {
        ref.read(manageTaskNotifierProvider.notifier)
          ..setPrompt(widget.task!.prompt)
          ..setPricePerDemo(
            widget.task?.rewardLimit?.toDouble(),
          )
          ..setUploadLimitValue(widget.task!.uploadLimit);
      }
    });
  }

  @override
  void dispose() {
    _promptFocusNode.dispose();
    _pricePerDemoFocusNode.dispose();
    _uploadLimitFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final state = ref.read(manageTaskNotifierProvider);
    if (state.prompt.isEmpty) {
      return;
    }
    final FactoryTask result;
    if (widget.modalType == ManageTaskModalType.create) {
      result = FactoryTask(
        prompt: state.prompt,
        rewardLimit: state.pricePerDemo != null ? Decimal.parse(state.pricePerDemo.toString()) : null,
        uploadLimit: state.uploadLimitValue,
      );
    } else {
      result = widget.task!.copyWith(
        prompt: state.prompt,
        rewardLimit: state.pricePerDemo != null ? Decimal.parse(state.pricePerDemo.toString()) : null,
        uploadLimit: state.uploadLimitValue,
      );
    }
    widget.onDone(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ),
        Center(
          child: CardWidget(
            padding: CardPadding.large,
            child: SizedBox(
              width: mediaQuery.size.height * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.modalType == ManageTaskModalType.create
                            ? 'Create a new task'
                            : 'Edit task',
                        style: theme.textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: () => widget.onClose(),
                        icon: Icon(
                          Icons.close,
                          color: ClonesColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Focus(
                    onKeyEvent: (node, event) {
                      if (event is KeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.tab) {
                        _pricePerDemoFocusNode.requestFocus();
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: ManageTaskModalPrompt(
                      focusNode: _promptFocusNode,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Focus(
                    onKeyEvent: (node, event) {
                      if (event is KeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.tab) {
                        _uploadLimitFocusNode.requestFocus();
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: ManageTaskModalPricePerDemo(
                      tokenSymbol: widget.tokenSymbol,
                      focusNode: _pricePerDemoFocusNode,
                      onSubmitted: (_) => _submit(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ManageTaskModalUploadLimit(
                    focusNode: _uploadLimitFocusNode,
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 20),
                  _footerButtons(ref),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _footerButtons(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BtnPrimary(
          buttonText: 'Cancel',
          onTap: widget.onClose,
          btnPrimaryType: BtnPrimaryType.outlinePrimary,
        ),
        const SizedBox(width: 10),
        BtnPrimary(
          buttonText: widget.modalType == ManageTaskModalType.create
              ? 'Add task'
              : 'Save task',
          onTap: _submit,
          isLocked: ref.watch(manageTaskNotifierProvider).prompt.isEmpty,
        ),
      ],
    );
  }
}
