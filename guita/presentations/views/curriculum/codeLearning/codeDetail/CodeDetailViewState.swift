//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

struct CodeDetailViewState {
  let codeType: CodeType
  let currentStep: Int
  let totalSteps: Int
  let currentInstruction: String
  let recognizedCode: String
  let isListening: Bool
  let canProceed: Bool
  
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
