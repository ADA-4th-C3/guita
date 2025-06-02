//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.
import SwiftUI

final class TechniqueViewModel: BaseViewModel<TechniqueViewState> {
  private let textToSpeechManager = TextToSpeechManager.shared
  private let voiceCommandManager = VoiceCommandManager.shared
  
  init() {
    let steps: [TechniqueStep] = [
      TechniqueStep(step: 1, totalSteps: 4, description: "주법은 기타를 치는 방법을 말합니다. 피크나 손가락으로 줄을 위아래로 튕기는 주법인 스트로크를 배워봅시다.", imageName: ""),
      TechniqueStep(step: 2, totalSteps: 4, description: "기타 몸통에 있는 구멍을 찾아보세요. 이 구멍을 사운드 홀이라고 부릅니다. 사운드 홀 위에서 위에서 아래로 줄을 쓸어내려 보세요.", imageName: ""),
      TechniqueStep(step: 3, totalSteps: 4, description: "음성을 듣고 주법을 따라쳐보세요.", imageName: "audio-file"),
      TechniqueStep(step: 4, totalSteps: 4, description: "주법 학습이 완료되었습니다.", imageName: ""),
    ]
    super.init(state: TechniqueViewState(currentStepIndex: 0, steps: steps))
  }

  func startVoiceCommand() {
    voiceCommandManager.start(
      commands: [
        VoiceCommand(keyword: .play, handler: play),
        VoiceCommand(keyword: .retry, handler: play),
        VoiceCommand(keyword: .next, handler: nextStep),
        VoiceCommand(keyword: .previous, handler: previousStep),
      ]
    )
  }
  
  func play() {
    textToSpeechManager.stop()
    Task {
      let currentDesription = state.steps[state.currentStepIndex].description
      await textToSpeechManager.speak(currentDesription)
    }
  }
  

  func stopVoiceCommand() {
    voiceCommandManager.stop()
    textToSpeechManager.stop()
   
  }

  override func dispose() {
    stopVoiceCommand()
  }
  
  func nextStep() {
    guard state.currentStepIndex < state.steps.count - 1 else { return }
    let newIndex = state.currentStepIndex + 1
    emit(state.copy(
      currentStepIndex: newIndex
    ))
    play()
  }

  func previousStep() {
    guard state.currentStepIndex > 0 else { return }
    let newIndex = state.currentStepIndex - 1
    emit(state.copy(
      currentStepIndex: newIndex
    ))
    play()
  }

  func currentImage() -> Image? {
    guard let imageName = state.currentStep.imageName, !imageName.isEmpty
    else {
      return nil
    }
    return Image(imageName)
  }
}
