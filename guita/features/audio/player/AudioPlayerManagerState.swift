//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.
import Foundation

struct AudioPlayerManagerState {
  var playerState: AudioPlayerState
  var initTime: TimeInterval
  var currentTime: TimeInterval
  var totalDuration: TimeInterval

  func copy(
    playerState: AudioPlayerState? = nil,
    initTime: TimeInterval? = nil,
    currentTime: TimeInterval? = nil,
    totalDuration: TimeInterval? = nil
  ) -> AudioPlayerManagerState {
    return AudioPlayerManagerState(
      playerState: playerState ?? self.playerState,
      initTime: initTime ?? self.initTime,
      currentTime: currentTime ?? self.currentTime,
      totalDuration: totalDuration ?? self.totalDuration
    )
  }
}
