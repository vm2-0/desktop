import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';

class ReferralInstructionsCard extends StatelessWidget {
  const ReferralInstructionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(
            'How It Works',
            style: theme.textTheme.titleSmall,
          ),
          _buildInstructionStep(
            context,
            1,
            'Share your referral code with friends',
            'Send your unique referral code to people you know who might be interested in Clones.',
          ),
          _buildInstructionStep(
            context,
            2,
            'They adding up using your code in referral desktop page',
            "When someone adds your referral code to their account, they'll be automatically linked to your account.",
          ),
          _buildInstructionStep(
            context,
            3,
            'Earn rewards together',
            "You'll earn rewards when your referrals complete tasks and contribute to the platform.",
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(
    BuildContext context,
    int step,
    String title,
    String description,
  ) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ClonesColors.containerIcon6.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            step == 1
                ? Icons.looks_one_outlined
                : step == 2
                    ? Icons.looks_two_outlined
                    : Icons.looks_3_outlined,
            color: ClonesColors.containerIcon6.withValues(alpha: 0.7),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
