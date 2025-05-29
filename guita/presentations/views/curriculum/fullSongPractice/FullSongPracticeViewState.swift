//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

struct FullSongPracticeViewState {
  let isPlaying: Bool
  let currentTime: TimeInterval
  let totalTime: TimeInterval
  let progress: Double
  let playbackSpeed: Double
  let isAudioReady: Bool
  
  func copy(
    isPlaying: Bool? = nil,
    currentTime: TimeInterval? = nil,
    totalTime: TimeInterval? = nil,
    progress: Double? = nil,
    playbackSpeed: Double? = nil,
    isAudioReady: Bool? = nil
  ) -> FullSongPracticeViewState {
    return FullSongPracticeViewState(
      isPlaying: isPlaying ?? self.isPlaying,
      currentTime: currentTime ?? self.currentTime,
      totalTime: totalTime ?? self.totalTime,
      progress: progress ?? self.progress,
      playbackSpeed: playbackSpeed ?? self.playbackSpeed,
      isAudioReady: isAudioReady ?? self.isAudioReady
    )
  }
}
