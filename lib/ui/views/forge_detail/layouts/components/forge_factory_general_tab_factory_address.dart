import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:clones_desktop/utils/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgeFactoryGeneralTabFactoryAddress extends ConsumerWidget {
  const ForgeFactoryGeneralTabFactoryAddress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forgeDetail = ref.watch(forgeDetailNotifierProvider);

    if (forgeDetail.factory == null ||
        forgeDetail.factory!.poolAddress == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    return Expanded(
      child: CardWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ClonesColors.containerIcon2.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.call_received,
                    color: ClonesColors.containerIcon2.withValues(alpha: 0.7),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Factory Address',
                      style: theme.textTheme.titleSmall,
                    ),
                    Text(
                      'This is the address of the factory smart contract',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: ClonesColors.gradientInputFormBackground,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      child: SelectableText(
                        forgeDetail.factory!.poolAddress ?? '',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                BtnPrimary(
                  buttonText: 'Copy',
                  btnPrimaryType: BtnPrimaryType.outlinePrimary,
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: forgeDetail.factory!.poolAddress ?? '',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Address copied!'),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                BtnPrimary(
                  buttonText: 'Open in Explorer',
                  btnPrimaryType: BtnPrimaryType.outlinePrimary,
                  onTap: () async {
                    if (!await launchUrl(
                      Uri.parse(
                        '${Env.baseScanBaseUrl}/address/${forgeDetail.factory!.poolAddress}',
                      ),
                      mode: LaunchMode.externalApplication,
                    )) {
                      throw Exception(
                        'Failed to launch URL: ${Env.baseScanBaseUrl}/address/${forgeDetail.factory!.poolAddress}',
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
