//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct TechniqueLessonViewState {
  let currentStepIndex: Int
  let steps: [TechniqueLessonStep]
  var currentStep: TechniqueLessonStep {
    steps[currentStepIndex]
  }

  func copy(currentStepIndex: Int? = nil, steps: [TechniqueLessonStep]? = nil) -> TechniqueLessonViewState {
    return TechniqueLessonViewState(
      currentStepIndex: currentStepIndex ?? self.currentStepIndex,
      steps: steps ?? self.steps
    )
  }
}
