//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class ChordLessonViewModel: BaseViewModel<ChordLessonViewState> {
  private let chordLesson: ChordLesson
  
  init(_ chord: Chord) {
    chordLesson = ChordLesson(chord)
    super.init(state: .init(chord: chord, step: .introduction, previousStep: nil, isPlay: false))
  }
  
  func goPrevious() {}
  
  func play() {
    let previousStep = state.step
    Task {
      switch state.step {
      case .introduction:
        await chordLesson.startIntroduction(state.isReplay)
      case .lineByLine:
        await chordLesson.startLineByLine(state.isReplay)
      case .fullChord:
        await chordLesson.startFullChord(state.isReplay)
      }
      self.emit(self.state.copy(previousStep: previousStep))
    }
  }
  
  func goNext() {}
  
}
