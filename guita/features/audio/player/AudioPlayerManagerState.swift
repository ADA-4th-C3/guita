//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.
import Foundation

struct AudioPlayerManagerState {
  var isPlaying: Bool = false
  var currentTime: TimeInterval
  var totalDuration: TimeInterval


  func copy(
    isPlaying: Bool? = nil,
    currentTime: TimeInterval? = nil,
    totalDuration: TimeInterval? = nil
  ) -> AudioPlayerManagerState {
    return AudioPlayerManagerState(
      isPlaying: isPlaying ?? self.isPlaying,
      currentTime: currentTime ?? self.currentTime,
      totalDuration: totalDuration ?? self.totalDuration
    )
  }
}
