import 'package:clones_desktop/domain/models/demonstration/demonstration.dart';
import 'package:clones_desktop/ui/components/design_widget/text/app_text.dart';
import 'package:clones_desktop/ui/views/record_overlay/bloc/provider.dart';
import 'package:clones_desktop/ui/views/record_overlay/layouts/components/record_overlay_controls.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordOverlayObjectives extends ConsumerWidget {
  const RecordOverlayObjectives({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingSession = ref.watch(trainingSessionNotifierProvider);
    final recordOverlay = ref.watch(recordOverlayNotifierProvider);

    if (recordOverlay.isCollapsed) {
      return const SizedBox.shrink();
    }

    final demo = trainingSession.recordingDemonstration;

    return Opacity(
      opacity: recordOverlay.focused ? 1.0 : 0.7,
      child: Column(
        children: [
          if (demo != null) _buildDemonstrationDetails(demo, context),
          if (demo == null)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 0.5,
                  ),
                ),
              ),
            ),
          const RecordOverlayControls(),
        ],
      ),
    );
  }

  Widget _buildDemonstrationDetails(
    Demonstration demonstration,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            demonstration.title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          if (demonstration.objectives.isNotEmpty)
            SizedBox(
              height: 320,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: demonstration.objectives.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Expanded(
                          child: AppText(
                            text: demonstration.objectives[index],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
