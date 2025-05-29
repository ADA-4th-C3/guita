//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 곡 구간 학습 화면의 상태를 관리하는 ViewState
struct SectionPracticeViewState {
  
  // MARK: - Properties
  
  let currentSection: Int                    // 현재 구간 (1~12)
  let totalSections: Int                     // 전체 구간 수
  let currentChordProgression: [String]      // 현재 구간의 코드 진행
  let currentChordIndex: Int                 // 현재 연주 중인 코드 인덱스
  let playbackSpeed: Double                  // 재생 속도 (0.5, 1.0, 1.5)
  let recognizedCode: String                 // 인식된 코드명
  let isListening: Bool                      // 오디오 인식 중인지 여부
  
  // MARK: - Initializer
  
  init(
    currentSection: Int = 1,
    totalSections: Int = 12,
    currentChordProgression: [String] = ["A", "A", "E", "E"],
    currentChordIndex: Int = 0,
    playbackSpeed: Double = 1.0,
    recognizedCode: String = "",
    isListening: Bool = false
  ) {
    self.currentSection = currentSection
    self.totalSections = totalSections
    self.currentChordProgression = currentChordProgression
    self.currentChordIndex = currentChordIndex
    self.playbackSpeed = playbackSpeed
    self.recognizedCode = recognizedCode
    self.isListening = isListening
  }
  
  // MARK: - Copy Method
  
  /// 상태 복사 메서드 - 불변성을 유지하면서 상태 업데이트
  func copy(
    currentSection: Int? = nil,
    currentChordProgression: [String]? = nil,
    currentChordIndex: Int? = nil,
    playbackSpeed: Double? = nil,
    recognizedCode: String? = nil,
    isListening: Bool? = nil
  ) -> SectionPracticeViewState {
    return SectionPracticeViewState(
      currentSection: currentSection ?? self.currentSection,
      totalSections: self.totalSections,
      currentChordProgression: currentChordProgression ?? self.currentChordProgression,
      currentChordIndex: currentChordIndex ?? self.currentChordIndex,
      playbackSpeed: playbackSpeed ?? self.playbackSpeed,
      recognizedCode: recognizedCode ?? self.recognizedCode,
      isListening: isListening ?? self.isListening
    )
  }
}

// MARK: - Computed Properties Extension

extension SectionPracticeViewState {
  
  /// 첫 번째 구간인지 여부
  var isFirstSection: Bool {
    return currentSection == 1
  }
  
  /// 마지막 구간인지 여부
  var isLastSection: Bool {
    return currentSection == totalSections
  }
  
  /// 전체 진행률 (0.0 ~ 1.0)
  var overallProgress: Double {
    return Double(currentSection) / Double(totalSections)
  }
  
  /// 현재 구간 내 진행률 (0.0 ~ 1.0)
  var sectionProgress: Double {
    guard !currentChordProgression.isEmpty else { return 0.0 }
    return Double(currentChordIndex) / Double(currentChordProgression.count)
  }
  
  /// 현재 연주 중인 코드
  var currentChord: String {
    guard currentChordIndex < currentChordProgression.count else { return "" }
    return currentChordProgression[currentChordIndex]
  }
  
  /// 올바른 코드가 인식되었는지 여부
  var isCorrectChordRecognized: Bool {
    return recognizedCode == currentChord
  }
  
  /// 재생 속도 레이블
  var playbackSpeedLabel: String {
    return String(format: "%.1fX", playbackSpeed)
  }
}
