import 'package:clones_desktop/application/submissions.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/domain/models/recording/api_recording.dart';
import 'package:clones_desktop/domain/models/recording/monitor_info.dart';
import 'package:clones_desktop/domain/models/recording/recording_meta.dart'
    as rec_meta;
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recording.g.dart';

@riverpod
Future<List<rec_meta.RecordingMeta>> listRecordings(Ref ref) async {
  final tauriApiClient = ref.watch(tauriApiClientProvider);
  return tauriApiClient.listRecordings();
}

@riverpod
Future<void> writeRecordingFile(
  Ref ref, {
  required String recordingId,
  required String filename,
  required String content,
}) async {
  final tauriApiClient = ref.watch(tauriApiClientProvider);
  await tauriApiClient.writeRecordingFile(
    recordingId: recordingId,
    filename: filename,
    content: content,
  );
}

@riverpod
Future<String> getRecordingFile(
  Ref ref, {
  required String recordingId,
  required String filename,
}) async {
  final tauriApiClient = ref.watch(tauriApiClientProvider);
  return tauriApiClient.getRecordingFile(
    recordingId: recordingId,
    filename: filename,
  );
}

@riverpod
Future<void> deleteRecording(Ref ref, {required String recordingId}) async {
  final tauriApiClient = ref.watch(tauriApiClientProvider);
  await tauriApiClient.deleteRecording(recordingId);
}

// TODO(reddwarf03): To test
@riverpod
Future<List<ApiRecording>> mergedRecordings(Ref ref) async {
  final submissions = await ref.watch(listSubmissionsProvider.future);
  final localRecordings = await ref.watch(listRecordingsProvider.future);

  final result = <ApiRecording>[];

  // 1. Add remote-only recordings (cloud)
  final remoteOnlySubmissions = submissions
      .where((s) => !localRecordings.any((r) => r.id == s.meta.id))
      .toList();

  result
    ..addAll(
      remoteOnlySubmissions.map(
        (s) {
          final meta = s.meta;
          return ApiRecording(
            id: meta.id,
            timestamp: meta.timestamp,
            durationSeconds: meta.durationSeconds,
            status: meta.status,
            title: meta.title,
            description: meta.description,
            platform: meta.platform,
            arch: meta.arch,
            version: meta.version,
            locale: meta.locale,
            primaryMonitor: meta.primaryMonitor,
            demonstration: meta.demonstration,
            submission: s,
            location: 'cloud',
          );
        },
      ),
    )

    // 2. Add local recordings with priority logic
    ..addAll(
      localRecordings.map(
        (rec) {
          final submission =
              submissions.firstWhereOrNull((s) => s.meta.id == rec.id);

          // If submission exists and has been successfully uploaded (completed status),
          // use backend data as source of truth
          if (submission != null &&
              (submission.status == 'completed' ||
                  submission.status == 'processing')) {
            final meta = submission.meta;
            return ApiRecording(
              schemaVersion: meta.schemaVersion,
              id: meta.id,
              timestamp: meta.timestamp,
              durationSeconds: meta.durationSeconds,
              status: meta.status,
              title: meta.title,
              description: meta.description,
              platform: meta.platform,
              arch: meta.arch,
              version: meta.version,
              locale: meta.locale,
              keyboardLayout: meta.keyboardLayout,
              primaryMonitor: meta.primaryMonitor,
              demonstration: meta.demonstration,
              submission: submission,
              location: 'cloud',
            );
          }

          // Otherwise, use local data (not uploaded yet or upload failed)
          return ApiRecording(
            schemaVersion: rec.schemaVersion,
            id: rec.id,
            timestamp: rec.timestamp,
            durationSeconds: rec.durationSeconds,
            status: submission?.meta.status ?? rec.status,
            title: rec.title,
            description: rec.description,
            platform: rec.platform,
            arch: rec.arch,
            version: rec.version,
            locale: rec.locale,
            keyboardLayout: rec.keyboardLayout,
            primaryMonitor:
                rec.primaryMonitor ?? const MonitorInfo(width: 0, height: 0),
            demonstration: rec.demonstration,
            submission: submission,
            location: 'local',
          );
        },
      ),
    );

  return result;
}
