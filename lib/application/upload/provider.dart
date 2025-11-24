import 'dart:async';

import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/application/submissions.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/application/upload.dart';
import 'package:clones_desktop/application/upload/state.dart';
import 'package:clones_desktop/domain/models/upload/upload_metadata.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadQueueProvider =
    StateNotifierProvider<UploadQueueNotifier, Map<String, UploadTaskState>>(
  UploadQueueNotifier.new,
);

class UploadQueueNotifier extends StateNotifier<Map<String, UploadTaskState>> {
  UploadQueueNotifier(this.ref) : super({});
  final Ref ref;

  void _updateTaskState(
    String recordingId,
    UploadTaskState taskState,
  ) {
    state = {
      ...state,
      recordingId: taskState,
    };
  }

  Future<void> setUploadDataAllowed(bool allowed) async {
    await ref.read(tauriApiClientProvider).setUploadDataAllowed(allowed);
    ref.invalidate(isUploadDataAllowedProvider);
  }

  Future<void> upload(
    String recordingId,
    String poolId,
    String name, {
    List<Map<String, double>>? deletedRanges,
  }) async {
    final address = ref.watch(sessionNotifierProvider).address;
    if (address == null) {
      throw Exception('Wallet address is null');
    }

    if (recordingId.isEmpty) {
      throw Exception('Recording ID is empty');
    }

    if (poolId.isEmpty) {
      throw Exception('Pool ID is empty');
    }

    final isConfirmed = await ref.read(isUploadDataAllowedProvider.future);
    if (!isConfirmed) {
      ref
          .read(demoDetailNotifierProvider.notifier)
          .setShowUploadConfirmModal(true);
      return;
    }

    _updateTaskState(
      recordingId,
      UploadTaskState(
        recordingId: recordingId,
        name: name,
        uploadStatus: UploadStatus.zipping,
      ),
    );

    final useFiltered = deletedRanges != null && deletedRanges.isNotEmpty;

    debugPrint(
      '[UploadQueueNotifier] Upload mode: ${useFiltered ? 'filtered' : 'full'}, deleted ranges: ${deletedRanges?.length ?? 0}',
    );

    final zipBytes = useFiltered
        ? await ref
            .read(tauriApiClientProvider)
            .getFilteredRecordingZip(recordingId, deletedRanges)
        : await ref.read(getRecordingZipProvider(recordingId).future);

    final chunks = _splitIntoChunks(zipBytes, 15 * 1024 * 1024);
    final totalBytes = zipBytes.length;

    _updateTaskState(
      recordingId,
      UploadTaskState(
        recordingId: recordingId,
        name: name,
        uploadStatus: UploadStatus.uploading,
        totalBytes: totalBytes,
      ),
    );

    final initResult = await ref.read(
      initUploadProvider(
        UploadMetadata(
          id: recordingId,
          poolId: poolId,
        ),
        chunks.length,
      ).future,
    );

    final uploadId = initResult['uploadId'] as String;

    _updateTaskState(
      recordingId,
      UploadTaskState(
        recordingId: recordingId,
        name: name,
        uploadId: uploadId,
        uploadStatus: UploadStatus.uploading,
        totalBytes: totalBytes,
      ),
    );

    var uploadedBytes = 0;
    for (var i = 0; i < chunks.length; i++) {
      debugPrint('uploading chunk $i of ${chunks.length}');
      final uploadProgress = await ref.read(
        uploadChunkProvider(
          uploadId: uploadId,
          chunk: chunks[i],
          chunkIndex: i,
        ).future,
      );

      uploadedBytes += chunks[i].length;

      _updateTaskState(
        recordingId,
        UploadTaskState(
          recordingId: recordingId,
          name: name,
          uploadId: uploadProgress.uploadId,
          uploadStatus: UploadStatus.uploading,
          totalBytes: totalBytes,
          uploadedBytes: uploadedBytes,
        ),
      );
    }

    final completeResult =
        await ref.read(completeUploadProvider(uploadId).future);
    final submissionId = completeResult['submissionId'] as String;

    _updateTaskState(
      recordingId,
      UploadTaskState(
        recordingId: recordingId,
        name: name,
        submissionId: submissionId,
        uploadStatus: UploadStatus.processing,
      ),
    );

    _pollSubmissionStatus(recordingId, submissionId);
  }

  void _pollSubmissionStatus(String recordingId, String submissionId) {
    const pollInterval = Duration(seconds: 5);
    const timeoutDuration = Duration(minutes: 5);
    final stopwatch = Stopwatch()..start();

    Timer.periodic(pollInterval, (timer) async {
      if (stopwatch.elapsed > timeoutDuration) {
        timer.cancel();
        _updateTaskState(
          recordingId,
          state[recordingId]!.copyWith(
            uploadStatus: UploadStatus.error,
            error: 'Processing timed out.',
          ),
        );
        return;
      }

      try {
        final submissionStatus = await ref.read(
          getSubmissionStatusProvider(
            submissionId: submissionId,
          ).future,
        );

        if (submissionStatus.status == 'completed') {
          timer.cancel();
          _updateTaskState(
            recordingId,
            state[recordingId]!.copyWith(uploadStatus: UploadStatus.done),
          );
        } else if (submissionStatus.status == 'failed') {
          timer.cancel();
          _updateTaskState(
            recordingId,
            state[recordingId]!
                .copyWith(uploadStatus: UploadStatus.error, error: 'Failed'),
          );
        } else if (submissionStatus.status == 'processing') {
          _updateTaskState(
            recordingId,
            state[recordingId]!.copyWith(uploadStatus: UploadStatus.processing),
          );
        }
      } catch (error) {
        debugPrint('Failed to get submission status: $error');
        timer.cancel();
        _updateTaskState(
          recordingId,
          state[recordingId]!.copyWith(
            uploadStatus: UploadStatus.error,
            error: error.toString(),
          ),
        );
      }
    });
  }

  void removeTask(String recordingId) {
    state = Map.from(state)..remove(recordingId);
  }

  List<Uint8List> _splitIntoChunks(Uint8List data, int chunkSize) {
    final chunks = <Uint8List>[];
    var start = 0;

    while (start < data.length) {
      final end =
          (start + chunkSize > data.length) ? data.length : start + chunkSize;
      chunks.add(Uint8List.sublistView(data, start, end));
      start = end;
    }

    return chunks;
  }
}
