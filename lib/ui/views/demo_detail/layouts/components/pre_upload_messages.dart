import 'dart:async';

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

  Widget _buildMessage(
    String content, {
    VoidCallback? onComplete,
    bool animate = true,
  }) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 15),
          child: MessageBox(
            messageBoxType: MessageBoxType.talkLeft,
            content: animate
                ? TypewriterText(
                    content,
                    onComplete: onComplete,
                    style: theme.textTheme.bodySmall,
                  )
                : Text(
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
    // Select specific fields to avoid rebuilding on unrelated state changes
    final messages = ref.watch(
      demoDetailNotifierProvider.select(
        (state) => (
          showFirstMessage: state.showFirstMessage,
          showSecondMessage: state.showSecondMessage,
          showThirdMessage: state.showThirdMessage,
        ),
      ),
    );

    ref.listen(
      demoDetailNotifierProvider.select((s) => s.isUploading),
      (previous, next) {
        if (next && (previous != true)) {
          ref
              .read(demoDetailNotifierProvider.notifier)
              .startThirdMessageAnimation();
        }
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (messages.showFirstMessage)
          _buildMessage(
            DemoDetailNotifier.fullFirstMessage,
            onComplete: () => ref
                .read(demoDetailNotifierProvider.notifier)
                .onFirstMessageAnimationComplete(),
            // Don't animate if second message is already shown (implies first is done)
            animate: !messages.showSecondMessage,
          ),
        if (messages.showSecondMessage) ...[
          const SizedBox(height: 20),
          _buildMessage(
            DemoDetailNotifier.fullSecondMessage,
            // Don't animate if third message is shown (implies second is done)
            animate: !messages.showThirdMessage,
          ),
        ],
        if (messages.showThirdMessage) ...[
          const SizedBox(height: 20),
          _buildMessage(
            DemoDetailNotifier.fullThirdMessage,
            animate: true,
          ),
        ],
      ],
    );
  }
}

class TypewriterText extends StatefulWidget {
  const TypewriterText(
    this.text, {
    this.duration = const Duration(milliseconds: 30),
    this.onComplete,
    this.style,
    super.key,
  });

  final String text;
  final Duration duration;
  final VoidCallback? onComplete;
  final TextStyle? style;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayedText = '';
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _timer = Timer.periodic(widget.duration, (timer) {
      if (!mounted) return;

      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayedText = widget.text.substring(0, _currentIndex + 1);
          _currentIndex++;
        });
      } else {
        timer.cancel();
        widget.onComplete?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style,
      softWrap: true,
    );
  }
}
