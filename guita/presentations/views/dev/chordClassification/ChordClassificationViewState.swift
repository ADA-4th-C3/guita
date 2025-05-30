//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct ChordClassificationViewState {
  let recordPermissionState: PermissionState //녹음 권한
  let chord: Chord? // 화면상에 나올 코드 !
  let confidence: Float
  let selectedCodes: [Chord]
  let allMatches: [(chord: Chord, confidence: Float)]
  
  
  func copy(
    recordPermissionState: PermissionState? = nil,
    chord: (() -> Chord?)? = nil,
    confidence: Float? = nil,
    selectedCodes: [Chord]? = nil,
    allMatches: [(chord: Chord, confidence: Float)]? = nil
  ) -> ChordClassificationViewState {
    return ChordClassificationViewState(
      recordPermissionState: recordPermissionState ?? self.recordPermissionState,
      chord: chord == nil ? self.chord : chord!(),
      confidence: confidence ?? self.confidence,
      selectedCodes: selectedCodes ?? self.selectedCodes,
      allMatches: allMatches ?? self.allMatches
    )
  }
}
