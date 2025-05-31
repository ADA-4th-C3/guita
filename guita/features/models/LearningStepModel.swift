//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 학습 단계 모델 - TTS와 사운드를 포함한 완전한 학습 단위
struct LearningStep {
  let id: String                      // 고유 식별자
  let stepType: StepType             // 단계 타입
  let ttsContents: [TTSContent]      // TTS 콘텐츠 배열
  let soundFiles: [String]           // 재생할 사운드 파일들
  let successSound: String           // 성공 시 효과음
  let failSound: String              // 실패 시 효과음
  let navigationSound: String        // 네비게이션 효과음
  
  /// 단계 표시용 제목
  var displayTitle: String {
    switch stepType {
    case .overview:
      return "개요 설명"
    case .singleString(let stringNumber):
      return "\(stringNumber)번 줄 학습"
    case .fullChord:
      return "전체 코드 연주"
    case .technique(let type):
      return "\(type.rawValue) 학습"
    }
  }
}

/// TTS 콘텐츠 단위
struct TTSContent {
  let text: String                   // 읽을 텍스트
  let type: TTSType                  // 콘텐츠 타입 (content/function)
  let canRepeat: Bool                // "다시" 명령으로 반복 가능 여부
  let pauseAfter: TimeInterval       // TTS 완료 후 대기 시간 (기본 0.3초)
  
  init(text: String, type: TTSType, canRepeat: Bool, pauseAfter: TimeInterval = 0.3) {
    self.text = text
    self.type = type
    self.canRepeat = canRepeat
    self.pauseAfter = pauseAfter
  }
}

/// 학습 단계 타입
enum StepType {
  case overview                                    // 개요 설명
  case singleString(stringNumber: Int)            // 개별 줄 학습
  case fullChord                                   // 전체 코드 연주
  case technique(type: TechniqueType)             // 주법 학습
  
  /// 단계에서 기대하는 사용자 입력 타입
  var expectedInputType: ExpectedInputType {
    switch self {
    case .overview:
      return .voiceCommandOnly
    case .singleString:
      return .chordRecognition
    case .fullChord:
      return .chordRecognition
    case .technique:
      return .rhythmPattern
    }
  }
}

/// 각 단계에서 기대하는 입력 타입
enum ExpectedInputType {
  case voiceCommandOnly    // 음성 명령만 (개요 설명 등)
  case chordRecognition    // 코드 인식 필요
  case rhythmPattern       // 리듬 패턴 인식 필요
}

/// 학습 단계 실행 결과
struct LearningStepResult {
  let stepId: String
  let isCompleted: Bool
  let recognizedInput: String?
  let feedback: String
  let shouldProceed: Bool
  
  static func success(stepId: String, input: String? = nil) -> LearningStepResult {
    return LearningStepResult(
      stepId: stepId,
      isCompleted: true,
      recognizedInput: input,
      feedback: "성공",
      shouldProceed: true
    )
  }
  
  static func failure(stepId: String, feedback: String) -> LearningStepResult {
    return LearningStepResult(
      stepId: stepId,
      isCompleted: false,
      recognizedInput: nil,
      feedback: feedback,
      shouldProceed: false
    )
  }
  
  static func waiting(stepId: String) -> LearningStepResult {
    return LearningStepResult(
      stepId: stepId,
      isCompleted: false,
      recognizedInput: nil,
      feedback: "대기 중",
      shouldProceed: false
    )
  }
}
