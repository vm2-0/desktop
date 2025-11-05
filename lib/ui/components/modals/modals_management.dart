import 'package:clones_desktop/application/claim_reward_modal/provider.dart';
import 'package:clones_desktop/application/factory_funds_modal/provider.dart';
import 'package:clones_desktop/application/factory_withdraw_modal/provider.dart';
import 'package:clones_desktop/application/gas_alert_provider.dart';
import 'package:clones_desktop/application/permissions_modal_provider.dart';
import 'package:clones_desktop/application/privacy_modal_provider.dart';
import 'package:clones_desktop/application/upload_modal_provider.dart';
import 'package:clones_desktop/application/wallet_modal_provider.dart';
import 'package:clones_desktop/ui/components/gas_alert_widget.dart';
import 'package:clones_desktop/ui/components/modals/claim_reward_modal.dart';
import 'package:clones_desktop/ui/components/modals/factory_funds_modal.dart';
import 'package:clones_desktop/ui/components/modals/factory_withdraw_modal.dart';
import 'package:clones_desktop/ui/components/modals/permissions_modal.dart';
import 'package:clones_desktop/ui/components/modals/privacy_modal.dart';
import 'package:clones_desktop/ui/components/modals/upload_progress_modal.dart';
import 'package:clones_desktop/ui/components/modals/wallet_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModalsManagement extends ConsumerWidget {
  const ModalsManagement({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showWalletModal = ref.watch(walletModalProvider);
    final showUploadModal = ref.watch(uploadModalProvider);
    final showFactoryFundsModal =
        ref.watch(factoryFundsModalNotifierProvider).isShown;
    final showFactoryWithdrawModal =
        ref.watch(factoryWithdrawModalNotifierProvider).isShown;
    final showClaimRewardModal =
        ref.watch(claimRewardModalNotifierProvider).isShown;
    final gasAlertState = ref.watch(gasAlertProvider);
    final showPrivacyModal = ref.watch(privacyModalProvider);
    final showPermissionsModal = ref.watch(permissionsModalProvider);

    return ClipRect(
      child: Stack(
        children: [
          if (showWalletModal)
            WalletModal(
              onClose: () {
                ref.read(walletModalProvider.notifier).hide();
              },
            ),
          if (showUploadModal)
            UploadProgressModal(
              onClose: () {
                ref.read(uploadModalProvider.notifier).hide();
              },
            ),
          if (showFactoryFundsModal) const FactoryFundsModal(),
          if (showFactoryWithdrawModal) const FactoryWithdrawModal(),
          if (showClaimRewardModal) const ClaimRewardModal(),
          if (showPrivacyModal) const PrivacyModal(),
          if (showPermissionsModal) const PermissionsModal(),
          if (gasAlertState.isVisible && gasAlertState.currentAlert != null)
            Positioned(
              top: 20,
              right: 20,
              child: GasAlertWidget(
                gasAnalysis: gasAlertState.currentAlert!,
                onDismiss: () {
                  ref.read(gasAlertProvider.notifier).hideAlert();
                },
                onProceed: () {
                  ref.read(gasAlertProvider.notifier).hideAlert();
                },
              ),
            ),
        ],
      ),
    );
  }
}
