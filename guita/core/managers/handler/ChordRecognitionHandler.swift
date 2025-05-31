//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import AVFoundation

/// 코드 인식을 담당하는 핸들러
final class ChordRecognitionHandler {
  
  // MARK: - Properties
  private let codeClassification = CodeClassification()
  private weak var delegate: ChordRecognitionDelegate?
  
  // 디바운싱 관련
  private var lastCodeRecognitionTime: Date = Date()
  private var codeRecognitionCooldown: TimeInterval = 2.0
  private var lastRecognizedCode: String = ""
  private var targetChord: Chord?
  
  // MARK: - Initialization
  init(delegate: ChordRecognitionDelegate) {
    self.delegate = delegate
  }
  
  // MARK: - Public Methods
  func processAudioBuffer(_ buffer: AVAudioPCMBuffer, audioState: AudioState) {
    // MP3 재생 중이면 코드 인식 건너뛰기
    guard audioState != .playingSound else { return }
    
    // 쿨다운 체크
    let now = Date()
    guard now.timeIntervalSince(lastCodeRecognitionTime) >= codeRecognitionCooldown else {
      return
    }
    
    // 코드 분류 실행
    guard let result = codeClassification.detectCode(
      buffer: buffer,
      windowSize: 8192
    ) else {
      return
    }
    
    // 같은 코드 반복 인식 방지
    guard result.code != lastRecognizedCode else { return }
    
    // 신뢰도 임계값 체크
    guard result.confidence >= 0.6 else { return }
    
    // 메인 스레드에서 처리
    DispatchQueue.main.async { [weak self] in
      self?.lastCodeRecognitionTime = now
      self?.lastRecognizedCode = result.code
      self?.handleChordRecognition(result.code, confidence: result.confidence)
    }
  }
  
  func setTargetChord(_ chord: Chord) {
    targetChord = chord
    Logger.d("타겟 코드 설정: \(chord.rawValue)")
  }
  
  func clearTargetChord() {
    targetChord = nil
    Logger.d("타겟 코드 필터 해제")
  }
  
  func setCooldown(_ cooldown: TimeInterval) {
    codeRecognitionCooldown = cooldown
  }
  
  // MARK: - Private Methods
  private func handleChordRecognition(_ recognizedChord: String, confidence: Float) {
    Logger.d("코드 인식됨: \(recognizedChord), 신뢰도: \(confidence)")
    
    delegate?.didRecognizeChord(recognizedChord, confidence: confidence)
    
    // 타겟 코드가 설정된 경우 검증
    if let targetChord = targetChord {
      let isCorrect = recognizedChord.uppercased() == targetChord.rawValue.uppercased()
      delegate?.didValidateChord(recognizedChord, expected: targetChord.rawValue, isCorrect: isCorrect)
    }
  }
}

/// ChordRecognitionHandler의 델리게이트 프로토콜
protocol ChordRecognitionDelegate: AnyObject {
  func didRecognizeChord(_ chord: String, confidence: Float)
  func didValidateChord(_ recognized: String, expected: String, isCorrect: Bool)
}
