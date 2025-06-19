//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation

struct DevChordClassificationWithMLViewState {
  let isStarted: Bool
  let isSilence: Bool
  let chord: Chord
  let pixel: CVPixelBuffer?

  func copy(
    isStarted: Bool? = nil,
    isSilence: Bool? = nil,
    chord: Chord? = nil,
    pixel: (() -> CVPixelBuffer)? = nil
  ) -> DevChordClassificationWithMLViewState {
    return DevChordClassificationWithMLViewState(
      isStarted: isStarted ?? self.isStarted,
      isSilence: isSilence ?? self.isSilence,
      chord: chord ?? self.chord,
      pixel: pixel == nil ? self.pixel : pixel!()
    )
  }
}
