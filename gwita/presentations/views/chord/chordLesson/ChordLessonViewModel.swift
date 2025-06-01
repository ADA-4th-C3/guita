//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

final class ChordLessonViewModel: BaseViewModel<ChordLessonViewState> {
  private let chordLesson: ChordLesson
  private var playTask: Task<Void, Never>? = nil
  
  init(_ chord: Chord) {
    chordLesson = ChordLesson(chord)
    super.init(state: .init(chord: chord, step: .introduction, currentStepPlayCount: 0, isPlay: false))
  }
  
  private func cancelPlayTask() {
    playTask?.cancel()
  }
  
  
  func play() {
    cancelPlayTask()
    self.emit(self.state.copy(
      currentStepPlayCount: state.currentStepPlayCount + 1
    ))
    playTask = Task {
      switch state.step {
      case .introduction:
        await chordLesson.startIntroduction(state.isReplay)
      case .lineByLine:
        await chordLesson.startLineByLine(state.isReplay)
      case .fullChord:
        chordLesson.startFullChord(state.isReplay)
      case .finish:
        break
      }
    }
  }
  
  func goNext() {
    cancelPlayTask()
    if state.step == .finish { return }
    emit(state.copy(
      step: state.step.next,
      currentStepPlayCount: 0
    ))
    play()
  }
  
  func goPrevious() {
    cancelPlayTask()
    if state.step == .introduction { return }
    emit(state.copy(
      step: state.step.previous,
      currentStepPlayCount: 0
    ))
    play()
  }
  
  override func dispose() {
    cancelPlayTask()
  }
}
