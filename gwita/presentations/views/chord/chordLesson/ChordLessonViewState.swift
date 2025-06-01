//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct ChordLessonViewState {
  let chord: Chord
  let step: ChordLessonStep
  let currentStepPlayCount: Int
  let isPlay: Bool
  
  var isReplay: Bool {
    currentStepPlayCount > 1
  }

  
  func copy(
    chord: Chord? = nil,
    step: ChordLessonStep? = nil,
    currentStepPlayCount: Int? = nil,
    isPlay: Bool? = nil
  ) -> ChordLessonViewState {
    return ChordLessonViewState(
      chord: chord ?? self.chord,
      step: step ?? self.step,
      currentStepPlayCount: currentStepPlayCount ?? self.currentStepPlayCount,
      isPlay: isPlay ?? self.isPlay
    )
  }
}
