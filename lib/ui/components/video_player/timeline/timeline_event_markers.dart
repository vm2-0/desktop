import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimelineEventMarkers extends ConsumerWidget {
  const TimelineEventMarkers({
    required this.videoId,
    required this.timelineWidth,
    super.key,
  });

  final String videoId;
  final double timelineWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoStateNotifierProvider(videoId));
    final durationMs = videoState.totalDuration.inMilliseconds.toDouble();
    final demoDetail = ref.watch(demoDetailNotifierProvider);
    final events = demoDetail.events;
    final enabledEventTypes = demoDetail.enabledEventTypes;
    final startTime = demoDetail.startTime;

    if (durationMs > 0) {
      return Stack(
        children: events.where(
          (event) {
            final relativeTimeMs = (event.time - startTime).toDouble();
            return enabledEventTypes.contains(event.event) &&
                relativeTimeMs >= 0 &&
                relativeTimeMs <= durationMs;
          },
        ).map(
          (event) {
            // Calculate relative time since recording start (should now be just event.time since startTime = 0)
            final relativeTimeMs = (event.time - startTime).toDouble();
            final position = (relativeTimeMs / durationMs) * timelineWidth -
                4; // Center 8px circle: -4px offset

            return Positioned(
              left: position,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: ClonesColors.getEventTypeColor(event.event),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        ).toList(),
      );
    }
    return const SizedBox.shrink();
  }
}
