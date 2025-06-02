
//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

class ConfigRepository {
  private let userDefaults = UserDefaults.standard
  private let configKey = "userConfig"

  func save(_ config: Config) {
    if let encoded = try? JSONEncoder().encode(config) {
      userDefaults.set(encoded, forKey: configKey)
    }
  }

  func load() -> Config? {
    guard let data = userDefaults.data(forKey: configKey),
          let config = try? JSONDecoder().decode(Config.self, from: data)
    else {
      return nil
    }
    return config
  }
}
