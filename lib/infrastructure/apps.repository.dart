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
}
