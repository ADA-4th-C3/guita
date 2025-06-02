//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import AVFoundation

/// 코드 상세 학습 화면의 ViewModel - BaseAudioLearningViewModel 상속
final class CodeDetailViewModel: BaseAudioLearningViewModel<CodeDetailViewState> {
  
  private let song: SongModel
  private let chord: Chord
  private var learningSteps: [LearningStep] = []
  
  static func create(song: SongModel, chord: Chord) -> CodeDetailViewModel {
    return CodeDetailViewModel(song: song, chord: chord)
  }
  
  private init(song: SongModel, chord: Chord) {
    self.song = song
    self.chord = chord
    
    // 학습 단계 데이터 로드
    self.learningSteps = ChordLearningStepFactory.createStepsForChord(chord)
    
    // ViewState 초기화
    let initialState = CodeDetailViewState(
      song: song,
      chord: chord,
      currentStep: 1,
      totalSteps: learningSteps.count,
      currentInstruction: "",
      recognizedCode: "",
      recognizedVoiceText: "",
      isListening: false,
      canProceed: false,
      audioState: .idle,
      isCompleted: false,
      nextChord: .B7,
      lastContentTTS: nil
    )
    
    super.init(state: initialState)
    Logger.d("CodeDetailViewModel 초기화: \(song.title) - \(chord.rawValue)")
    
    // 타겟 코드 설정
    setTargetChordFilter(chord)
  }
  
  
  
  // MARK: - BaseAudioLearningViewModel 추상 메서드 구현
  
  override func onNextCommand() {
    guard currentStepIndex < learningSteps.count - 1 else {
            // 마지막 단계에서 다음 버튼 클릭 시 완료 처리
            emit(state.copy(isCompleted: true))
            Logger.d("A코드 학습 완료 - B7 버튼 활성화")
            return
        }
    
    let oldStepIndex = currentStepIndex
    currentStepIndex += 1
    Logger.d("다음 단계로 진행: \(oldStepIndex)/ \(currentStepIndex + 1)/\(learningSteps.count)")
    
    updateCurrentStep()
    updateRecognitionModeForCurrentStep()
    executeCurrentStep()
  }
  
  /// 이전 단계로 돌아가기
  override func onPreviousCommand() {
    guard currentStepIndex > 0 else {
      Logger.d("이미 첫 번째 단계")
      return
    }
    
    currentStepIndex -= 1
    Logger.d("이전 단계로 돌아가기: \(currentStepIndex + 1)/\(learningSteps.count)")
    
    updateCurrentStep()
    updateRecognitionModeForCurrentStep()
    executeCurrentStep()
  }
  
  override func getCurrentLearningSteps() -> [LearningStep] {
    return learningSteps
  }
  
  override func updateStateWithAudio(_ audioState: AudioState, lastTTS: String?) {
    emit(state.copy(
      isListening: audioState == .listeningVoice, audioState: audioState,
      lastContentTTS: lastTTS
    ))
  }
  
  override func updateRecognizedChord(_ chord: String) {
    emit(state.copy(
      recognizedCode: chord,
      canProceed: shouldAllowProceed(recognizedChord: chord)
    ))
  }
  override func updateRecognizedNote(_ note: String, frequency: Double) {
      emit(state.copy(
          recognizedCode: note,
          canProceed: shouldAllowProceed(recognizedChord: note)
      ))
  }

  override func updateRecognizedVoiceText(_ text: String) {
      emit(state.copy(recognizedVoiceText: text))
  }
  
  private func updateRecognitionModeForCurrentStep() {
      guard currentStepIndex < learningSteps.count else { return }
      
      let currentStep = learningSteps[currentStepIndex]
      
      switch currentStep.stepType {
      case .singleString(let stringNumber):
          setRecognitionMode(.note)
          setTargetNoteForString(chord, string: stringNumber)
          
      case .fullChord:
          setRecognitionMode(.chord)
          setTargetChordFilter(chord)
          
      default:
          break
      }
  }
  
  func onAudioRecoveryFailed() {
    Logger.e("오디오 복구 실패 - 사용자에게 알림")
    // TODO: 에러 상태를 ViewState에 추가하여 UI에서 에러 메시지 표시
  }
  
  // MARK: - Public Methods
  
  /// 학습 시작
  func startLearning() {
    Logger.d("코드 학습 시작: \(chord.rawValue)")
    
    let permissionManager = PermissionManager.shared
    if permissionManager.microphonePermission == .granted &&
        permissionManager.speechPermission == .granted {
      setupVoiceRecognition()
      updateRecognitionModeForCurrentStep()
      executeCurrentStep()
    } else {
      permissionManager.onPermissionsCompleted = { [weak self] in
        self?.setupVoiceRecognition()
        self?.updateRecognitionModeForCurrentStep()
        self?.executeCurrentStep()
      }
    }
    
    updateCurrentStep()
  }
  
  /// 학습 종료
  func stopLearning() {
    Logger.d("코드 학습 종료: \(song.title) - \(chord.rawValue)")
    stopVoiceRecognition()
    stopAllAudio()
  }
  
  /// 권한 허용 완료 후 호출
  func onPermissionsGranted() {
    Logger.d("권한 허용 완료 - 오디오 및 음성인식 시작")
    setupVoiceRecognition()
    executeCurrentStep()
  }
  
  /// 다음 단계로 진행 (UI에서 호출)
  func nextStep() {
    onNextCommand()
  }
  
  /// 이전 단계로 돌아가기 (UI에서 호출)
  func previousStep() {
    onPreviousCommand()
  }
  
  // MARK: - Private Methods
  
  /// 현재 단계 정보 업데이트
  private func updateCurrentStep() {
    guard currentStepIndex < learningSteps.count else { return }
    
    let currentStep = learningSteps[currentStepIndex]
    let instruction = getCurrentInstruction()
    let canProceed = shouldAllowProceedForCurrentStep()
    
    emit(state.copy(
      currentStep: currentStepIndex + 1,
      currentInstruction: instruction,
      canProceed: canProceed
    ))
  }
  
  /// 현재 단계의 안내 문구 반환
  private func getCurrentInstruction() -> String {
    guard currentStepIndex < learningSteps.count else { return "" }
    
    let step = learningSteps[currentStepIndex]
    
    // TTS 콘텐츠 중 content 타입만 추출하여 표시
    let contentTexts = step.ttsContents
      .filter { $0.type == .content }
      .map { $0.text }
    
    return contentTexts.joined(separator: " ")
  }
  
  /// 현재 단계에서 진행 가능 여부 판단
  private func shouldAllowProceedForCurrentStep() -> Bool {
    guard currentStepIndex < learningSteps.count else { return false }
    
    let step = learningSteps[currentStepIndex]
    
    switch step.stepType.expectedInputType {
    case .voiceCommandOnly:
      return true // 개요 단계는 항상 진행 가능
    case .chordRecognition:
      return false // 코드 인식 필요 - 올바른 코드 인식 시에만 가능
    case .rhythmPattern:
      return false // 리듬 패턴 인식 필요
    }
  }
  
  /// 코드 인식 결과에 따른 진행 가능 여부
  private func shouldAllowProceed(recognizedChord: String) -> Bool {
    guard currentStepIndex < learningSteps.count else { return false }
    
    let step = learningSteps[currentStepIndex]
    
    // 코드 인식이 필요한 단계에서만 검증
    if step.stepType.expectedInputType == .chordRecognition {
      return recognizedChord.uppercased() == chord.rawValue.uppercased()
    }
    
    return shouldAllowProceedForCurrentStep()
  }
  
  
  // MARK: - Cleanup
  
  override func dispose() {
    stopLearning()
    clearTargetChordFilter()
    super.dispose()
  }
}
