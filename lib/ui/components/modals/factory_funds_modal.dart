import 'dart:ui';
import 'package:clones_desktop/application/factory_funds_modal/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FactoryFundsModal extends ConsumerWidget {
  const FactoryFundsModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final factory = ref.watch(factoryFundsModalNotifierProvider).factory;
    final modalState = ref.watch(factoryFundsModalNotifierProvider);

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
              width: mediaQuery.size.width * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fund my Factory',
                        style: theme.textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(factoryFundsModalNotifierProvider.notifier)
                              .hide();
                        },
                        icon: Icon(
                          Icons.close,
                          color: ClonesColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Reward Funding',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        'Amount to fund factory rewards (you pay gas fees)',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: theme.colorScheme.primaryContainer,
                            width: 0.5,
                          ),
                          gradient: ClonesColors.gradientInputFormBackground,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Consumer(
                            builder: (context, ref, child) {
                              final modalState =
                                  ref.watch(factoryFundsModalNotifierProvider);
                              return TextField(
                                onChanged: (value) {
                                  ref
                                      .read(
                                        factoryFundsModalNotifierProvider
                                            .notifier,
                                      )
                                      .setFundingAmount(value);
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                style: theme.textTheme.bodyMedium,
                                enabled: !modalState.isFunding,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: modalState.isFunding
                                      ? 'Processing...'
                                      : 'Enter amount to fund',
                                  hintStyle:
                                      theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.textTheme.bodyMedium?.color!
                                        .withValues(alpha: 0.5),
                                  ),
                                  suffixText: factory?.token?.symbol ?? '',
                                  suffixStyle: theme.textTheme.bodyMedium,
                                  errorText: modalState.error?.isNotEmpty ==
                                          true
                                      ? null // Don't show error in field, we have dedicated error widget
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      _buildGasInfo(context, ref),
                      _buildErrorMessage(context, ref),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BtnPrimary(
                            buttonText: 'Cancel',
                            onTap: () {
                              ref
                                  .read(
                                    factoryFundsModalNotifierProvider.notifier,
                                  )
                                  .hide();
                            },
                            btnPrimaryType: BtnPrimaryType.outlinePrimary,
                          ),
                          const SizedBox(width: 10),
                          BtnPrimary(
                            buttonText: 'Fund',
                            isLoading: modalState.isFunding,
                            isLocked: modalState.fundingAmount.isEmpty ||
                                modalState.gasExceedsReward,
                            onTap: () {
                              ref
                                  .read(
                                    factoryFundsModalNotifierProvider.notifier,
                                  )
                                  .fundFactory();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGasInfo(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final modalState = ref.watch(factoryFundsModalNotifierProvider);

    if (modalState.estimatedGasCost == null && !modalState.gasExceedsReward) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        if (modalState.estimatedGasCost != null) ...[
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              Text(
                'Estimated gas: ${modalState.estimatedGasCost}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
        if (modalState.gasExceedsReward) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Gas cost may exceed net reward. Consider increasing funding amount.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorMessage(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final modalState = ref.watch(factoryFundsModalNotifierProvider);

    if (modalState.error == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  modalState.error!,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
