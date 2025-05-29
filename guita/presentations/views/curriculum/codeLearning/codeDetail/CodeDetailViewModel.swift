//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import AVFoundation

/// 코드 상세 학습 화면의 ViewModel
/// 단계별 코드 학습 진행과 실시간 오디오 인식을 관리
final class CodeDetailViewModel: BaseViewModel<CodeDetailViewState> {
  
  // MARK: - Dependencies
  
  private let codeType: CodeType
  private let audioManager = AudioManager.shared
  private let codeClassification = CodeClassification()
  
  // MARK: - Private Properties
  
  private var isAudioSetup = false
  
  // MARK: - Initializer
  
  init(codeType: CodeType) {
    self.codeType = codeType
    super.init(state: CodeDetailViewState(codeType: codeType))
    Logger.d("CodeDetailViewModel 초기화: \(codeType.rawValue)")
  }
  
  // MARK: - Public Methods
  
  /// 학습 시작 - 오디오 세션 설정 및 코드 인식 시작
  func startLearning() {
    Logger.d("코드 학습 시작: \(codeType.rawValue)")
    setupAudioRecognition()
    updateInstructionForCurrentStep()
  }
  
  /// 학습 종료 - 오디오 세션 정리
  func stopLearning() {
    Logger.d("코드 학습 종료: \(codeType.rawValue)")
    audioManager.stop()
    isAudioSetup = false
  }
  
  /// 다음 단계로 진행
  func nextStep() {
    guard state.canProceed else {
      Logger.d("다음 단계 진행 불가 - canProceed: false")
      return
    }
    
    guard state.currentStep < state.totalSteps else {
      Logger.d("이미 마지막 단계")
      return
    }
    
    let newStep = state.currentStep + 1
    Logger.d("다음 단계로 진행: \(state.currentStep) -> \(newStep)")
    
    emit(state.copy(
      currentStep: newStep,
      currentInstruction: getInstructionForStep(newStep),
      canProceed: shouldAllowProceedForStep(newStep)
    ))
  }
  
  /// 이전 단계로 돌아가기
  func previousStep() {
    guard state.currentStep > 1 else {
      Logger.d("이미 첫 번째 단계")
      return
    }
    
    let newStep = state.currentStep - 1
    Logger.d("이전 단계로 돌아가기: \(state.currentStep) -> \(newStep)")
    
    emit(state.copy(
      currentStep: newStep,
      currentInstruction: getInstructionForStep(newStep),
      canProceed: shouldAllowProceedForStep(newStep)
    ))
  }
  
  /// 권한 승인 처리
  func handlePermissionGranted() {
    Logger.d("권한 승인됨")
    nextStep()
  }
  
  // MARK: - Private Methods
  
  /// 오디오 인식 설정
  private func setupAudioRecognition() {
    guard !isAudioSetup else {
      Logger.d("오디오 이미 설정됨")
      return
    }
    
    audioManager.start { [weak self] buffer, _ in
      self?.processAudioBuffer(buffer)
    }
    
    isAudioSetup = true
    Logger.d("오디오 인식 설정 완료")
  }
  
  /// 오디오 버퍼 처리 및 코드 인식
  private func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
    guard let result = codeClassification.detectCode(
      buffer: buffer,
      windowSize: audioManager.windowSize
    ) else {
      return
    }
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      let isCorrectCode = result.code == self.codeType.rawValue
      let shouldAllowProceed = self.shouldAllowProceedBasedOnRecognition(
        recognizedCode: result.code,
        isCorrect: isCorrectCode
      )
      
      self.emit(self.state.copy(
        recognizedCode: result.code,
        isListening: true,
        canProceed: shouldAllowProceed
      ))
      
      if isCorrectCode {
        Logger.d("올바른 코드 인식됨: \(result.code)")
      }
    }
  }
  
  /// 현재 단계의 안내 문구 업데이트
  private func updateInstructionForCurrentStep() {
    let instruction = getInstructionForStep(state.currentStep)
    emit(state.copy(currentInstruction: instruction))
  }
  
  /// 단계별 안내 문구 반환
  private func getInstructionForStep(_ step: Int) -> String {
    switch step {
    case 1, 2:
      return "" // 권한 요청 단계는 별도 컴포넌트에서 처리
    case 3:
      return "\(codeType.rawValue)코드는 2번 프렛 위에\n검지, 중지, 약지\n총 3 손가락을\n사용하는 코드입니다."
    case 4:
      return "검지를 2번 프렛\n4번 줄에 올리고\n해당 줄을 한번 쳐보세요."
    case 5:
      return "중지를 2번 프렛\n3번 줄에 올리고\n해당 줄을 한번 쳐보세요."
    case 6:
      return "약지를 2번 프렛\n2번 줄에 올리고\n해당 줄을 한번 쳐보세요."
    default:
      return ""
    }
  }
  
  /// 단계별 진행 가능 여부 판단
  private func shouldAllowProceedForStep(_ step: Int) -> Bool {
    switch step {
    case 1, 2, 3:
      return true // 권한 요청 및 설명 단계는 항상 진행 가능
    case 4, 5, 6:
      return false // 실제 연주 단계는 코드 인식 후 진행 가능
    default:
      return false
    }
  }
  
  /// 코드 인식 결과에 따른 진행 가능 여부 판단
  private func shouldAllowProceedBasedOnRecognition(
    recognizedCode: String,
    isCorrect: Bool
  ) -> Bool {
    // 실제 연주 단계(4-6)에서만 코드 인식 검증
    guard state.currentStep >= 4 && state.currentStep <= 6 else {
      return shouldAllowProceedForStep(state.currentStep)
    }
    
    return isCorrect
  }
  
  // MARK: - Cleanup
  
  override func dispose() {
    stopLearning()
    super.dispose()
  }
}
