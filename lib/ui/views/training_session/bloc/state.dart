import 'package:clones_desktop/domain/app_info.dart';
import 'package:clones_desktop/domain/models/demonstration/demonstration.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/domain/models/factory/workflow_task.dart';
import 'package:clones_desktop/domain/models/message/message.dart';
import 'package:clones_desktop/domain/models/message/typing_message.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

enum RecordingState { off, starting, recording, stopping, saved }

@freezed
class TrainingSessionState with _$TrainingSessionState {
  const factory TrainingSessionState({
    String? prompt,
    Factory? factory,
    WorkflowTask? factoryTask,
    Demonstration? recordedDemonstration,
    Demonstration? recordingDemonstration,
    @Default(false) bool recordingProcessing,
    @Default(false) bool showUploadConfirmModal,
    String? currentRecordingId,
    @Default(false) bool isUploading,
    Size? originalWindowSize,
    @Default(RecordingState.off) RecordingState recordingState,
    @Default([]) List<Message> chatMessages,
    @Default(null) TypingMessage? typingMessage,
    @Default(false) bool isWaitingForResponse,
    @Default(0) int scrollToBottomNonce,
    @Default(false) bool hasGivenUp,
  }) = _TrainingSessionState;
  const TrainingSessionState._();
}

@freezed
class ReplayGroupItem with _$ReplayGroupItem implements ChatItem {
  const factory ReplayGroupItem({
    required List<SingleMessageItem> messages,
  }) = _ReplayGroupItem;
}

@freezed
class SingleMessageItem with _$SingleMessageItem implements ChatItem {
  const factory SingleMessageItem({
    required Message message,
    required int index,
  }) = _SingleMessageItem;
}

abstract class ChatItem {}
