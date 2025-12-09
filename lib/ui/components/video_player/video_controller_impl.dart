import 'dart:async';
import 'dart:io';

import 'package:clones_desktop/ui/components/video_player/video_controller.dart';
import 'package:clones_desktop/ui/components/video_player/video_source.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path_provider/path_provider.dart';

/// Implementation of VideoController using media_kit for all desktop platforms
class VideoControllerImpl with VideoControllerMixin {
  VideoControllerImpl(this.source, this.ref, this._videoId);

  final VideoSource source;
  final dynamic ref;
  final String _videoId;

  Player? _player;
  VideoController? _videoController;

  StreamSubscription? _positionSubscription;
  StreamSubscription? _playingSubscription;
  StreamSubscription? _rateSubscription;
  Timer? _fallbackTimer;
  Timer? _positionDebounceTimer;
  Duration? _lastReportedPosition;
  String? _tempFilePath;
  bool _isDisposed = false;
  // Coalesce player position events immediately following a seek to avoid UI "flash"
  Timer? _postSeekCoalesceTimer;
  Duration? _postSeekLatestPosition;
  bool _coalescingSeek = false;
  // Track if video has ever been played to prevent initial position jump
  bool _hasStartedPlaying = false;

  /// Returns the media_kit video controller for the widget
  VideoController? get videoController => _videoController;

  Future<void> initialize() async {
    try {
      ref
          .read(videoStateNotifierProvider(_videoId).notifier)
          .setStatus(VideoPlayerStatus.loading);

      _player = Player();
      _videoController = VideoController(_player!);

      final filePath = await _prepareVideoFile();

      _fallbackTimer = Timer(const Duration(seconds: 35), () {
        throw VideoControllerException(
          'Video initialization timeout - fallback triggered',
        );
      });

      // Determine if filePath is an HTTP URL or local file path
      final mediaUri =
          filePath.startsWith('http://') || filePath.startsWith('https://')
              ? Uri.parse(filePath)
              : Uri.file(filePath);

      await withInitializationTimeout(
        _player!.open(
          Media(mediaUri.toString()),
          play: false, // Disable autoplay
        ),
        'initialize media_kit player',
      );

      _fallbackTimer?.cancel();

      // Wait for duration to be available
      await _player!.stream.duration.firstWhere((d) => d != Duration.zero);
      final duration = _player!.state.duration;

      ref
          .read(videoStateNotifierProvider(_videoId).notifier)
          .setReady(duration);

      // Setup position listener with coalescing (post-seek) & debouncing to prevent rapid UI updates
      _positionSubscription = _player!.stream.position.listen((position) {
        if (!_isDisposed) {
          // Force position to 0 until video has started playing (prevents initial jump to first keyframe)
          if (!_hasStartedPlaying) {
            _updatePositionAndCheck(Duration.zero);
            return;
          }

          // During the post-seek coalescing window, accumulate the latest position and return.
          if (_coalescingSeek) {
            _postSeekLatestPosition = position;
            return;
          }

          // Cancel any pending debounced update
          _positionDebounceTimer?.cancel();

          // If this is very similar to the last reported position (within 150ms), debounce it
          if (_lastReportedPosition != null &&
              (position - _lastReportedPosition!).inMilliseconds.abs() < 150) {
            _positionDebounceTimer =
                Timer(const Duration(milliseconds: 120), () {
              if (!_isDisposed) {
                _updatePositionAndCheck(position);
              }
            });
          } else {
            // Position change is significant, update immediately
            _updatePositionAndCheck(position);
          }
        }
      });

      // Setup playing/paused state listener
      _playingSubscription = _player!.stream.playing.listen((isPlaying) {
        if (!_isDisposed) {
          final notifier =
              ref.read(videoStateNotifierProvider(_videoId).notifier);
          if (isPlaying) {
            notifier.setPlaying();
          } else {
            notifier.setPaused();
          }
        }
      });

      // Setup playback speed listener
      _rateSubscription = _player!.stream.rate.listen((rate) {
        if (!_isDisposed) {
          ref
              .read(videoStateNotifierProvider(_videoId).notifier)
              .setSpeed(rate);
        }
      });
    } catch (e) {
      _fallbackTimer?.cancel();

      ref
          .read(videoStateNotifierProvider(_videoId).notifier)
          .setError('Failed to initialize video: $e');

      rethrow;
    }
  }

  /// Prepares video file from source
  Future<String> _prepareVideoFile() async {
    return switch (source) {
      FileVideoSource(path: final path) => path,
      AssetVideoSource(path: final path) =>
        // For assets, we need to get the full path
        // This might need adjustment based on how assets are bundled
        path,
      HttpVideoSource(url: final url) => url, // Direct HTTP streaming
      Base64VideoSource() => await _createTempFileFromBase64(),
    };
  }

  Future<String> _createTempFileFromBase64() async {
    final base64Source = source as Base64VideoSource;
    final bytes = base64Source.videoBytes;

    final tempDir = await getTemporaryDirectory();
    _tempFilePath =
        '${tempDir.path}/temp_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    final tempFile = File(_tempFilePath!);
    await tempFile.writeAsBytes(bytes);

    return _tempFilePath!;
  }

  Future<void> play() async {
    if (_player == null) {
      throw VideoControllerException('Cannot play: player not initialized');
    }
    _hasStartedPlaying = true;
    await withOperationTimeout(
      _player!.play(),
      'play video',
    );
  }

  Future<void> pause() async {
    if (_player == null) {
      throw VideoControllerException('Cannot pause: player not initialized');
    }
    await withOperationTimeout(
      _player!.pause(),
      'pause video',
    );
  }

  Future<void> stop() async {
    if (_player == null) {
      throw VideoControllerException('Cannot stop: player not initialized');
    }
    _hasStartedPlaying = false; // Reset flag to lock playhead at 0
    await withOperationTimeout(
      Future.wait([
        _player!.pause(),
        _player!.seek(Duration.zero),
      ]),
      'stop video',
    );
    ref.read(videoStateNotifierProvider(_videoId).notifier).setStopped();
  }

  Future<void> seekTo(Duration position) async {
    if (_player == null) {
      throw VideoControllerException('Cannot seek: player not initialized');
    }
    // If user seeks to non-zero position, allow playhead to move
    if (position > Duration.zero) {
      _hasStartedPlaying = true;
    }
    // Begin coalescing position events to avoid showing the unsynchronized position
    _coalescingSeek = true;
    _postSeekLatestPosition = null;
    _postSeekCoalesceTimer?.cancel();
    // At ~30fps, frame-step granularity is ~33ms. Use a conservative window to allow libmpv to settle.
    _postSeekCoalesceTimer = Timer(const Duration(milliseconds: 200), () {
      if (_isDisposed) return;
      // Push the latest known position (ideally the synced one) after coalescing window
      if (_postSeekLatestPosition != null) {
        _updatePositionAndCheck(_postSeekLatestPosition!);
      }
      _postSeekLatestPosition = null;
      _coalescingSeek = false;
    });
    await withOperationTimeout(
      _player!.seek(position),
      'seek to position',
    );
  }

  Future<void> setSpeed(double speed) async {
    if (_player == null) {
      throw VideoControllerException(
        'Cannot set speed: player not initialized',
      );
    }
    await withOperationTimeout(
      _player!.setRate(speed),
      'set playback speed',
    );
    ref.read(videoStateNotifierProvider(_videoId).notifier).setSpeed(speed);
  }

  /// Helper method to update position and check deleted zones
  void _updatePositionAndCheck(Duration position) {
    final notifier = ref.read(videoStateNotifierProvider(_videoId).notifier);
    notifier.updatePosition(position);
    _lastReportedPosition = position;

    // Check if we're in a deleted zone and skip if needed
    // Only check if we have started playing to avoid initial seek loops or jumps
    if (_player!.state.playing && _hasStartedPlaying) {
      _checkAndSkipDeletedZones(position);
    }
  }

  /// Check if current position is in a deleted zone and skip to next valid position
  void _checkAndSkipDeletedZones(Duration currentPosition) {
    try {
      final demoDetailNotifier = ref.read(demoDetailNotifierProvider.notifier);
      final currentMs = currentPosition.inMilliseconds.toDouble();

      if (demoDetailNotifier.isPositionInDeletedZone(currentMs)) {
        final nextValidMs = demoDetailNotifier.getNextValidPosition(currentMs);

        if (nextValidMs != null) {
          debugPrint(
            'Auto-skipping deleted zone: ${currentMs}ms → ${nextValidMs}ms',
          );
          final nextPosition = Duration(milliseconds: nextValidMs.round());
          _player?.seek(nextPosition);
        } else {
          // No more valid positions, pause the video
          _player?.pause();
        }
      }
    } catch (e) {
      // Provider not available, ignore (e.g., not in demo detail page)
    }
  }

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;

    _fallbackTimer?.cancel();
    _positionDebounceTimer?.cancel();
    _postSeekCoalesceTimer?.cancel();
    _positionSubscription?.cancel();
    _playingSubscription?.cancel();
    _rateSubscription?.cancel();

    _player?.dispose();
    _player = null;
    _videoController = null;

    // Clean up temporary file
    if (_tempFilePath != null) {
      try {
        final tempFile = File(_tempFilePath!);
        if (tempFile.existsSync()) {
          tempFile.deleteSync();
        }
      } catch (_) {}
      _tempFilePath = null;
    }
  }
}
