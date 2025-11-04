import 'dart:async';

import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/domain/models/tool_status/tool_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tool_status_provider.g.dart';

@riverpod
class ToolStatusNotifier extends _$ToolStatusNotifier {
  Timer? _pollingTimer;

  @override
  ToolStatus build() {
    // Cleanup when the provider is disposed
    ref.onDispose(() {
      _pollingTimer?.cancel();
    });

    return const ToolStatus(
      status: ToolInitStatus.idle(),
      message: 'Tools not initialized',
      progress: 0,
    );
  }

  Future<void> initializeTools() async {
    try {
      state = const ToolStatus(
        status: ToolInitStatus.starting(),
        message: 'Starting tool initialization...',
        progress: 0,
      );

      final apiClient = ref.read(tauriApiClientProvider);
      await apiClient.initTools();

      // Check tools status periodically
      _pollToolsStatus();
    } catch (e) {
      state = ToolStatus(
        status: const ToolInitStatus.error(),
        message: 'Failed to initialize tools: $e',
        progress: 0,
      );
    }
  }

  void _pollToolsStatus() {
    _scheduleNextPoll();
  }

  void _scheduleNextPoll() {
    _pollingTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final apiClient = ref.read(tauriApiClientProvider);

        // Get the detailed progress from the backend
        final progressData = await apiClient.getToolInitProgress();

        // Parse the progress data
        final statusStr = progressData['status'] as String? ?? 'idle';
        final message = progressData['message'] as String? ?? 'Unknown status';
        final progress = progressData['progress'] as int? ?? 0;

        // Update state with the received progress
        final newStatus = ToolInitStatus.fromString(statusStr);
        
        state = ToolStatus(
          status: newStatus,
          message: message,
          progress: progress,
        );

        // Stop polling if completed or error, otherwise schedule next poll
        if (newStatus == const ToolInitStatus.completed() ||
            newStatus == const ToolInitStatus.error()) {
          _pollingTimer = null;
        } else {
          // Schedule next poll
          _scheduleNextPoll();
        }
      } catch (e) {
        state = ToolStatus(
          status: const ToolInitStatus.error(),
          message: 'Failed to check tools status: $e',
          progress: 0,
        );
        _pollingTimer = null;
      }
    });
  }
}
