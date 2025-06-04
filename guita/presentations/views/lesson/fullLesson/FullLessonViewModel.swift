//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Combine
import Foundation

final class FullLessonViewModel: BaseViewModel<FullLessonViewState> {
  private let router: Router
  private let voiceCommandManager: VoiceCommandManager = .shared
  private let audioRecorderManager: AudioRecorderManager = .shared
  private let audioPlayerManager: AudioPlayerManager = .shared
  private let textToSpeechManager: TextToSpeechManager = .shared
  private var audioPlayerManagerCancellables = Set<AnyCancellable>()
  
  init(_ router: Router, _ songInfo : SongInfo) {
    self.router = router
    let steps = FullLesson.makeSteps()
    
    super.init(state: FullLessonViewState(
      songInfo: songInfo,
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
      .store(in: &audioPlayerManagerCancellables)
    
    audioPlayerManager.initialize(state.songInfo.fullSong)
  }
  
  /// 권한 승인
  func onPermissionGranted() {
    if state.isPermissionGranted { return }
    emit(state.copy(isPermissionGranted: true))
    startVoiceCommand()
  }
  
  /// 노래 재생 시작
  func play() {
    Task {
      await audioPlayerManager.start(audioFile: state.songInfo.fullSong)
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
  
  /// 재생 시간 변경
  func setCurrentTime(_ currentTime: Double) {
    audioPlayerManager.setCurrentTime(currentTime)
  }
  
  /// 다음 step
  func nextStep() {
    guard state.currentStepIndex < state.steps.count - 1 else { return }
    
    let newIndex = state.currentStepIndex + 1
    emit(state.copy(currentStepIndex: newIndex))
  }
  
  /// 이전 step
  func previousStep() {
    guard state.currentStepIndex > 0 else { return }
    let newIndex = state.currentStepIndex - 1
    emit(state.copy(
      currentStepIndex: newIndex
    ))
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
        VoiceCommand(keyword: .play, handler: {
          self.state.playerState == .stopped ? self.play() : self.resume()
        }),
        VoiceCommand(keyword: .retry, handler: { self.play() }),
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
    voiceCommandManager.stop()
    audioRecorderManager.stop()
  }
}
