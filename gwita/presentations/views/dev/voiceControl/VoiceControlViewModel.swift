//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class VoiceControlViewModel: BaseViewModel<VoiceControlViewState> {
  private let speechToTextManager = SpeechToTextManager.shared

  init() {
    super.init(state: .init(text: ""))
  }
  
  func start() {
    speechToTextManager.start { text in
      self.emit(self.state.copy(text: text))
    }
  }

  override func dispose() {
    speechToTextManager.stop()
  }
}
