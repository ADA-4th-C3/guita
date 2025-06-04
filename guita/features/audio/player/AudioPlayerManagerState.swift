//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.
import Foundation

struct AudioPlayerManagerState {
  var playerState: AudioPlayerState
  var currentTime: TimeInterval
  var totalDuration: TimeInterval

  func copy(
    playerState: AudioPlayerState? = nil,
    currentTime: TimeInterval? = nil,
    totalDuration: TimeInterval? = nil
  ) -> AudioPlayerManagerState {
    return AudioPlayerManagerState(
      playerState: playerState ?? self.playerState,
      currentTime: currentTime ?? self.currentTime,
      totalDuration: totalDuration ?? self.totalDuration
    )
  }
}
