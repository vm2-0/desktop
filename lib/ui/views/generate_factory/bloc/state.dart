import 'package:clones_desktop/domain/models/factory/workflow_task.dart';
import 'package:clones_desktop/domain/models/supported_token.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

enum GenerateFactoryStep {
  input,
  generating,
  preview,
}

@freezed
class GenerateFactoryState with _$GenerateFactoryState {
  const factory GenerateFactoryState({
    String? skills,
    String? error,
    String? factoryName,
    List<WorkflowTask>? tasks,
    @Default(false) bool showJsonEditor,
    @Default(GenerateFactoryStep.input) GenerateFactoryStep currentStep,
    @Default(false) bool isCreating,
    @Default(false) bool isCreated,
    List<SupportedToken>? supportedTokens,
    String? selectedTokenSymbol,
    String? predictedPoolAddress,
    String? fundingAmount,
    String? estimatedGasCost,
    bool? gasExceedsReward,
    String? transactionStatus,
    @Default(false) bool openSourceAppsOnly,
    @Default(false) bool webappAppsOnly,
    @Default(false) bool desktopAppsOnly,
  }) = _GenerateFactoryState;
  const GenerateFactoryState._();

  List<Map<String, String>> get examplePrompts => [
        {
          'label': 'AI-Powered Workflows',
          'text':
              'Combining ChatGPT web interface, Claude desktop app, Perplexity research, and traditional document tools for content creation and analysis',
        },
        {
          'label': 'Social Commerce & Creator Economy',
          'text':
              'Managing multi-platform content across TikTok Creator Center, YouTube Studio, Instagram Business Suite, and emerging platforms like Threads and Bluesky',
        },
        {
          'label': 'Content Creation Pipeline',
          'text':
              'Research workflows combining browser research, AI writing assistants, design tools, and multi-platform publishing systems',
        },
        {
          'label': 'No-Code Development',
          'text':
              'Building applications using Webflow, Airtable databases, Zapier automations, and integration testing across browser environments',
        },
        {
          'label': 'Data Analysis & Reporting',
          'text':
              'Processing business data through Excel/Google Sheets, creating visualizations in web-based tools, and presenting findings via multiple platforms',
        },
        {
          'label': 'Customer Support Operations',
          'text':
              'Managing support workflows across ticketing systems, knowledge bases, CRM platforms, and real-time communication tools',
        },
        {
          'label': 'Financial Management',
          'text':
              'Tracking expenses across banking apps, reconciling data in spreadsheets, generating reports, and coordinating with accounting software',
        },
      ];
}
