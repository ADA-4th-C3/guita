//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class ConfigManager: BaseViewModel<Config> {
  static let shared = ConfigManager()
  private let repository = ConfigRepository()

  private init() {
    super.init(state: repository.load() ?? Config(
      ttsSpeed: .x0_45,
      fullTrackPlaySpeed: .x1_0,
      noteThrottleInterval: 1.0,
      chordThrottleInterval: 1.0,
      isVoiceCommandEnabled: true,
      chordClassificationType: .similarity
    ))
  }

  func updateConfig(_ newConfig: Config) {
    emit(newConfig)
    repository.save(newConfig)
  }
}
