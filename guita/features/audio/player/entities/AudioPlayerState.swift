//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum AudioPlayerState {
  case paused
  case playing
  case stopped

  var isPlaying: Bool { self == .playing }
}
