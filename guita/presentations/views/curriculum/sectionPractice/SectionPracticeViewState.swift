//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

struct SectionPracticeViewState {
  let currentSection: Int
  let totalSections: Int
  let currentChordProgression: [String]
  let currentChordIndex: Int
  let playbackSpeed: Double
  let recognizedCode: String
  let isListening: Bool
  
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
