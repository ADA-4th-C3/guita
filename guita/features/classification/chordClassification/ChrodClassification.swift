//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFAudio

enum ChordClassificationType: String, Codable, CaseIterable {
  case similarity="similarity"
  case regression="regression"
}

final class ChordClassification: ChordClassificationUseCase {
  let useCase: ChordClassificationUseCase
  
  init(type: ChordClassificationType) {
    self.useCase = switch type {
    case .similarity: ChordClassificationWithSimilarity()
    case .regression: ChordClassificationWithRegression()
    }
  }
  
  func run(
    buffer: AVAudioPCMBuffer,
    windowSize: Int,
    activeChords: [Chord],
    minVolumeThreshold: Double = 0.025,
    minConfidenceThreshold: Float = 0.5
  ) -> (chord: Chord?, confidence: Float)? {
    let result = useCase.run(
      buffer: buffer,
      windowSize: windowSize,
      activeChords: activeChords,
      minVolumeThreshold: minVolumeThreshold,
      minConfidenceThreshold: minConfidenceThreshold
    )
    return result
  }
}
