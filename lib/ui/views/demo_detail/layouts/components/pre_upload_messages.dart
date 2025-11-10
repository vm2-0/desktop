import 'package:clones_desktop/ui/components/design_widget/message_box/message_box.dart';
import 'package:clones_desktop/ui/components/pfp.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreUploadMessages extends ConsumerStatefulWidget {
  const PreUploadMessages({super.key});

  @override
  ConsumerState<PreUploadMessages> createState() => _PreUploadMessagesState();
}

class _PreUploadMessagesState extends ConsumerState<PreUploadMessages> {
  bool _hasStartedAnimation = false;

  @override
  void initState() {
    super.initState();
    // Start animation only if it hasn't started yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(demoDetailNotifierProvider);
      if (!state.showFirstMessage && !_hasStartedAnimation) {
        _hasStartedAnimation = true;
        ref.read(demoDetailNotifierProvider.notifier).startPreUploadAnimation();
      }
    });
  }

  Widget _buildMessage(String content) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 15),
          child: MessageBox(
            messageBoxType: MessageBoxType.talkLeft,
            content: Text(
              content,
              style: theme.textTheme.bodySmall,
              softWrap: true,
            ),
          ),
        ),
        const Positioned(
          left: 0,
          top: 0,
          child: Pfp(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(demoDetailNotifierProvider);

    ref.listen(demoDetailNotifierProvider, (previous, next) {
      if (next.isUploading && (previous?.isUploading != true)) {
        ref
            .read(demoDetailNotifierProvider.notifier)
            .startThirdMessageAnimation();
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.showFirstMessage) _buildMessage(state.firstMessage),
        if (state.showSecondMessage) ...[
          const SizedBox(height: 20),
          _buildMessage(state.secondMessage),
        ],
        if (state.showThirdMessage) ...[
          const SizedBox(height: 20),
          _buildMessage(state.thirdMessage),
        ],
      ],
    );
  }
}
