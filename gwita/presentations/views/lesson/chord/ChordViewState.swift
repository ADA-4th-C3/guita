//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct ChordViewState {
  let songInfo: SongInfo

  func copy(songInfo: SongInfo? = nil) -> ChordViewState {
    return ChordViewState(
      songInfo: songInfo ?? self.songInfo
    )
  }
}
