import 'package:clones_desktop/domain/models/dataset/dataset.dart';
import 'package:clones_desktop/infrastructure/dataset.repository.dart';
import 'package:clones_desktop/utils/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'datasets.g.dart';

/// Provider for dataset repository instance
@riverpod
DatasetRepository datasetRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DatasetRepositoryImpl(apiClient);
}

/// Provider to fetch datasets for a specific factory
@riverpod
Future<List<Dataset>> getFactoryDatasets(
  Ref ref,
  String factoryId,
) async {
  final repository = ref.watch(datasetRepositoryProvider);
  return repository.getDatasets(factoryId: factoryId);
}
