import 'package:clones_desktop/domain/models/api/request_options.dart';
import 'package:clones_desktop/domain/models/submission/paginated_submissions.dart';
import 'package:clones_desktop/domain/models/submission/pool_submission.dart';
import 'package:clones_desktop/domain/models/submission/submission_status.dart';
import 'package:clones_desktop/utils/api_client.dart';

class SubmissionsRepositoryImpl {
  SubmissionsRepositoryImpl(this._client);
  final ApiClient _client;

  Future<SubmissionStatus> getSubmissionStatus({
    required String submissionId,
  }) async {
    try {
      return await _client.get<SubmissionStatus>(
        '/forge/submissions/$submissionId',
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) {
          return SubmissionStatus.fromJson(json as Map<String, dynamic>);
        },
      );
    } catch (e) {
      throw Exception('Failed to get submission status: $e');
    }
  }

  Future<List<SubmissionStatus>> listSubmissions() async {
    try {
      final submissions = await _client.get<List<dynamic>>(
        '/forge/submissions/user',
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => (json as List)
            .map(
              (e) => SubmissionStatus.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );
      return submissions.cast<SubmissionStatus>();
    } catch (e) {
      throw Exception('Failed to list submissions: $e');
    }
  }

  Future<PaginatedSubmissions> listSubmissionsPaginated({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final result = await _client.get<Map<String, dynamic>>(
        '/forge/submissions/user?limit=$limit&offset=$offset',
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return PaginatedSubmissions.fromJson(result);
    } catch (e) {
      throw Exception('Failed to list submissions (paginated): $e');
    }
  }

  Future<List<PoolSubmission>> getFactorySubmissions({
    required String factoryAddress,
  }) async {
    try {
      final submissions = await _client.get<List<dynamic>>(
        '/forge/submissions/pool/$factoryAddress',
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => (json as List).map((e) {
          return PoolSubmission.fromJson(e as Map<String, dynamic>);
        }).toList(),
      );
      return submissions.cast<PoolSubmission>();
    } catch (e) {
      throw Exception('Failed to get pool submissions: $e');
    }
  }

  Future<String> getDemoFile({
    required String submissionId,
    required String filename,
  }) async {
    try {
      // Use getRawText for text/plain responses (bypasses JSON parsing)
      return await _client.getRawText(
        '/forge/demo-files/$submissionId/$filename',
        options: const RequestOptions(requiresAuth: true),
      );
    } catch (e) {
      throw Exception('Failed to get demo file $filename: $e');
    }
  }

  Future<String> getDemoFileAsBase64({
    required String submissionId,
    required String filename,
  }) async {
    try {
      // Use getRawText for text/plain responses (bypasses JSON parsing)
      final base64Data = await _client.getRawText(
        '/forge/demo-files/$submissionId/$filename?asBase64=true',
        options: const RequestOptions(requiresAuth: true),
      );
      
      // Convert to proper Data URI format for video player
      if (filename.endsWith('.mp4')) {
        return 'data:video/mp4;base64,$base64Data';
      } else if (filename.endsWith('.json')) {
        return 'data:application/json;base64,$base64Data';
      } else if (filename.endsWith('.jsonl')) {
        return 'data:application/x-ndjson;base64,$base64Data';
      }
      
      // Default fallback
      return 'data:application/octet-stream;base64,$base64Data';
    } catch (e) {
      throw Exception('Failed to get demo file $filename as base64: $e');
    }
  }
}
