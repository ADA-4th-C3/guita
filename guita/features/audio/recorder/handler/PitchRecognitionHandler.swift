//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import AVFoundation

/// 피치(음정) 인식을 담당하는 핸들러 - Note 기반
final class PitchRecognitionHandler {
  
  // MARK: - Properties
  private let pitchClassification = PitchClassification()
  private weak var delegate: PitchRecognitionDelegate?
  
  // 디바운싱 관련
  private var lastPitchRecognitionTime: Date = Date()
  private var pitchRecognitionCooldown: TimeInterval = 1.0
  private var lastRecognizedNote: String = ""
  
  // 타겟 노트들
  private var targetNotes: [Note] = []
  
  // MARK: - Initialization
  init(delegate: PitchRecognitionDelegate) {
    self.delegate = delegate
  }
  
  
  func processAudioBuffer(_ buffer: AVAudioPCMBuffer, audioState: AudioState) {
    // MP3, TTS 재생 중이면 피치 인식 건너뛰기
    guard audioState != .playingSound && audioState != .playingTTS else { return }
    
    // 쿨다운 체크
    let now = Date()
    guard now.timeIntervalSince(lastPitchRecognitionTime) >= pitchRecognitionCooldown else {
      return
    }
    
    // 피치 분류 실행
    guard let result = pitchClassification.run(
      buffer: buffer,
      sampleRate: Double(buffer.format.sampleRate),
      windowSize: 8192
    ) else {
      return
    }
    
    // 같은 음정 반복 인식 방지
    guard result.note != lastRecognizedNote else { return }
    
    // 메인 스레드에서 처리
    DispatchQueue.main.async { [weak self] in
      self?.lastPitchRecognitionTime = now
      self?.lastRecognizedNote = result.note
      self?.handlePitchRecognition(result.note, frequency: result.frequency)
    }
  }
  
  func setTargetNotes(_ notes: [Note]) {
    targetNotes = notes
    Logger.d("타겟 노트들 설정: \(notes.map { String(describing: $0) })")
  }
  
  
  func clearTargetNote() {
    targetNotes = []
    Logger.d("타겟 노트 필터 해제")
  }
  
  func setCooldown(_ cooldown: TimeInterval) {
    pitchRecognitionCooldown = cooldown
  }
  
  
  // MARK: - Private Methods
  private func handlePitchRecognition(_ recognizedNote: String, frequency: Double) {
    Logger.d("노트 인식됨: \(recognizedNote), 주파수: \(frequency)Hz")
    
    delegate?.didRecognizeNote(recognizedNote, frequency: frequency)
    
    // 타겟 노트가 설정된 경우 검증
    if !targetNotes.isEmpty {
      let (matchedNote, isCorrect) = validateAgainstTargetNotes(recognizedNote, frequency: frequency)
      if let matched = matchedNote {
        delegate?.didValidateNote(recognizedNote, expected: matched, isCorrect: isCorrect)
      }
    }
  }
  
  /// 여러 타겟 노트 중 하나와 매칭되는지 확인
  private func validateAgainstTargetNotes(_ recognizedNote: String, frequency: Double) -> (matchedNote: Note?, isCorrect: Bool) {
    for targetNote in targetNotes {
      if isMatchingNote(recognizedNote, target: targetNote) {
        return (targetNote, true)
      }
    }
    return (nil, false)
  }
  
  /// 인식된 노트가 타겟 노트와 매칭되는지 확인
  private func isMatchingNote(_ recognizedNote: String, target: Note) -> Bool {
    // Note enum의 좌표 정보를 활용하여 해당 줄에서 연주했을 때 나오는 음정인지 확인
    let expectedFrequency = target.frequency
    let recognizedFrequency = getFrequencyFromNoteName(recognizedNote)
    
    // 주파수 허용 오차 범위 (±10Hz)
    let tolerance: Double = 10.0
    return abs(expectedFrequency - recognizedFrequency) <= tolerance
  }
  
  /// 노트 이름에서 주파수 추출
  private func getFrequencyFromNoteName(_ noteName: String) -> Double {
    // Note enum에서 해당하는 케이스 찾기
    for note in Note.allCases {
      if noteName.contains(extractNoteBase(from: note)) {
        return note.frequency
      }
    }
    return 0.0
  }
  
  /// Note enum에서 기본 노트명 추출 (예: E2 -> E, F#3 -> F#)
  private func extractNoteBase(from note: Note) -> String {
    let noteString = String(describing: note)
    // 숫자를 제거하여 노트명만 추출
    return noteString.replacingOccurrences(of: "\\d", with: "", options: .regularExpression)
  }
}

/// PitchRecognitionHandler의 델리게이트 프로토콜
protocol PitchRecognitionDelegate: AnyObject {
  func didRecognizeNote(_ note: String, frequency: Double)
  func didValidateNote(_ recognized: String, expected: Note, isCorrect: Bool)
}
