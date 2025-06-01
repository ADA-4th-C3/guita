//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct ChordLessonViewState {
  let chord: Chord
  
  func copy(withChord newChord: Chord? = nil) -> ChordLessonViewState {
    return ChordLessonViewState(
      chord: newChord ?? self.chord
    )
  }
}
