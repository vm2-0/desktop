import 'dart:async';

import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/views/record_overlay/bloc/provider.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/provider.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecordOverlayControls extends ConsumerWidget {
  const RecordOverlayControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingSession = ref.watch(trainingSessionNotifierProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (trainingSession.recordingState == RecordingState.recording) ...[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: BtnPrimary(
                widthExpanded: true,
                buttonText: 'Give Up',
                btnPrimaryType: BtnPrimaryType.outlinePrimary,
                onTap: () async {
                  ref.read(recordOverlayNotifierProvider.notifier).stopTimer();
                  unawaited(
                    ref.read(trainingSessionNotifierProvider.notifier).giveUp(),
                  );
                  context.pop();
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 20),
              child: BtnPrimary(
                widthExpanded: true,
                buttonText: 'Complete',
                onTap: () async {
                  ref.read(recordOverlayNotifierProvider.notifier).stopTimer();
                  unawaited(
                    ref
                        .read(trainingSessionNotifierProvider.notifier)
                        .recordingComplete(),
                  );
                  ref.read(recordOverlayNotifierProvider.notifier).close();
                },
              ),
            ),
          ),
        ],
        if (trainingSession.recordingState == RecordingState.starting ||
            trainingSession.recordingState == RecordingState.stopping)
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        if (trainingSession.recordingState == RecordingState.off)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Recording tools loading',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    const SizedBox(
                      width: 8,
                      height: 8,
                      child: CircularProgressIndicator(
                        strokeWidth: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
