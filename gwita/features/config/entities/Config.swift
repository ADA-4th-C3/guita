//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct Config: Codable {
  let fullTrackPlaySpeed: PlaySpeed

  func copy(fullTrackPlaySpeed: PlaySpeed? = nil) -> Config {
    return Config(
      fullTrackPlaySpeed: fullTrackPlaySpeed ?? self.fullTrackPlaySpeed
    )
  }
}
