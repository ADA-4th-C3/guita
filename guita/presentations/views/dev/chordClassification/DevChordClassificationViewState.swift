//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct DevChordClassificationViewState {
  let recordPermissionState: PermissionResult // 녹음 권한
  let chord: Chord? // 화면상에 나올 코드 !
  let confidence: Float
  let selectedCodes: [Chord]

  func copy(
    recordPermissionState: PermissionResult? = nil,
    chord: (() -> Chord?)? = nil,
    confidence: Float? = nil,
    selectedCodes: [Chord]? = nil
  ) -> DevChordClassificationViewState {
    return DevChordClassificationViewState(
      recordPermissionState: recordPermissionState ?? self.recordPermissionState,
      chord: chord == nil ? self.chord : chord!(),
      confidence: confidence ?? self.confidence,
      selectedCodes: selectedCodes ?? self.selectedCodes
    )
  }
}
