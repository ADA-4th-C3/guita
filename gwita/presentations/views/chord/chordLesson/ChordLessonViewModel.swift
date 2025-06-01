//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

final class ChordLessonViewModel: BaseViewModel<ChordLessonViewState> {
  private var chordLesson: ChordLesson
  private var playTask: Task<Void, Never>? = nil

  init(_ chord: Chord) {
    let state = ChordLessonViewState(chord: chord, index: 0, currentStepPlayCount: 0)
    chordLesson = ChordLesson(chord, state.totalStep)
    super.init(state: state)
  }

  private func cancelPlayTask() {
    playTask?.cancel()
  }

  func play() {
    cancelPlayTask()
    emit(state.copy(
      currentStepPlayCount: state.currentStepPlayCount + 1
    ))
    playTask = Task {
      switch state.step {
      case .introduction:
        await chordLesson.startIntroduction(state.isReplay)
      case .lineByLine:
        await chordLesson.startLineByLine(state.isReplay, index: state.index)
      case .fullChord:
        await chordLesson.startFullChord(state.isReplay)
      case .finish:
        break
      }
    }
  }

  func goNext() {
    cancelPlayTask()
    if state.step == .finish { return }
    emit(state.copy(
      index: state.index + 1,
      currentStepPlayCount: state.nextStep != state.step ? 0 : nil
    ))
    play()
  }

  func goPrevious() {
    cancelPlayTask()
    if state.step == .introduction { return }
    emit(state.copy(
      index: state.index - 1,
      currentStepPlayCount: state.prevStep != state.step ? 0 : nil
    ))
    play()
  }

  override func dispose() {
    cancelPlayTask()
  }
}
