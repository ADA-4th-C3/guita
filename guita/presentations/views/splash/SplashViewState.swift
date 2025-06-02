//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct SplashViewState {
  let loaded: Bool

  func copy(loaded: Bool? = nil) -> SplashViewState {
    return SplashViewState(loaded: loaded ?? self.loaded)
  }
}
