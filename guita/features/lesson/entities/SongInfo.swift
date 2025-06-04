//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

struct SongInfo: Identifiable, Hashable {
  let id = UUID()
  let level: String
  let title: String
  let chords: [Chord]
  let fullSong: AudioFile
}

extension SongInfo {
  var truncatedTitle: String {
    let maxCount = 20
    if title.count > maxCount {
      return title.prefix(maxCount) + "…"
    } else {
      return title
    }
  }
  
  static var curriculum: [SongInfo] = [
    SongInfo(level: "[초급1]", title: "여행을 떠나요", chords: [.A, .E, .B7], fullSong: .basic_1)
  ]
}
