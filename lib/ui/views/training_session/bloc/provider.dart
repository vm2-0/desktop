import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/application/submissions.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/application/upload/provider.dart';
import 'package:clones_desktop/application/upload/state.dart';
import 'package:clones_desktop/domain/models/api/api_error.dart';
import 'package:clones_desktop/domain/models/demonstration/demonstration.dart';
import 'package:clones_desktop/domain/models/demonstration/demonstration_reward.dart';
import 'package:clones_desktop/domain/models/message/message.dart';
import 'package:clones_desktop/domain/models/message/typing_message.dart';
import 'package:clones_desktop/infrastructure/flutter_window_manager.dart';
import 'package:clones_desktop/ui/views/record_overlay/bloc/state.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/setters.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/state.dart';
import 'package:clones_desktop/utils/env.dart';
import 'package:clones_desktop/utils/window_alignment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class TrainingSessionNotifier extends _$TrainingSessionNotifier
    with TrainingSessionSetters {
  TrainingSessionNotifier();

  @override
  TrainingSessionState build() {
    return const TrainingSessionState();
  }

  Future<void> startRecording() async {
    try {
      if (state.recordingState == RecordingState.off) {
        final originalSize = await FlutterWindowManager.getWindowSize();
        state = state.copyWith(
          originalWindowSize: Size(
            originalSize.width,
            originalSize.height,
          ),
        );

        if (!kIsWeb) {
          unawaited(
            FlutterWindowManager.resizeWindow(
              kRecordOverlaySize.width,
              kRecordOverlaySize.height,
            ),
          );

          unawaited(
            FlutterWindowManager.setWindowPosition(
              WindowAlignment.topRight,
            ),
          );
        }

        await ref
            .read(tauriApiClientProvider)
            .startRecording(demonstration: state.recordingDemonstration);
        setRecordingState(RecordingState.recording);
      }
    } catch (error) {
      debugPrint('Recording error: $error');
    }
  }

  Future<void> typeMessage(
    String content,
    int messageIndex, {
    bool delay = true,
  }) async {
    try {
      if (content.isEmpty) return;
      if (delay) await Future.delayed(const Duration(milliseconds: 300));

      const baseDelay = 1000 / 15 / 2;
      const chunkSize = 2;

      for (var i = 0; i <= content.length; i += chunkSize) {
        setTypingMessage(
          TypingMessage(
            content: content.substring(0, i),
            target: content,
            messageIndex: messageIndex,
          ),
        );

        final variation = baseDelay * (0.8 + Random().nextDouble() * 0.4);

        triggerScrollToBottom();
        if (delay) {
          await Future.delayed(Duration(milliseconds: variation.toInt()));
        }
      }

      setTypingMessage(null);
    } catch (e) {
      debugPrint('Error typing message: $e');
    }
  }

  Future<void> addMessage(
    Message msg, {
    bool delay = true,
  }) async {
    final messageIndex = state.chatMessages.length;
    final isText = msg.type == MessageType.text;

    if (msg.role == 'assistant' && isText) {
      await typeMessage(
        msg.content,
        messageIndex,
        delay: delay,
      );

      setChatMessages([
        ...state.chatMessages,
        msg,
      ]);
      triggerScrollToBottom();
    } else {
      setChatMessages([
        ...state.chatMessages,
        msg,
      ]);
      triggerScrollToBottom();
    }
  }

  Future<void> demonstrationData(Demonstration demonstration) async {
    if (demonstration.content.isNotEmpty) {
      await addMessage(generateAssistantMessage(demonstration.content));
    }

    if (demonstration.title.isNotEmpty &&
        demonstration.app.isNotEmpty &&
        demonstration.objectives.isNotEmpty) {
      final currentDemonstration = Demonstration(
        title: demonstration.title,
        app: demonstration.app,
        iconUrl: demonstration.iconUrl,
        objectives: demonstration.objectives,
        content: demonstration.content,
        poolId: state.factory?.id,
        reward: DemonstrationReward(
          time: 0,
          maxReward: state.factory?.pricePerDemo ?? 0,
          token: state.factory?.token,
        ),
        taskId: state.app?.taskId,
      );

      if (state.factory?.id != null) {
        try {
          await addMessage(
            generateUserMessage("I'll show you how to do this task."),
          );
        } catch (error) {
          await addMessage(
            generateAssistantMessage(
              'Failed to get task reward info.\nWARNING: This demonstration will not provide rewards.',
            ),
          );
          debugPrint('Failed to get reward info: $error');
        }
      }
      setRecordingDemonstration(currentDemonstration);
    }
  }

  Future<void> toolCall(Map<String, dynamic> toolCall) async {
    try {
      final functionName = toolCall['function']?['name'];
      final arguments = toolCall['function']?['arguments'];
      if (functionName == null || arguments == null) return;

      switch (functionName) {
        case 'generate_demonstration':
        case 'validate_task_request':
          final _demonstrationData = jsonDecode(arguments);
          final _demonstration = Demonstration.fromJson(_demonstrationData);
          await demonstrationData(_demonstration);
          break;
        default:
          debugPrint('Unknown tool call: $functionName');
      }
    } catch (error) {
      debugPrint('Failed to handle tool call: $error');
      await addMessage(
        generateAssistantMessage(
          'I encountered an error processing the tool call. Please try again.',
        ),
      );
    }
  }

  Future<void> recordingComplete() async {
    if (state.recordingProcessing) {
      return;
    }

    setRecordingProcessing(true);
    setRecordedDemonstration(state.recordingDemonstration);
    setRecordingDemonstration(null);

    if (state.recordingState == RecordingState.recording) {
      try {
        if (state.originalWindowSize != null) {
          unawaited(
            FlutterWindowManager.resizeWindow(
              state.originalWindowSize!.width,
              state.originalWindowSize!.height,
            ),
          );
          unawaited(
            FlutterWindowManager.setWindowPosition(
              WindowAlignment.topCenter,
            ),
          );
        }
        final recordingId =
            await ref.read(tauriApiClientProvider).stopRecording('done');

        setCurrentRecordingId(recordingId);
        setRecordingState(RecordingState.off);
      } catch (e) {
        debugPrint('Error stopping recording: $e');
      }
    }

    // Recording stopped, processing will be done manually via "Analyse demo" button
    setRecordingProcessing(false);
  }

  Future<void> giveUp() async {
    if (state.recordingState == RecordingState.recording) {
      try {
        if (state.originalWindowSize != null) {
          unawaited(
            FlutterWindowManager.resizeWindow(
              state.originalWindowSize!.width,
              state.originalWindowSize!.height,
            ),
          );
          unawaited(
            FlutterWindowManager.setWindowPosition(
              WindowAlignment.topCenter,
            ),
          );
        }

        final recordingId =
            await ref.read(tauriApiClientProvider).stopRecording('fail');

        setRecordingDemonstration(null);
        setRecordingState(RecordingState.off);

        // Mark that user has given up to skip confirmation on close
        state = state.copyWith(hasGivenUp: true);

        await addMessage(
          Message(
            role: 'user',
            content: recordingId,
            type: MessageType.recording,
          ),
        );

        await addMessage(
          generateUserMessage('I’ve stopped this task.'),
        );
        await addMessage(
          generateAssistantMessage(
            'This task has been stopped. Feel free to choose a different one.',
          ),
        );
      } catch (e) {
        debugPrint('Error stopping recording: $e');
        return;
      }
    }
  }

  Future<void> assistantResponse(Map<String, dynamic> response) async {
    try {
      final message = response['data'];
      final _toolCall = message['tool_calls']?[0];

      if (_toolCall != null) {
        await toolCall(_toolCall);
      } else if (message['role'] == 'assistant' &&
          message['content'] is String) {
        await addMessage(
          Message(
            role: message['role'],
            content: message['content'],
          ),
        );
      }
    } catch (error) {
      debugPrint('Failed to handle assistant response: $error');
      await addMessage(
        generateAssistantMessage(
          'I encountered an error processing the response. Please try again.',
        ),
      );
    }
  }

  Future<void> initialMessage() async {
    setIsWaitingForResponse(true);

    try {
      final response = await http.post(
        Uri.parse('${Env.apiBackendUrl}/api/v1/forge/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'messages': [],
          'task_prompt': state.prompt ?? 'anything keep it simple',
          'app': state.app?.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await assistantResponse(responseData);
      } else {
        throw Exception('Failed to get initial message: ${response.body}');
      }
    } catch (e) {
      debugPrint('Failed to get initial message: $e');
      await addMessage(
        generateAssistantMessage(
          "I'm sorry, I encountered an error starting our conversation. Please try again.",
        ),
      );
    } finally {
      setIsWaitingForResponse(false);
    }
  }

  Future<void> uploadRecording(String recordingId) async {
    setIsUploading(true);

    try {
      final demonstrationTitle = state.recordingDemonstration?.title ??
          state.recordedDemonstration?.title ??
          'Unknown';

      await addMessage(
        generateAssistantMessage(
          'Your demonstration is being processed. This may take a while. Feel free to complete more tasks or come back later when it is done processing!',
        ),
      );

      late ProviderSubscription<Map<String, UploadTaskState>> sub;
      sub = ref.listen<Map<String, UploadTaskState>>(uploadQueueProvider,
          (previous, next) async {
        final uploadState = next[recordingId];
        if (uploadState == null) return;

        if (uploadState.uploadStatus == UploadStatus.done) {
          sub.close();
          setIsUploading(false);
          await addMessage(
            generateAssistantMessage(
              'Your demonstration was successfully uploaded!',
            ),
          );

          if (uploadState.submissionId != null) {
            try {
              final submissionDetails = await ref.read(
                getSubmissionStatusProvider(
                  submissionId: uploadState.submissionId!,
                ).future,
              );
              await addMessage(
                generateAssistantMessage(
                  'You scored ${submissionDetails.clampedScore}% on this task.',
                ),
              );

              if (submissionDetails.gradeResult != null) {
                await addMessage(
                  generateAssistantMessage(
                    'Feedback:\n${submissionDetails.gradeResult!.summary}',
                  ),
                );
              }
            } catch (e) {
              debugPrint('Failed to get submission details: $e');
            }
          }
        } else if (uploadState.uploadStatus == UploadStatus.error) {
          sub.close();
          setIsUploading(false);
          await addMessage(
            generateAssistantMessage(
              'There was an error processing your demonstration: ${uploadState.error ?? 'Unknown error'}',
            ),
          );
        }
      });

      final poolId = state.recordingDemonstration?.poolId ??
          state.recordedDemonstration?.poolId ??
          '';

      await ref.read(uploadQueueProvider.notifier).upload(
            recordingId,
            poolId,
            demonstrationTitle,
          );
    } on Exception catch (e) {
      if (e.toString().contains('Upload data is not allowed')) {
        setShowUploadConfirmModal(true);
        setIsUploading(false);
        return;
      }
      debugPrint('Error in upload process: $e');
      await addMessage(
        generateAssistantMessage(
          e is ApiError
              ? e.message
              : 'There was an error starting the upload: $e',
        ),
      );
      setIsUploading(false);
    }
  }

  Future<void> confirmAndUpload() async {
    if (state.currentRecordingId != null) {
      await uploadRecording(state.currentRecordingId!);
    }
  }
}
