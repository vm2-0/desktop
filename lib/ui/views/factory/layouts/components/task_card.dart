import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/application/feature_flags.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/app_info.dart';
import 'package:clones_desktop/domain/models/factory/factory_app.dart';
import 'package:clones_desktop/domain/models/factory/factory_task.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/referral_required_dialog.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/demo_detail_view.dart';
import 'package:clones_desktop/utils/fav_tools.dart';
import 'package:clones_desktop/utils/format_num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TaskCard extends ConsumerWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.app,
  });

  final FactoryTask task;
  final FactoryApp app;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final factory = ref
        .watch(
          getFactoryProvider(factoryId: app.poolId!),
        )
        .valueOrNull;

    if (factory == null) {
      return const SizedBox.shrink();
    }

    final tokenSymbol = factory.token.symbol;

    final rewardAmount =
        task.rewardLimit != null ? task.rewardLimit! : factory.pricePerDemo;

    final rewardText =
        '${rewardAmount.toStringAsFixedLowValue(2, 5)} $tokenSymbol';

    Future<void> onTap(BuildContext context) async {
      // Check if farming is locked without referral code
      if (FeatureFlags.lockFarmingWithoutReferral) {
        final session = ref.read(sessionNotifierProvider);
        if (session.referrerCode == null || session.referrerCode!.isEmpty) {
          await ReferralRequiredDialog.show(context, ref);
          return;
        }
      }

      final appInfo = AppInfo(
        type: 'website',
        name: app.name,
        url: 'https://${app.domain}',
        taskId: task.id,
      );
      final appParam = Uri.encodeComponent(jsonEncode(appInfo.toJson()));

      context.go(
        DemoDetailView.routeName,
        extra: {
          'prompt': task.prompt,
          'appParam': appParam,
          'poolId': factory.id,
          'taskId': task.id,
        },
      );
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: CardWidget(
            padding: CardPadding.small,
            variant: CardVariant.secondary,
            child: InkWell(
              onTap: () async =>
                  factory.balance >= rewardAmount ? onTap(context) : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: getFaviconUrl(app.domain),
                          width: 20,
                          height: 20,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (_, __, ___) => const Icon(
                            Icons.web,
                            size: 20,
                            color: ClonesColors.primaryText,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            app.name,
                            style: theme.textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: AutoSizeText(
                        task.prompt,
                        maxLines: 3,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (factory.balance >= rewardAmount)
                    BtnPrimary(
                      widthExpanded: true,
                      onTap: () async => onTap(context),
                      buttonText: 'Start Training',
                    )
                  else
                    const BtnPrimary(
                      widthExpanded: true,
                      isLocked: true,
                      btnPrimaryType: BtnPrimaryType.outlinePrimary,
                      onTap: null,
                      buttonText: 'Insufficient funds',
                    )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: factory.balance >= rewardAmount
                  ? ClonesColors.rewardInfo.withValues(alpha: 0.3)
                  : ClonesColors.rewardInfo.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withAlpha(60),
                  blurRadius: 6,
                  offset: const Offset(
                    0,
                    3,
                  ),
                ),
              ],
            ),
            child: Text(
              rewardText,
              style: theme.textTheme.bodySmall!.copyWith(
                color: factory.balance >= rewardAmount
                    ? ClonesColors.rewardInfo
                    : Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
