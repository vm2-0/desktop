import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/score_distribution_bars.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgeFactoryGeneralTabStatDemo extends ConsumerWidget {
  const ForgeFactoryGeneralTabStatDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final factory = ref.watch(forgeDetailNotifierProvider).factory;
    final theme = Theme.of(context);

    if (factory == null) {
      return const SizedBox.shrink();
    }

    final gradingResultsAsync =
        ref.watch(getFactoryGradingResultsProvider(factoryId: factory.id));

    return CardWidget(
      child: gradingResultsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Could not load score data.',
            style: theme.textTheme.bodySmall,
          ),
        ),
        data: (results) {
          final total = results.length;
          final averageScore = total > 0
              ? results.map((r) => r.score).reduce((a, b) => a + b) / total
              : 0;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ClonesColors.containerIcon5.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.assessment_outlined,
                      color: ClonesColors.containerIcon1.withValues(alpha: 0.7),
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${averageScore.toStringAsFixed(0)}%',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ClonesColors.getScoreColor(averageScore.toInt()),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Average Score',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ScoreDistributionBars(results: results),
              ),
            ],
          );
        },
      ),
    );
  }
}
