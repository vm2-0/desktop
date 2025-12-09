import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/recording/recording_event.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/video_player/axtree_overlay.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoDetailVideoPreview extends ConsumerStatefulWidget {
  const DemoDetailVideoPreview({
    super.key,
    this.onExpand,
    this.videoWidget,
    this.videoId,
  });
  final VoidCallback? onExpand;
  final Widget? videoWidget;
  final String? videoId;

  @override
  ConsumerState<DemoDetailVideoPreview> createState() =>
      _DemoDetailVideoPreviewState();
}

class _DemoDetailVideoPreviewState
    extends ConsumerState<DemoDetailVideoPreview> {
  @override
  Widget build(BuildContext context) {
    // Select only specific fields to prevent unnecessary rebuilds
    final videoState = ref.watch(
      demoDetailNotifierProvider.select(
        (s) => (
          isLoading: s.isLoading,
          showAxTreeOverlay: s.showAxTreeOverlay,
          recordingLocation: s.recording?.location,
        ),
      ),
    );

    final theme = Theme.of(context);

    return CardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Video Preview',
                style: theme.textTheme.titleMedium,
              ),
              Row(
                children: [
                  // AxTree toggle button
                  if (_hasAxTreeEvents())
                    IconButton(
                      icon: Icon(
                        Icons.account_tree,
                        color: videoState.showAxTreeOverlay
                            ? ClonesColors.tertiary
                            : ClonesColors.tertiary.withValues(alpha: 0.5),
                      ),
                      onPressed: () {
                        ref
                            .read(demoDetailNotifierProvider.notifier)
                            .toggleAxTreeOverlay();
                      },
                      tooltip: videoState.showAxTreeOverlay
                          ? 'Hide AxTree overlay'
                          : 'Show AxTree overlay',
                    ),
                  if (widget.onExpand != null)
                    IconButton(
                      icon: const Icon(
                        Icons.fullscreen,
                        color: ClonesColors.secondary,
                      ),
                      onPressed: widget.onExpand,
                      tooltip: 'Fullscreen',
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (videoState.isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      color: ClonesColors.primary,
                      strokeWidth: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading video preview...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: ClonesColors.secondaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            Flexible(
              child: widget.videoWidget == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            videoState.recordingLocation == 'cloud'
                                ? Icons.cloud_outlined
                                : Icons.videocam_off,
                            size: 48,
                            color: ClonesColors.secondaryText,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            videoState.recordingLocation == 'cloud'
                                ? 'No video available for this cloud recording'
                                : 'No video found',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: ClonesColors.secondaryText,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : MouseRegion(
                      child: _buildVideoContainer(),
                    ),
            ),
        ],
      ),
    );
  }

  bool _hasAxTreeEvents() {
    // TODO(reddwarf03): Hardcoded for now, we need to improve this
    return false;
  }

  Widget _buildVideoContainer() {
    if (widget.videoWidget == null) {
      return const SizedBox.shrink();
    }

    // Use a reasonable default aspect ratio for videos
    // Most recordings are likely to be in 16:9 or similar
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildVideoWithOverlay(),
      ],
    );
  }

  Widget _buildVideoWithOverlay() {
    if (widget.videoWidget == null) {
      return const SizedBox.shrink();
    }

    final showAxTreeOverlay = ref.watch(
      demoDetailNotifierProvider.select((s) => s.showAxTreeOverlay),
    );

    // If AxTree overlay is disabled or no AxTree events, just return the original video
    if (!showAxTreeOverlay || !_hasAxTreeEvents()) {
      return widget.videoWidget!;
    }

    // ... rest of the method

    // Find current AxTree event based on video position
    final currentAxTreeEvent = _getCurrentAxTreeEvent();

    if (currentAxTreeEvent == null) {
      return widget.videoWidget!;
    }

    // Get video dimensions (we'll use a standard size for now)
    const videoSize = Size(1200, 675); // 16:9 aspect ratio
    const recordingResolution =
        Size(1920, 1080); // Typical recording resolution

    return Stack(
      children: [
        widget.videoWidget!,
        Positioned.fill(
          child: IgnorePointer(
            child: ColoredBox(
              color: Colors.red.withValues(
                alpha: 0.3,
              ),
              child: AxTreeOverlay(
                axTreeEvent: currentAxTreeEvent,
                videoSize: videoSize,
                recordingResolution: recordingResolution,
              ),
            ),
          ),
        ),
      ],
    );
  }

  RecordingEvent? _getCurrentAxTreeEvent() {
    final state = ref.read(demoDetailNotifierProvider);
    final videoId = widget.videoId;

    if (videoId == null) {
      return null;
    }

    // Get current video position
    final videoState = ref.read(videoStateNotifierProvider(videoId));
    final currentTimeMs = videoState.currentPosition.inMilliseconds;

    final axTreeEvents =
        state.events.where((e) => e.event == 'axtree').toList();

    if (axTreeEvents.isEmpty) return null;

    // If we have AxTree events, let's check if they use absolute timestamps
    final firstEvent = axTreeEvents.first;
    final isAbsoluteTimestamp =
        firstEvent.time > 1000000000000; // > year 2001 in ms

    if (isAbsoluteTimestamp) {
      // For now, just return the first AxTree event for testing
      // TODO(reddwarf03): We need to convert absolute timestamps to relative ones
      return firstEvent;
    }

    // Original logic for relative timestamps
    RecordingEvent? currentEvent;
    for (final event in axTreeEvents) {
      if (event.time <= currentTimeMs) {
        if (currentEvent == null || event.time > currentEvent.time) {
          currentEvent = event;
        }
      }
    }

    return currentEvent;
  }
}
