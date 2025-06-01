// CodeDetailViewState.swift 수정

struct CodeDetailViewState: AudioLearningState {
  
  // MARK: - Properties
  
  let song: SongModel                     // 선택된 노래 정보
  let chord: Chord                        // 학습 중인 코드 타입
  let currentStep: Int                    // 현재 학습 단계 (1~5)
  let totalSteps: Int                     // 전체 학습 단계 수
  let currentInstruction: String          // 현재 단계의 안내 문구
  let recognizedCode: String              // 인식된 코드명/노트명
  let recognizedVoiceText: String         // 인식된 음성 텍스트
  let isListening: Bool                  // 오디오 인식 중인지 여부
  let canProceed: Bool                   // 다음 단계로 진행 가능한지 여부
  
  // MARK: - AudioLearningState 프로토콜 구현
  
  let audioState: AudioState              // 오디오 재생 상태
  let lastContentTTS: String?             // 마지막 콘텐츠 TTS
  var recognizedInput: String { recognizedCode } // AudioLearningState 호환성
  
  // MARK: - Copy Method
  
  /// 상태 복사 메서드 - 불변성을 유지하면서 상태 업데이트
  func copy(
    currentStep: Int? = nil,
    currentInstruction: String? = nil,
    recognizedCode: String? = nil,
    recognizedVoiceText: String? = nil,
    isListening: Bool? = nil,
    canProceed: Bool? = nil,
    audioState: AudioState? = nil,
    lastContentTTS: String?? = nil
  ) -> CodeDetailViewState {
    return CodeDetailViewState(
      song: self.song,
      chord: self.chord,
      currentStep: currentStep ?? self.currentStep,
      totalSteps: self.totalSteps,
      currentInstruction: currentInstruction ?? self.currentInstruction,
      recognizedCode: recognizedCode ?? self.recognizedCode,
      recognizedVoiceText: recognizedVoiceText ?? self.recognizedVoiceText,
      isListening: isListening ?? self.isListening,
      canProceed: canProceed ?? self.canProceed,
      audioState: audioState ?? self.audioState,
      lastContentTTS: lastContentTTS ?? self.lastContentTTS
    )
  }
}
