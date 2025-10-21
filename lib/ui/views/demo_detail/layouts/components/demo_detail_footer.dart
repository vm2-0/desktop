import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoDetailFooter extends ConsumerWidget {
  const DemoDetailFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAddress =
        ref.watch(sessionNotifierProvider.select((s) => s.address));

    final demoDetail = ref.watch(demoDetailNotifierProvider);
    final recording = demoDetail.recording;
    final submission = recording?.submission;
    final demoDetailNotifier = ref.watch(demoDetailNotifierProvider.notifier);
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (recording != null && recording.status == 'completed') ...[
          if (demoDetail.sftMessages.isEmpty)
            BtnPrimary(
              onTap: demoDetailNotifier.processRecording,
              isLoading: demoDetail.isProcessing,
              isLocked: demoDetail.isProcessing ||
                  demoDetail.isUploading ||
                  walletAddress == null,
              buttonText: 'Analyse demo',
            )
          else
            BtnPrimary(
              onTap: demoDetailNotifier.uploadRecording,
              isLoading: demoDetail.isUploading,
              isLocked: demoDetail.isUploading ||
                  walletAddress == null ||
                  submission?.status == 'completed' ||
                  (submission != null && submission.status != 'failed'),
              buttonText: submission?.status == 'completed'
                  ? '✓ Graded'
                  : submission?.status == 'failed'
                      ? 'Failed'
                      : submission != null
                          ? 'Processing...'
                          : 'Submit Final Version for Scoring',
            ),
        ],
      ],
    );
  }
}
