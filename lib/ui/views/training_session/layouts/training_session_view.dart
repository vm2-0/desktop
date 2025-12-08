import 'dart:async';
import 'dart:ui';

import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/application/tasks.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/message/message.dart';
import 'package:clones_desktop/ui/components/design_widget/dialog/dialog.dart';
import 'package:clones_desktop/ui/components/design_widget/message_box/message_box.dart';
import 'package:clones_desktop/ui/components/pfp.dart';
import 'package:clones_desktop/ui/views/factory/layouts/factory_view.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/provider.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/state.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/components/message_item.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/components/record_panel.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/components/stream_message.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/components/typing_indicator.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/components/upload_confirm_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TrainingSessionView extends ConsumerStatefulWidget {
  const TrainingSessionView({
    super.key,
    this.prompt,
    this.poolId,
    this.taskId,
    this.onRecordingCompleted,
  });
  final String? prompt;
  final String? poolId;
  final String? taskId;
  final Function(String recordingId)? onRecordingCompleted;

  @override
  ConsumerState<TrainingSessionView> createState() =>
      _TrainingSessionViewState();
}

class _TrainingSessionViewState extends ConsumerState<TrainingSessionView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    Future(() async {
      if (widget.poolId != null) {
        final factory = await ref
            .read(getFactoryProvider(factoryId: widget.poolId!).future);
        ref.read(trainingSessionNotifierProvider.notifier).setFactory(factory);
      }
      if (widget.prompt != null) {
        ref
            .read(trainingSessionNotifierProvider.notifier)
            .setPrompt(widget.prompt);
      }
      if (widget.taskId != null) {
        final factoryTasks = await ref.read(
          getTasksForFactoryProvider(
            filter: {
              'poolId': widget.poolId,
            },
          ).future,
        );
        final factoryTask =
            factoryTasks.firstWhere((task) => task.id == widget.taskId);
        ref
            .read(trainingSessionNotifierProvider.notifier)
            .setFactoryTask(factoryTask);
      }
      await ref.read(trainingSessionNotifierProvider.notifier).initializeFromTask();
    });
    super.initState();
  }

  List<ChatItem> _processMessages(List<Message> messages) {
    final processed = <ChatItem>[];
    var inReplayBlock = false;
    var currentReplayItems = <SingleMessageItem>[];

    for (var i = 0; i < messages.length; i++) {
      final message = messages[i];

      if (message.type == MessageType.start) {
        inReplayBlock = true;
        continue;
      }

      if (message.type == MessageType.end) {
        inReplayBlock = false;
        if (currentReplayItems.isNotEmpty) {
          processed.add(ReplayGroupItem(messages: currentReplayItems));
        }
        currentReplayItems = [];
        continue;
      }

      final item = SingleMessageItem(message: message, index: i);
      if (inReplayBlock) {
        currentReplayItems.add(item);
      } else {
        processed.add(item);
      }
    }

    if (currentReplayItems.isNotEmpty) {
      processed.add(ReplayGroupItem(messages: currentReplayItems));
    }

    return processed;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ref
      ..listen(
        trainingSessionNotifierProvider.select((s) => s.showUploadConfirmModal),
        (previous, next) {
          if (next) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              useRootNavigator: false,
              builder: (BuildContext context) {
                return UploadConfirmModal(
                  onConfirm: () {
                    ref
                        .read(trainingSessionNotifierProvider.notifier)
                        .confirmAndUpload();
                  },
                  onCancel: () {
                    ref
                        .read(trainingSessionNotifierProvider.notifier)
                        .setIsUploading(false);
                  },
                );
              },
            ).then((_) {
              ref
                  .read(trainingSessionNotifierProvider.notifier)
                  .setShowUploadConfirmModal(false);
            });
          }
        },
      )
      ..listen(
        trainingSessionNotifierProvider.select((s) => s.scrollToBottomNonce),
        (previous, next) {
          if (previous != next) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          }
        },
      )
      ..listen(
        trainingSessionNotifierProvider.select((s) => s.recordingState),
        (previous, next) {
          // When recording completes (state changes from recording to off), call the callback
          if (previous == RecordingState.recording &&
              next == RecordingState.off &&
              widget.onRecordingCompleted != null) {
            final recordingId =
                ref.read(trainingSessionNotifierProvider).currentRecordingId;
            if (recordingId != null) {
              widget.onRecordingCompleted!(recordingId);
            }
          }
        },
      );

    final trainingSession = ref.watch(trainingSessionNotifierProvider);
    final processedItems = _processMessages(trainingSession.chatMessages);
    final showTypingIndicator = trainingSession.isWaitingForResponse &&
        trainingSession.typingMessage == null;
    final showStreamingMessage = trainingSession.typingMessage != null;
    final mediaQuery = MediaQuery.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(
            parent: RangeMaintainingScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              titleTextStyle: theme.textTheme.titleMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.5,
              ),
              title: const Text('Demonstration'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () {
                      final trainingSessionState =
                          ref.read(trainingSessionNotifierProvider);

                      // Skip confirmation if not recording or user has given up
                      if (trainingSessionState.recordingState !=
                              RecordingState.recording ||
                          trainingSessionState.hasGivenUp) {
                        context.go(FactoryView.routeName);
                        return;
                      }

                      AppDialogs.showConfirmDialog(
                        context,
                        ref,
                        'Leave Demonstration Recording?',
                        'Are you sure you want to leave the recording of this demonstration ? Your progress will be lost.',
                        'Leave',
                        () {
                          context.go(FactoryView.routeName);
                        },
                      );
                    },
                    icon: Icon(
                      Icons.close,
                      color: ClonesColors.secondaryText,
                    ),
                  ),
                ),
              ],
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = processedItems[index];
                    Widget child;

                    final single = item as SingleMessageItem;
                    child = MessageItem(
                      message: single.message,
                      index: single.index,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: child,
                    );
                  },
                  childCount: processedItems.length,
                ),
              ),
            ),
            if (showStreamingMessage)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverToBoxAdapter(
                  child: StreamMessage(
                    typingMessage: trainingSession.typingMessage!,
                  ),
                ),
              ),
            if (showTypingIndicator)
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverToBoxAdapter(child: TypingIndicator()),
              ),
            if (trainingSession.recordingDemonstration != null)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 15),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: mediaQuery.size.width * 0.7,
                              ),
                              child: const MessageBox(
                                messageBoxType: MessageBoxType.talkLeft,
                                content: RecordPanel(),
                              ),
                            ),
                          ),
                          const Positioned(
                            left: 0,
                            top: 0,
                            child: Pfp(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
