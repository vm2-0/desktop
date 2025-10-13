import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/factory_status_badge.dart';
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
    final factoryBalanceAsync = ref.watch(
      getFactoryBalanceProvider(poolAddress: factory.poolAddress),
    );
    
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pool Balance:',
                  style: TextStyle(
                    color: ClonesColors.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                _getBalanceText(factoryBalanceAsync, theme),
              ],
            ),
            _demoProgress(context, factoryBalanceAsync),
            const SizedBox(height: 8),
            _viewDetailsButton(),
          ],
        ),
      ),
    );
  }

  Widget _getBalanceText(AsyncValue<double> factoryBalanceAsync, ThemeData theme) {
    return factoryBalanceAsync.when(
      data: (balance) {
        return Text(
          '$balance ${factory.token.symbol}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: balance == 0 ? ClonesColors.error : ClonesColors.secondary,
          ),
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

  Widget _demoProgress(
    BuildContext context,
    AsyncValue<double> factoryBalanceAsync,
  ) {
    final pricePerDemo = factory.pricePerDemo;
    final balance = factoryBalanceAsync.maybeWhen(
      data: (value) => value,
      orElse: () => factory.balance,
    );
    final possibleDemos = (pricePerDemo > 0)
        ? (Decimal.parse(
                  balance.toString(),
                ) /
                Decimal.parse(pricePerDemo.toString()))
            .toDouble()
            .floor()
        : 0;

    final demoPercentage = possibleDemos > 0
        ? (factory.demonstrations / possibleDemos * 100).clamp(0, 100)
        : 0;

    if (pricePerDemo == 0) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Sessions completed',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: ClonesColors.secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${factory.demonstrations} / $possibleDemos',
              style: TextStyle(
                color: ClonesColors.secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ClonesColors.primary.withValues(alpha: 0.3),
                    ClonesColors.secondary.withValues(alpha: 0.3),
                    ClonesColors.tertiary.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            if (factory.demonstrations >= possibleDemos)
              FractionallySizedBox(
                widthFactor: demoPercentage / 100,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ClonesColors.rewardInfo.withValues(alpha: 0.3),
                        ClonesColors.rewardInfo,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              )
            else
              FractionallySizedBox(
                widthFactor: demoPercentage / 100,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ClonesColors.secondary.withValues(alpha: 0.3),
                        ClonesColors.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
          ],
        ),
      ],
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
