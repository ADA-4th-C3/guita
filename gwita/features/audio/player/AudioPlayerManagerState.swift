//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct AudioPlayerManagerState {
  var isPlaying: Bool = false

  func copy(isPlaying: Bool? = nil) -> AudioPlayerManagerState {
    return AudioPlayerManagerState(isPlaying: isPlaying ?? self.isPlaying)
  }
}
