//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct DevNoteClassificationViewState {
  let recordPermissionState: PermissionResult
  let note: Note?
  let confidence: Float

  func copy(
    recordPermissionState: PermissionResult? = nil,
    note: (() -> Note?)? = nil,
    confidence: Float? = nil
  ) -> DevNoteClassificationViewState {
    return DevNoteClassificationViewState(
      recordPermissionState: recordPermissionState ?? self.recordPermissionState,
      note: note == nil ? self.note : note!(),
      confidence: confidence ?? self.confidence
    )
  }
}
