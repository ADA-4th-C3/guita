//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

final class SectionLessonViewModel: BaseViewModel<SectionLessonViewState> {
  
  private let voiceCommandManager = VoiceCommandManager.shared
  private let audioRecorderManager: AudioRecorderManager = .shared
  private let audioPlayerManager: AudioPlayerManager = .shared
  private let textToSpeechManager = TextToSpeechManager.shared
  
  private var playTask: Task<Void, Never>? = nil
  private let router: Router
  
  init(_ router: Router) {
    self.router = router
    let steps = SectionLesson.makeSteps()
    
    super.init(state: SectionLessonViewState(
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
  
  /// 정지???!?!
  private func cancelPlayTask() {
    playTask?.cancel()
  }
  
  /// 구간 반복 시작
  func play(isRetry: Bool = false) {
    cancelPlayTask()
    playTask = Task {
      do {
        try await Task.sleep(nanoseconds: 100_000_000)
        
        let currentStep = state.steps[state.currentStepIndex]
        let stepNumber = currentStep.step
        let totalSteps = state.steps.count
        
        await textToSpeechManager.speak("총 \(totalSteps) 단게 중 \(stepNumber) 단계")
        
        for lessonInfo in currentStep.sectionLessonInfo {
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
  
  func playStepChangeSound(completion: (() -> Void)? = nil) {
    Task {
      await AudioPlayerManager.shared.start(audioFile: .next)
      try? await Task.sleep(nanoseconds: 200_000_000)
      completion?()
    }
  }
  
  
  
  /// 음성 명령 인식 시작
  func startVoiceCommand() {
    voiceCommandManager.start(
      commands: [
        VoiceCommand(keyword: .play, handler: { self.play() }),
        VoiceCommand(keyword: .retry, handler: { self.play(isRetry: true) }),
        VoiceCommand(keyword: .next, handler: nextStep),
        VoiceCommand(keyword: .previous, handler: previousStep),
        VoiceCommand(keyword: .stop, handler: dispose),
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
