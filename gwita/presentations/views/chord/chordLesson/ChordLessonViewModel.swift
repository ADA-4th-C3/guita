//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class ChordLessonViewModel: BaseViewModel<ChordLessonViewState> {
  init(_ chord: Chord) {
    super.init(state: .init(chord: chord))
  }
}
