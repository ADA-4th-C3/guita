//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class ConfigViewModel: BaseViewModel<Config> {
  private let configManager = ConfigManager.shared

  init() {
    super.init(state: configManager.state)
  }

  override func emit(_ config: Config) {
    super.emit(config)
    configManager.updateConfig(config)
  }

  func speedUp() {
    guard let nextSpeed = state.fullTrackPlaySpeed.next else {
      return
    }
    emit(state.copy(fullTrackPlaySpeed: nextSpeed))
  }

  func speedDown() {
    guard let previousSpeed = state.fullTrackPlaySpeed.previous else {
      return
    }
    emit(state.copy(fullTrackPlaySpeed: previousSpeed))
  }
}
