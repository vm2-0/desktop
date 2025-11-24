import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

const kRecordOverlaySize = Size(300, 500);
const kRecordOverlayCollapsedSize = Size(300, 80);

@freezed
class RecordOverlayState with _$RecordOverlayState {
  const factory RecordOverlayState({
    @Default(null) Timer? timer,
    @Default(0) int seconds,
    @Default(false) bool isLocked,
    @Default(false) bool isCollapsed,
    @Default(true) bool focused,
    @Default(false) bool close,
  }) = _RecordOverlayState;
  const RecordOverlayState._();
}
