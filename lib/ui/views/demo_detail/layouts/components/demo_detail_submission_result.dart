import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/submission/grade_result.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/score_indicator.dart';
import 'package:clones_desktop/ui/components/wallet_not_connected.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart'
    show demoDetailNotifierProvider, videoSeekCallbackProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoDetailSubmissionResult extends ConsumerStatefulWidget {
  const DemoDetailSubmissionResult({super.key});

  @override
  ConsumerState<DemoDetailSubmissionResult> createState() =>
      _DemoDetailSubmissionResultState();
}

class _DemoDetailSubmissionResultState
    extends ConsumerState<DemoDetailSubmissionResult> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConnected =
        ref.watch(sessionNotifierProvider.select((s) => s.isConnected));
    if (isConnected == false) {
      return const WalletNotConnected();
    }

    final demoDetailState = ref.watch(demoDetailNotifierProvider);
    final submission = demoDetailState.recording?.submission;

    final theme = Theme.of(context);
    if (submission?.gradeResult == null) {
      return const SizedBox.shrink();
    }

    final gradeResult = submission!.gradeResult!;

    final scores = _getScores(gradeResult);

    return Column(
      children: [
        CardWidget(
          child: Column(
            children: [
              const SizedBox(height: 10, width: double.infinity),
              _buildScoreDisplay(gradeResult, scores),
              const SizedBox(height: 15),
              SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: scores.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              scores[index]['label'],
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 100,
                              ),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                  ),
                                  child: Text(
                                    scores[index]['reasoning'] ??
                                        'No reasoning provided.',
                                    style: theme.textTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (index > 0)
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: ClonesColors.secondaryText,
                                ),
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                            ),
                          ),
                        if (index < scores.length - 1)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  color: ClonesColors.secondaryText,
                                ),
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  scores.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? theme.primaryColor
                          : theme.disabledColor,
                    ),
                  ),
                ),
              ),
              if (gradeResult.videoTimeline.isNotEmpty) ...[
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'AI Analysis Timeline',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: gradeResult.videoTimeline.length,
                  itemBuilder: (context, index) {
                    final item = gradeResult.videoTimeline[index];
                    final timestamp = item['timestamp_seconds'] as num;
                    final status = item['status'] as String;
                    final timeStr =
                        '${(timestamp ~/ 60).toString().padLeft(2, '0')}:${(timestamp % 60).toInt().toString().padLeft(2, '0')}';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            final seekCallback =
                                ref.read(videoSeekCallbackProvider);
                            if (seekCallback != null) {
                              final seconds = timestamp.toInt();
                              seekCallback(Duration(seconds: seconds));
                            }
                          },
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(status),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      timeStr,
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        fontFamily: 'monospace',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    status,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 8,
                                      color: _getStatusColor(status),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item['description'] ?? '',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'success':
        return ClonesColors.highScore;
      case 'failed':
        return ClonesColors.lowScore;
      case 'neutral':
        return ClonesColors.mediumScore;
      default:
        return ClonesColors.tertiary;
    }
  }

  List<Map<String, dynamic>> _getScores(GradeResult gradeResult) {
    final scores = <Map<String, dynamic>>[
      {
        'label': 'Total Score',
        'score': gradeResult.score.toDouble(),
        'reasoning': gradeResult.reasoningForUser,
        'index': 0,
      }
    ];
    if (gradeResult.outcomeAchievement != null) {
      scores.add({
        'label': 'Outcome Achievement',
        'score': gradeResult.outcomeAchievement,
        'reasoning': gradeResult.outcomeAchievementReasoning,
        'index': 1,
      });
    }

    if (gradeResult.processQuality != null) {
      scores.add({
        'label': 'Process Quality',
        'score': gradeResult.processQuality,
        'reasoning': gradeResult.processQualityReasoning,
        'index': 2,
      });
    }

    if (gradeResult.efficiency != null) {
      scores.add({
        'label': 'Efficiency',
        'score': gradeResult.efficiency,
        'reasoning': gradeResult.efficiencyReasoning,
        'index': 3,
      });
    }

    if (gradeResult.confidence != null) {
      scores.add({
        'label': 'Confidence',
        'score': gradeResult.confidence,
        'reasoning': gradeResult.confidenceReasoning,
        'index': 4,
      });
    }

    return scores;
  }

  Widget _buildScoreDisplay(
    GradeResult gradeResult,
    List<Map<String, dynamic>> scores,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            _pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ScoreIndicator(
              score: gradeResult.score.toDouble(),
              size: 100,
              fontSize: 16,
              label: 'Total',
              isHighlighted: _currentIndex == 0,
            ),
          ),
        ),
        Column(
          spacing: 40,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (gradeResult.outcomeAchievement != null)
                  GestureDetector(
                    onTap: () {
                      final index = scores.indexWhere(
                        (s) => s['label'] == 'Outcome Achievement',
                      );
                      if (index != -1) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ScoreIndicator(
                        score: gradeResult.outcomeAchievement!,
                        size: 70,
                        strokeWidth: 6,
                        fontSize: 12,
                        label: 'Outcome',
                        isHighlighted: _currentIndex ==
                            scores.indexWhere(
                              (s) => s['label'] == 'Outcome Achievement',
                            ),
                      ),
                    ),
                  ),
                if (gradeResult.outcomeAchievement != null &&
                    gradeResult.processQuality != null)
                  const SizedBox(width: 100),
                if (gradeResult.processQuality != null)
                  GestureDetector(
                    onTap: () {
                      final index = scores.indexWhere(
                        (s) => s['label'] == 'Process Quality',
                      );
                      if (index != -1) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ScoreIndicator(
                        score: gradeResult.processQuality!,
                        size: 70,
                        strokeWidth: 6,
                        fontSize: 12,
                        label: 'Process',
                        isHighlighted: _currentIndex ==
                            scores.indexWhere(
                              (s) => s['label'] == 'Process Quality',
                            ),
                      ),
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (gradeResult.efficiency != null)
                  GestureDetector(
                    onTap: () {
                      final index = scores.indexWhere(
                        (s) => s['label'] == 'Efficiency',
                      );
                      if (index != -1) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ScoreIndicator(
                        score: gradeResult.efficiency!,
                        size: 70,
                        strokeWidth: 6,
                        fontSize: 12,
                        label: 'Efficiency',
                        isHighlighted: _currentIndex ==
                            scores
                                .indexWhere((s) => s['label'] == 'Efficiency'),
                      ),
                    ),
                  ),
                if (gradeResult.efficiency != null &&
                    gradeResult.confidence != null)
                  const SizedBox(width: 40),
                if (gradeResult.confidence != null)
                  GestureDetector(
                    onTap: () {
                      final index = scores.indexWhere(
                        (s) => s['label'] == 'Confidence',
                      );
                      if (index != -1) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ScoreIndicator(
                        score: gradeResult.confidence!,
                        size: 70,
                        strokeWidth: 6,
                        fontSize: 12,
                        label: 'Confidence',
                        isHighlighted: _currentIndex ==
                            scores
                                .indexWhere((s) => s['label'] == 'Confidence'),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
