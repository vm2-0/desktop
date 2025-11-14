import 'package:clones_desktop/ui/components/video_player/timeline/timeline_blur_regions.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_clips_overlay.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_deleted_zones.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimelineEditingElements extends ConsumerWidget {
  const TimelineEditingElements({
    required this.durationMs,
    required this.timelineWidth,
    super.key,
  });

  final double durationMs;
  final double timelineWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(demoDetailNotifierProvider);
    final widgets = <Widget>[];

    // Show deleted zones first (underneath)
    if (state.deletedClipsHistory.isNotEmpty) {
      widgets.add(
        TimelineDeletedZones(
          deletedClipsHistory: state.deletedClipsHistory,
          durationMs: durationMs,
          timelineWidth: timelineWidth,
        ),
      );
    }

    // Show blur regions (between deleted zones and clips)
    if (state.blurRegions.isNotEmpty) {
      widgets.add(
        TimelineBlurRegions(
          blurRegions: state.blurRegions,
          selectedIds: state.selectedBlurRegionIds,
          durationMs: durationMs,
          timelineWidth: timelineWidth,
          onRegionTap: (region) {
            ref.read(demoDetailNotifierProvider.notifier).selectBlurRegion(region.id);
          },
        ),
      );
    }

    // Render clips (iMovie-like) as lighter bands on top
    if (state.clips.isNotEmpty) {
      widgets.add(
        TimelineClipsOverlay(
          clips: state.clips,
          selectedIds: state.selectedClipIds,
          durationMs: durationMs,
          timelineWidth: timelineWidth,
        ),
      );
    }

    return Stack(children: widgets);
  }
}
