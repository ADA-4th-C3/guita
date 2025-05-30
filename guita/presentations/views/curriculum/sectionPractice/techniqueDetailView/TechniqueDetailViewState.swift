//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 주법 학습 상세 화면의 상태를 관리하는 ViewState
struct TechniqueDetailViewState {
  
  
  let song: SongModel                     // 선택된 노래 정보
  let currentStep: Int                    // 현재 학습 단계 (1~4)
  let totalSteps: Int                     // 전체 학습 단계 수
  let currentInstruction: String          // 현재 단계의 안내 문구
  let currentTechnique: TechniqueType     // 현재 학습 중인 주법 타입
  let recognizedInput: String             // 인식된 입력
  let isListening: Bool                  // 오디오 인식 중인지 여부
  let canProceed: Bool                   // 다음 단계로 진행 가능한지 여부
  
  
  /// 상태 복사 메서드 - 불변성을 유지하면서 상태 업데이트
  func copy(
    currentStep: Int? = nil,
    currentInstruction: String? = nil,
    currentTechnique: TechniqueType? = nil,
    recognizedInput: String? = nil,
    isListening: Bool? = nil,
    canProceed: Bool? = nil
  ) -> TechniqueDetailViewState {
    return TechniqueDetailViewState(
      song: self.song,
      currentStep: currentStep ?? self.currentStep,
      totalSteps: self.totalSteps,
      currentInstruction: currentInstruction ?? self.currentInstruction,
      currentTechnique: currentTechnique ?? self.currentTechnique,
      recognizedInput: recognizedInput ?? self.recognizedInput,
      isListening: isListening ?? self.isListening,
      canProceed: canProceed ?? self.canProceed
    )
  }
}
