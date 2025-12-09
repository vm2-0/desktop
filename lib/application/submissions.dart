import 'package:clones_desktop/domain/models/submission/pool_submission.dart';
import 'package:clones_desktop/domain/models/submission/submission_status.dart';
import 'package:clones_desktop/infrastructure/submissions.repository.dart';
import 'package:clones_desktop/utils/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'submissions.g.dart';

@riverpod
SubmissionsRepositoryImpl submissionsRepository(
  Ref ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return SubmissionsRepositoryImpl(apiClient);
}

@riverpod
Future<SubmissionStatus> getSubmissionStatus(
  Ref ref, {
  required String submissionId,
}) async {
  final submissionsRepository = ref.watch(submissionsRepositoryProvider);
  return submissionsRepository.getSubmissionStatus(submissionId: submissionId);
}

@riverpod
Future<List<SubmissionStatus>> listSubmissions(
  Ref ref,
) async {
  final submissionsRepository = ref.watch(submissionsRepositoryProvider);
  return submissionsRepository.listSubmissions();
}

@riverpod
Future<List<PoolSubmission>> getFactorySubmissions(
  Ref ref,
  String factoryAddress,
) async {
  final submissionsRepository = ref.watch(submissionsRepositoryProvider);
  return submissionsRepository.getFactorySubmissions(
    factoryAddress: factoryAddress,
  );
}

@riverpod
Future<String> getDemoFile(
  Ref ref, {
  required String submissionId,
  required String filename,
}) async {
  final submissionsRepository = ref.watch(submissionsRepositoryProvider);
  return submissionsRepository.getDemoFile(
    submissionId: submissionId,
    filename: filename,
  );
}

@riverpod
Future<String> getDemoFileAsBase64(
  Ref ref, {
  required String submissionId,
  required String filename,
}) async {
  final submissionsRepository = ref.watch(submissionsRepositoryProvider);
  return submissionsRepository.getDemoFileAsBase64(
    submissionId: submissionId,
    filename: filename,
  );
}

// Metadata for pagination
class PaginationMetadata {
  PaginationMetadata({
    required this.total,
    required this.hasMore,
    required this.currentOffset,
  });

  final int total;
  final bool hasMore;
  final int currentOffset;
}

@riverpod
class PaginatedSubmissionsNotifier extends _$PaginatedSubmissionsNotifier {
  static const int pageSize = 20;

  // Store pagination metadata separately
  PaginationMetadata _metadata = PaginationMetadata(
    total: 0,
    hasMore: true,
    currentOffset: 0,
  );

  PaginationMetadata get metadata => _metadata;

  @override
  Future<List<SubmissionStatus>> build() async {
    final submissionsRepository = ref.watch(submissionsRepositoryProvider);
    final result = await submissionsRepository.listSubmissionsPaginated();

    _metadata = PaginationMetadata(
      total: result.total,
      hasMore: result.hasMore,
      currentOffset: pageSize,
    );

    return result.submissions;
  }

  Future<void> loadMore() async {
    if (!_metadata.hasMore) return;

    final currentSubmissions = state.valueOrNull ?? [];
    final submissionsRepository = ref.watch(submissionsRepositoryProvider);

    final result = await submissionsRepository.listSubmissionsPaginated(
      offset: _metadata.currentOffset,
    );

    _metadata = PaginationMetadata(
      total: result.total,
      hasMore: result.hasMore,
      currentOffset: _metadata.currentOffset + pageSize,
    );

    state = AsyncValue.data([...currentSubmissions, ...result.submissions]);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();

    final submissionsRepository = ref.watch(submissionsRepositoryProvider);
    final result = await submissionsRepository.listSubmissionsPaginated();

    _metadata = PaginationMetadata(
      total: result.total,
      hasMore: result.hasMore,
      currentOffset: pageSize,
    );

    state = AsyncValue.data(result.submissions);
  }
}
