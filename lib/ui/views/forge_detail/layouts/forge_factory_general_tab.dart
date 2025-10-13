import 'package:clones_desktop/application/feature_flags.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';

import 'package:clones_desktop/ui/components/design_widget/message_box/message_box.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/forge_factory_general_tab_factory_address.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/forge_factory_general_tab_factory_name.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/forge_factory_general_tab_factory_upload_limit.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/forge_factory_general_tab_price_per_demo.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/forge_factory_general_tab_stat_demo_price.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/forge_factory_general_tab_stat_pool_balance.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/forge_factory_general_tab_stat_session_completed.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/forge_factory_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgeFactoryGeneralTab extends ConsumerWidget {
  const ForgeFactoryGeneralTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forgeDetail = ref.watch(forgeDetailNotifierProvider);
    final theme = Theme.of(context);
    if (forgeDetail.factory == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ForgeFactoryHeader(),
          Text(
            '1. General Information',
            style: theme.textTheme.titleMedium,
          ),
          if (forgeDetail.factory!.status == FactoryStatus.error)
            _buildNoFundsMessageBox(context, ref),
          const SizedBox(height: 20),
          _buildGlobalStats(ref),
          const SizedBox(height: 20),
          const SizedBox(
            child: SizedBox(
              height: 160,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ForgeFactoryGeneralTabFactoryName(),
                  SizedBox(width: 20),
                  ForgeFactoryGeneralTabPricePerDemo(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(
            child: SizedBox(
              height: 160,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ForgeFactoryGeneralTabFactoryAddress(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (FeatureFlags.uploadLimits)
            const ForgeFactoryGeneralTabFactoryUploadLimit(),
        ],
      ),
    );
  }

  Widget _buildNoFundsMessageBox(BuildContext context, WidgetRef ref) {
    final forgeDetail = ref.watch(forgeDetailNotifierProvider);
    if (forgeDetail.factory == null) {
      return const SizedBox.shrink();
    }
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: mediaQuery.size.width,
        child: MessageBox(
          messageBoxType: MessageBoxType.warning,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Insufficient ${forgeDetail.factory!.token.symbol} Tokens',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ClonesColors.primaryText,
                ),
              ),
              Text(
                "Your factory needs ${forgeDetail.factory!.token.symbol} tokens to reward users who provide demonstrations. Without funds, users won't receive compensation.",
                style: TextStyle(
                  color: ClonesColors.secondaryText,
                ),
              ),
              Text(
                'Deposit ${forgeDetail.factory!.token.symbol} to the address above to activate your factory and start collecting data.',
                style: TextStyle(
                  color: ClonesColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalStats(WidgetRef ref) {
    final forgeDetail = ref.watch(forgeDetailNotifierProvider);
    if (forgeDetail.factory == null) {
      return const SizedBox.shrink();
    }
    return const SizedBox(
      height: 160,
      child: Row(
        spacing: 20,
        children: [
          ForgeFactoryGeneralTabStatSessionCompleted(),
          ForgeFactoryGeneralTabStatDemoPrice(),
          ForgeFactoryGeneralTabStatPoolBalance(),
        ],
      ),
    );
  }
}
