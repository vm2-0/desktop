import 'package:clones_desktop/domain/models/factory/workflow_task.dart';
import 'package:clones_desktop/domain/models/ui/factory_filter.dart';
import 'package:clones_desktop/infrastructure/apps.repository.dart';
import 'package:clones_desktop/utils/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apps.g.dart';

@riverpod
AppsRepositoryImpl appsRepository(
  Ref ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return AppsRepositoryImpl(apiClient);
}

@riverpod
Future<Map<String, dynamic>> generateWorkflows(
  Ref ref, {
  required String prompt,
}) async {
  final appsRepository = ref.read(appsRepositoryProvider);
  return appsRepository.generateWorkflows(prompt: prompt);
}

@riverpod
Future<List<WorkflowTask>> getTasksForFactory(
  Ref ref, {
  required FactoryFilter filter,
}) async {
  final appsRepository = ref.read(appsRepositoryProvider);
  final tasks =
      await appsRepository.getTasksForFactory(filter: filter.toJson());
  return tasks;
}

@riverpod
Future<List<String>> getFactoryCategories(Ref ref) async {
  final appsRepository = ref.read(appsRepositoryProvider);
  return appsRepository.getFactoryCategories();
}
