//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.
import SwiftUI

final class TechniqueViewModel: BaseViewModel<TechniqueViewState> {
  
  static let steps: [LearningStep] = [
    LearningStep(step: 1, totalSteps: 4, description: "주법은 기타를 치는 방법을 말합니다. 피크나 손가락으로 줄을 위아래로 튕기는 주법인 스트로크를 배워봅시다.",imageName: ""),
    LearningStep(step: 2, totalSteps: 4, description: "기타 몸통에 있는 구멍을 찾아보세요. 이 구멍을 사운드 홀이라고 부릅니다. 사운드 홀 위에서 위에서 아래로 줄을 쓸어내려 보세요.",imageName: ""),
    LearningStep(step: 3, totalSteps: 4, description: "음성을 듣고 주법을 따라쳐보세요.",imageName: "audio-file"),
    LearningStep(step: 4, totalSteps: 4, description: "주법 학습이 완료되었습니다.",imageName: "")
    
  ]
  
  init() {
    super.init(state: TechniqueViewState(currentStepIndex: 0, steps: TechniqueViewModel.steps, currentStep: TechniqueViewModel.steps[0]))
  }
  
  func nextStep() {
    guard state.currentStepIndex < Self.steps.count - 1 else { return }
    let newIndex = state.currentStepIndex + 1
    emit(state.copy(
      currentStepIndex: newIndex,
      currentStep: state.steps[newIndex]))
  }
  
  func previousStep() {
    guard state.currentStepIndex > 0 else { return }
    let newIndex = state.currentStepIndex - 1
    emit(state.copy(
      currentStepIndex: newIndex,
      currentStep: state.steps[newIndex]))
  }
  
  func currentImage() -> Image? {
    guard let imageName = state.currentStep.imageName, !imageName.isEmpty
    else {
      return nil
    }
    return Image(imageName)
  }
}
