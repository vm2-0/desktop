import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/factory_status_badge.dart';
import 'package:clones_desktop/ui/components/score_distribution_bars.dart';
import 'package:clones_desktop/ui/components/usd_price.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgeExistingFactoryCard extends ConsumerWidget {
  const ForgeExistingFactoryCard({
    super.key,
    required this.factory,
    required this.onTap,
  });

  final Factory factory;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final gradingResultsAsync =
        ref.watch(getFactoryGradingResultsProvider(factoryId: factory.id));

    return CardWidget(
      padding: CardPadding.small,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: FactoryStatusBadge(status: factory.status),
            ),
            Text(
              factory.name,
              style: theme.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                gradingResultsAsync.when(
                  data: (results) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: ScoreDistributionBars(
                      results: results,
                      barHeight: 4,
                      spacing: 6,
                    ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 8),
                if (factory.poolAddress != null && factory.token != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Balance:',
                        style: TextStyle(
                          color: ClonesColors.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      _getBalanceText(ref, context),
                    ],
                  ),
                ] else
                  const SizedBox(
                    height: 32,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _viewDetailsButton(),
          ],
        ),
      ),
    );
  }

  Widget _getBalanceText(
    WidgetRef ref,
    BuildContext context,
  ) {
    final factoryBalanceAsync = ref.watch(
      getFactoryBalanceProvider(poolAddress: factory.poolAddress ?? ''),
    );
    final theme = Theme.of(context);
    return factoryBalanceAsync.when(
      data: (balance) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${balance.toStringAsFixed(3)} ${factory.token?.symbol ?? ''}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    balance == 0 ? ClonesColors.error : ClonesColors.secondary,
              ),
            ),
            UsdPrice(
              amount: Decimal.parse(balance.toString()),
              symbol: factory.token?.symbol ?? '',
              withParentheses: false,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color:
                    balance == 0 ? ClonesColors.error : ClonesColors.secondary,
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.square(
        dimension: 12,
        child: CircularProgressIndicator(
          strokeWidth: 0.5,
        ),
      ),
      error: (error, stack) => Text(
        'Error loading balance',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: ClonesColors.error,
        ),
      ),
    );
  }

  Widget _viewDetailsButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: BtnPrimary(
        widthExpanded: true,
        onTap: onTap,
        buttonText: 'View Details',
      ),
    );
  }
}
