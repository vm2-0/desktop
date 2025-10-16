import 'package:clones_desktop/ui/components/video_player/timeline_widget.dart';
import 'package:clones_desktop/ui/components/video_player/transport_controls.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ConsumerVideoPlayerState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> {
  @protected
  String get videoId;
  @protected
  void videoPlay();
  @protected
  void videoPause();
  @protected
  void videoStop();
  @protected
  void videoSeekBackward();
  @protected
  void videoSeekForward();
  @protected
  void videoSeek(Duration position);
  @protected
  void videoSetSpeed(double speed);
  @protected
  Widget buildVideoPlayer(BuildContext context);

  void _handlePlayPause() {
    final isPlaying = ref.read(videoStateNotifierProvider(videoId)).isPlaying;
    if (isPlaying) {
      videoPause();
    } else {
      videoPlay();
    }
  }

  void _handleStop() {
    videoStop();
  }

  void _handleSeekBackward() {
    videoSeekBackward();
  }

  void _handleSeekForward() {
    videoSeekForward();
  }

  void _handleSeek(Duration position) {
    final seekTo = position < Duration.zero ? Duration.zero : position;
    videoSeek(seekTo);
  }

  void _handleSpeedChange(double speed) {
    videoSetSpeed(speed);
  }

  @override
  Widget build(BuildContext context) {
    final videoState = ref.watch(videoStateNotifierProvider(videoId));

    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is! KeyDownEvent) return;
        final key = event.logicalKey;
        if (key == LogicalKeyboardKey.space) {
          _handlePlayPause();
        } else if (key == LogicalKeyboardKey.arrowLeft) {
          _handleSeekBackward();
        } else if (key == LogicalKeyboardKey.arrowRight) {
          _handleSeekForward();
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate available height minus controls and spacing
          const controlsHeight =
              120; // Approximate height for timeline + transport controls + spacing
          final availableVideoHeight = constraints.maxHeight - controlsHeight;
          final maxVideoWidth = constraints.maxWidth;

          // Calculate optimal video size maintaining 16:9 aspect ratio
          const aspectRatio = 16 / 9;
          var videoWidth = maxVideoWidth;
          var videoHeight = videoWidth / aspectRatio;

          // If calculated height exceeds available space, constrain by height
          if (videoHeight > availableVideoHeight) {
            videoHeight = availableVideoHeight;
            videoWidth = videoHeight * aspectRatio;
          }

          return Column(
            children: [
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: videoWidth,
                      maxHeight: videoHeight,
                    ),
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: videoState.hasError
                            ? _buildErrorWidget(context, videoState)
                            : videoState.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : buildVideoPlayer(context),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TimelineWidget(
                videoId: videoId,
                onSeek: _handleSeek,
              ),
              const SizedBox(height: 16),
              TransportControls(
                videoId: videoId,
                onPlayPause: _handlePlayPause,
                onStop: _handleStop,
                onSeekBackward: _handleSeekBackward,
                onSeekForward: _handleSeekForward,
                onSpeedChange: _handleSpeedChange,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, VideoState videoState) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Video playback error',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            videoState.errorMessage ?? 'Unknown error',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
