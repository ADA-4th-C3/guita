//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct FullLessonViewState {
  let currentStepIndex: Int
  let steps: [FullLessonStep]
  var currentStep: FullLessonStep {
    steps[currentStepIndex]
  }

  // SongProgressBar를 위한 시간
  var currentTime: Double = 0.0
  var totalDuration: Double = 0.0

  var isPlaying: Bool = false

  /// 기능 사용 여부
  let isPermissionGranted: Bool
  let isVoiceCommandEnabled: Bool

  func copy(
    currentStepIndex: Int? = nil,
    steps: [FullLessonStep]? = nil,
    currentTime: Double? = nil,
    totalDuration: Double? = nil,
    isPlaying: Bool? = nil,
    isPermissionGranted: Bool? = nil,
    isVoiceCommandEnabled: Bool? = nil
  ) -> FullLessonViewState {
    return FullLessonViewState(
      currentStepIndex: currentStepIndex ?? self.currentStepIndex,
      steps: steps ?? self.steps,
      currentTime: currentTime ?? self.currentTime,
      totalDuration: totalDuration ?? self.totalDuration,
      isPlaying: isPlaying ?? self.isPlaying,
      isPermissionGranted: isPermissionGranted ?? self.isPermissionGranted,
      isVoiceCommandEnabled: isVoiceCommandEnabled ?? self.isVoiceCommandEnabled
    )
  }
}
