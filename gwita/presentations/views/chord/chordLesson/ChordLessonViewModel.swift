//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

final class ChordLessonViewModel: BaseViewModel<ChordLessonViewState> {
  private let voiceCommandManager = VoiceCommandManager.shared
  private let audioRecorderManager: AudioRecorderManager = .shared
  private let noteClassification: NoteClassification = .init()
  private let chordClassification: ChordClassification = .init()
  private var chordLesson: ChordLesson
  private var playTask: Task<Void, Never>? = nil

  init(_ chord: Chord) {
    let state = ChordLessonViewState(
      chord: chord,
      index: 0,
      currentStepPlayCount: 0,
      isPermissionGranted: false,
      isVoiceCommandEnabled: false
    )
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
        await chordLesson.startFinish(state.isReplay)
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

  func onPermissionGranted() {
    if state.isPermissionGranted { return }
    emit(state.copy(isPermissionGranted: true))
    startVoiceCommand()
    startClassification()
  }

  private func startVoiceCommand() {
    voiceCommandManager.start(
      commands: [
        VoiceCommand(keyword: .play, handler: play),
        VoiceCommand(keyword: .retry, handler: play),
        VoiceCommand(keyword: .next, handler: goNext),
        VoiceCommand(keyword: .previous, handler: goPrevious),
      ]
    )
    emit(state.copy(
      isVoiceCommandEnabled: true
    ))
  }

  private func startClassification() {
    audioRecorderManager.start { buffer, _ in
      // Chord classification
      let chord = self.chordClassification.detectCode(
        buffer: buffer,
        windowSize: self.audioRecorderManager.windowSize,
        activeChords: [self.state.chord]
      )
      self.chordLesson.onChordClassified(userChord: chord)

      // Note classification
      let note = self.noteClassification.run(
        buffer: buffer,
        sampleRate: self.audioRecorderManager.sampleRate,
        windowSize: self.audioRecorderManager.windowSize
      )
      self.chordLesson.onNoteClassified(userNote: note, index: self.state.index)
    }
  }

  override func dispose() {
    cancelPlayTask()
    voiceCommandManager.stop()
    audioRecorderManager.stop()
  }
}
