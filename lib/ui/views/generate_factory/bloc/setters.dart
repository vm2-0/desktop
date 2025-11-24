import 'package:clones_desktop/domain/models/factory/workflow_task.dart';
import 'package:clones_desktop/ui/views/generate_factory/bloc/state.dart';
import 'package:riverpod/riverpod.dart';

mixin GenerateFactorySetters on AutoDisposeNotifier<GenerateFactoryState> {
  void setCurrentStep(GenerateFactoryStep currentStep) {
    state = state.copyWith(currentStep: currentStep);
  }

  void setSkills(String skills) {
    // Validate each skill line doesn't exceed 500 characters
    final skillLines = skills.split('\n');
    var hasInvalidSkill = false;
    String? error;

    for (var i = 0; i < skillLines.length; i++) {
      final skill = skillLines[i].trim();
      if (skill.isNotEmpty && skill.length > 500) {
        hasInvalidSkill = true;
        error =
            'Skill ${i + 1} is too long (${skill.length}/500 characters max)';
        break;
      }
    }

    if (hasInvalidSkill) {
      state = state.copyWith(skills: skills, error: error);
    } else {
      state = state.copyWith(skills: skills, error: null);
    }
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void setFactoryName(String factoryName) {
    // Validate factory name length (500 characters max)
    if (factoryName.length > 500) {
      state = state.copyWith(
        factoryName: factoryName,
        error:
            'Factory name is too long (${factoryName.length}/500 characters max)',
      );
    } else {
      // Clear error if it was about factory name length
      var currentError = state.error;
      if (currentError != null &&
          currentError.contains('Factory name is too long')) {
        currentError = null;
      }
      state = state.copyWith(factoryName: factoryName, error: currentError);
    }
  }

  void setTasks(List<WorkflowTask> tasks) {
    state = state.copyWith(tasks: tasks);
  }

  void setSelectedToken(String symbol) {
    state = state.copyWith(selectedTokenSymbol: symbol);
  }

  // Abstract method to be implemented by the notifier
  Future<void> predictPoolAddress();

  void setFundingAmount(String amount) {
    state = state.copyWith(fundingAmount: amount);
  }

  void setOpenSourceAppsOnly(bool value) {
    state = state.copyWith(openSourceAppsOnly: value);
  }

  void setWebappAppsOnly(bool value) {
    state = state.copyWith(webappAppsOnly: value);
    if (value) {
      state = state.copyWith(desktopAppsOnly: false);
    }
  }

  void setDesktopAppsOnly(bool value) {
    state = state.copyWith(desktopAppsOnly: value);
    if (value) {
      state = state.copyWith(webappAppsOnly: false);
    }
  }
}
