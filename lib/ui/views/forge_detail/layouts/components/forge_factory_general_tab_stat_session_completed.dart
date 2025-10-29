import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgeFactoryGeneralTabStatSessionCompleted extends ConsumerWidget {
  const ForgeFactoryGeneralTabStatSessionCompleted({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forgeDetail = ref.watch(forgeDetailNotifierProvider);

    if (forgeDetail.factory == null) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Expanded(
      child: CardWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ClonesColors.containerIcon5.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.lightbulb_outline,
                color: ClonesColors.containerIcon5.withValues(alpha: 0.7),
                size: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              forgeDetail.factory!.demonstrations.toString(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Sessions completed',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
