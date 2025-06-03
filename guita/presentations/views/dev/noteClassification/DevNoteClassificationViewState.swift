//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct DevNoteClassificationViewState {
  let recordPermissionState: PermissionResult
  let note: Note?
  let confidence: Double?

  func copy(
    recordPermissionState: PermissionResult? = nil,
    note: (() -> Note?)? = nil,
    confidence: (() -> Double)? = nil
  ) -> DevNoteClassificationViewState {
    return DevNoteClassificationViewState(
      recordPermissionState: recordPermissionState ?? self.recordPermissionState,
      note: note == nil ? self.note : note!(),
      confidence: confidence == nil ? self.confidence : confidence!()
    )
  }
}
