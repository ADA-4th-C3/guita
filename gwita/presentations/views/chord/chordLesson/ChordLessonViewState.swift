//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct ChordLessonViewState {
  let chord: Chord
  let step: ChordLessonStep
  let previousStep: ChordLessonStep?
  let isPlay: Bool
  
  var isReplay: Bool {
    previousStep == step
  }

  
  func copy(
    chord: Chord? = nil,
    step: ChordLessonStep? = nil,
    previousStep: ChordLessonStep? = nil,
    isPlay: Bool? = nil
  ) -> ChordLessonViewState {
    return ChordLessonViewState(
      chord: chord ?? self.chord,
      step: step ?? self.step,
      previousStep: previousStep ?? self.previousStep,
      isPlay: isPlay ?? self.isPlay
    )
  }
}
