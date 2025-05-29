//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

struct VoiceControlViewState {
  let recordPermissionState: PermissionState
  let isListening: Bool
  let recognizedText: String
  let isPlaying: Bool
  let currentTime: TimeInterval
  let totalTime: TimeInterval
  let volume: Float
  
  func copy(
    recordPermissionState: PermissionState? = nil,
    isListening: Bool? = nil,
    recognizedText: String? = nil,
    isPlaying: Bool? = nil,
    currentTime: TimeInterval? = nil,
    totalTime: TimeInterval? = nil,
    volume: Float? = nil
  ) -> VoiceControlViewState {
    return VoiceControlViewState(
      recordPermissionState: recordPermissionState ?? self.recordPermissionState,
      isListening: isListening ?? self.isListening,
      recognizedText: recognizedText ?? self.recognizedText,
      isPlaying: isPlaying ?? self.isPlaying,
      currentTime: currentTime ?? self.currentTime,
      totalTime: totalTime ?? self.totalTime,
      volume: volume ?? self.volume
    )
  }
}
