//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class ConfigManager: BaseViewModel<Config> {
  static let shared = ConfigManager()
  private let repository = ConfigRepository()

  private init() {
    super.init(state: repository.load() ?? Config(fullTrackPlaySpeed: .x1_0))
  }

  func updateConfig(_ newConfig: Config) {
    emit(newConfig)
    repository.save(newConfig)
  }
}
