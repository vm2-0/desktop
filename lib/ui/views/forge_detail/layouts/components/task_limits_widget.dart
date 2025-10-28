import 'package:clones_desktop/application/token_price_provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/domain/models/factory/factory_task.dart';
import 'package:clones_desktop/domain/models/factory/factory_token.dart';
import 'package:clones_desktop/ui/components/design_widget/message_box/message_box.dart';
import 'package:clones_desktop/utils/format_num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskLimitsWidget extends ConsumerWidget {
  const TaskLimitsWidget({
    super.key,
    required this.factory,
    required this.task,
    required this.factoryToken,
  });

  final Factory factory;
  final FactoryTask task;
  final FactoryToken factoryToken;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewardAmount =
        task.rewardLimit != null ? task.rewardLimit! : factory.pricePerDemo;
    final priceUSD = ref.watch(
      convertTokenPriceProvider(
        factoryToken.symbol,
        rewardAmount,
      ),
    );
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Text(
                'Max reward per demo: ${rewardAmount.toStringAsFixedLowValue(4, 5)} ${factoryToken.symbol}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: ClonesColors.rewardInfo,
                ),
              ),
              priceUSD.when(
                data: (price) => Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    '(\$${price.toStringAsFixedLowValue(2, 5)})',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: ClonesColors.rewardInfo,
                    ),
                  ),
                ),
                error: (error, stackTrace) => const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            task.uploadLimit != null
                ? 'Upload limit: ${task.uploadLimit}'
                : factory.uploadLimit != null
                    ? 'Upload limit: ${factory.uploadLimit?.value}'
                    : 'Upload limit: infinite',
            style: theme.textTheme.bodySmall?.copyWith(
              color: task.uploadLimit != null
                  ? ClonesColors.uploadLimit
                  : factory.uploadLimit != null
                      ? ClonesColors.uploadLimit
                      : ClonesColors.rewardInfo,
            ),
          ),
        ),
        if (task.limitReason != null && task.limitReason!.isNotEmpty)
          Flexible(
            child: Text(
              'Limit reason: ${task.limitReason}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (factory.balance < rewardAmount)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: MessageBox(
              messageBoxType: MessageBoxType.warning,
              content: Text(
                'Factory balance is less than the reward amount. This task will not be available for users to complete.',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
      ],
    );
  }
}
