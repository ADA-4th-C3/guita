//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

struct SongInfo :Identifiable, Hashable {
  let id = UUID()
  let level: String
  let title: String
  let chords: [String]
  
  func copy(level: String? = nil,title: String? = nil,chords: [String]? = nil) -> SongInfo {
    return SongInfo(
      level: level ?? self.level,
      title: title ?? self.title,
      chords: chords ?? self.chords
    )
  
  }
}
