//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

final class ChordLessonViewModel: BaseViewModel<ChordLessonViewState> {
  private let voiceCommandManager = VoiceCommandManager.shared
  private let audioRecorderManager: AudioRecorderManager = .shared
  private let audioPlayerManager: AudioPlayerManager = .shared
  private let textToSpeechManager: TextToSpeechManager = .shared
  private let noteClassification: NoteClassification = .init()
  private let chordClassification: ChordClassification = .init()
  private let noteThrottle = ThrottleAggregator<Note>(
    interval: ConfigManager.shared.state.noteThrottleInterval
  )
  private let chordThrottle = ThrottleAggregator<Chord>(
    interval: ConfigManager.shared.state.chordThrottleInterval
  )
  private var chordLesson: ChordLesson
  private var playTask: Task<Void, Never>? = nil
  private let router: Router

  init(_ router: Router, _ chord: Chord, _ chords: [Chord]) {
    self.router = router
    chordLesson = ChordLesson(chord)
    super.init(state: ChordLessonViewState(
      chords: chords,
      chord: chord,
      index: 0,
      currentStepDescription: "",
      isPermissionGranted: false,
      isVoiceCommandEnabled: false,
      isReplay: false,
      steps: chordLesson.steps
    ))
  }

  private func cancelPlayTask() {
    playTask?.cancel()
  }

  /// 레슨 재생
  func play() {
    cancelPlayTask()

    Task {
      try? await Task.sleep(nanoseconds: 300_000_000)
      emit(state.copy(
        isReplay: true
      ))
    }
    playTask = Task {
      switch state.step {
      case .introduction:
        await chordLesson.startIntroduction(state.isReplay)
      case let .lineFingering(nString, nFret, nFinger, coordIdx):
        await chordLesson.startLineFingering(
          state.isReplay,
          index: state.index,
          nString: nString,
          nFret: nFret,
          nFinger: nFinger,
          coordIdx: coordIdx
        )
      case let .lineSoundCheck(nString, nFret, nFinger, coordIdx):
        await chordLesson.startLineSoundCheck(
          state.isReplay,
          index: state.index,
          nString: nString,
          nFret: nFret,
          nFinger: nFinger,
          coordIdx: coordIdx
        )
      case .chordFingering:
        await chordLesson.startChordFingering(state.isReplay, index: state.index)
      case .chordSoundCheck:
        await chordLesson.startChordSoundCheck(state.isReplay, index: state.index)
      case .finish:
        await chordLesson.startFinish(state.isReplay, nextChord: state.nextChord)
      }
    }
  }

  /// 다음 레슨으로 이동
  func goNext() {
    cancelPlayTask()
    if state.step == .finish {
      guard let nextChord = state.nextChord else {
        // 코드 학습 종료
        router.pop()
        return
      }

      // 다음 코드 시작
      startNextChord(nextChord)
      playStepChangeSound()
    } else {
      // 다음 스탭
      emit(state.copy(
        index: state.index + 1,
        isReplay: false
      ))
      playStepChangeSound()
    }
  }

  func readDescription() {
    Task {
      await textToSpeechManager.speak(state.description)
    }
  }

  /// 이전 레슨으로 이동
  func goPrevious() {
    cancelPlayTask()
    if state.step == .introduction { return }
    emit(state.copy(
      index: state.index - 1,
      isReplay: false
    ))
    playStepChangeSound()
  }

  /// 권한 승인
  func onPermissionGranted() {
    if state.isPermissionGranted { return }
    DispatchQueue.main.async {
      self.emit(self.state.copy(isPermissionGranted: true))
      self.startVoiceCommand()
      self.startClassification()
    }
  }

  /// 다음 코드 학습으로 넘어가기
  func startNextChord(_ nextChord: Chord) {
    let nextState = state.copy(
      chord: nextChord,
      index: 0,
      currentStepDescription: ""
    )
    chordLesson = ChordLesson(nextChord)
    emit(nextState)
    play()
  }

  /// 음성 명령 인식 시작
  private func startVoiceCommand() {
    voiceCommandManager.start(
      commands: [
        VoiceCommand(keyword: .play, handler: play),
        VoiceCommand(keyword: .retry, handler: play),
        VoiceCommand(keyword: .next, handler: {
          self.goNext()
          self.play()
        }),
        VoiceCommand(keyword: .previous, handler: {
          self.goPrevious()
          self.play()
        }),
      ]
    )
    emit(state.copy(
      isVoiceCommandEnabled: true
    ))
  }

  /// 사운드 분류 시작
  private func startClassification() {
    audioRecorderManager.start { buffer, _ in
      // Chord classification
      if let (chord, chordConfidence) = self.chordClassification.run(
        buffer: buffer,
        windowSize: self.audioRecorderManager.windowSize,
        activeChords: [self.state.chord]
      ) {
        if let throttledChord = self.chordThrottle.add(value: chord, confidence: chordConfidence) {
          self.chordLesson.onChordClassified(userChord: throttledChord.value)
        }
      }

      // Note classification
      if let (note, noteConfidence) = self.noteClassification.run(
        buffer: buffer,
        sampleRate: self.audioRecorderManager.sampleRate,
        windowSize: self.audioRecorderManager.windowSize
      ) {
        if let throttledNote = self.noteThrottle.add(value: note, confidence: noteConfidence) {
          self.chordLesson.onNoteClassified(userNote: throttledNote.value)
        }
      }
    }
  }

  private func playStepChangeSound(completion: (() -> Void)? = nil) {
    Task {
      await self.audioPlayerManager.start(audioFile: .next)
      try? await Task.sleep(nanoseconds: 200_000_000)
      completion?()
    }
  }

  override func dispose() {
    cancelPlayTask()
    voiceCommandManager.stop()
    audioRecorderManager.stop()
  }
}

extension ChordLessonViewModel {
  var nextChordAccessibilityLabel: String {
    let isLastStep = state.index + 1 == state.totalStep
    if isLastStep {
      if let nextChord = state.nextChord {
        return "다음으로 학습할 코드는 \(nextChord.rawValue) 코드 입니다. \(nextChord.rawValue) 코드로 넘어가기"
      } else {
        return "다음"
      }
    } else {
      return "다음"
    }
  }
}
