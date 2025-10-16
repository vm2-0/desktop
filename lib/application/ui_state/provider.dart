import 'package:clones_desktop/application/ui_state/state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class UiStateNotifier extends _$UiStateNotifier {
  @override
  UiState build() {
    return const UiState();
  }

  void setVideoFullscreen(bool isFullscreen) {
    state = state.copyWith(isVideoFullscreen: isFullscreen);
  }
}