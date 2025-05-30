//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import AVFoundation

/// 주법 학습 상세 화면의 ViewModel
final class TechniqueDetailViewModel: BaseViewModel<TechniqueDetailViewState> {
  
  private let song: SongModel
  private let audioManager = AudioManager.shared
  private var isAudioSetup = false
  
  static func create(song: SongModel) -> TechniqueDetailViewModel {
    return TechniqueDetailViewModel(song: song)
  }
  
  private init(song: SongModel) {
    self.song = song
    
    super.init(state: TechniqueDetailViewState(
      song: song,
      currentStep: 1,
      totalSteps: 4,
      currentInstruction: "",
      currentTechnique: .strumming,
      recognizedInput: "",
      isListening: false,
      canProceed: false
    ))
    Logger.d("TechniqueDetailViewModel 초기화: \(song.title)")
  }
  
  // MARK: - Public Methods
  
  /// 학습 시작 - 오디오 세션 설정 및 인식 시작
  func startLearning() {
    Logger.d("주법 학습 시작: \(song.title)")
    setupAudioRecognition()
    updateInstructionForCurrentStep()
  }
  
  /// 학습 종료 - 오디오 세션 정리
  func stopLearning() {
    Logger.d("주법 학습 종료: \(song.title)")
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
      currentTechnique: getTechniqueForStep(newStep),
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
      currentTechnique: getTechniqueForStep(newStep),
      canProceed: shouldAllowProceedForStep(newStep)
    ))
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
  
  /// 오디오 버퍼 처리
  private func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
    // 주법 학습에서는 리듬과 패턴을 분석
    // 실제 구현에서는 주법별 특성을 분석하는 로직이 필요
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      // 임시로 랜덤하게 인식 상태 업데이트
      let shouldRecognize = Bool.random()
      
      if shouldRecognize {
        let recognizedTechnique = self.state.currentTechnique.rawValue
        
        self.emit(self.state.copy(
          recognizedInput: recognizedTechnique,
          isListening: true,
          canProceed: true
        ))
        
        Logger.d("주법 인식됨: \(recognizedTechnique)")
      } else {
        self.emit(self.state.copy(
          isListening: true,
          canProceed: false
        ))
      }
    }
  }
  
  /// 현재 단계의 안내 문구 업데이트
  private func updateInstructionForCurrentStep() {
    let instruction = getInstructionForStep(state.currentStep)
    let technique = getTechniqueForStep(state.currentStep)
    
    emit(state.copy(
      currentInstruction: instruction,
      currentTechnique: technique
    ))
  }
  
  /// 단계별 안내 문구 반환
  private func getInstructionForStep(_ step: Int) -> String {
    switch step {
    case 1:
      return "스트러밍은 손목을 부드럽게 사용하여\n줄을 위아래로 치는 기법입니다.\n천천히 연습해보세요."
    case 2:
      return "핑거피킹은 각 손가락으로\n개별 줄을 뜯는 기법입니다.\n엄지부터 시작해보세요."
    case 3:
      return "아르페지오는 코드를 구성하는\n음들을 순차적으로 연주하는 기법입니다."
    case 4:
      return "팜뮤팅은 오른손 손바닥으로\n줄을 살짝 눌러 음을 줄이는 기법입니다."
    default:
      return ""
    }
  }
  
  /// 단계별 주법 타입 반환
  private func getTechniqueForStep(_ step: Int) -> TechniqueType {
    switch step {
    case 1: return .strumming
    case 2: return .fingerpicking
    case 3: return .arpeggios
    case 4: return .palmMuting
    default: return .strumming
    }
  }
  
  /// 단계별 진행 가능 여부 판단
  private func shouldAllowProceedForStep(_ step: Int) -> Bool {
    switch step {
    case 1:
      return true // 설명 단계는 항상 진행 가능
    case 2, 3, 4:
      return false // 실제 연주 단계는 기법 인식 후 진행 가능
    default:
      return false
    }
  }
  
  // MARK: - Cleanup
  
  override func dispose() {
    stopLearning()
    super.dispose()
  }
}
