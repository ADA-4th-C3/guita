//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct PitchClassificationViewState {
  let recordPermissionState: PermissionState
  let note: String
  let frequency: Double

  func copy(recordPermissionState: PermissionState? = nil, note: String? = nil, frequency: Double? = nil) -> PitchClassificationViewState {
    return PitchClassificationViewState(
      recordPermissionState: recordPermissionState ?? self.recordPermissionState,
      note: note ?? self.note,
      frequency: frequency ?? self.frequency
    )
  }
}
