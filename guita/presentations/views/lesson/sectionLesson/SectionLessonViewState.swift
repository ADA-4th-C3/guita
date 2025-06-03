//
//  SectionLessonViewState.swift
//  guita
//
//  Created by 박정욱 on 6/3/25.
//

struct SectionLessonViewState {
  let currentStepIndex: Int
  let steps: [SectionLessonStep]
  var currentStep: SectionLessonStep {
    steps[currentStepIndex]
  }

  /// 기능 사용 여부
  let isPermissionGranted: Bool
  let isVoiceCommandEnabled: Bool

  func copy(
    currentStepIndex: Int? = nil,
    steps: [SectionLessonStep]? = nil,
    isPermissionGranted: Bool? = nil,
    isVoiceCommandEnabled: Bool? = nil
  ) -> SectionLessonViewState {
    return SectionLessonViewState(
      currentStepIndex: currentStepIndex ?? self.currentStepIndex,
      steps: steps ?? self.steps,
      isPermissionGranted: isPermissionGranted ?? self.isPermissionGranted,
      isVoiceCommandEnabled: isVoiceCommandEnabled ?? self.isVoiceCommandEnabled
    )
  }
}
