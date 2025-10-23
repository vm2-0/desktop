import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:clones_desktop/application/recording.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/application/submissions.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/application/upload/provider.dart';
import 'package:clones_desktop/application/upload/state.dart';
import 'package:clones_desktop/domain/models/message/sft_message.dart';
import 'package:clones_desktop/domain/models/recording/api_recording.dart';
import 'package:clones_desktop/domain/models/recording/recording_event.dart';
import 'package:clones_desktop/domain/models/submission/submission_status.dart';
import 'package:clones_desktop/domain/models/video_clip.dart';
import 'package:clones_desktop/ui/components/video_player/video_source.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/state.dart';
import 'package:clones_desktop/utils/env.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

/// Provider to store the video seek callback
final videoSeekCallbackProvider =
    StateProvider<void Function(Duration)?>((ref) => null);

@riverpod
class DemoDetailNotifier extends _$DemoDetailNotifier {
  File? _tempVideoFile;
  Timer? _typingTimer;

  @override
  DemoDetailState build() {
    ref.onDispose(() {
      _typingTimer?.cancel();
      // Clean up temporary file if it exists
      _tempVideoFile?.deleteSync();
    });
    return const DemoDetailState();
  }

  Future<void> loadRecording(String recordingId) async {
    state = state.copyWith(
      isLoading: true,
      events: [],
      sftMessages: [],
      eventTypes: {},
      enabledEventTypes: {},
      startTime: 0,
      videoSource: null,
      clips: [],
      selectedClipIds: {},
      clipboardClip: null,
      deletedClipsHistory: [],
      currentAxTreeEvent: null,
    );

    // Start pre-upload animation when recording is loaded
    startPreUploadAnimation();

    try {
      var recordings = await ref.read(mergedRecordingsProvider.future);
      var recording =
          recordings.firstWhereOrNull((element) => element.id == recordingId);

      // If recording not found, refresh providers and try again
      if (recording == null) {
        ref
          ..invalidate(listRecordingsProvider)
          ..invalidate(mergedRecordingsProvider);
        recordings = await ref.read(mergedRecordingsProvider.future);
        recording =
            recordings.firstWhere((element) => element.id == recordingId);
      }

      state = state.copyWith(
        recording: recording,
        userAccessType: 'owner',
      );

      // Now load other data separately to avoid one failure stopping others
      await loadEvents(recordingId);
      await loadSftData(recordingId);
      await initializeVideoPlayer(recordingId);

      state = state.copyWith(isLoading: false);
    } catch (_) {}
    state = state.copyWith(isLoading: false);
  }

  Future<void> loadPoolSubmission(
    String submissionId,
    String factoryAddress,
  ) async {
    state = state.copyWith(
      isLoading: true,
      events: [],
      sftMessages: [],
      eventTypes: {},
      enabledEventTypes: {},
      startTime: 0,
      videoSource: null,
      clips: [],
      selectedClipIds: {},
      clipboardClip: null,
      deletedClipsHistory: [],
      currentAxTreeEvent: null,
    );

    // Start pre-upload animation when recording is loaded
    startPreUploadAnimation();

    try {
      // Try to find the PoolSubmission and convert it to ApiRecording
      final factorySubmissions =
          await ref.read(getFactorySubmissionsProvider(factoryAddress).future);
      final poolSubmission =
          factorySubmissions.firstWhereOrNull((s) => s.id == submissionId);

      if (poolSubmission != null) {
        // Convert PoolSubmission to SubmissionStatus format for ApiRecording
        final submissionStatus = SubmissionStatus(
          id: poolSubmission.id,
          meta: poolSubmission.meta,
          status: poolSubmission.status,
          createdAt: poolSubmission.createdAt,
          updatedAt: poolSubmission.updatedAt,
          gradeResult: poolSubmission.gradeResult,
          maxReward: poolSubmission.maxReward,
          reward: poolSubmission.reward,
          clampedScore: poolSubmission.clampedScore?.toInt(),
          claimAuthorization: poolSubmission.claimAuthorization,
        );

        // Convert to ApiRecording format
        final recording = ApiRecording(
          id: poolSubmission.meta.id,
          timestamp: poolSubmission.meta.timestamp,
          durationSeconds: poolSubmission.meta.durationSeconds,
          status: poolSubmission.meta.status,
          title: poolSubmission.meta.title,
          description: poolSubmission.meta.description,
          platform: poolSubmission.meta.platform,
          arch: poolSubmission.meta.arch,
          version: poolSubmission.meta.version,
          locale: poolSubmission.meta.locale,
          primaryMonitor: poolSubmission.meta.primaryMonitor,
          demonstration: poolSubmission.meta.demonstration,
          submission: submissionStatus,
          location: 'cloud',
        );

        state = state.copyWith(
          recording: recording,
          userAccessType: 'factory_creator',
        );

        // Load other data
        await loadEvents(submissionId);
        await loadSftData(submissionId);
        await initializeVideoPlayer(submissionId);
      } else {
        // If not found, try with the regular loadRecording method
        await loadRecording(submissionId);
      }
    } catch (_) {
      // Fallback to regular loadRecording if pool submission fails
      try {
        await loadRecording(submissionId);
      } catch (_) {}
    }
    state = state.copyWith(isLoading: false);
  }

  Future<void> initializeVideoPlayer(String recordingId) async {
    // Clear any existing video state first
    state = state.copyWith(
      videoSource: null,
    );

    // Get fresh recording data to avoid stale state
    // First check if we have a recording in current state (for factory submissions)
    var recording = state.recording;

    // If not, get from merged recordings (for regular recordings)
    if (recording == null) {
      final recordings = await ref.read(mergedRecordingsProvider.future);
      recording =
          recordings.firstWhereOrNull((element) => element.id == recordingId);
    }

    // Check if the recording is local or cloud
    if (recording?.location == 'local') {
      await _initializeVideoFromLocal(recordingId);
    } else if (recording?.location == 'cloud') {
      await _initializeVideoFromCloud();
    }
    // For other cases, keep video state null
  }

  Future<void> _initializeVideoFromLocal(String recordingId) async {
    try {
      final videoData = await ref.read(tauriApiClientProvider).getRecordingFile(
            recordingId: recordingId,
            filename: 'recording.mp4',
            asBase64: true,
          );

      await _createVideoSource(videoData);
    } catch (e) {
      debugPrint('Error loading local video: $e');
      // This is expected for recordings without video files
    }
  }

  Future<void> _initializeVideoFromCloud() async {
    final submissionId = state.recording?.submission?.id;
    if (submissionId == null) return;

    try {
      final videoData = await ref.read(
        getDemoFileAsBase64Provider(
          submissionId: submissionId,
          filename: 'recording.mp4',
        ).future,
      );

      await _createVideoSource(videoData);
    } catch (e) {
      debugPrint('Error loading cloud video: $e');
      // Video might not exist or not accessible
    }
  }

  Future<void> _createVideoSource(String videoData) async {
    // Create VideoSource for your custom video player system
    final videoSource = Base64VideoSource(videoData);

    // Force a complete refresh by setting videoSource to null first
    state = state.copyWith(
      videoSource: null,
    );

    // Small delay to ensure UI detects the change
    await Future.delayed(const Duration(milliseconds: 100));

    state = state.copyWith(
      videoSource: videoSource,
    );
  }

  /// Store the current video ID for access from other widgets
  void setCurrentVideoId(String videoId) {
    state = state.copyWith(currentVideoId: videoId);
  }

  Future<void> loadEvents(String recordingId) async {
    // Check if the recording is local or cloud
    if (state.recording?.location == 'local') {
      await _loadEventsFromLocal(recordingId);
    } else if (state.recording?.location == 'cloud') {
      await _loadEventsFromCloud();
    } else {
      // Default to empty
      state = state.copyWith(
        events: [],
        eventTypes: {},
        enabledEventTypes: {},
        startTime: 0,
      );
    }
  }

  Future<void> _loadEventsFromLocal(String recordingId) async {
    try {
      final eventsJsonl =
          await ref.read(tauriApiClientProvider).getRecordingFile(
                recordingId: recordingId,
                filename: 'input_log.jsonl',
              );
      await _parseEventsData(eventsJsonl);
    } catch (e) {
      // It's okay if this fails, the file might not exist
      state = state.copyWith(
        events: [],
        eventTypes: {},
        enabledEventTypes: {},
        startTime: 0,
      );
    }
  }

  Future<void> _loadEventsFromCloud() async {
    final submissionId = state.recording?.submission?.id;
    if (submissionId == null) {
      state = state.copyWith(
        events: [],
        eventTypes: {},
        enabledEventTypes: {},
        startTime: 0,
      );
      return;
    }

    try {
      final eventsJsonl = await ref.read(
        getDemoFileProvider(
          submissionId: submissionId,
          filename: 'input_log.jsonl',
        ).future,
      );
      await _parseEventsData(eventsJsonl);
    } catch (e) {
      // File might not exist or not accessible
      state = state.copyWith(
        events: [],
        eventTypes: {},
        enabledEventTypes: {},
        startTime: 0,
      );
    }
  }

  Future<void> _parseEventsData(String eventsJsonl) async {
    final events = eventsJsonl
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .map((line) {
          try {
            return RecordingEvent.fromJson(jsonDecode(line));
          } catch (e) {
            return null;
          }
        })
        .where((item) => item != null)
        .cast<RecordingEvent>()
        .toList()

      // Sort events by time
      ..sort((a, b) => a.time.compareTo(b.time));

    final eventTypes = events.map((e) => e.event).toSet();
    final startTime = events.isNotEmpty ? events.first.time : 0;

    // Disable axtree and ffmpeg_stderr by default
    final filteredEventTypes = eventTypes
        .where((type) => type != 'axtree' && type != 'ffmpeg_stderr')
        .toSet();

    state = state.copyWith(
      events: events,
      eventTypes: eventTypes,
      enabledEventTypes: filteredEventTypes,
      startTime: startTime,
    );
  }

  Future<void> loadSftData(String recordingId) async {
    state = state.copyWith(sftMessages: []);

    // Check if the recording is local or cloud
    if (state.recording?.location == 'local') {
      await _loadSftDataFromLocal(recordingId);
    } else if (state.recording?.location == 'cloud') {
      await _loadSftDataFromCloud();
    }
    // For other cases, keep empty list
  }

  Future<void> _loadSftDataFromLocal(String recordingId) async {
    try {
      final sftJson = await ref.read(tauriApiClientProvider).getRecordingFile(
            recordingId: recordingId,
            filename: 'sft.json',
          );
      await _parseSftData(sftJson);
    } catch (e) {
      // SFT file might not exist, continue with empty messages
    }
  }

  Future<void> _loadSftDataFromCloud() async {
    final submissionId = state.recording?.submission?.id;
    if (submissionId == null) return;

    try {
      final sftJson = await ref.read(
        getDemoFileProvider(
          submissionId: submissionId,
          filename: 'sft.json',
        ).future,
      );
      await _parseSftData(sftJson);
    } catch (e) {
      // File might not exist or not accessible
    }
  }

  Future<void> _parseSftData(String sftJson) async {
    final sftData = jsonDecode(sftJson) as List<dynamic>;
    final sftMessages =
        sftData.map((data) => SftMessage.fromJson(data)).toList();
    state = state.copyWith(sftMessages: sftMessages);
  }

  void toggleEventType(String eventType) {
    final newEnabledTypes = Set<String>.from(state.enabledEventTypes);
    if (newEnabledTypes.contains(eventType)) {
      newEnabledTypes.remove(eventType);
    } else {
      newEnabledTypes.add(eventType);
    }
    state = state.copyWith(enabledEventTypes: newEnabledTypes);
  }

  // --- Video Editing Logic ---

  // Build clips from current video duration when first requested
  void initializeClips(Duration totalDuration) {
    if (state.clips.isNotEmpty) return;
    final durationMs = totalDuration.inMilliseconds.toDouble();
    if (durationMs <= 0) return;

    final initialClip = VideoClip.create(start: 0, end: durationMs);

    state = state.copyWith(
      clips: [initialClip],
      selectedClipIds: <String>{},
      // Keep legacy compatibility
      clipSegments: [RangeValues(0, durationMs)],
      selectedClipIndexes: <int>{},
    );
  }

  void selectClip(int index, {bool toggle = false, bool additive = false}) {
    if (index < 0 || index >= state.clips.length) return;

    final clipId = state.clips[index].id;
    final current = Set<String>.from(state.selectedClipIds);
    final currentIndexes = Set<int>.from(state.selectedClipIndexes);

    if (toggle) {
      if (current.contains(clipId)) {
        current.remove(clipId);
        currentIndexes.remove(index);
      } else {
        current.add(clipId);
        currentIndexes.add(index);
      }
    } else if (additive) {
      current.add(clipId);
      currentIndexes.add(index);
    } else {
      current
        ..clear()
        ..add(clipId);
      currentIndexes
        ..clear()
        ..add(index);
    }

    state = state.copyWith(
      selectedClipIds: current,
      selectedClipIndexes: currentIndexes, // Keep legacy
    );
  }

  void clearSelection() {
    if (state.selectedClipIds.isEmpty) return;
    state = state.copyWith(
      selectedClipIds: <String>{},
      selectedClipIndexes: <int>{}, // Keep legacy
    );
  }

  void splitClipAt(double positionMs) {
    final clips = [...state.clips];
    if (clips.isEmpty) {
      return;
    }

    // Find the clip that contains position
    final clipIndex = clips.indexWhere((c) => c.contains(positionMs));
    if (clipIndex == -1) return;

    final clip = clips[clipIndex];
    if (!clip.canSplitAt(positionMs)) return;

    // Split the clip
    final (leftClip, rightClip) = clip.splitAt(positionMs);

    // Replace the original clip with the two new clips
    clips
      ..removeAt(clipIndex)
      ..insertAll(clipIndex, [leftClip, rightClip]);

    state = state.copyWith(
      clips: clips,
      selectedClipIds: {rightClip.id}, // Select the right-side clip
      // Keep legacy compatibility
      clipSegments: clips.map((c) => c.toRangeValues()).toList(),
      selectedClipIndexes: {clipIndex + 1}, // Select right clip index
    );
  }

  void deleteSelectedClips() {
    if (state.selectedClipIds.isEmpty) return;

    // Save deleted clips for undo as a new operation
    final deletedClips = <VideoClip>[];
    final remaining = <VideoClip>[];

    for (final clip in state.clips) {
      if (state.selectedClipIds.contains(clip.id)) {
        deletedClips.add(clip);
      } else {
        remaining.add(clip);
      }
    }

    // Add this deletion operation to the history stack
    final newHistory = [...state.deletedClipsHistory, deletedClips];

    state = state.copyWith(
      clips: remaining,
      selectedClipIds: <String>{},
      deletedClipsHistory: newHistory,
      // Keep legacy for compatibility
      clipSegments: remaining.map((c) => c.toRangeValues()).toList(),
      selectedClipIndexes: <int>{},
    );
  }

  void undoDelete(double clickTimeMs) {
    if (state.deletedClipsHistory.isEmpty) return;

    // Find which deletion operation contains the clicked position
    var operationIndex = -1;
    for (var i = 0; i < state.deletedClipsHistory.length; i++) {
      final operation = state.deletedClipsHistory[i];
      if (operation.any((clip) => clip.contains(clickTimeMs))) {
        operationIndex = i;
        break;
      }
    }

    if (operationIndex == -1) return;

    // Restore only the clips from this specific operation
    final clipsToRestore = state.deletedClipsHistory[operationIndex];
    final restoredClips = [...state.clips, ...clipsToRestore]
      ..sort((a, b) => a.start.compareTo(b.start));

    // Remove this operation from history
    final newHistory = [...state.deletedClipsHistory]..removeAt(operationIndex);

    state = state.copyWith(
      clips: restoredClips,
      deletedClipsHistory: newHistory,
      // Keep legacy for compatibility
      clipSegments: restoredClips.map((c) => c.toRangeValues()).toList(),
    );
  }

  /// Check if a position is in a deleted zone
  bool isPositionInDeletedZone(double positionMs) {
    return state.deletedClipsHistory
        .expand((operation) => operation)
        .any((clip) => clip.contains(positionMs));
  }

  /// Find the next valid (non-deleted) position after the given position
  /// Returns null if there's no valid position after (end of video)
  double? getNextValidPosition(double positionMs) {
    if (state.clips.isEmpty) return null;

    // Find the first clip that starts after the current position
    final nextClip =
        state.clips.where((clip) => clip.start > positionMs).fold<VideoClip?>(
              null,
              (min, clip) => min == null || clip.start < min.start ? clip : min,
            );

    return nextClip?.start;
  }

  /// Adjust a seek position to avoid deleted zones
  /// If the position is in a deleted zone, move to the start of the next valid clip
  double adjustSeekPositionToValidZone(double positionMs) {
    if (!isPositionInDeletedZone(positionMs)) {
      return positionMs;
    }

    // Position is in a deleted zone, find the next valid position
    final nextValid = getNextValidPosition(positionMs);
    if (nextValid != null) {
      return nextValid;
    }

    // No valid position after, go to the start of the last valid clip
    if (state.clips.isNotEmpty) {
      return state.clips.last.start;
    }

    return positionMs; // Fallback
  }

  // --- Modal Management ---

  void setShowTrainingSessionModal(bool show) {
    state = state.copyWith(showTrainingSessionModal: show);
  }

  void setShowUploadConfirmModal(bool show) {
    state = state.copyWith(showUploadConfirmModal: show);
  }

  // --- AxTree Overlay Management ---

  void toggleAxTreeOverlay() {
    state = state.copyWith(showAxTreeOverlay: !state.showAxTreeOverlay);
  }

  void setShowAxTreeOverlay(bool show) {
    state = state.copyWith(showAxTreeOverlay: show);
  }

  void updateAxTreeForCurrentTime(int currentTimeMs) {
    if (!state.showAxTreeOverlay) {
      return;
    }
    final axTreeEvent = state.getAxTreeEventAtPosition(currentTimeMs);
    if (axTreeEvent != state.currentAxTreeEvent) {
      state = state.copyWith(currentAxTreeEvent: axTreeEvent);
    }
  }

  Future<void> confirmUploadPermission() async {
    try {
      await ref.read(uploadQueueProvider.notifier).setUploadDataAllowed(true);
      state = state.copyWith(showUploadConfirmModal: false);
      // Retry the upload
      await uploadRecording();
    } catch (e) {
      state = state.copyWith(
        uploadError: e.toString(),
        showUploadConfirmModal: false,
      );
    }
  }

  Future<void> onDemoRecordingCompleted(String recordingId) async {
    // Close modal and load the new recording
    state = state.copyWith(showTrainingSessionModal: false);

    // Invalidate recording providers to force refresh
    ref
      ..invalidate(listRecordingsProvider)
      ..invalidate(mergedRecordingsProvider);

    // Small delay to ensure files are written to disk
    await Future.delayed(const Duration(milliseconds: 100));
    await loadRecording(recordingId);
  }

  // --- Button Actions ---
  Future<void> processRecording() async {
    final recordingId = state.recording?.id;
    if (recordingId == null || state.isProcessing) return;

    debugPrint(
      '[DemoDetail] Starting processRecording, setting isProcessing = true',
    );
    state = state.copyWith(isProcessing: true);

    try {
      // Get connect token from session
      final connectToken =
          ref.read(sessionNotifierProvider.select((s) => s.connectionToken));

      debugPrint('[DemoDetail] Calling backend API processRecording...');
      await ref.read(tauriApiClientProvider).processRecording(
            recordingId,
            connectToken: connectToken,
            backendUrl: Env.apiBackendUrl,
          );
      debugPrint('[DemoDetail] Backend API processRecording completed');

      // After processing, we might need to reload some data, e.g., sft.json
      await loadSftData(recordingId);
    } catch (e) {
      debugPrint('[DemoDetail] processRecording error: $e');
      // TODO(reddwarf03): handle error
    } finally {
      debugPrint(
        '[DemoDetail] Finished processRecording, setting isProcessing = false',
      );
      state = state.copyWith(isProcessing: false);
    }
  }

  static const String fullFirstMessage =
      'Now that your demo has been recorded, feel free to edit out anything you find sensitive. You can also trim parts that feel too long, unnecessary, or where mistakes happened. The more polished your demo is, the better your score will be!';
  static const String fullSecondMessage =
      "Once you're happy with your demo, just click Analyse demo and then Upload to send it to the Clones Quality Agent for scoring.";
  static const String fullThirdMessage =
      'Your demo is now being uploaded and reviewed by the Clones Quality Agent. This may take a little while...';

  static const Duration typingInterval = Duration(milliseconds: 30);
  static const Duration messageDelay = Duration(milliseconds: 500);

  void startPreUploadAnimation() {
    if (state.showFirstMessage) return; // Already started

    state = state.copyWith(
      showFirstMessage: true,
      currentMessageIndex: 0,
      currentTypingIndex: 0,
      firstMessage: '',
      secondMessage: '',
      thirdMessage: '',
    );
    _startTypingTimer();
  }

  void _startTypingTimer() {
    if (_typingTimer?.isActive == true) return;

    _typingTimer = Timer.periodic(typingInterval, (timer) {
      updateTypingAnimation();

      // Check if current message is complete
      final isComplete = _isCurrentMessageComplete();

      if (isComplete) {
        timer.cancel();

        if (state.currentMessageIndex == 0) {
          // Start second message after delay
          Timer(messageDelay, _startTypingTimer);
        }
      }
    });
  }

  bool _isCurrentMessageComplete() {
    final messageIndex = state.currentMessageIndex;
    final currentIndex = state.currentTypingIndex;

    String fullMessage;
    switch (messageIndex) {
      case 0:
        fullMessage = fullFirstMessage;
        break;
      case 1:
        fullMessage = fullSecondMessage;
        break;
      case 2:
        fullMessage = fullThirdMessage;
        break;
      default:
        return true;
    }

    return currentIndex >= fullMessage.length;
  }

  void updateTypingAnimation() {
    final currentIndex = state.currentTypingIndex;
    final messageIndex = state.currentMessageIndex;

    String fullMessage;
    switch (messageIndex) {
      case 0:
        fullMessage = fullFirstMessage;
        break;
      case 1:
        fullMessage = fullSecondMessage;
        break;
      case 2:
        fullMessage = fullThirdMessage;
        break;
      default:
        return;
    }

    if (currentIndex < fullMessage.length) {
      final currentText = fullMessage.substring(0, currentIndex + 1);

      switch (messageIndex) {
        case 0:
          state = state.copyWith(
            firstMessage: currentText,
            currentTypingIndex: currentIndex + 1,
          );
          break;
        case 1:
          state = state.copyWith(
            secondMessage: currentText,
            currentTypingIndex: currentIndex + 1,
          );
          break;
        case 2:
          state = state.copyWith(
            thirdMessage: currentText,
            currentTypingIndex: currentIndex + 1,
          );
          break;
      }
    } else {
      // Current message complete
      if (messageIndex == 0) {
        // Start second message after delay
        state = state.copyWith(
          showSecondMessage: true,
          currentMessageIndex: 1,
          currentTypingIndex: 0,
        );
      }
    }
  }

  void startThirdMessageAnimation() {
    _typingTimer?.cancel();
    state = state.copyWith(
      showThirdMessage: true,
      currentMessageIndex: 2,
      currentTypingIndex: 0,
      thirdMessage: '',
    );
    _startTypingTimer();
  }

  Future<void> uploadRecording() async {
    final recordingId = state.recording?.id;
    if (recordingId == null || state.isUploading) return;

    state = state.copyWith(isUploading: true, uploadError: null);

    // Start third message animation when upload begins
    startThirdMessageAnimation();

    try {
      final demonstrationTitle = state.recording?.title ?? 'Unknown';

      late ProviderSubscription<Map<String, UploadTaskState>> sub;
      sub = ref.listen<Map<String, UploadTaskState>>(uploadQueueProvider,
          (previous, next) async {
        final uploadState = next[recordingId];
        if (uploadState == null) return;

        if (uploadState.uploadStatus == UploadStatus.done) {
          sub.close();
          state = state.copyWith(isUploading: false);

          // Invalidate recording providers to force refresh of cached data
          ref
            ..invalidate(listRecordingsProvider)
            ..invalidate(mergedRecordingsProvider);

          // Delete the recording from the local filesystem
          await ref
              .read(deleteRecordingProvider(recordingId: recordingId).future);

          // Wait a bit to ensure file deletion is complete
          await Future.delayed(const Duration(milliseconds: 500));

          // Force invalidation again after deletion to ensure fresh data
          ref
            ..invalidate(listRecordingsProvider)
            ..invalidate(mergedRecordingsProvider);

          // Reload recording to get updated submission data (this also calls initializeVideoPlayer)
          await loadRecording(recordingId);
        } else if (uploadState.uploadStatus == UploadStatus.error) {
          sub.close();
          state = state.copyWith(
            isUploading: false,
            uploadError: uploadState.error ?? 'Upload failed',
          );
        }
      });

      // Start the upload by calling the upload method
      // We need to find the poolId from the recording's demonstration
      final poolId = state.recording?.demonstration?.poolId ?? 'unknown';

      // Pass deleted segments to upload for filtering
      final deletedRanges = state.deletedClipsHistory
          .expand((operation) => operation)
          .map((clip) => {'start': clip.start, 'end': clip.end})
          .toList();

      await ref.read(uploadQueueProvider.notifier).upload(
            recordingId,
            poolId,
            demonstrationTitle,
            deletedRanges: deletedRanges,
          );
    } catch (e) {
      if (e.toString().contains('Upload data is not allowed')) {
        state = state.copyWith(
          showUploadConfirmModal: true,
          isUploading: false,
        );
        return;
      }
      state = state.copyWith(
        isUploading: false,
        uploadError: e.toString(),
      );
    }
  }
}
