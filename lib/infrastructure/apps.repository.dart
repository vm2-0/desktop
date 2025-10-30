import 'dart:math';

import 'package:clones_desktop/domain/models/factory/factory_app.dart';
import 'package:clones_desktop/domain/models/factory/factory_task.dart';
import 'package:clones_desktop/utils/api_client.dart';

class AppsRepositoryImpl {
  AppsRepositoryImpl(this._client);
  final ApiClient _client;

  Future<Map<String, dynamic>> generateApps({required String prompt}) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        '/forge/factories/apps',
        data: {'prompt': prompt},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to generate apps: $e');
    }
  }

  Future<List<FactoryApp>> getAppsForFactory({
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
      }

      final appsJson = await _client.get<List<dynamic>>(
        '/forge/factories/apps/',
        params: params,
      );
      final apps = appsJson
          .map((e) => FactoryApp.fromJson(e as Map<String, dynamic>))
          .toList();

      if (filter != null && filter['poolId'] != null) {
        return apps;
      }

      final shuffledApps = List<FactoryApp>.from(apps)..shuffle(Random());
      return shuffledApps
          .map(
            (app) => app.copyWith(
              tasks: List<FactoryTask>.from(app.tasks)..shuffle(Random()),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get apps for factory: $e');
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
