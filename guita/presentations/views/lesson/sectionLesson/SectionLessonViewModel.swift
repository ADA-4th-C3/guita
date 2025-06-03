//
//  SectionLessonViewModel.swift
//  guita
//
//  Created by 박정욱 on 6/3/25.
//

//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

final class SectionLessonViewModel: BaseViewModel<SectionLessonViewState> {
  
  private let voiceCommandManager = VoiceCommandManager.shared
  private let audioRecorderManager: AudioRecorderManager = .shared
  private let audioPlayerManager: AudioPlayerManager = .shared

  private var playTask: Task<Void, Never>? = nil
  private let router: Router

  init(_ router: Router, _ chord: Chord, _ chords: [Chord]) {
    self.router = router
    let state = SectionLessonViewState(
      index: 0,
      currentStepPlayCount: 0,
      currentStepDescription: "",
      isPermissionGranted: false,
      isVoiceCommandEnabled: false
    )
    super.init(state: state)
  }

  private func cancelPlayTask() {
    playTask?.cancel()
  }

  /// 레슨 재생
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
        await chordLesson.startFullChord(state.isReplay, index: state.index)
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
        currentStepPlayCount: state.nextStep != state.step ? 0 : nil
      ))
      playStepChangeSound {
        self.play()
      }
    }
  }

  /// 이전 레슨으로 이동
  func goPrevious() {
    cancelPlayTask()
    if state.step == .introduction { return }
    emit(state.copy(
      index: state.index - 1,
      currentStepPlayCount: state.prevStep != state.step ? 0 : nil
    ))
    playStepChangeSound {
      self.play()
    }
  }

  /// 권한 승인
  func onPermissionGranted() {
    if state.isPermissionGranted { return }
    emit(state.copy(isPermissionGranted: true))
    startVoiceCommand()
    startClassification()
  }

  /// 다음 코드 학습으로 넘어가기
  func startNextChord(_ nextChord: Chord) {
    let nextState = state.copy(
      chord: nextChord,
      index: 0,
      currentStepPlayCount: 0,
      currentStepDescription: ""
    )
    chordLesson = ChordLesson(nextChord, nextState.totalStep)
    emit(nextState)
    play()
  }

  /// 음성 명령 인식 시작
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

  /// 사운드 분류 시작
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