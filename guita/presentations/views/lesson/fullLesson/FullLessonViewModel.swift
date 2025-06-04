//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import Combine

final class FullLessonViewModel: BaseViewModel<FullLessonViewState> {
  private let voiceCommandManager: VoiceCommandManager = .shared
  private let audioRecorderManager: AudioRecorderManager = .shared
  private let audioPlayerManager: AudioPlayerManager = .shared
  private let textToSpeechManager: TextToSpeechManager = .shared

  private var playTask: Task<Void, Never>? = nil
  private let router: Router

  private var cancellables = Set<AnyCancellable>()

  init(_ router: Router) {
    self.router = router
    let steps = FullLesson.makeSteps()

    super.init(state: FullLessonViewState(
      currentStepIndex: 0,
      steps: steps,
      playerState: .stopped,
      isPermissionGranted: false,
      isVoiceCommandEnabled: false
    ))
    
    audioPlayerManager.$state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] audioPlayerManagerState in
        guard let self = self else { return }
        self.emit(self.state.copy(
          playerState: audioPlayerManagerState.playerState,
          currentTime: audioPlayerManagerState.currentTime,
          totalDuration: audioPlayerManagerState.totalDuration
        ))
      }
      .store(in: &cancellables)
  }

  /// 권한 승인
  func onPermissionGranted() {
    if state.isPermissionGranted { return }
    emit(state.copy(isPermissionGranted: true))
    startVoiceCommand()
  }

  /// 실행 중인 비동기 작업 정지
  private func cancelPlayTask() {
    playTask?.cancel()
  }

  /// 노래 재생 시작
  func play(isRetry _: Bool = false) {
    cancelPlayTask()
    playTask = Task {
      await audioPlayerManager.start(audioFile: .full_song)
      // 오디오 재생이 끝난 후 TTS 재생
//      await textToSpeechManager.speak("다시 듣고 싶으시면 \"재생\"이라고 말씀해주십시오. 중간에 멈추고 싶으시면 \"정지\"라고 말씀해주십시오.")
    }
  }
  
  /// 재시작
  func resume() {
    audioPlayerManager.resume()
  }

  /// 정지
  func pause() {
    audioPlayerManager.pause()
  }

  /// 다음 step
  func nextStep() {
    cancelPlayTask()
    guard state.currentStepIndex < state.steps.count - 1 else { return }

    let newIndex = state.currentStepIndex + 1
    emit(state.copy(currentStepIndex: newIndex))
    playStepChangeSound {
      self.play()
    }
  }

  /// 이전 step
  func previousStep() {
    cancelPlayTask()
    guard state.currentStepIndex > 0 else { return }
    let newIndex = state.currentStepIndex - 1
    emit(state.copy(
      currentStepIndex: newIndex
    ))
    playStepChangeSound {
      self.play()
    }
  }

  /// 다음 스텝 사운드 재생
  func playStepChangeSound(completion: (() -> Void)? = nil) {
    Task {
      await AudioPlayerManager.shared.start(audioFile: .next)
      try? await Task.sleep(nanoseconds: 200_000_000)
      completion?()
    }
  }

  /// 현재 속도 반환
  func getPlaybackRate() -> Float {
    return audioPlayerManager.getCurrentRate()
  }

  /// 속도 빠르게
  func increasePlaybackRate() {
    audioPlayerManager.increasePlaybackRate()
  }

  /// 속도 느리게
  func decreasePlaybackRate() {
    audioPlayerManager.decreasePlaybackRate()
  }

  /// 최대 속도 확인
  func isMaxPlaybackRate() -> Bool {
    return audioPlayerManager.isAtMaxRate()
  }

  /// 최소 속도 확인
  func isMinPlaybackRate() -> Bool {
    return audioPlayerManager.isAtMinRate()
  }

  /// 음성 명령 인식 시작
  func startVoiceCommand() {
    voiceCommandManager.start(
      commands: [
        VoiceCommand(keyword: .play, handler: { self.play() }),
        VoiceCommand(keyword: .retry, handler: { self.play(isRetry: true) }),
        VoiceCommand(keyword: .next, handler: nextStep),
        VoiceCommand(keyword: .previous, handler: previousStep),
        VoiceCommand(keyword: .stop, handler: pause),
      ]
    )
  }

  /// 음성 명령 인식 정지
  func stopVoiceCommand() {
    voiceCommandManager.stop()
    textToSpeechManager.stop()
  }

  override func dispose() {
    cancelPlayTask()
    voiceCommandManager.stop()
    audioRecorderManager.stop()
  }
}
