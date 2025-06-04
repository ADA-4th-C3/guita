//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct FullLessonViewState {
  let songInfo: SongInfo
  let currentStepIndex: Int
  let steps: [FullLessonStep]
  var currentStep: FullLessonStep {
    steps[currentStepIndex]
  }

  /// 재생 상태
  var playerState: AudioPlayerState

  /// SongProgressBar를 위한 시간
  var currentTime: Double = 0.0
  var totalDuration: Double = 0.0

  /// 기능 사용 여부
  let isPermissionGranted: Bool
  let isVoiceCommandEnabled: Bool

  func copy(
    songInfo: SongInfo? = nil,
    currentStepIndex: Int? = nil,
    steps: [FullLessonStep]? = nil,
    playerState: AudioPlayerState? = nil,
    currentTime: Double? = nil,
    totalDuration: Double? = nil,
    isPermissionGranted: Bool? = nil,
    isVoiceCommandEnabled: Bool? = nil
  ) -> FullLessonViewState {
    return FullLessonViewState(
      songInfo: songInfo ?? self.songInfo,
      currentStepIndex: currentStepIndex ?? self.currentStepIndex,
      steps: steps ?? self.steps,
      playerState: playerState ?? self.playerState,
      currentTime: currentTime ?? self.currentTime,
      totalDuration: totalDuration ?? self.totalDuration,
      isPermissionGranted: isPermissionGranted ?? self.isPermissionGranted,
      isVoiceCommandEnabled: isVoiceCommandEnabled ?? self.isVoiceCommandEnabled
    )
  }
}
