import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/state.dart';
import 'package:clones_desktop/ui/views/manage_task/bloc/state.dart';
import 'package:riverpod/riverpod.dart';

mixin ForgeDetailSetters on AutoDisposeNotifier<ForgeDetailState> {
  void setFactory(Factory factory) {
    state = state.copyWith(
      factory: factory,
      hasFactoryPropertyChanges:
          false, // Reset property changes when setting new factory
    );
  }

  void setViewModeTasks(ViewModeTasks viewModeTasks) {
    state = state.copyWith(viewModeTasks: viewModeTasks);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void setFactoryName(String factoryName) {
    if (state.factoryName == factoryName) return;

    // Check if this is different from the original factory value
    final factory = state.factory;
    final hasChanges = factory != null && factoryName != factory.name;

    state = state.copyWith(
      factoryName: factoryName,
      hasFactoryPropertyChanges:
          hasChanges || _hasOtherFactoryPropertyChanges(),
    );
  }

  void setUploadLimitValue(int uploadLimitValue) {
    if (state.uploadLimitValue == uploadLimitValue) return;
    state = state.copyWith(uploadLimitValue: uploadLimitValue);
  }

  void setUploadLimitType(String uploadLimitType) {
    if (state.uploadLimitType == uploadLimitType) return;
    state = state.copyWith(uploadLimitType: uploadLimitType);
  }

  void setHasUnsavedChanges(bool hasUnsavedChanges) {
    if (state.hasUnsavedChanges == hasUnsavedChanges) return;
    state = state.copyWith(hasUnsavedChanges: hasUnsavedChanges);
  }

  void setFactoryStatus(FactoryStatus factoryStatus) {
    if (state.factoryStatus == factoryStatus) return;

    state = state.copyWith(
      factoryStatus: factoryStatus,
    );
  }

  void setIsUpdateFactoryStatusSuccess(bool isUpdateFactoryStatusSuccess) {
    if (state.isUpdateFactoryStatusSuccess == isUpdateFactoryStatusSuccess) {
      return;
    }
    state = state.copyWith(
      isUpdateFactoryStatusSuccess: isUpdateFactoryStatusSuccess,
    );
  }

  void setIsUpdatePoolSuccess(bool isUpdatePoolSuccess) {
    if (state.isUpdatePoolSuccess == isUpdatePoolSuccess) return;
    state = state.copyWith(isUpdatePoolSuccess: isUpdatePoolSuccess);
  }

  void setIsRefreshBalanceSuccess(bool isRefreshBalanceSuccess) {
    if (state.isRefreshBalanceSuccess == isRefreshBalanceSuccess) return;
    state = state.copyWith(isRefreshBalanceSuccess: isRefreshBalanceSuccess);
  }

  void setShowNewAppForm(bool showNewAppForm) {
    state = state.copyWith(showNewAppForm: showNewAppForm);
  }

  void setNewAppName(String newAppName) {
    state = state.copyWith(newAppName: newAppName);
  }

  void setNewAppDomain(String newAppDomain) {
    state = state.copyWith(newAppDomain: newAppDomain);
  }

  void setShowManageTaskModal(bool showManageTaskModal) {
    state = state.copyWith(showManageTaskModal: showManageTaskModal);
  }

  void setManageTaskModalType(ManageTaskModalType manageTaskModalType) {
    state = state.copyWith(manageTaskModalType: manageTaskModalType);
  }


  void setEditingTaskIdx(int? editingTaskIdx) {
    state = state.copyWith(editingTaskIdx: editingTaskIdx);
  }

  void updateFactoryBalance(double newBalance) {
    final currentFactory = state.factory;
    if (currentFactory == null) return;

    final updatedFactory = currentFactory.copyWith(balance: newBalance);
    state = state.copyWith(factory: updatedFactory);
  }

  /// Check if there are changes in other factory properties (excluding the one being set)
  bool _hasOtherFactoryPropertyChanges() {
    final factory = state.factory;
    if (factory == null) return false;

    return state.factoryName != factory.name ||
        state.factoryStatus != factory.status;
  }
}
