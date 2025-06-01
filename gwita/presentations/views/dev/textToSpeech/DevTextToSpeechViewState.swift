//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct DevTextToSpeechViewState {
  let samples: [String]
  let index: Int
  let isVoiceCommandEnabled: Bool

  func copy(
    samples: [String]? = nil,
    index: Int? = nil,
    isVoiceCommandEnabled: Bool? = nil
  ) -> DevTextToSpeechViewState {
    return DevTextToSpeechViewState(
      samples: samples ?? self.samples,
      index: index ?? self.index,
      isVoiceCommandEnabled: isVoiceCommandEnabled ?? self.isVoiceCommandEnabled
    )
  }
}
