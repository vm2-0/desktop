import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/views/generate_factory/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenerateFactoryModalStep1 extends ConsumerStatefulWidget {
  const GenerateFactoryModalStep1({
    super.key,
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  ConsumerState<GenerateFactoryModalStep1> createState() =>
      _GenerateFactoryModalStep1State();
}

class _GenerateFactoryModalStep1State
    extends ConsumerState<GenerateFactoryModalStep1> {
  late TextEditingController skillsController;
  late TextEditingController fundingAmountController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(generateFactoryNotifierProvider.notifier).fetchSupportedTokens();
    });
    final generateFactory = ref.read(generateFactoryNotifierProvider);
    skillsController = TextEditingController(text: generateFactory.skills);
    fundingAmountController =
        TextEditingController(text: generateFactory.fundingAmount);
  }

  @override
  void dispose() {
    skillsController.dispose();
    fundingAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final generateFactoryState = ref.watch(generateFactoryNotifierProvider);

    // Synchronize controllers with state when navigating back
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (skillsController.text != (generateFactoryState.skills ?? '')) {
        skillsController.text = generateFactoryState.skills ?? '';
      }
      if (fundingAmountController.text !=
          (generateFactoryState.fundingAmount ?? '')) {
        fundingAmountController.text = generateFactoryState.fundingAmount ?? '';
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create a factory by describing the skills you want to train, then specify reward funding.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              10,
            ),
            border: Border.all(
              color: ClonesColors.secondary.withValues(alpha: 0.3),
              width: 0.5,
            ),
            gradient: LinearGradient(
              colors: [
                ClonesColors.secondary.withValues(alpha: 0.3),
                ClonesColors.secondary.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextField(
              controller: skillsController,
              autocorrect: false,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              maxLength: 1000,
              buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                return Text(
                  '$currentLength/$maxLength',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: currentLength > 900
                      ? Colors.orange
                      : theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                  ),
                );
              },
              onChanged: (v) => ref
                  .read(generateFactoryNotifierProvider.notifier)
                  .setSkills(v),
              cursorColor: ClonesColors.secondaryText,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 10),
                hintText: 'List the skills to train (one per line, max 1000 characters)...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      theme.textTheme.bodyMedium?.color!.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
        ),
        _options(ref),
        const SizedBox(height: 10),
        _buildErrorMessage(context, ref),
        _examplePrompts(ref),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildRewardTokenSelector(context, ref),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _buildFundingSection(context, ref),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _footerButtons(ref),
      ],
    );
  }

  Widget _options(WidgetRef ref) {
    final generateFactoryState = ref.watch(generateFactoryNotifierProvider);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Open source apps only',
                    style: theme.textTheme.bodySmall,
                  ),
                  value: generateFactoryState.openSourceAppsOnly,
                  onChanged: (value) {
                    ref
                        .read(generateFactoryNotifierProvider.notifier)
                        .setOpenSourceAppsOnly(value ?? false);
                  },
                  activeColor: ClonesColors.primary,
                  checkColor: Colors.white,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Webapp apps only',
                    style: theme.textTheme.bodySmall,
                  ),
                  value: generateFactoryState.webappAppsOnly,
                  onChanged: (value) {
                    ref
                        .read(generateFactoryNotifierProvider.notifier)
                        .setWebappAppsOnly(value ?? false);
                  },
                  activeColor: ClonesColors.primary,
                  checkColor: Colors.white,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Desktop apps only',
                    style: theme.textTheme.bodySmall,
                  ),
                  value: generateFactoryState.desktopAppsOnly,
                  onChanged: (value) {
                    ref
                        .read(generateFactoryNotifierProvider.notifier)
                        .setDesktopAppsOnly(value ?? false);
                  },
                  activeColor: ClonesColors.primary,
                  checkColor: Colors.white,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final generateFactoryState = ref.watch(generateFactoryNotifierProvider);

    if (generateFactoryState.error == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              generateFactoryState.error!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardTokenSelector(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final generateFactoryState = ref.watch(generateFactoryNotifierProvider);
    final generateFactoryNotifier =
        ref.read(generateFactoryNotifierProvider.notifier);

    if (generateFactoryState.supportedTokens == null) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 0.5,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reward Token', style: theme.textTheme.titleMedium),
        Text(
          'Choose the reward token for your factory',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.colorScheme.primaryContainer,
              width: 0.5,
            ),
            gradient: ClonesColors.gradientInputFormBackground,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton<String>(
              value: generateFactoryState.selectedTokenSymbol,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              dropdownColor: Colors.black.withValues(alpha: 0.9),
              style: theme.textTheme.bodyMedium,
              items: generateFactoryState.supportedTokens!
                  .map(
                    (token) => DropdownMenuItem(
                      value: token.symbol,
                      child: Row(
                        children: [
                          Text('${token.name} (${token.symbol})'),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  generateFactoryNotifier.setSelectedTokenWithPrediction(value);
                }
              },
            ),
          ),
        ),
        if (generateFactoryState.predictedPoolAddress != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              SelectableText(
                'Future Factory Pool address: ${generateFactoryState.predictedPoolAddress}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _examplePrompts(WidgetRef ref) {
    final generateFactory = ref.watch(generateFactoryNotifierProvider);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Example prompts:',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: generateFactory.examplePrompts.map((prompt) {
            return OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: ClonesColors.tertiary,
                  width: 0.1,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
              onPressed: () {
                skillsController.text = prompt['text']!;
                ref
                    .read(generateFactoryNotifierProvider.notifier)
                    .setSkills(prompt['text']!);
              },
              child: Text(
                prompt['label']!,
                style: theme.textTheme.bodySmall,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _footerButtons(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BtnPrimary(
          buttonText: 'Cancel',
          onTap: widget.onClose,
          btnPrimaryType: BtnPrimaryType.outlinePrimary,
        ),
        const SizedBox(width: 10),
        BtnPrimary(
          buttonText: 'Generate Factory',
          onTap: () => ref
              .read(generateFactoryNotifierProvider.notifier)
              .validateAndStartGeneration(),
          isLocked:
              ref.watch(generateFactoryNotifierProvider).skills?.isEmpty ??
                  true,
        ),
      ],
    );
  }

  Widget _buildFundingSection(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final generateFactoryState = ref.watch(generateFactoryNotifierProvider);
    final generateFactoryNotifier =
        ref.read(generateFactoryNotifierProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reward Funding', style: theme.textTheme.titleMedium),
        Text(
          'Amount to fund factory rewards initially (you pay gas fees)',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.colorScheme.primaryContainer,
              width: 0.5,
            ),
            gradient: ClonesColors.gradientInputFormBackground,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: fundingAmountController,
              onChanged: generateFactoryNotifier.setFundingAmount,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  if (newValue.text.isEmpty) return newValue;
                  final value = double.tryParse(newValue.text);
                  if (value == null || value < 0) {
                    return oldValue;
                  }
                  return newValue;
                }),
              ],
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      theme.textTheme.bodyMedium?.color!.withValues(alpha: 0.5),
                ),
                suffixText: generateFactoryState.selectedTokenSymbol ?? '',
                suffixStyle: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ),
        if (generateFactoryState.estimatedGasCost != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              Text(
                'Estimated gas: ${generateFactoryState.estimatedGasCost}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
        if (generateFactoryState.gasExceedsReward == true) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Gas cost may exceed net reward. Consider increasing funding amount.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
