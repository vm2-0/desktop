import 'package:clones_desktop/ui/views/manage_task/bloc/state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class ManageTaskNotifier extends _$ManageTaskNotifier {
  ManageTaskNotifier();

  @override
  ManageTaskState build() {
    return const ManageTaskState();
  }

  void setPrompt(String prompt) {
    state = state.copyWith(prompt: prompt);
  }

  void setPricePerDemo(double? pricePerDemo) {
    state = state.copyWith(pricePerDemo: pricePerDemo);
  }

  void setUploadLimitValue(int? uploadLimitValue) {
    state = state.copyWith(uploadLimitValue: uploadLimitValue);
  }

  void setModalType(ManageTaskModalType modalType) {
    state = state.copyWith(modalType: modalType);
  }
}
