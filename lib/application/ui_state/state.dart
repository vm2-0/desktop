import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class UiState with _$UiState {
  const factory UiState({
    @Default(false) bool isVideoFullscreen,
  }) = _UiState;
}