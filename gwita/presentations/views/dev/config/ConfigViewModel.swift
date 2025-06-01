//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class ConfigViewModel: BaseViewModel<Config> {
  private let configManager = ConfigManager.shared
  private let textToSpeechManager = TextToSpeechManager.shared

  init() {
    super.init(state: configManager.state)
  }

  override func emit(_ config: Config) {
    super.emit(config)
    configManager.updateConfig(config)
  }

  func updateFullTrackPlaySpeed(isSpeedUp: Bool) {
    emit(state.copy(fullTrackPlaySpeed: isSpeedUp ? state.fullTrackPlaySpeed.next : state.fullTrackPlaySpeed.previous))
  }

  func updateTtsSpeed(isSpeedUp: Bool) {
    emit(state.copy(ttsSpeed: isSpeedUp ? state.ttsSpeed.next : state.ttsSpeed.previous))
    Task {
      textToSpeechManager.stop()
      await textToSpeechManager.speak("코로나로 식욕이 사라졌던 줄리앤 블랙홀 처럼 모든 걸 빨아들이게 된 사연은? Feat. 아 배고프다 편의점 갈 사람?")
    }
  }

  override func dispose() {
    textToSpeechManager.stop()
  }
}
