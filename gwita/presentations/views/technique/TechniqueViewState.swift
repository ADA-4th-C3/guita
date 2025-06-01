//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct TechniqueViewState {
  let currentStepIndex: Int
  let steps: [TechniqueStep]
  var currentStep: TechniqueStep {
    steps[currentStepIndex]
  }

  func copy(currentStepIndex: Int? = nil, steps: [TechniqueStep]? = nil) -> TechniqueViewState {
    return TechniqueViewState(
      currentStepIndex: currentStepIndex ?? self.currentStepIndex,
      steps: steps ?? self.steps
    )
  }
}
