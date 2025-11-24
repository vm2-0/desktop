import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/domain/models/factory/workflow_task.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/setters.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/state.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class ForgeDetailNotifier extends _$ForgeDetailNotifier
    with ForgeDetailSetters {
  ForgeDetailNotifier();

  @override
  ForgeDetailState build() {
    return const ForgeDetailState();
  }

  Future<void> refreshBalance() async {
    setIsRefreshBalanceSuccess(false);
    setError(null);
    final factory = state.factory;
    if (factory == null) {
      throw Exception('Factory not found');
    }

    try {
      // Fetch fresh pool info from backend/blockchain
      final poolInfoData = await ref.read(
        getPoolInfoProvider(
          poolAddress: factory.poolAddress ?? '',
        ).future,
      );

      // Extract tokenBalance from the API response

      if (poolInfoData.containsKey('tokenBalance')) {
        final tokenBalanceString = poolInfoData['tokenBalance'] as String?;
        if (tokenBalanceString != null) {
          final newBalance = double.tryParse(tokenBalanceString) ?? 0.0;

          // Update factory balance in state
          updateFactoryBalance(newBalance);
        }
      }

      setIsRefreshBalanceSuccess(true);
    } catch (e) {
      debugPrint('Failed to refresh factory balance: $e');
      setError(e.toString());
    }
  }

  Future<void> updateFactoryStatus() async {
    setIsUpdateFactoryStatusSuccess(false);

    try {
      var updatedFactory = await ref.read(
        updateFactoryProvider(
          factoryId: state.factory?.id ?? '',
          walletAddress: state.factory?.ownerAddress ?? '',
          status: state.factoryStatus,
        ).future,
      );
      updatedFactory =
          updatedFactory.copyWith(balance: state.factory?.balance ?? 0);

      setFactory(updatedFactory);
      setIsUpdateFactoryStatusSuccess(true);
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> updateFactory() async {
    setIsUpdatePoolSuccess(false);
    try {
      // First save factory tasks if there are unsaved changes
      if (state.hasUnsavedChanges) {
        await saveFactoryTasks();
      }

      var updatedFactory = await ref.read(
        updateFactoryProvider(
          factoryId: state.factory?.id ?? '',
          walletAddress: state.factory?.ownerAddress ?? '',
          factoryName: state.factoryName,
          description: state.factory?.description ?? '',
          skills: state.factory?.skills ?? [],
          status: state.factoryStatus,
        ).future,
      );
      updatedFactory =
          updatedFactory.copyWith(balance: state.factory?.balance ?? 0);

      setFactory(updatedFactory);
      setIsUpdatePoolSuccess(true);
      // Reset factory property changes after successful save
      state = state.copyWith(hasFactoryPropertyChanges: false);
    } catch (e) {
      setError(e.toString());
    }
  }

  void removeTask(int taskIdx) {
    final factory = state.factory;
    if (factory == null) return;
    
    final tasks = List<WorkflowTask>.from(factory.tasks)..removeAt(taskIdx);
    final updatedFactory = factory.copyWith(tasks: tasks);
    
    setFactory(updatedFactory);
    setHasUnsavedChanges(true);
  }

  void createTask(WorkflowTask task) {
    final factory = state.factory;
    if (factory == null) return;
    
    final tasks = List<WorkflowTask>.from(factory.tasks)..add(task);
    final updatedFactory = factory.copyWith(tasks: tasks);
    
    setFactory(updatedFactory);
    setHasUnsavedChanges(true);
  }

  void updateTask(int taskIndex, WorkflowTask task) {
    final factory = state.factory;
    if (factory == null) return;
    
    final tasks = List<WorkflowTask>.from(factory.tasks);
    tasks[taskIndex] = task;
    final updatedFactory = factory.copyWith(tasks: tasks);
    
    setFactory(updatedFactory);
    setHasUnsavedChanges(true);
  }

  Future<void> saveFactoryTasks() async {
    setError(null);
    final factory = state.factory;
    if (factory == null) {
      setError('Factory not found');
      return;
    }

    try {
      var updatedFactory = await ref.read(
        updateFactoryTasksProvider(
          factoryId: factory.id,
          tasks: factory.tasks,
          walletAddress: factory.ownerAddress,
        ).future,
      );
      updatedFactory = updatedFactory.copyWith(balance: factory.balance);

      // Update the factory without marking as having unsaved changes since we just saved
      state = state.copyWith(
        factory: updatedFactory,
        hasUnsavedChanges: false,
      );
      debugPrint('Factory tasks saved successfully');
    } catch (e) {
      debugPrint('Failed to save factory tasks: $e');
      setError('Failed to save tasks: $e');
    }
  }
}
