import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/views/home/layouts/home_view.dart';
import 'package:clones_desktop/ui/views/referral/layouts/referral_view.dart';
import 'package:clones_desktop/utils/env.dart';
import 'package:clones_desktop/utils/format_address.dart';
import 'package:clones_desktop/utils/format_num.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletModal extends ConsumerWidget {
  const WalletModal({
    super.key,
    required this.onClose,
  });
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final session = ref.watch(sessionNotifierProvider);

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
                        'My Wallet',
                        style: theme.textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: onClose,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Wallet',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: session.address ?? '',
                                    ),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Address copied!'),
                                    ),
                                  );
                                },
                                child: Text(
                                  session.address?.shortAddress() ?? '',
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    color: ClonesColors.primaryText,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () async {
                                  try {
                                    if (!await launchUrl(
                                      Uri.parse(
                                        '${Env.baseScanBaseUrl}/address/${session.address}',
                                      ),
                                      mode: LaunchMode.externalApplication,
                                    )) {
                                      throw Exception(
                                        'Failed to launch URL: ${Env.baseScanBaseUrl}/address/${session.address}',
                                      );
                                    }
                                  } catch (e) {
                                    debugPrint(
                                      'Failed to open external URL: $e',
                                    );
                                  }
                                },
                                child: Icon(
                                  Icons.open_in_new,
                                  color: ClonesColors.secondaryText,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (session.referralCode != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Referral Code',
                              style: theme.textTheme.bodyMedium,
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: session.referralCode!,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Referral code copied!'),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    session.referralCode!,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      color: ClonesColors.primaryText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Referral Code',
                              style: theme.textTheme.bodyMedium,
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () async {
                                    onClose();
                                    context.go(ReferralView.routeName);
                                  },
                                  child: const Text(
                                    'Get your referral code',
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      color: ClonesColors.tertiary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      if (session.referrerCode != null &&
                          session.referrerAddress != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Your Referrer',
                                style: theme.textTheme.bodyMedium,
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: session.referrerAddress!,
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Referrer address copied!'),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      '${session.referrerAddress!.shortAddress()} (${session.referrerCode})',
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        color: ClonesColors.primaryText,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () async {
                                      try {
                                        if (!await launchUrl(
                                          Uri.parse(
                                            '${Env.baseScanBaseUrl}/address/${session.referrerAddress}',
                                          ),
                                          mode: LaunchMode.externalApplication,
                                        )) {
                                          throw Exception(
                                            'Failed to launch URL: ${Env.baseScanBaseUrl}/address/${session.referrerAddress}',
                                          );
                                        }
                                      } catch (e) {
                                        debugPrint(
                                          'Failed to open external URL: $e',
                                        );
                                      }
                                    },
                                    child: Icon(
                                      Icons.open_in_new,
                                      color: ClonesColors.secondaryText,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 10),
                      Divider(
                        color: ClonesColors.secondary.withValues(alpha: 0.3),
                        thickness: 0.5,
                      ),
                      const SizedBox(height: 6),
                      // Tier information section
                      if (session.tier != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Commission Tier',
                              style: theme.textTheme.bodyMedium,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: ClonesColors.tertiary
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                session.tier!.tierName,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: ClonesColors.tertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Commission Rate',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Text(
                                  session.tier!.formattedCommissionPercentage,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: ClonesColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            if (session.tier!.nextTierMinHolding != null) ...[
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    session.tier!.tierName == 'Tier 0'
                                        ? 'To reach Tier 1'
                                        : 'Next Tier',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    session.tier!.tierName == 'Tier 0'
                                        ? '${session.tier!.formattedNextTierMinHolding} CLONES needed'
                                        : '+${session.tier!.formattedTokensNeededForNextTier!} CLONES',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () async {
                                if (!await launchUrl(
                                  Uri.parse(
                                    'https://clones.gitbook.io/clones.docs/the-forge/how-it-works#commission-structure',
                                  ),
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  throw Exception(
                                    'Failed to launch URL: https://clones.gitbook.io/clones.docs/the-forge/how-it-works#commission-structure',
                                  );
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'More infos',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: ClonesColors.secondaryText,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.open_in_new,
                                    color: ClonesColors.secondaryText,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: ClonesColors.secondary.withValues(alpha: 0.3),
                          thickness: 0.5,
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (session.balances != null)
                        ...session.balances!.map(
                          (tokenBalance) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    if (tokenBalance.logoUrl != null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: CachedNetworkImage(
                                          imageUrl: tokenBalance.logoUrl!,
                                          width: 20,
                                          height: 20,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (_, __, ___) =>
                                              const SizedBox.shrink(),
                                        ),
                                      )
                                    else
                                      const SizedBox.shrink(),
                                    Text(
                                      tokenBalance.name,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                if (tokenBalance.isLoading)
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 0.5,
                                    ),
                                  )
                                else
                                  Text(
                                    '${tokenBalance.balance?.toStringAsFixedLowValue(2, 5) ?? '0.00'} ${tokenBalance.symbol}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: ClonesColors.secondary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      BtnPrimary(
                        widthExpanded: true,
                        onTap: () {
                          ref
                              .read(sessionNotifierProvider.notifier)
                              .cancelConnection();
                          onClose();
                          context.go(HomeView.routeName);
                        },
                        buttonText: 'Disconnect Wallet',
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
}
