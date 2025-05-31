//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 오디오 재생 상태 - TTS와 MP3를 구분하여 음성인식 제어
enum AudioState {
  case idle                    // 대기 상태
  case playingTTS             // TTS 재생 중 (음성인식 유지)
  case playingSound           // MP3/효과음 재생 중 (음성인식 차단)
  case listeningVoice         // 음성인식 대기 중
}

/// TTS 콘텐츠 타입 - "다시" 명령 처리 구분
enum TTSType {
  case content    // "다시" 명령으로 재생 가능
  case function   // "다시" 명령 무시
}


/// 오디오 학습 상태를 가져야 하는 ViewState들의 공통 프로토콜
protocol AudioLearningState {
  var audioState: AudioState { get }
  var lastContentTTS: String? { get }
  var currentStep: Int { get }
  var totalSteps: Int { get }
  var isListening: Bool { get }
  var recognizedInput: String { get }
  var canProceed: Bool { get }
}

/// 학습 단계별 오디오 처리 상태
struct AudioProcessingState {
  let isVoiceRecognitionActive: Bool    // 음성인식 활성화 여부
  let isTTSPlaying: Bool               // TTS 재생 중 여부
  let isSoundPlaying: Bool             // 사운드 재생 중 여부
  let lastRecognizedCommand: VoiceCommand?  // 마지막 인식된 명령
  
  static let idle = AudioProcessingState(
    isVoiceRecognitionActive: false,
    isTTSPlaying: false,
    isSoundPlaying: false,
    lastRecognizedCommand: nil
  )
}
