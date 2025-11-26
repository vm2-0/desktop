import 'package:clones_desktop/domain/models/api/request_options.dart';
import 'package:clones_desktop/domain/models/factory/workflow_task.dart';
import 'package:clones_desktop/utils/api_client.dart';

class AppsRepositoryImpl {
  AppsRepositoryImpl(this._client);
  final ApiClient _client;

  /// Generate workflow tasks using new tasks-first endpoint
  Future<Map<String, dynamic>> generateWorkflows({
    required String prompt,
    String? factoryId,
  }) async {
    try {
      final data = <String, dynamic>{'prompt': prompt};
      if (factoryId != null) {
        data['factoryId'] = factoryId;
      }

      final response = await _client.post<Map<String, dynamic>>(
        '/forge/factories/apps/workflows',
        data: data,
        options: const RequestOptions(requiresAuth: true),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to generate workflows: $e');
    }
  }

  /// Get tasks directly (preferred method for tasks-first architecture)
  Future<List<WorkflowTask>> getTasksForFactory({
    Map<String, dynamic>? filter,
  }) async {
    try {
      final params = <String, dynamic>{};

      if (filter != null) {
        if (filter['poolId'] != null) params['pool_id'] = filter['poolId'];
        if (filter['categories'] != null) {
          params['categories'] = filter['categories'].join(',');
        }
        if (filter['query'] != null) params['query'] = filter['query'];
        if (filter['hideAdult'] != null) {
          params['hide_adult'] = filter['hideAdult'];
        }
      }

      final tasksJson = await _client.get<List<dynamic>>(
        '/forge/factories/apps/tasks',
        params: params,
      );

      return tasksJson
          .map((e) => WorkflowTask.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get tasks for factory: $e');
    }
  }

  Future<List<String>> getFactoryCategories() async {
    try {
      final categories = await _client.get<List<dynamic>>(
        '/forge/factories/apps/categories',
      );
      return categories.cast<String>();
    } catch (e) {
      throw Exception('Failed to get factory categories: $e');
    }
  }

  /// Get alternative apps for a given app name or domain
  Future<List<Map<String, dynamic>>> getAppAlternatives({
    required String identifier,
    List<String>? categories,
  }) async {
    try {
      final params = <String, dynamic>{};
      if (categories != null && categories.isNotEmpty) {
        params['categories'] = categories.join(',');
      }

      final alternatives = await _client.get<List<dynamic>>(
        '/forge/factories/apps/alternatives/$identifier',
        params: params,
      );

      return alternatives.cast<Map<String, dynamic>>();
    } catch (e) {
      // If 404, it means no alternatives exist - return empty list
      if (e.toString().contains('404')) {
        return [];
      }
      throw Exception('Failed to get app alternatives: $e');
    }
  }

  /// Increment usage count for an app (tracking popular apps)
  Future<void> incrementAppUsage({required String identifier}) async {
    try {
      await _client.post<Map<String, dynamic>>(
        '/forge/factories/apps/increment-usage/$identifier',
      );
    } catch (e) {
      // Silent fail - usage tracking is not critical
    }
  }
}
