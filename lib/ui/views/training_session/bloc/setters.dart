import 'package:clones_desktop/domain/app_info.dart';
import 'package:clones_desktop/domain/models/demonstration/demonstration.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/domain/models/factory/factory_task.dart';
import 'package:clones_desktop/domain/models/message/message.dart';
import 'package:clones_desktop/domain/models/message/typing_message.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/state.dart';
import 'package:riverpod/riverpod.dart';

mixin TrainingSessionSetters on AutoDisposeNotifier<TrainingSessionState> {
  void setPrompt(String? prompt) {
    state = state.copyWith(prompt: prompt);
  }

  void setFactory(Factory? factory) {
    state = state.copyWith(factory: factory);
  }

  void setRecordedDemonstration(Demonstration? demonstration) {
    state = state.copyWith(recordedDemonstration: demonstration);
  }

  void setRecordingDemonstration(Demonstration? demonstration) {
    state = state.copyWith(recordingDemonstration: demonstration);
  }

  void setRecordingProcessing(bool recordingProcessing) {
    state = state.copyWith(recordingProcessing: recordingProcessing);
  }

  void setShowUploadConfirmModal(bool showUploadConfirmModal) {
    state = state.copyWith(showUploadConfirmModal: showUploadConfirmModal);
  }

  void setCurrentRecordingId(String? currentRecordingId) {
    state = state.copyWith(currentRecordingId: currentRecordingId);
  }

  void setIsUploading(bool isUploading) {
    state = state.copyWith(isUploading: isUploading);
  }

  void setRecordingState(RecordingState recordingState) {
    state = state.copyWith(recordingState: recordingState);
  }

  void setChatMessages(List<Message> chatMessages) {
    state = state.copyWith(chatMessages: chatMessages);
  }

  void setTypingMessage(TypingMessage? typingMessage) {
    state = state.copyWith(typingMessage: typingMessage);
  }

  void setIsWaitingForResponse(bool isWaitingForResponse) {
    state = state.copyWith(isWaitingForResponse: isWaitingForResponse);
  }

  void setApp(AppInfo? app) {
    state = state.copyWith(app: app);
  }

  void triggerScrollToBottom() {
    state = state.copyWith(scrollToBottomNonce: state.scrollToBottomNonce + 1);
  }

  void setFactoryTask(FactoryTask? factoryTask) {
    state = state.copyWith(factoryTask: factoryTask);
  }
}
