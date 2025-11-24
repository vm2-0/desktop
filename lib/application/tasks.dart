import 'package:clones_desktop/domain/models/factory/workflow_task.dart';
import 'package:clones_desktop/infrastructure/tasks.repository.dart';
import 'package:clones_desktop/utils/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks.g.dart';

@riverpod
TasksRepositoryImpl tasksRepository(
  Ref ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return TasksRepositoryImpl(apiClient);
}

@riverpod
Future<List<WorkflowTask>> getTasksForFactory(
  Ref ref, {
  Map<String, dynamic>? filter,
}) async {
  final tasksRepository = ref.watch(tasksRepositoryProvider);
  return tasksRepository.getTasksForFactory(filter: filter);
}
