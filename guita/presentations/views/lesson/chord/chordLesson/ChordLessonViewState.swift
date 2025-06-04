//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct ChordLessonViewState {
  /// 전체 코드
  let chords: [Chord]

  /// 학습 중인 코드
  let chord: Chord

  /// 현재 단계
  let index: Int

  /// 현재 단계 설명
  let currentStepDescription: String

  /// 기능 사용 여부
  let isPermissionGranted: Bool
  let isVoiceCommandEnabled: Bool

  /// 반복 실행 여부
  let isReplay: Bool

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

  /// 전달 받은 index에 따른 스탭
  private func getStep(_ i: Int) -> ChordLessonStep {
    i == 0 ? .introduction
      : i == totalStep - 1 ? .finish
      : i == totalStep - 2 ? .fullChord
      : .lineByLine
  }

  /// 다음 배울 코드
  var nextChord: Chord? {
    guard let currentIndex = chords.firstIndex(where: { $0 == chord }) else {
      return nil
    }
    let nextIndex = currentIndex + 1
    return nextIndex < chords.count ? chords[nextIndex] : nil
  }

  func copy(
    chords: [Chord]? = nil,
    chord: Chord? = nil,
    index: Int? = nil,
    currentStepDescription: String? = nil,
    isPermissionGranted: Bool? = nil,
    isVoiceCommandEnabled: Bool? = nil,
    isReplay: Bool? = nil
  ) -> ChordLessonViewState {
    return ChordLessonViewState(
      chords: chords ?? self.chords,
      chord: chord ?? self.chord,
      index: index ?? self.index,
      currentStepDescription: currentStepDescription ?? self.currentStepDescription,
      isPermissionGranted: isPermissionGranted ?? self.isPermissionGranted,
      isVoiceCommandEnabled: isVoiceCommandEnabled ?? self.isVoiceCommandEnabled,
      isReplay: isReplay ?? self.isReplay
    )
  }
}
