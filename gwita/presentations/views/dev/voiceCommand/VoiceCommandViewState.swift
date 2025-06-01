//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct VoiceCommandViewState {
  let text: String
  let commands: [VoiceCommand]
  let history: [VoiceCommandHistory]

  func copy(
    text: String? = nil,
    commands: [VoiceCommand]? = nil,
    history: [VoiceCommandHistory]? = nil
  ) -> VoiceCommandViewState {
    return VoiceCommandViewState(
      text: text ?? self.text,
      commands: commands ?? self.commands,
      history: history ?? self.history
    )
  }
}
