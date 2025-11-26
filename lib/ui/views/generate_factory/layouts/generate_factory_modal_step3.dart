import 'package:clones_desktop/application/apps.dart';
import 'package:clones_desktop/application/transaction/provider.dart';
import 'package:clones_desktop/ui/components/app_chip_widget.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/design_widget/dialog/dialog.dart';
import 'package:clones_desktop/ui/views/generate_factory/bloc/provider.dart';
import 'package:clones_desktop/ui/views/generate_factory/bloc/state.dart';
import 'package:clones_desktop/ui/views/generate_factory/widgets/app_alternatives_modal.dart';
import 'package:clones_desktop/ui/views/shared/components/task_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        Expanded(child: _tasksList(context, ref)),
        const SizedBox(height: 20),
        _footerButtons(context, ref),
      ],
    );
  }

  Widget _tasksList(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final generateFactory = ref.watch(generateFactoryNotifierProvider);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Choose a descriptive name for your factory. This name will be visible to users and cannot be changed after creation.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 6),
            // Factory name will be set from the generation result
            const SizedBox(height: 12),
            Builder(
              builder: (context) {
                final totalFunding =
                    double.tryParse(generateFactory.fundingAmount ?? '0') ??
                        0.0;
                final totalTasks = generateFactory.tasks?.length ?? 1;
                final defaultReward =
                    totalTasks > 0 ? totalFunding / totalTasks : 0.0;

                return Text(
                  'Tasks: Review and customize the generated tasks below.\n'
                  '• Edit task descriptions to be more specific\n'
                  '• Set custom reward amounts (leave empty for automatic distribution: ${defaultReward.toStringAsFixed(4)} ${generateFactory.selectedTokenSymbol ?? ''} per task)\n'
                  '• Set upload limits to control how many times each task can be completed\n'
                  "• Remove tasks if you don't want to provide them to your factory",
                  style: theme.textTheme.bodySmall,
                );
              },
            ),
            if (generateFactory.tasks != null &&
                generateFactory.tasks!.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (generateFactory.tasks! as List).length,
                itemBuilder: (context, taskIdx) {
                  final task = generateFactory.tasks![taskIdx];
                  final generateFactoryNotifier =
                      ref.watch(generateFactoryNotifierProvider.notifier);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CardWidget(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                task.taskName,
                                style: theme.textTheme.titleSmall,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  AppDialogs.showConfirmDialog(
                                    context,
                                    ref,
                                    'Remove Task?',
                                    'Are you sure you want to remove this task?',
                                    'Remove',
                                    () {
                                      generateFactoryNotifier
                                          .removeTask(taskIdx);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          TaskInputField(
                            initialValue: task.prompt,
                            maxLength: 2000,
                            minLines: 3,
                            maxLines: 8,
                            onChanged: (value) {
                              ref
                                  .read(
                                    generateFactoryNotifierProvider.notifier,
                                  )
                                  .updateTaskPrompt(taskIdx, value);
                            },
                            showLimits: true,
                            tokenSymbol: generateFactory.selectedTokenSymbol,
                            rewardLimit: task.rewardLimit?.toDouble(),
                            uploadLimit: task.uploadLimit,
                            onRewardLimitChanged: (rewardLimit) {
                              ref
                                  .read(
                                    generateFactoryNotifierProvider.notifier,
                                  )
                                  .updateTaskRewardLimit(taskIdx, rewardLimit);
                            },
                            onUploadLimitChanged: (uploadLimit) {
                              ref
                                  .read(
                                    generateFactoryNotifierProvider.notifier,
                                  )
                                  .updateTaskUploadLimit(taskIdx, uploadLimit);
                            },
                          ),
                          const SizedBox(height: 20),
                          if (task.appsUsed.isNotEmpty) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Apps to be used:',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: task.appsUsed
                                        .asMap()
                                        .entries
                                        .map(
                                          (entry) => InkWell(
                                            onTap: () => _showAppAlternatives(
                                              context,
                                              ref,
                                              taskIdx,
                                              entry.key,
                                              entry.value.name,
                                              entry.value.domain,
                                              generateFactory,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Tooltip(
                                              message:
                                                  'Click to replace with alternative',
                                              child: AppChipWidget(
                                                appName: entry.value.name,
                                                domain: entry.value.domain,
                                                index: entry.key,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
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

  Widget _footerButtons(BuildContext context, WidgetRef ref) {
    final generateFactory = ref.watch(generateFactoryNotifierProvider);
    final generateFactoryNotifier =
        ref.read(generateFactoryNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BtnPrimary(
            onTap: () {
              generateFactoryNotifier.setCurrentStep(
                GenerateFactoryStep.input,
              );
            },
            buttonText: 'Back',
            btnPrimaryType: BtnPrimaryType.outlinePrimary,
          ),
          Row(
            children: [
              if (generateFactory.tasks != null &&
                  generateFactory.tasks!.isNotEmpty) ...[
                BtnPrimary(
                  onTap: () {
                    final tasksText =
                        generateFactory.tasks!.asMap().entries.map((entry) {
                      final index = entry.key + 1;
                      final task = entry.value;
                      return 'Task $index: ${task.taskName}\n${task.prompt}';
                    }).join('\n\n');

                    Clipboard.setData(ClipboardData(text: tasksText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Copied ${generateFactory.tasks!.length} ${generateFactory.tasks!.length > 1 ? 'tasks' : 'task'} to clipboard',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  buttonText: 'Copy All Tasks',
                  btnPrimaryType: BtnPrimaryType.outlinePrimary,
                ),
              ],
              const SizedBox(width: 12),
              if (generateFactory.isCreated)
                BtnPrimary(
                  onTap: onClose,
                  buttonText: 'Close',
                )
              else
                BtnPrimary(
                  onTap: generateFactory.isCreating ||
                          generateFactory.tasks == null ||
                          generateFactory.tasks!.isEmpty
                      ? null
                      : () async {
                          await generateFactoryNotifier.createFactory();
                        },
                  buttonText: generateFactory.isCreating
                      ? 'Creating...'
                      : 'Create Factory',
                  isLoading: generateFactory.isCreating,
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAppAlternatives(
    BuildContext context,
    WidgetRef ref,
    int taskIndex,
    int appIndex,
    String currentAppName,
    String currentAppDomain,
    GenerateFactoryState generateFactory,
  ) {
    // Build categories filter from current state
    final filterCategories = <String>[];
    if (generateFactory.openSourceAppsOnly) {
      filterCategories.add('open_source');
    }
    if (generateFactory.webappAppsOnly) {
      filterCategories.add('webapp');
    }
    if (generateFactory.desktopAppsOnly) {
      filterCategories.add('desktop');
    }

    showDialog<void>(
      context: context,
      builder: (context) => AppAlternativesModal(
        currentAppName: currentAppName,
        currentAppDomain: currentAppDomain,
        filterCategories: filterCategories.isEmpty ? null : filterCategories,
        onSelectAlternative: (name, domain, description) {
          ref
              .read(generateFactoryNotifierProvider.notifier)
              .replaceAppInTask(taskIndex, appIndex, name, domain, description);

          // Track usage increment
          ref.read(incrementAppUsageProvider(identifier: name).future);
        },
      ),
    );
  }
}
