import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/referral/bloc/provider.dart';
import 'package:clones_desktop/utils/format_num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReferralStatTotalRewards extends ConsumerWidget {
  const ReferralStatTotalRewards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referralState = ref.watch(referralNotifierProvider);
    if (referralState.referralInfo == null ||
        referralState.referralInfo!.totalRewards == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    return CardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ClonesColors.containerIcon3.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.monetization_on_outlined,
              color: ClonesColors.containerIcon3.withValues(alpha: 0.7),
              size: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            referralState.referralInfo!.totalRewards!
                .toStringAsFixedLowValue(2, 5),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Total Rewards',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
