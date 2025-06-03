//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

final class FullLessonViewModel: BaseViewModel<FullLessonViewState> {
  private let voiceCommandManager = VoiceCommandManager.shared
  private let audioRecorderManager: AudioRecorderManager = .shared
  private let audioPlayerManager: AudioPlayerManager = .shared
  private let textToSpeechManager = TextToSpeechManager.shared
  
  private var playTask: Task<Void, Never>? = nil
  private let router: Router
  
  private var progressTimer: Timer?
  
  init(_ router: Router) {
    self.router = router
    let steps = FullLesson.makeSteps()
    
    super.init(state: FullLessonViewState(
      currentStepIndex: 0,
      steps: steps,
      isPermissionGranted: false,
      isVoiceCommandEnabled: false
    ))
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
  func play(isRetry: Bool = false) {
    cancelPlayTask()
    playTask = Task {
      do {
        try await Task.sleep(nanoseconds: 100_000_000)
        
        let currentStep = state.steps[state.currentStepIndex]
        // 추후 다른 곡 추가할 때 사용
        //        let stepNumber = currentStep.step
        //        let totalSteps = state.steps.count
        
        for lessonInfo in currentStep.fullLessonInfo {
          try Task.checkCancellation()
          if let ttsText = lessonInfo.ttsText {
            await textToSpeechManager.speak(ttsText)
          }
          try Task.checkCancellation()
          if let audioFile = currentStep.audioFile {
            await AudioPlayerManager.shared.start(audioFile: audioFile)
          }
        }
        if !isRetry {
          await textToSpeechManager.speak(currentStep.featureDescription)
        }
      } catch {
        textToSpeechManager.stop()
        AudioPlayerManager.shared.stop()
      }
    }
    startProgressTracking()
  }
  
  /// 정지
  func pause() {
//    cancelPlayTask()
    AudioPlayerManager.shared.pause()
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
  
  /// SongProgressBar Tracking Start
  func startProgressTracking() {
    progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
      let currentTime = self.audioPlayerManager.getCurrentTime()
      let duration = self.audioPlayerManager.getDuration()
      
      self.emit(self.state.copy(
        currentTime: currentTime,
        totalDuration: duration
      ))
    }
  }
  
  /// SongProgressBar Tracking Stop
  func stopProgressTracking() {
    progressTimer?.invalidate()
    progressTimer = nil
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
    Logger.d("최대 속도 확인: \(audioPlayerManager.getCurrentRate())")
    Logger.d("최대 속도 확인: \(audioPlayerManager.isAtMaxRate())")
    return audioPlayerManager.isAtMaxRate()
  }
  
  /// 최소 속도 확인
  func isMinPlaybackRate() -> Bool {
    Logger.d("최소 속도 확인: \(audioPlayerManager.getCurrentRate())")
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
    stopProgressTracking()
  }
  
  override func dispose() {
    cancelPlayTask()
    voiceCommandManager.stop()
    audioRecorderManager.stop()
  }
}

