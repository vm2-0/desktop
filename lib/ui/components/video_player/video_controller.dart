import 'dart:async';

import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:flutter/foundation.dart';

/// Exception for video controller errors
class VideoControllerException implements Exception {
  VideoControllerException(this.message, [this.originalException]);
  final String message;
  final Object? originalException;

  @override
  String toString() => 'VideoControllerException: $message';
}

mixin VideoControllerMixin {
  static const Duration _initializationTimeout = Duration(seconds: 30);
  static const Duration _operationTimeout = Duration(seconds: 10);

  Future<T> _withTimeout<T>(
    Future<T> future,
    String operation, [
    Duration? timeout,
  ]) async {
    try {
      return await future.timeout(
        timeout ?? _operationTimeout,
        onTimeout: () => throw VideoControllerException(
          'Timeout during $operation after ${timeout?.inSeconds ?? _operationTimeout.inSeconds}s',
        ),
      );
    } catch (e) {
      if (e is VideoControllerException) rethrow;
      throw VideoControllerException(
        'Failed to $operation: $e',
        e,
      );
    }
  }

  Future<T> withInitializationTimeout<T>(Future<T> future, String operation) {
    return _withTimeout(future, operation, _initializationTimeout);
  }

  Future<T> withOperationTimeout<T>(Future<T> future, String operation) {
    return _withTimeout(future, operation);
  }

  Future<void> safeExecute(
    Future<void> Function() operation,
    String operationName,
    dynamic ref, [
    String? videoId,
  ]) async {
    try {
      await operation();
    } catch (e) {
      final message = e is VideoControllerException
          ? e.message
          : 'Unexpected error during $operationName: $e';

      if (kDebugMode) {
        print('VideoController Error [$operationName]: $message');
        if (e is VideoControllerException && e.originalException != null) {
          print('Original exception: ${e.originalException}');
        }
      }

      // Only set error if videoId is provided (new scoped approach)
      if (videoId != null) {
        ref
            .read(videoStateNotifierProvider(videoId).notifier)
            .setError(message);
      }
    }
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
  }
}

