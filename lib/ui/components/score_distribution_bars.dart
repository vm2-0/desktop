import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory_grading_result.dart';
import 'package:flutter/material.dart';

class ScoreDistributionBars extends StatelessWidget {
  const ScoreDistributionBars({
    super.key,
    required this.results,
    this.barHeight = 6,
    this.spacing = 15,
  });

  final List<FactoryGradingResult> results;
  final double barHeight;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final total = results.length;

    // We build the graph widget in all cases.
    // When total is 0, it will have 0 counts and 0% progress,
    // and we'll make it invisible to just use it for sizing.
    final highScoreCount = results.where((r) => r.score >= 80).length;
    final mediumScoreCount =
        results.where((r) => r.score >= 50 && r.score < 80).length;
    final lowScoreCount = results.where((r) => r.score < 50).length;

    final graph = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ScoreTierRow(
          color: ClonesColors.highScore,
          label: '80-100% (High)',
          count: highScoreCount,
          percentage: total > 0 ? highScoreCount / total : 0,
          barHeight: barHeight,
        ),
        SizedBox(height: spacing),
        _ScoreTierRow(
          color: ClonesColors.mediumScore,
          label: '50-79% (Medium)',
          count: mediumScoreCount,
          percentage: total > 0 ? mediumScoreCount / total : 0,
          barHeight: barHeight,
        ),
        SizedBox(height: spacing),
        _ScoreTierRow(
          color: ClonesColors.lowScore,
          label: '0-49% (Low)',
          count: lowScoreCount,
          percentage: total > 0 ? lowScoreCount / total : 0,
          barHeight: barHeight,
        ),
      ],
    );

    // If there are results, just show the graph.
    return total == 0 ? Opacity(opacity: 0.3, child: graph) : graph;
  }
}

class _ScoreTierRow extends StatelessWidget {
  const _ScoreTierRow({
    required this.color,
    required this.label,
    required this.count,
    required this.percentage,
    required this.barHeight,
    // ignore: unused_element_parameter
    this.showLabels = true,
  });

  final Color color;
  final String label;
  final int count;
  final double percentage;
  final double barHeight;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        if (showLabels)
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(label, style: theme.textTheme.bodySmall),
              const Spacer(),
              Text(
                '$count',
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        if (showLabels) const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: barHeight,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
