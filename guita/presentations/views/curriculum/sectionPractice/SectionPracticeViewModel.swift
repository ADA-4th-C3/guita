//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import AVFAudio

/// 곡 구간 학습 화면의 ViewModel
/// 구간별 코드 진행과 실시간 오디오 인식을 관리
final class SectionPracticeViewModel: BaseViewModel<SectionPracticeViewState> {
  
  // MARK: - Dependencies
  
  private let audioManager = AudioManager.shared
  private let codeClassification = CodeClassification()
  
  // MARK: - Private Properties
  
  private var practiceTimer: Timer?
  private var isAudioSetup = false
  
  // MARK: - Initializer
  
  init() {
    super.init(state: SectionPracticeViewState())
    Logger.d("SectionPracticeViewModel 초기화")
  }
  
  // MARK: - Public Methods
  
  /// 구간 연습 시작
  func startPractice() {
    Logger.d("곡 구간 학습 시작")
    setupAudioRecognition()
    startChordProgressionTimer()
  }
  
  /// 구간 연습 종료
  func stopPractice() {
    Logger.d("곡 구간 학습 종료")
    audioManager.stop()
    stopChordProgressionTimer()
    isAudioSetup = false
  }
  
  /// 다음 구간으로 이동
  func nextSection() {
    guard state.currentSection < state.totalSections else {
      Logger.d("이미 마지막 구간")
      return
    }
    
    let newSection = state.currentSection + 1
    let newProgression = getChordProgressionForSection(newSection)
    
    Logger.d("다음 구간으로 이동: \(state.currentSection) -> \(newSection)")
    
    emit(state.copy(
      currentSection: newSection,
      currentChordProgression: newProgression,
      currentChordIndex: 0
    ))
    
    restartChordProgressionTimer()
  }
  
  /// 이전 구간으로 이동
  func previousSection() {
    guard state.currentSection > 1 else {
      Logger.d("이미 첫 번째 구간")
      return
    }
    
    let newSection = state.currentSection - 1
    let newProgression = getChordProgressionForSection(newSection)
    
    Logger.d("이전 구간으로 이동: \(state.currentSection) -> \(newSection)")
    
    emit(state.copy(
      currentSection: newSection,
      currentChordProgression: newProgression,
      currentChordIndex: 0
    ))
    
    restartChordProgressionTimer()
  }
  
  /// 재생 속도 설정
  func setPlaybackSpeed(_ speed: Double) {
    Logger.d("재생 속도 변경: \(state.playbackSpeed) -> \(speed)")
    
    emit(state.copy(playbackSpeed: speed))
    restartChordProgressionTimer() // 새로운 속도로 타이머 재시작
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
      
      self.emit(self.state.copy(
        recognizedCode: result.code,
        isListening: true
      ))
      
      Logger.d("코드 인식됨: \(result.code)")
    }
  }
  
  /// 코드 진행 타이머 시작
  private func startChordProgressionTimer() {
    stopChordProgressionTimer() // 기존 타이머 정리
    
    let interval = calculateTimerInterval()
    practiceTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
      self?.advanceToNextChord()
    }
    
    Logger.d("코드 진행 타이머 시작 (간격: \(interval)초)")
  }
  
  /// 코드 진행 타이머 중지
  private func stopChordProgressionTimer() {
    practiceTimer?.invalidate()
    practiceTimer = nil
  }
  
  /// 코드 진행 타이머 재시작
  private func restartChordProgressionTimer() {
    stopChordProgressionTimer()
    startChordProgressionTimer()
  }
  
  /// 다음 코드로 진행
  private func advanceToNextChord() {
    let nextIndex = (state.currentChordIndex + 1) % state.currentChordProgression.count
    emit(state.copy(currentChordIndex: nextIndex))
  }
  
  /// 타이머 간격 계산 (재생 속도에 따라 조정)
  private func calculateTimerInterval() -> TimeInterval {
    let baseInterval: TimeInterval = 2.0 // 기본 2초 간격
    return baseInterval / state.playbackSpeed
  }
  
  /// 구간별 코드 진행 반환
  private func getChordProgressionForSection(_ section: Int) -> [String] {
    // 12개 구간의 다양한 코드 진행 패턴
    switch section {
    case 1: return ["A", "A", "E", "E"]
    case 2: return ["E", "E", "B7", "B7"]
    case 3: return ["B7", "B7", "A", "A"]
    case 4: return ["A", "E", "A", "E"]
    case 5: return ["E", "B7", "E", "B7"]
    case 6: return ["B7", "A", "B7", "A"]
    case 7: return ["A", "A", "A", "E"]
    case 8: return ["E", "E", "E", "B7"]
    case 9: return ["B7", "B7", "B7", "A"]
    case 10: return ["A", "E", "B7", "E"]
    case 11: return ["E", "B7", "A", "E"]
    case 12: return ["A", "E", "B7", "A"]
    default: return ["A", "E", "B7", "A"]
    }
  }
  
  // MARK: - Cleanup
  
  override func dispose() {
    stopPractice()
    super.dispose()
  }
}
