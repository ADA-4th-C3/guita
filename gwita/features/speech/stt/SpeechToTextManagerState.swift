//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct SpeechToTextState {
  let permission: PermissionResult
  let isRecognizing: Bool

  func copy(
    permission: PermissionResult? = nil,
    isRecognizing: Bool? = nil
  ) -> SpeechToTextState {
    return SpeechToTextState(
      permission: permission ?? self.permission,
      isRecognizing: isRecognizing ?? self.isRecognizing
    )
  }
}
