//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct NoteClassificationViewState {
  let recordPermissionState: PermissionState
  let note: Note?

  func copy(recordPermissionState: PermissionState? = nil, note: (() -> Note?)? = nil) -> NoteClassificationViewState {
    return NoteClassificationViewState(
      recordPermissionState: recordPermissionState ?? self.recordPermissionState,
      note: note == nil ? self.note : note!()
    )
  }
}
