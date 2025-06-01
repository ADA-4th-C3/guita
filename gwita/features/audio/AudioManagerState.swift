//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct AudioManagerState {
  let permission: PermissionResult
  let isRecording: Bool

  func copy(
    permission: PermissionResult? = nil,
    isRecording: Bool? = nil
  ) -> AudioManagerState {
    return AudioManagerState(
      permission: permission ?? self.permission,
      isRecording: isRecording ?? self.isRecording
    )
  }
}
