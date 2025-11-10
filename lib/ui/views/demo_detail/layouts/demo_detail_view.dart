import 'dart:ui';

import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/application/transaction/provider.dart';
import 'package:clones_desktop/application/ui_state/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/video_player/video_player_with_id.dart';
import 'package:clones_desktop/ui/components/video_player/video_source.dart';
import 'package:clones_desktop/ui/components/wallet_not_connected.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_editor.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_events.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_footer.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_infos.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_rewards.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_steps.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_submission_result.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_video_preview.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/pre_upload_messages.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/components/upload_confirm_modal.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/training_session_view.dart';
import 'package:clones_desktop/utils/breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoDetailView extends ConsumerStatefulWidget {
  const DemoDetailView({super.key, this.recordingId, this.trainingParams});

  static const String routeName = '/demo-detail';

  final String? recordingId;
  final Map<String, dynamic>? trainingParams;

  @override
  ConsumerState<DemoDetailView> createState() => _DemoDetailViewState();
}

class _DemoDetailViewState extends ConsumerState<DemoDetailView>
    with TickerProviderStateMixin {
  bool _videoFullscreen = false;
  Widget? _videoPlayerWidget;
  String? _currentVideoId;
  VideoSource? _lastVideoSource;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Set modal state immediately if no recordingId and not a factory submission
    if (widget.recordingId == null &&
        widget.trainingParams?['isFactorySubmission'] != true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(demoDetailNotifierProvider.notifier)
            .setShowTrainingSessionModal(true);
      });
    }

    Future.delayed(Duration.zero, () async {
      if (widget.recordingId != null) {
        await ref
            .read(demoDetailNotifierProvider.notifier)
            .loadRecording(widget.recordingId!);
      } else if (widget.trainingParams?['isFactorySubmission'] == true) {
        final submissionId = widget.trainingParams?['submissionId'] as String?;
        final factoryAddress =
            widget.trainingParams?['factoryAddress'] as String?;
        if (submissionId != null && factoryAddress != null) {
          await ref
              .read(demoDetailNotifierProvider.notifier)
              .loadPoolSubmission(submissionId, factoryAddress);
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleVideoFullscreen() {
    setState(() {
      _videoFullscreen = !_videoFullscreen;
    });

    // Update global UI state
    ref
        .read(uiStateNotifierProvider.notifier)
        .setVideoFullscreen(_videoFullscreen);

    if (_videoFullscreen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Future<void> _reloadCurrentData() async {
    final demoDetailNotifier = ref.read(demoDetailNotifierProvider.notifier);
    final currentState = ref.read(demoDetailNotifierProvider);
    final currentRecording = currentState.recording;
    if (currentRecording != null) {
      await demoDetailNotifier.loadRecording(currentRecording.id);
    }
  }

  Widget _buildVideoPreview({bool showExpandButton = true}) {
    final demoDetail = ref.watch(demoDetailNotifierProvider);
    final videoSource = demoDetail.videoSource;

    if (videoSource == null) {
      return DemoDetailVideoPreview(
        onExpand: showExpandButton ? _toggleVideoFullscreen : null,
      );
    }

    // Recreate video player widget when source changes
    if (_lastVideoSource != videoSource) {
      _videoPlayerWidget = VideoPlayerWithId(
        key: ValueKey('video-player-${videoSource.hashCode}'),
        source: videoSource,
        onVideoIdAvailable: (videoId) {
          setState(() {
            _currentVideoId = videoId;
          });
          // Store videoId in the provider for access from other widgets
          ref
              .read(demoDetailNotifierProvider.notifier)
              .setCurrentVideoId(videoId);
        },
      );
      _lastVideoSource = videoSource;
    }

    return DemoDetailVideoPreview(
      videoWidget: _videoPlayerWidget,
      videoId: _currentVideoId,
      onExpand: showExpandButton ? _toggleVideoFullscreen : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for successful claim transactions to reload data
    ref
      ..listen(transactionManagerProvider, (previous, next) {
        if (next.lastSuccessfulTx != null &&
            next.currentTransactionType == 'claimRewards' &&
            previous?.lastSuccessfulTx != next.lastSuccessfulTx) {
          _reloadCurrentData();
        }
      })
      ..listen(
        demoDetailNotifierProvider.select((s) => s.showUploadConfirmModal),
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
                        .read(demoDetailNotifierProvider.notifier)
                        .confirmUploadPermission();
                  },
                );
              },
            );
          }
        },
      );

    final isConnected =
        ref.watch(sessionNotifierProvider.select((s) => s.isConnected));
    if (isConnected == false) {
      return const WalletNotConnected();
    }

    final demoDetail = ref.watch(demoDetailNotifierProvider);

    if (demoDetail.recording == null && widget.recordingId != null) {
      return const Center(child: Text('Recording not found'));
    }

    final submission =
        ref.watch(demoDetailNotifierProvider).recording?.submission;
    final demoDetailState = ref.watch(demoDetailNotifierProvider);

    final showTrainingSessionModal = demoDetailState.showTrainingSessionModal;
    final recording = demoDetailState.recording;
    final userAccessType = demoDetailState.userAccessType;
    final isFactoryCreator = userAccessType == 'factory_creator';

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Padding(
                  padding: EdgeInsets.all(_videoFullscreen ? 0 : 24),
                  child: Column(
                    children: [
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            if (constraints.maxWidth > Breakpoints.desktop) {
                              return _buildDesktopLayout(
                                constraints,
                                submission,
                                recording,
                                showTrainingSessionModal,
                                isFactoryCreator,
                              );
                            }
                            return _buildMobileLayout(
                              submission,
                              recording,
                              showTrainingSessionModal,
                              isFactoryCreator,
                            );
                          },
                        ),
                      ),
                      if (!_videoFullscreen && !isFactoryCreator) ...[
                        const SizedBox(height: 10),
                        AnimatedOpacity(
                          opacity: 1 - _animationController.value,
                          duration: const Duration(milliseconds: 300),
                          child: const DemoDetailFooter(),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
            if (ref.watch(demoDetailNotifierProvider).showTrainingSessionModal)
              _buildTrainingSessionModal(),
          ],
        );
      },
    );
  }

  Widget _buildDesktopLayout(
    BoxConstraints constraints,
    dynamic submission,
    dynamic recording,
    bool showTrainingSessionModal,
    bool isFactoryCreator,
  ) {
    if (_videoFullscreen) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        child: Stack(
          children: [
            _buildVideoPreview(showExpandButton: false),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.fullscreen_exit,
                  color: ClonesColors.secondary,
                  size: 32,
                ),
                onPressed: _toggleVideoFullscreen,
                tooltip: 'Exit fullscreen',
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_videoFullscreen) ...[
                AnimatedOpacity(
                  opacity: 1 - _animationController.value,
                  duration: const Duration(milliseconds: 300),
                  child: const DemoDetailInfos(),
                ),
                const SizedBox(height: 20),
              ],
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _buildVideoPreview(),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 4,
                      child: AnimatedOpacity(
                        opacity: 1 - _animationController.value,
                        duration: const Duration(milliseconds: 300),
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Column(
                            children: [
                              if (submission == null &&
                                  recording != null &&
                                  !showTrainingSessionModal)
                                CardWidget(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: const PreUploadMessages(),
                                  ),
                                )
                              else
                                const DemoDetailSubmissionResult(),
                              const SizedBox(height: 20),
                              if (submission != null) ...[
                                const DemoDetailSteps(),
                                const SizedBox(height: 20),
                              ],
                              if (submission != null && !isFactoryCreator) ...[
                                const DemoDetailRewards(),
                                const SizedBox(height: 20),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isFactoryCreator) ...[
          const SizedBox(width: 20),
          Expanded(
            flex: 3,
            child: _buildEditorTabs(isFactoryCreator),
          ),
        ],
      ],
    );
  }

  Widget _buildMobileLayout(
    dynamic submission,
    dynamic recording,
    bool showTrainingSessionModal,
    bool isFactoryCreator,
  ) {
    if (_videoFullscreen) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        child: Stack(
          children: [
            _buildVideoPreview(showExpandButton: false),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.fullscreen_exit,
                  color: ClonesColors.secondary,
                  size: 32,
                ),
                onPressed: _toggleVideoFullscreen,
                tooltip: 'Exit fullscreen',
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          if (!_videoFullscreen) ...[
            AnimatedOpacity(
              opacity: 1 - _animationController.value,
              duration: const Duration(milliseconds: 300),
              child: const DemoDetailInfos(),
            ),
            const SizedBox(height: 20),
          ],
          _buildVideoPreview(),
          const SizedBox(height: 20),
          AnimatedOpacity(
            opacity: 1 - _animationController.value,
            duration: const Duration(milliseconds: 300),
            child: const DemoDetailSteps(),
          ),
          const SizedBox(height: 20),
          if (submission == null &&
              recording != null &&
              !showTrainingSessionModal)
            AnimatedOpacity(
              opacity: 1 - _animationController.value,
              duration: const Duration(milliseconds: 300),
              child: CardWidget(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const PreUploadMessages(),
                ),
              ),
            )
          else
            AnimatedOpacity(
              opacity: 1 - _animationController.value,
              duration: const Duration(milliseconds: 300),
              child: const DemoDetailSubmissionResult(),
            ),
          const SizedBox(height: 20),
          if (!isFactoryCreator) ...[
            AnimatedOpacity(
              opacity: 1 - _animationController.value,
              duration: const Duration(milliseconds: 300),
              child: const DemoDetailRewards(),
            ),
            const SizedBox(height: 20),
          ],
          if (!isFactoryCreator)
            AnimatedOpacity(
              opacity: 1 - _animationController.value,
              duration: const Duration(milliseconds: 300),
              child: SizedBox(
                height: 500,
                child: _buildEditorTabs(isFactoryCreator),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEditorTabs(bool isFactoryCreator) {
    return CardWidget(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: ClonesColors.secondary,
              unselectedLabelColor: ClonesColors.secondaryText,
              dividerColor: ClonesColors.secondary,
              tabs: const [
                Tab(text: 'Editor'),
                Tab(text: 'Events'),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  DemoDetailEditor(),
                  DemoDetailEvents(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingSessionModal() {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ),
        Center(
          child: CardWidget(
            padding: CardPadding.large,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Expanded(
                    child: TrainingSessionView(
                      prompt: widget.trainingParams?['prompt'],
                      appParam: widget.trainingParams?['appParam'],
                      poolId: widget.trainingParams?['poolId'],
                      taskId: widget.trainingParams?['taskId'],
                      onRecordingCompleted: (recordingId) async {
                        await ref
                            .read(demoDetailNotifierProvider.notifier)
                            .onDemoRecordingCompleted(recordingId);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
