import 'package:clones_desktop/application/token_price_provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory_task.dart';
import 'package:clones_desktop/domain/models/factory/factory_token.dart';
import 'package:clones_desktop/utils/format_num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskLimitsWidget extends ConsumerWidget {
  const TaskLimitsWidget({
    super.key,
    required this.task,
    required this.factoryToken,
  });
  final FactoryTask task;
  final FactoryToken factoryToken;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceUSD = ref.watch(
      convertTokenPriceProvider(factoryToken.symbol, task.rewardLimit ?? 0),
    );
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (task.rewardLimit != null)
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text(
                  'Max reward per demo: ${task.rewardLimit?.toStringAsFixedLowValue(4, 5)} ${factoryToken.symbol}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: ClonesColors.rewardInfo,
                  ),
                ),
                priceUSD.when(
                  data: (price) => Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      '(\$${price.toStringAsFixedLowValue(2, 5)})',
                      style: theme.textTheme.bodyMedium?.copyWith(
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
        if (task.uploadLimit != null && task.uploadLimit! > 0)
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Upload limit: ${task.uploadLimit}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ClonesColors.uploadLimit,
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
      ],
    );
  }
}
