import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum VideoPlayerStatus {
  loading,
  ready,
  playing,
  paused,
  stopped,
  error,
}

class VideoState {
  const VideoState({
    required this.status,
    required this.currentPosition,
    required this.totalDuration,
    required this.currentSpeed,
    this.errorMessage,
  });
  final VideoPlayerStatus status;
  final Duration currentPosition;
  final Duration totalDuration;
  final double currentSpeed;
  final String? errorMessage;

  VideoState copyWith({
    VideoPlayerStatus? status,
    Duration? currentPosition,
    Duration? totalDuration,
    double? currentSpeed,
    String? errorMessage,
  }) {
    return VideoState(
      status: status ?? this.status,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      currentSpeed: currentSpeed ?? this.currentSpeed,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isPlaying => status == VideoPlayerStatus.playing;
  bool get isLoading => status == VideoPlayerStatus.loading;
  bool get hasError => status == VideoPlayerStatus.error;
}

class VideoStateNotifier extends StateNotifier<VideoState> {
  VideoStateNotifier()
      : super(
          const VideoState(
            status: VideoPlayerStatus.loading,
            currentPosition: Duration.zero,
            totalDuration: Duration.zero,
            currentSpeed: 1,
          ),
        );
  DateTime? _lastPositionUpdate;
  StreamSubscription? _positionSubscription;

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  void setStatus(VideoPlayerStatus status) {
    state = state.copyWith(status: status);
  }

  void setError(String errorMessage) {
    state = state.copyWith(
      status: VideoPlayerStatus.error,
      errorMessage: errorMessage,
    );
  }

  void setSpeed(double speed) {
    state = state.copyWith(currentSpeed: speed);
  }

  // Throttled position updates to avoid excessive rebuilds
  void updatePosition(Duration position) {
    final now = DateTime.now();
    final timeSinceLastUpdate = _lastPositionUpdate == null
        ? 0
        : now.difference(_lastPositionUpdate!).inMilliseconds;
    final positionDiff =
        (position - state.currentPosition).inMilliseconds.abs();

    // Only update if enough time has passed (30fps = ~33ms) or if it's a significant change
    if (_lastPositionUpdate == null ||
        timeSinceLastUpdate >= 33 ||
        positionDiff >= 100) {
      _lastPositionUpdate = now;
      state = state.copyWith(currentPosition: position);
    }
  }

  void setReady(Duration totalDuration) {
    state = state.copyWith(
      status: VideoPlayerStatus.ready,
      totalDuration: totalDuration,
      currentPosition: Duration.zero,
    );
  }

  void setPlaying() {
    state = state.copyWith(status: VideoPlayerStatus.playing);
  }

  void setPaused() {
    state = state.copyWith(status: VideoPlayerStatus.paused);
  }

  void setStopped() {
    state = state.copyWith(
      status: VideoPlayerStatus.stopped,
      currentPosition: Duration.zero,
    );
  }
}

// Provider for the video state - now scoped per video instance
final videoStateNotifierProvider =
    StateNotifierProvider.family<VideoStateNotifier, VideoState, String>(
  (ref, videoId) => VideoStateNotifier(),
);
