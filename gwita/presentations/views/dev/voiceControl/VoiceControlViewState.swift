//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct VoiceControlViewState {
  let text: String

  func copy(text: String? = nil) -> VoiceControlViewState {
    return VoiceControlViewState(text: text ?? self.text)
  }
}
