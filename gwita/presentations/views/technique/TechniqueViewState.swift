//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct TechniqueViewState {
  let currentStepIndex: Int
  let steps: [LearningStep]
  let currentStep: LearningStep

  
  func copy(currentStepIndex: Int? = nil, steps: [LearningStep]? = nil, currentStep: LearningStep? = nil) -> TechniqueViewState {
    return TechniqueViewState(
      currentStepIndex: currentStepIndex ?? self.currentStepIndex,
      steps: steps ?? self.steps,
      currentStep: currentStep ?? self.currentStep
    )
  }
}
