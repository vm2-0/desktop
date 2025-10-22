import 'dart:async';

import 'package:clones_desktop/application/token_price_provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/design_widget/text/app_text.dart';
import 'package:clones_desktop/ui/views/record_overlay/layouts/record_overlay_view.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/provider.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/state.dart';
import 'package:clones_desktop/utils/format_num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecordPanel extends ConsumerStatefulWidget {
  const RecordPanel({
    super.key,
  });

  @override
  ConsumerState<RecordPanel> createState() => _RecordPanelState();
}

class _RecordPanelState extends ConsumerState<RecordPanel> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trainingSession = ref.watch(trainingSessionNotifierProvider);
    final recordingState = trainingSession.recordingState;
    final tokenPrice = ref.watch(
      convertTokenPriceProvider(
        trainingSession.factory?.token.symbol ?? '',
        trainingSession.factory?.pricePerDemo ?? 0,
      ),
    );

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: trainingSession.factory?.token != null ? 100 : 0,
              ),
              child: Text(
                trainingSession.recordingDemonstration!.title,
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 10),
            if (trainingSession.factory?.token != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complete the task to earn a reward.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Row(
                    children: [
                      Text(
                        'Up to: ${trainingSession.factory?.pricePerDemo.toStringAsFixedLowValue(2, 5) ?? 0} ${trainingSession.factory?.token.symbol ?? ''} ',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ClonesColors.secondary,
                        ),
                      ),
                      tokenPrice.when(
                        data: (price) => Text(
                          '(\$${price.toStringAsFixedLowValue(2, 5)})',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: ClonesColors.secondary,
                          ),
                        ),
                        error: (error, stackTrace) => const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '''
Please focus on the required steps: keep actions efficient, avoid unnecessary clicks, and limit unrelated activity.
For the cleanest recording, it’s best to close any applications you don’t need before starting.
Once the recording is finished, you’ll be able to trim segments—for example, to remove personal data or any information you don’t want to share.''',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              )
            else
              Column(
                children: [
                  Text(
                    'Complete the task to get a reward.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '''
Please focus on the required steps: keep actions efficient, avoid unnecessary clicks, and limit unrelated activity.
For the cleanest recording, it’s best to close any applications you don’t need before starting.
Once the recording is finished, you’ll be able to trim segments—for example, to remove personal data or any information you don’t want to share.''',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            const SizedBox(height: 10),
            Text(
              'Your Objectives:',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ...trainingSession.recordingDemonstration!.objectives.map(
              (obj) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Expanded(
                      child: AppText(
                        text: obj,
                        style: theme.textTheme.bodyMedium,
                        iconUrl:
                            trainingSession.recordingDemonstration!.iconUrl,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '''
Warning: The maximum length of a recording is 2 minutes.''',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ClonesColors.uploadLimit,
              ),
            ),
            const SizedBox(height: 20),
            _buildActionButtons(recordingState),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    RecordingState recordingState,
  ) {
    if (recordingState == RecordingState.recording) {
      return Row(
        children: [
          BtnPrimary(
            onTap: () =>
                ref.read(trainingSessionNotifierProvider.notifier).giveUp(),
            btnPrimaryType: BtnPrimaryType.outlinePrimary,
            buttonText: 'Give Up',
          ),
          const SizedBox(width: 10),
          BtnPrimary(
            onTap: () => ref
                .read(trainingSessionNotifierProvider.notifier)
                .recordingComplete(),
            buttonText: 'Complete',
          ),
        ],
      );
    } else {
      return BtnPrimary(
        onTap: () async {
          unawaited(
            ref
                .read(
                  trainingSessionNotifierProvider.notifier,
                )
                .startRecording(),
          );
          await context.push(
            RecordOverlayView.routeName,
          );
        },
        buttonText: 'Start Recording',
      );
    }
  }
}
