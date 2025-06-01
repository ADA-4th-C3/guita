//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct TextToSpeechState {
  let isSpeaking: Bool

  func copy(isSpeaking: Bool? = nil) -> TextToSpeechState {
    TextToSpeechState(
      isSpeaking: isSpeaking ?? self.isSpeaking
    )
  }
}
