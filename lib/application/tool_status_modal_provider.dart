import 'package:flutter_riverpod/flutter_riverpod.dart';

final toolStatusModalProvider =
    StateNotifierProvider<ToolStatusModalNotifier, bool>((ref) {
  return ToolStatusModalNotifier();
});

class ToolStatusModalNotifier extends StateNotifier<bool> {
  ToolStatusModalNotifier() : super(false);

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}
