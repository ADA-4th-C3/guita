//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class DevVoiceCommandViewModel: BaseViewModel<DevVoiceCommandViewState> {
  private let voiceCommandManager = VoiceCommandManager.shared

  init() {
    super.init(state: .init(
      text: "",
      commands: VoiceCommandKeyword.allCases.map {
        VoiceCommand(keyword: $0, handler: {})
      },
      history: []
    ))
  }

  func start() {
    voiceCommandManager.start(
      commands: state.commands,
      sttResult: { text in
        self.emit(self.state.copy(text: text))
      },
      historyListener: { history in
        self.emit(self.state.copy(history: history))
      }
    )
  }

  override func dispose() {
    voiceCommandManager.stop()
  }
}
