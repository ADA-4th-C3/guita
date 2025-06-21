//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct DevChordClassificationWithSimilarityViewState {
  let recordPermissionState: PermissionResult
  let chord: Chord?
  let confidence: Float
  let selectedCodes: [Chord]

  func copy(
    recordPermissionState: PermissionResult? = nil,
    chord: (() -> Chord?)? = nil,
    confidence: Float? = nil,
    selectedCodes: [Chord]? = nil
  ) -> DevChordClassificationWithSimilarityViewState {
    return DevChordClassificationWithSimilarityViewState(
      recordPermissionState: recordPermissionState ?? self.recordPermissionState,
      chord: chord == nil ? self.chord : chord!(),
      confidence: confidence ?? self.confidence,
      selectedCodes: selectedCodes ?? self.selectedCodes
    )
  }
}
