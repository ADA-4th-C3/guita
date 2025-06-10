//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct TechniqueLessonViewState {
  let isPermissionGranted: Bool
  let currentStepIndex: Int
  let steps: [TechniqueLessonStep]
  var currentStep: TechniqueLessonStep {
    steps[currentStepIndex]
  }

  var totalStep: Int { steps.count }
  var isLastStep: Bool {
    currentStepIndex == totalStep - 1
  }

  func copy(
    isPermissionGranted: Bool? = nil,
    currentStepIndex: Int? = nil,
    steps: [TechniqueLessonStep]? = nil
  ) -> TechniqueLessonViewState {
    return TechniqueLessonViewState(
      isPermissionGranted: isPermissionGranted ?? self.isPermissionGranted,
      currentStepIndex: currentStepIndex ?? self.currentStepIndex,
      steps: steps ?? self.steps
    )
  }
}
