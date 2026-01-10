import 'package:clones_desktop/application/transaction/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/views/create_dataset/bloc/provider.dart';
import 'package:clones_desktop/ui/views/create_dataset/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateDatasetModal extends ConsumerStatefulWidget {
  const CreateDatasetModal({super.key});

  @override
  ConsumerState<CreateDatasetModal> createState() => _CreateDatasetModalState();
}

class _CreateDatasetModalState extends ConsumerState<CreateDatasetModal> {
  late TextEditingController nameController;
  late TextEditingController symbolController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(createDatasetNotifierProvider);
    nameController = TextEditingController(text: state.name);
    symbolController = TextEditingController(text: state.symbol);
    descriptionController = TextEditingController(text: state.description);
    categoryController = TextEditingController(text: state.category);
  }

  @override
  void dispose() {
    nameController.dispose();
    symbolController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(createDatasetNotifierProvider);

    // Show success message or creating state
    if (state.currentStep == CreateDatasetStep.creating) {
      return _buildCreatingState(context);
    }

    if (state.currentStep == CreateDatasetStep.created) {
      return _buildSuccessState(context, state);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RepaintBoundary(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                  'Create a tokenized dataset from your factory demonstrations.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                if (state.demoHashes != null && state.demoHashes!.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: ClonesColors.tertiary.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          ClonesColors.tertiary.withValues(alpha: 0.2),
                          ClonesColors.tertiary.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: ClonesColors.tertiary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${state.demoHashes!.length} demonstrations will be included',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ClonesColors.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                _buildTextField(
                  controller: nameController,
                  label: 'Dataset Name',
                  hint: 'E-commerce Customer Service',
                  maxLength: 100,
                  isRequired: true,
                  onChanged: (v) => ref.read(createDatasetNotifierProvider.notifier).setName(v),
                  errorText: state.nameError,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: symbolController,
                  label: 'Symbol',
                  hint: 'ECUSTOM',
                  maxLength: 10,
                  isRequired: true,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (v) => ref.read(createDatasetNotifierProvider.notifier).setSymbol(v),
                  errorText: state.symbolError,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: descriptionController,
                  label: 'Description',
                  hint: 'High-quality demonstrations for...',
                  maxLength: 1000,
                  maxLines: 3,
                  onChanged: (v) => ref.read(createDatasetNotifierProvider.notifier).setDescription(v),
                  errorText: state.descriptionError,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: categoryController,
                  label: 'Category',
                  hint: 'customer-service',
                  maxLength: 50,
                  onChanged: (v) => ref.read(createDatasetNotifierProvider.notifier).setCategory(v),
                  errorText: state.categoryError,
                ),
                const SizedBox(height: 16),
                _buildBurnThresholdSelector(context, state),
                if (state.error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.withValues(alpha: 0.2),
                          Colors.red.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 16,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.error!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BtnPrimary(
              onTap: state.canCreate && !state.isCreating
                  ? () => ref.read(createDatasetNotifierProvider.notifier).validateAndCreate()
                  : null,
              buttonText: state.isCreating ? 'Creating...' : 'Create Dataset',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required int maxLength,
    required Function(String) onChanged,
    bool isRequired = false,
    int maxLines = 1,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? errorText,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: ClonesColors.tertiary,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: errorText != null
                  ? Colors.red.withValues(alpha: 0.5)
                  : ClonesColors.secondary.withValues(alpha: 0.3),
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
              controller: controller,
              autocorrect: false,
              textCapitalization: textCapitalization,
              maxLines: maxLines,
              maxLength: maxLength,
              buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                return Text(
                  '$currentLength/$maxLength',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: currentLength > maxLength! * 0.9
                        ? Colors.orange
                        : theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                  ),
                );
              },
              onChanged: onChanged,
              cursorColor: ClonesColors.secondaryText,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 10, right: 10),
                hintText: hint,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color!.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCreatingState(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(createDatasetNotifierProvider);
    final transactionState = ref.watch(transactionManagerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transaction Status',
                style: theme.textTheme.titleSmall,
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
                        state.transactionStatus ?? 'Waiting for transaction confirmation...',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ] else if (state.isCreating) ...[
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
                        state.transactionStatus ?? 'Creating dataset...',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (state.name != null) ...[
          Container(
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
                Text(
                  'Dataset Details',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Name: ',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      state.name!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Symbol: ',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      state.symbol!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Burn Threshold: ',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      '${state.burnThresholdPercentage}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Demonstrations: ',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      '${state.demonstrationCount ?? 0}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        const Spacer(),
        Center(
          child: Text(
            'Please do not close this window',
            style: theme.textTheme.bodySmall?.copyWith(
              color: ClonesColors.secondaryText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState(BuildContext context, CreateDatasetState state) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                ClonesColors.tertiary.withValues(alpha: 0.2),
                ClonesColors.tertiary.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.check_circle,
                size: 48,
                color: ClonesColors.tertiary,
              ),
              const SizedBox(height: 16),
              Text(
                'Dataset Deployed Successfully!',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: ClonesColors.tertiary,
                ),
              ),
              const SizedBox(height: 8),
              if (state.transactionStatus != null) ...[
                Text(
                  state.transactionStatus!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: ClonesColors.tertiary.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
              ],
              if (state.calculatedQualityScore != null) ...[
                Text(
                  'Quality Score: ${state.calculatedQualityScore!.toStringAsFixed(1)}%',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
              ],
              Text(
                '${state.demonstrationCount ?? 0} demonstrations included',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: ClonesColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        BtnPrimary(
          widthExpanded: true,
          onTap: () {
            ref.read(createDatasetNotifierProvider.notifier).reset();
          },
          buttonText: 'Close',
        ),
      ],
    );
  }

  Widget _buildBurnThresholdSelector(BuildContext context, CreateDatasetState state) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Burn Threshold',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              ' *',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ClonesColors.tertiary,
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Percentage of total supply users must burn to download dataset',
              child: Icon(
                Icons.info_outline,
                size: 16,
                color: ClonesColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: state.burnThresholdPercentage.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          label: '${state.burnThresholdPercentage}%',
          activeColor: ClonesColors.tertiary,
          onChanged: (value) => ref
              .read(createDatasetNotifierProvider.notifier)
              .setBurnThresholdPercentage(value.toInt()),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: ClonesColors.tertiary.withValues(alpha: 0.3),
              width: 0.5,
            ),
            gradient: LinearGradient(
              colors: [
                ClonesColors.tertiary.withValues(alpha: 0.2),
                ClonesColors.tertiary.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${state.burnThresholdPercentage}% Threshold Impact:',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ClonesColors.tertiary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• Maximum downloads: ${state.maxDownloads}',
                style: theme.textTheme.bodySmall,
              ),
              Text(
                '• Tokens per download: ${state.tokensPerDownload}',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                state.thresholdRecommendation,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: ClonesColors.tertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
