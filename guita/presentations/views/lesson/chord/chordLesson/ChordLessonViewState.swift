//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

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

  /// 전체 레슨
  let steps: [ChordLessonStep]

  /// 현재 레슨
  var step: ChordLessonStep { steps[index] }
  var nextStep: ChordLessonStep { index + 1 > totalStep ? .finish : steps[index + 1] }
  var prevStep: ChordLessonStep { index - 1 < 0 ? .introduction : steps[index - 1] }

  /// 전체 스탭 개수
  var totalStep: Int { steps.count }

  /// 설명
  var description: String { step.getDescription(chord, index: index) }

  /// 다음 배울 코드
  var nextChord: Chord? {
    guard let currentIndex = chords.firstIndex(where: { $0 == chord }) else {
      return nil
    }
    let nextIndex = currentIndex + 1
    return nextIndex < chords.count ? chords[nextIndex] : nil
  }

  var nextChordAccessibilityLabel: String {
    let isLastStep = index + 1 == totalStep
    if isLastStep, let nextChord = nextChord {
      return String(
        format: NSLocalizedString("ChordLesson.NextLabel1", comment: ""),
        "\(nextChord.rawValue)"
      )
    }

    return NSLocalizedString("Next", comment: "")
  }

  func copy(
    chords: [Chord]? = nil,
    chord: Chord? = nil,
    index: Int? = nil,
    currentStepDescription: String? = nil,
    isPermissionGranted: Bool? = nil,
    isVoiceCommandEnabled: Bool? = nil,
    isReplay: Bool? = nil,
    steps: [ChordLessonStep]? = nil
  ) -> ChordLessonViewState {
    return ChordLessonViewState(
      chords: chords ?? self.chords,
      chord: chord ?? self.chord,
      index: index ?? self.index,
      currentStepDescription: currentStepDescription ?? self.currentStepDescription,
      isPermissionGranted: isPermissionGranted ?? self.isPermissionGranted,
      isVoiceCommandEnabled: isVoiceCommandEnabled ?? self.isVoiceCommandEnabled,
      isReplay: isReplay ?? self.isReplay,
      steps: steps ?? self.steps
    )
  }
}
