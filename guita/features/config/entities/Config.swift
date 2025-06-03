//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct Config: Codable {
  let ttsSpeed: TTSSpeed
  let fullTrackPlaySpeed: PlaySpeed
  let noteThrottleInterval: Double
  let chordThrottleInterval: Double

  func copy(
    ttsSpeed: TTSSpeed? = nil,
    fullTrackPlaySpeed: PlaySpeed? = nil,
    noteThrottleInterval: Double? = nil,
    chordThrottleInterval: Double? = nil
  ) -> Config {
    return Config(
      ttsSpeed: ttsSpeed ?? self.ttsSpeed,
      fullTrackPlaySpeed: fullTrackPlaySpeed ?? self.fullTrackPlaySpeed,
      noteThrottleInterval: noteThrottleInterval ?? self.noteThrottleInterval,
      chordThrottleInterval: chordThrottleInterval ?? self.chordThrottleInterval
    )
  }
}
