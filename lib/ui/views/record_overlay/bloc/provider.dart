import 'dart:async';

import 'package:clones_desktop/infrastructure/flutter_window_manager.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/state.dart';
import 'package:clones_desktop/ui/views/record_overlay/bloc/state.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/provider.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class RecordOverlayNotifier extends _$RecordOverlayNotifier {
  RecordOverlayNotifier();

  @override
  RecordOverlayState build() {
    ref
      ..onDispose(stopTimer)
      ..listen(trainingSessionNotifierProvider, (previous, next) {
        if (next.recordingState == RecordingState.recording) {
          startTimer();
        } else {
          stopTimer();
        }
      });

    return const RecordOverlayState();
  }

  void close() {
    state = state.copyWith(close: true);
  }

  void startTimer() {
    stopTimer();
    setSeconds(0);
    state = state.copyWith(
      timer: Timer.periodic(const Duration(seconds: 1), (timer) {
        setSeconds(state.seconds + 1);

        if (state.seconds >= kMaxRecordingDuration) {
          timer.cancel();
          unawaited(
            ref
                .read(trainingSessionNotifierProvider.notifier)
                .recordingComplete(),
          );
          close();
        }
      }),
    );
  }

  void stopTimer() {
    state.timer?.cancel();
    setTimer(null);
  }

  Future<void> toggleCollapsed() async {
    state = state.copyWith(isCollapsed: !state.isCollapsed);
    if (state.isCollapsed) {
      await FlutterWindowManager.resizeWindow(
        kRecordOverlayCollapsedSize.width,
        kRecordOverlayCollapsedSize.height,
      );
    } else {
      await FlutterWindowManager.resizeWindow(
        kRecordOverlaySize.width,
        kRecordOverlaySize.height,
      );
    }
  }

  Future<void> toggleLocked() async {
    state = state.copyWith(isLocked: !state.isLocked);
    // TODO(reddwarf03): Implement this
    /*  if (state.isLocked) {
      await ref.read(tauriApiClientProvider).setResizable(false);
    } else {
      await ref.read(tauriApiClientProvider).setResizable(true);
    }*/
  }

  void setSeconds(int seconds) {
    state = state.copyWith(seconds: seconds);
  }

  void setTimer(Timer? timer) {
    state = state.copyWith(timer: timer);
  }
}
