import 'package:clones_desktop/ui/components/video_player/axtree_overlay.dart';
import 'package:clones_desktop/ui/components/video_player/video_controller.dart';
import 'package:clones_desktop/ui/components/video_player/video_controller_impl.dart';
import 'package:clones_desktop/ui/components/video_player/video_player_interface.dart';
import 'package:clones_desktop/ui/components/video_player/video_source.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit_video/media_kit_video.dart';

// Note: videoSeekCallbackProvider is imported from demo_detail/bloc/provider.dart

/// Unified video player for desktop platforms (Windows and macOS)
/// Uses media_kit for video playback on all platforms
class VideoPlayer extends ConsumerStatefulWidget {
  const VideoPlayer({super.key, required this.source});

  final VideoSource source;

  @override
  ConsumerState<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends ConsumerVideoPlayerState<VideoPlayer>
    with VideoControllerMixin {
  late VideoControllerImpl _controller;
  late String _videoId;
  bool _shouldRenderVideo = false;

  @override
  String get videoId => _videoId;

  @override
  void initState() {
    super.initState();
    // Generate unique video ID based on source and timestamp
    _videoId =
        '${widget.source.hashCode}-${DateTime.now().microsecondsSinceEpoch}';
    _controller = VideoControllerImpl(widget.source, ref, _videoId);

    // Register the seek callback for external access
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Make the videoSeek method available to other widgets
      try {
        ref.read(videoSeekCallbackProvider.notifier).state = videoSeek;
      } catch (e) {
        // Provider might not be available in all contexts
      }
      _initializeVideo();
    });

    // CRITICAL: Delay video widget creation to avoid blocking UI
    // The Video widget creation is synchronous and blocks the main thread
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _shouldRenderVideo = true;
        });
      }
    });
  }

  Future<void> _initializeVideo() async {
    await safeExecute(
      () => _controller.initialize(),
      'initialize video',
      ref,
      _videoId,
    );
  }

  @override
  void didUpdateWidget(VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the video source has changed
    if (oldWidget.source != widget.source) {
      // Dispose old controller
      _controller.dispose();
      // Create new controller with new source
      _videoId =
          '${widget.source.hashCode}-${DateTime.now().microsecondsSinceEpoch}';
      _controller = VideoControllerImpl(widget.source, ref, _videoId);
      // Reinitialize
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeVideo();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildVideoPlayer(BuildContext context) {
    final videoController = _controller.videoController;
    if (videoController == null) {
      return const SizedBox.shrink();
    }

    // Watch for current position changes to update AxTree overlay
    final videoState = ref.watch(videoStateNotifierProvider(_videoId));

    final showAxTreeOverlay = ref.watch(
      demoDetailNotifierProvider.select((s) => s.showAxTreeOverlay),
    );
    final currentAxTreeEvent = ref.watch(
      demoDetailNotifierProvider.select((s) => s.currentAxTreeEvent),
    );
    final recording = ref.watch(
      demoDetailNotifierProvider.select((s) => s.recording),
    );

    // Update AxTree for current position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(demoDetailNotifierProvider.notifier)
            .updateAxTreeForCurrentTime(
              videoState.currentPosition.inMilliseconds,
            );
      }
    });

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Stack(
          children: [
            // Only render Video widget after delay to avoid blocking UI
            if (_shouldRenderVideo)
              Positioned.fill(
                child: Video(
                  controller: videoController,
                  controls: NoVideoControls,
                ),
              )
            else
              // Show loading state while waiting for render delay
              const Positioned.fill(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Preparing video player...',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

            // AxTree overlay
            if (showAxTreeOverlay && currentAxTreeEvent != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: AxTreeOverlay(
                    axTreeEvent: currentAxTreeEvent,
                    videoSize: Size(
                      videoController.rect.value?.width ?? 1920,
                      videoController.rect.value?.height ?? 1080,
                    ),
                    recordingResolution: Size(
                      recording?.primaryMonitor.width.toDouble() ?? 1920,
                      recording?.primaryMonitor.height.toDouble() ?? 1080,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void videoPause() =>
      safeExecute(() => _controller.pause(), 'pause', ref, _videoId);

  @override
  void videoPlay() =>
      safeExecute(() => _controller.play(), 'play', ref, _videoId);

  @override
  void videoSeekBackward() {
    final currentPos =
        ref.read(videoStateNotifierProvider(_videoId)).currentPosition;
    var newPosition = currentPos - const Duration(seconds: 1);
    newPosition = newPosition < Duration.zero ? Duration.zero : newPosition;

    // Adjust position to skip deleted zones
    final adjustedMs =
        _adjustSeekPositionToValidZone(newPosition.inMilliseconds.toDouble());
    final seekTo = Duration(milliseconds: adjustedMs.round());

    safeExecute(
      () => _controller.seekTo(seekTo),
      'seek backward',
      ref,
      _videoId,
    );
  }

  @override
  void videoSeekForward() {
    final state = ref.read(videoStateNotifierProvider(_videoId));
    final newPosition = state.currentPosition + const Duration(seconds: 1);
    if (newPosition < state.totalDuration) {
      // Adjust position to skip deleted zones
      final adjustedMs =
          _adjustSeekPositionToValidZone(newPosition.inMilliseconds.toDouble());
      final seekTo = Duration(milliseconds: adjustedMs.round());

      safeExecute(
        () => _controller.seekTo(seekTo),
        'seek forward',
        ref,
        _videoId,
      );
    }
  }

  @override
  void videoSeek(Duration position) {
    final state = ref.read(videoStateNotifierProvider(_videoId));
    Duration clampedPosition;
    if (position < Duration.zero) {
      clampedPosition = Duration.zero;
    } else if (position > state.totalDuration) {
      clampedPosition = state.totalDuration;
    } else {
      clampedPosition = position;
    }

    // Adjust position to skip deleted zones
    final adjustedMs = _adjustSeekPositionToValidZone(
      clampedPosition.inMilliseconds.toDouble(),
    );
    final seekTo = Duration(milliseconds: adjustedMs.round());

    safeExecute(
      () => _controller.seekTo(seekTo),
      'seek',
      ref,
      _videoId,
    );
  }

  /// Adjust seek position to avoid deleted zones
  double _adjustSeekPositionToValidZone(double positionMs) {
    try {
      final notifier = ref.read(demoDetailNotifierProvider.notifier);
      return notifier.adjustSeekPositionToValidZone(positionMs);
    } catch (e) {
      // If provider not available (e.g., not in demo detail page), return original position
      return positionMs;
    }
  }

  @override
  void videoSetSpeed(double speed) => safeExecute(
        () => _controller.setSpeed(speed),
        'set speed',
        ref,
        _videoId,
      );

  @override
  void videoStop() =>
      safeExecute(() => _controller.stop(), 'stop', ref, _videoId);
}
