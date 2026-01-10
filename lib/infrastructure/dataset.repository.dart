import 'package:clones_desktop/domain/models/api/request_options.dart';
import 'package:clones_desktop/domain/models/dataset/dataset.dart';
import 'package:clones_desktop/utils/api_client.dart';

abstract class DatasetRepository {
  Future<Dataset> createDataset(CreateDatasetRequest request);
  Future<Dataset> getDataset(String datasetId);
  Future<List<Dataset>> getDatasets({
    int page = 1,
    int limit = 20,
    String? filter,
    String? category,
    String? search,
    String? factoryId,
  });
}

/// Repository for Dataset operations - integrated with Data Marketplace API
class DatasetRepositoryImpl implements DatasetRepository {
  const DatasetRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  /// Create a new dataset
  @override
  Future<Dataset> createDataset(CreateDatasetRequest request) async {
    try {
      final responseData = await _apiClient.post<Map<String, dynamic>>(
        '/datamarketplace/datasets',
        data: request.toJson(),
        options: const RequestOptions(requiresAuth: true),
      );

      final response = CreateDatasetResponse.fromJson(responseData);
      return response.dataset;
    } catch (e) {
      throw Exception('Failed to create dataset: $e');
    }
  }

  /// Get dataset by ID
  @override
  Future<Dataset> getDataset(String datasetId) async {
    try {
      final responseData = await _apiClient.get<Map<String, dynamic>>(
        '/datamarketplace/datasets/$datasetId',
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return Dataset.fromJson(responseData);
    } catch (e) {
      throw Exception('Failed to get dataset: $e');
    }
  }

  /// Get list of datasets with filtering
  @override
  Future<List<Dataset>> getDatasets({
    int page = 1,
    int limit = 20,
    String? filter,
    String? category,
    String? search,
    String? factoryId,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (filter != null) queryParams['filter'] = filter;
      if (category != null) queryParams['category'] = category;
      if (search != null) queryParams['search'] = search;
      if (factoryId != null) queryParams['factoryId'] = factoryId;

      final responseData = await _apiClient.get<Map<String, dynamic>>(
        '/datamarketplace/datasets',
        params: queryParams,
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final datasets = (responseData['datasets'] as List<dynamic>)
          .map((json) => Dataset.fromJson(json as Map<String, dynamic>))
          .toList();

      return datasets;
    } catch (e) {
      throw Exception('Failed to get datasets: $e');
    }
  }
}
