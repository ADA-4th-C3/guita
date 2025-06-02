//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct ChordLessonViewState {
  /// 학습 중인 코드
  let chord: Chord

  /// 현재 단계
  let index: Int

  /// 현재 단계 반복 횟수 ([ChordLessonStep]가 바뀌는 경우에만 초기화 됨)
  let currentStepPlayCount: Int
  
  /// 현재 단계 설명
  let currentStepDescription: String

  /// 기능 사용 여부
  let isPermissionGranted: Bool
  let isVoiceCommandEnabled: Bool

  /// 반복 실행 여부
  var isReplay: Bool { currentStepPlayCount > 1 }

  /// 레슨 스탭
  var step: ChordLessonStep { getStep(index) }
  var nextStep: ChordLessonStep { getStep(index + 1) }
  var prevStep: ChordLessonStep { getStep(index - 1) }

  /// 전체 스탭 개수
  var totalStep: Int {
    let intro = 1
    let lineByLine = chord.coordinates.count
    let fullChord = 1
    let finish = 1
    return intro + lineByLine + fullChord + finish
  }

  private func getStep(_ i: Int) -> ChordLessonStep {
    i == 0 ? .introduction
      : i == totalStep - 1 ? .finish
      : i == totalStep - 2 ? .fullChord
      : .lineByLine
  }

  func copy(
    chord: Chord? = nil,
    index: Int? = nil,
    currentStepPlayCount: Int? = nil,
    currentStepDescription: String? = nil,
    isPermissionGranted: Bool? = nil,
    isVoiceCommandEnabled: Bool? = nil
  ) -> ChordLessonViewState {
    return ChordLessonViewState(
      chord: chord ?? self.chord,
      index: index ?? self.index,
      currentStepPlayCount: currentStepPlayCount ?? self.currentStepPlayCount,
      currentStepDescription: currentStepDescription ?? self.currentStepDescription,
      isPermissionGranted: isPermissionGranted ?? self.isPermissionGranted,
      isVoiceCommandEnabled: isVoiceCommandEnabled ?? self.isVoiceCommandEnabled
    )
  }
}
