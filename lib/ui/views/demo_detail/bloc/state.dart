import 'package:clones_desktop/domain/models/message/sft_message.dart';
import 'package:clones_desktop/domain/models/recording/api_recording.dart';
import 'package:clones_desktop/domain/models/recording/recording_event.dart';
import 'package:clones_desktop/domain/models/video_clip.dart';
import 'package:clones_desktop/ui/components/video_player/video_source.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

const kMaxRecordingDuration = 120;

@freezed
class DemoDetailState with _$DemoDetailState {
  const factory DemoDetailState({
    @Default(false) bool isLoading,
    ApiRecording? recording,
    @Default([]) List<RecordingEvent> events,
    @Default([]) List<SftMessage> sftMessages,
    @Default({}) Set<String> eventTypes,
    @Default({}) Set<String> enabledEventTypes,
    @Default(0) int startTime,
    @JsonKey(includeIfNull: false) VideoSource? videoSource,
    String? currentVideoId,
    @Default(false) bool showTrainingSessionModal,

    // Video editing
    @Default([]) List<VideoClip> clips,
    @Default({}) Set<String> selectedClipIds,
    @JsonKey(includeIfNull: false) VideoClip? clipboardClip,
    // Each deletion operation is stored as a separate list of clips
    @Default([]) List<List<VideoClip>> deletedClipsHistory,

    // Legacy support for RangeValues (deprecated)
    @Default([]) List<RangeValues> clipSegments,
    @Default({}) Set<int> selectedClipIndexes,

    // New states for button handling
    @Default(false) bool isProcessing,
    @Default(false) bool isExporting,
    @Default(false) bool isUploading,
    @Default(false) bool showUploadConfirmModal,
    String? exportPath,
    String? exportError,
    String? uploadError,

    // AxTree overlay state
    @Default(false) bool showAxTreeOverlay,
    RecordingEvent? currentAxTreeEvent,

    // Pre-upload messages animation state
    @Default('') String firstMessage,
    @Default('') String secondMessage,
    @Default('') String thirdMessage,
    @Default(false) bool showFirstMessage,
    @Default(false) bool showSecondMessage,
    @Default(false) bool showThirdMessage,
    @Default(0) int currentTypingIndex,
    @Default(0) int currentMessageIndex,
    String? userAccessType, // 'owner' or 'factory_creator'
  }) = _DemoDetailState;
  const DemoDetailState._();
}

/// Extension to add computed properties to DemoDetailState
extension DemoDetailStateComputed on DemoDetailState {
  /// Compute which event indices are in deleted zones
  /// This is called once per state instance during UI build,
  /// avoiding repeated calculations for every event
  Set<int> get eventsInDeletedZones {
    if (deletedClipsHistory.isEmpty || events.isEmpty) {
      return {};
    }

    final deletedSet = <int>{};
    for (var i = 0; i < events.length; i++) {
      final relativeTime = (events[i].time - startTime).toDouble();
      final isDeleted = deletedClipsHistory.any(
        (operation) => operation.any((clip) => clip.contains(relativeTime)),
      );
      if (isDeleted) {
        deletedSet.add(i);
      }
    }
    return deletedSet;
  }

  /// Compute which SFT message indices are in deleted zones
  /// This is called once per state instance during UI build,
  /// avoiding repeated calculations for every message
  Set<int> get sftMessagesInDeletedZones {
    if (deletedClipsHistory.isEmpty || sftMessages.isEmpty) {
      return {};
    }

    final deletedSet = <int>{};
    for (var i = 0; i < sftMessages.length; i++) {
      final msg = sftMessages[i];
      // SFT message timestamps are already relative to video start (not absolute Unix time)
      // So we use them directly without subtracting startTime
      final messageTime = msg.timestamp.toDouble();
      final isDeleted = deletedClipsHistory.any(
        (operation) => operation.any((clip) => clip.contains(messageTime)),
      );

      if (isDeleted) {
        deletedSet.add(i);
      }
    }

    return deletedSet;
  }

  /// Get the most recent AxTree event at or before the current video position
  RecordingEvent? getAxTreeEventAtPosition(int currentTimeMs) {
    if (!showAxTreeOverlay || events.isEmpty) {
      return null;
    }

    final relativeTimeMs = currentTimeMs;

    // Find the most recent axtree event at or before the current position
    RecordingEvent? mostRecentAxTree;

    for (final event in events.reversed) {
      if (event.event == 'axtree') {
        final eventRelativeTime = event.time - startTime;
        if (eventRelativeTime <= relativeTimeMs) {
          mostRecentAxTree = event;
          break;
        }
      }
    }

    return mostRecentAxTree;
  }
}
