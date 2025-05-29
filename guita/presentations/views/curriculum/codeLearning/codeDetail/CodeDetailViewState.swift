//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 코드 상세 학습 화면의 상태를 관리하는 ViewState
struct CodeDetailViewState {
  
  // MARK: - Properties
  
  let codeType: CodeType              // 학습 중인 코드 타입
  let currentStep: Int                // 현재 학습 단계 (1~6)
  let totalSteps: Int                 // 전체 학습 단계 수
  let currentInstruction: String      // 현재 단계의 안내 문구
  let recognizedCode: String          // 인식된 코드명
  let isListening: Bool              // 오디오 인식 중인지 여부
  let canProceed: Bool               // 다음 단계로 진행 가능한지 여부
  
  // MARK: - Initializer
  
  init(
    codeType: CodeType,
    currentStep: Int = 1,
    totalSteps: Int = 6,
    currentInstruction: String = "",
    recognizedCode: String = "",
    isListening: Bool = false,
    canProceed: Bool = false
  ) {
    self.codeType = codeType
    self.currentStep = currentStep
    self.totalSteps = totalSteps
    self.currentInstruction = currentInstruction
    self.recognizedCode = recognizedCode
    self.isListening = isListening
    self.canProceed = canProceed
  }
  
  // MARK: - Copy Method
  
  /// 상태 복사 메서드 - 불변성을 유지하면서 상태 업데이트
  func copy(
    currentStep: Int? = nil,
    currentInstruction: String? = nil,
    recognizedCode: String? = nil,
    isListening: Bool? = nil,
    canProceed: Bool? = nil
  ) -> CodeDetailViewState {
    return CodeDetailViewState(
      codeType: self.codeType,
      currentStep: currentStep ?? self.currentStep,
      totalSteps: self.totalSteps,
      currentInstruction: currentInstruction ?? self.currentInstruction,
      recognizedCode: recognizedCode ?? self.recognizedCode,
      isListening: isListening ?? self.isListening,
      canProceed: canProceed ?? self.canProceed
    )
  }
}

// MARK: - Computed Properties Extension

extension CodeDetailViewState {
  
  /// 첫 번째 단계인지 여부
  var isFirstStep: Bool {
    return currentStep == 1
  }
  
  /// 마지막 단계인지 여부
  var isLastStep: Bool {
    return currentStep == totalSteps
  }
  
  /// 권한 요청 단계인지 여부 (1-2단계)
  var isPermissionStep: Bool {
    return currentStep <= 2
  }
  
  /// 실제 학습 단계인지 여부 (3-6단계)
  var isLearningStep: Bool {
    return currentStep >= 3
  }
  
  /// 진행률 (0.0 ~ 1.0)
  var progress: Double {
    return Double(currentStep) / Double(totalSteps)
  }
  
  /// 올바른 코드가 인식되었는지 여부
  var isCorrectCodeRecognized: Bool {
    return recognizedCode == codeType.rawValue
  }
}
