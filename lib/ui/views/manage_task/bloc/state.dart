import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

enum ManageTaskModalType {
  create,
  edit,
}

@freezed
class ManageTaskState with _$ManageTaskState {
  const factory ManageTaskState({
    @Default(ManageTaskModalType.create) ManageTaskModalType modalType,
    @Default('') String prompt,
    double? pricePerDemo,
    int? uploadLimitValue,
  }) = _ManageTaskState;
  const ManageTaskState._();
}
