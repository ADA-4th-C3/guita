//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct VoiceCommandManagerState {
  let isRecognizing: Bool
  let isPaused: Bool
  let previousText: String
  let history: [VoiceCommandHistory]

  func copy(
    isRecognizing: Bool? = nil,
    isPaused: Bool? = nil,
    previousText: String? = nil,
    history: [VoiceCommandHistory]? = nil
  ) -> VoiceCommandManagerState {
    return VoiceCommandManagerState(
      isRecognizing: isRecognizing ?? self.isRecognizing,
      isPaused: isPaused ?? self.isPaused,
      previousText: previousText ?? self.previousText,
      history: history ?? self.history
    )
  }
}
