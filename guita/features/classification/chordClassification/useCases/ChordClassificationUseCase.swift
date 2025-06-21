//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Accelerate
import AVFoundation
import Foundation

protocol ChordClassificationUseCase {
  func run(
    buffer: AVAudioPCMBuffer,
    windowSize: Int,
    activeChords: [Chord],
    minVolumeThreshold: Double,
    minConfidenceThreshold: Float
  ) -> (chord: Chord?, confidence: Float)?
}
