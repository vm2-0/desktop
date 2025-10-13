import 'package:clones_desktop/application/transaction/provider.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/views/generate_factory/bloc/provider.dart';
import 'package:clones_desktop/ui/views/generate_factory/bloc/state.dart';
import 'package:clones_desktop/ui/views/generate_factory/layouts/components/generate_factory_textfield_app.dart';
import 'package:clones_desktop/ui/views/generate_factory/layouts/components/generate_factory_textfield_factory_app.dart';
import 'package:clones_desktop/ui/views/generate_factory/layouts/components/generate_factory_textfield_factory_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenerateFactoryModalStep3 extends ConsumerWidget {
  const GenerateFactoryModalStep3({
    super.key,
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _buildPoolDetails(context, ref),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _buildTransactionStatus(context, ref),
              ),
            ),
          ],
        ),
        Expanded(child: _uiEditor(context, ref)),
        const SizedBox(height: 20),
        _footerButtons(context, ref),
      ],
    );
  }

  Widget _uiEditor(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final generateFactory = ref.watch(generateFactoryNotifierProvider);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GenerateFactoryTextFieldFactoryApp(),
          const SizedBox(height: 12),
          if (generateFactory.apps != null && generateFactory.apps!.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: (generateFactory.apps! as List).length,
                itemBuilder: (context, appIdx) {
                  final app = generateFactory.apps![appIdx];
                  return Card(
                    color: Colors.transparent,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    'http://127.0.0.1:19847/proxy-image?url=${Uri.encodeComponent('https://www.google.com/s2/favicons?domain=${app.domain}&sz=32')}',
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.apps,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GenerateFactoryTextFieldApp(
                                  appIdx: appIdx,
                                ),
                              ),
                            ],
                          ),
                          if (app.tasks.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 60, top: 4),
                              child: Column(
                                children: List.generate(
                                  app.tasks.length,
                                  (taskIdx) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child:
                                              GenerateFactoryTextFieldFactoryPrompt(
                                            appIdx: appIdx,
                                            taskIdx: taskIdx,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No apps or tasks generated',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _footerButtons(BuildContext context, WidgetRef ref) {
    final generateFactoryNotifier =
        ref.watch(generateFactoryNotifierProvider.notifier);
    final generateFactoryState = ref.watch(generateFactoryNotifierProvider);

    // If factory is created, show only close button
    if (generateFactoryState.isCreated) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BtnPrimary(
            buttonText: 'Close',
            onTap: onClose,
          ),
        ],
      );
    }

    // Default state: show back and create factory buttons
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BtnPrimary(
          buttonText: 'Back',
          onTap: () => generateFactoryNotifier
            ..setError(null)
            ..setCurrentStep(GenerateFactoryStep.input),
          btnPrimaryType: BtnPrimaryType.outlinePrimary,
        ),
        const SizedBox(width: 10),
        BtnPrimary(
          isLoading: generateFactoryState.isCreating,
          buttonText: 'Create Factory',
          onTap: () async {
            await generateFactoryNotifier.createPool();
          },
        ),
      ],
    );
  }

  Widget _buildPoolDetails(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final generateFactory = ref.watch(generateFactoryNotifierProvider);

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        ),
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Factory Details',
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (generateFactory.selectedTokenSymbol != null) ...[
            Row(
              children: [
                Text(
                  'Reward Token: ',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  generateFactory.selectedTokenSymbol!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (generateFactory.fundingAmount != null &&
              generateFactory.fundingAmount!.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  'Reward Funding: ',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  '${generateFactory.fundingAmount} ${generateFactory.selectedTokenSymbol ?? ''}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (generateFactory.predictedPoolAddress != null) ...[
            Row(
              children: [
                Text(
                  'Reward Pool Address:',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 4),
                SelectableText(
                  generateFactory.predictedPoolAddress!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (generateFactory.estimatedGasCost != null) ...[
            Row(
              children: [
                Text(
                  'Estimated Gas: ',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  generateFactory.estimatedGasCost!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: generateFactory.gasExceedsReward == true
                        ? Colors.orange
                        : null,
                  ),
                ),
              ],
            ),
          ],
          if (generateFactory.gasExceedsReward == true) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Warning: Gas costs may exceed net rewards',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionStatus(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final generateFactory = ref.watch(generateFactoryNotifierProvider);
    final transactionState = ref.watch(transactionManagerProvider);
    final transactionManager = ref.watch(transactionManagerProvider.notifier);

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: generateFactory.isCreated
              ? Colors.green.withValues(alpha: 0.3)
              : theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
        color: generateFactory.isCreated
            ? Colors.green.withValues(alpha: 0.1)
            : theme.colorScheme.primary.withValues(alpha: 0.1),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Transaction Status',
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (transactionState.awaitingCallback) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 0.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Waiting for transaction confirmation in browser...',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ] else if (transactionState.lastSuccessfulTx != null) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Transaction confirmed: ${transactionState.lastSuccessfulTx!.substring(0, 10)}...',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (transactionState.error != null) ...[
                Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Transaction failed: ${transactionState.error}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (!generateFactory.isCreating &&
                  generateFactory.transactionStatus == null) ...[
                Text(
                  'No transaction in progress',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color
                        ?.withValues(alpha: 0.6),
                  ),
                ),
              ],
              if (generateFactory.isCreating)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 0.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Creating Factory...',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              if (generateFactory.isCreated)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          generateFactory.transactionStatus!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (transactionState.lastSuccessfulTx != null ||
              transactionState.error != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: BtnPrimary(
                buttonText: 'Transaction Status',
                onTap: () async =>
                    transactionManager.showTransactionStatus(context),
                btnPrimaryType: BtnPrimaryType.outlinePrimary,
              ),
            ),
        ],
      ),
    );
  }
}
