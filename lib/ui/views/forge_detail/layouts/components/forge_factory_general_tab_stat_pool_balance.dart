import 'package:clones_desktop/application/factory_funds_modal/provider.dart';
import 'package:clones_desktop/application/factory_withdraw_modal/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/usd_price.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:clones_desktop/utils/format_num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgeFactoryGeneralTabStatPoolBalance extends ConsumerWidget {
  const ForgeFactoryGeneralTabStatPoolBalance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final factory = ref.watch(forgeDetailNotifierProvider).factory;
    if (factory == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    return CardWidget(
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: Row(
                children: [
                  BtnPrimary(
                    buttonText: 'Funds',
                    btnPrimaryType: factory.balance > 0
                        ? BtnPrimaryType.outlinePrimary
                        : BtnPrimaryType.primary,
                    onTap: () {
                      ref
                          .read(factoryFundsModalNotifierProvider.notifier)
                          .show(factory);
                    },
                  ),
                  if (factory.balance > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: BtnPrimary(
                        buttonText: 'Withdraw',
                        btnPrimaryType: BtnPrimaryType.outlinePrimary,
                        onTap: () {
                          ref
                              .read(
                                factoryWithdrawModalNotifierProvider.notifier,
                              )
                              .show(factory);
                        },
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            ClonesColors.containerIcon4.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_outlined,
                        color:
                            ClonesColors.containerIcon4.withValues(alpha: 0.7),
                        size: 20,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color:
                            ClonesColors.containerIcon4.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'POOL',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ClonesColors.containerIcon4
                              .withValues(alpha: 0.7),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${formatNumberWithSeparator(factory.balance)} ${factory.token.symbol}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                UsdPrice(
                  amount: factory.balance,
                  symbol: factory.token.symbol,
                ),
                const SizedBox(height: 5),
                Text(
                  'available',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
    );
  }
}
