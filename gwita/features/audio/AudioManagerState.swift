//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct AudioManagerState {
  let permission: PermissionState
  let isRecording: Bool

  func copy(
    permission: PermissionState? = nil,
    isRecording: Bool? = nil
  ) -> AudioManagerState {
    return AudioManagerState(
      permission: permission ?? self.permission,
      isRecording: isRecording ?? self.isRecording
    )
  }
}
