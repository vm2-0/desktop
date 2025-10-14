import 'package:clones_desktop/application/feature_flags.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/referral/referral_info.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/views/referral/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReferralReferrerCodeCard extends ConsumerStatefulWidget {
  const ReferralReferrerCodeCard({super.key});

  @override
  ConsumerState<ReferralReferrerCodeCard> createState() =>
      _ReferralReferrerCodeCardState();
}

class _ReferralReferrerCodeCardState
    extends ConsumerState<ReferralReferrerCodeCard> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    final referralState = ref.read(referralNotifierProvider);
    controller = TextEditingController(
      text: referralState.referrerCode,
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final referralState = ref.watch(referralNotifierProvider);
    if (referralState.referralInfo == null) {
      return const SizedBox.shrink();
    }

    final session = ref.watch(sessionNotifierProvider);

    return CardWidget(
      child: session.referrerCode == null
          ? _buildAddReferrerCodeCard()
          : _buildReferrerInfoCard(),
    );
  }

  Widget _buildAddReferrerCodeCard() {
    ref.listen(referralNotifierProvider.select((value) => value.referrerCode),
        (previous, next) {
      if (next != null && controller.text != next) {
        controller.text = next;
        controller.selection =
            TextSelection.fromPosition(TextPosition(offset: next.length));
      }
    });

    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ClonesColors.containerIcon5.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.add,
                color: ClonesColors.containerIcon5.withValues(alpha: 0.7),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add a Referrer Code',
                  style: theme.textTheme.titleSmall,
                ),
                if (FeatureFlags.lockFarmingWithoutReferral)
                  Text(
                    'Add a referrer code to access all features.',
                    style: theme.textTheme.bodySmall,
                  )
                else
                  Text(
                    'If a friend referred you, you can add their code here to thank them.',
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 230,
              child: Row(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                border: Border.all(
                                  color: ClonesColors.tertiary
                                      .withValues(alpha: 0.3),
                                  width: 0.5,
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    ClonesColors.primary.withValues(alpha: 0.1),
                                    ClonesColors.tertiary
                                        .withValues(alpha: 0.1),
                                  ],
                                ),
                              ),
                              child: TextField(
                                style: theme.textTheme.bodyMedium,
                                autocorrect: false,
                                controller: controller,
                                onChanged: (text) async {
                                  ref
                                      .read(
                                        referralNotifierProvider.notifier,
                                      )
                                      .setReferrerCode(text);
                                },
                                showCursor: true,
                                cursorColor: ClonesColors.secondaryText,
                                focusNode: focusNode,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                    referrerCodeLength,
                                  ),
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^[a-zA-Z0-9]+$'),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 0.5,
                                      color: ClonesColors.secondary
                                          .withValues(alpha: 0.1),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 0.5,
                                      color: ClonesColors.primary
                                          .withValues(alpha: 0.1),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(left: 10),
                                  hintText: 'Enter Referrer Code',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color!
                                            .withValues(alpha: 0.2),
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                BtnPrimary(
                  buttonText: 'Paste',
                  btnPrimaryType: BtnPrimaryType.outlinePrimary,
                  onTap: () async {
                    final clipboardData =
                        await Clipboard.getData(Clipboard.kTextPlain);
                    if (clipboardData == null ||
                        clipboardData.text == null ||
                        clipboardData.text!.isEmpty) {
                      return;
                    }

                    ref.read(referralNotifierProvider.notifier).setReferrerCode(
                          clipboardData.text!.length > referrerCodeLength
                              ? clipboardData.text!
                                  .substring(0, referrerCodeLength)
                              : clipboardData.text,
                        );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Referrer code pasted!'),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                BtnPrimary(
                  buttonText: 'Apply',
                  onTap: () async {
                    await ref
                        .read(referralNotifierProvider.notifier)
                        .applyReferrerCode();
                    if (ref
                        .read(referralNotifierProvider)
                        .errorMessage
                        .isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Referrer code applied!'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ref.read(referralNotifierProvider).errorMessage,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReferrerInfoCard() {
    final theme = Theme.of(context);
    final session = ref.watch(sessionNotifierProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ClonesColors.containerIcon5.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.person_outline,
                color: ClonesColors.containerIcon5.withValues(alpha: 0.7),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Referrer Info',
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  'The person who referred you',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    '${session.referrerAddress} (${session.referrerCode})',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
