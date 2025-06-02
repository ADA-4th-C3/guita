//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum ChordLessonStep: CaseIterable {
  case introduction
  case lineByLine
  case fullChord
  case finish

  var next: ChordLessonStep? {
    switch self {
    case .introduction: .lineByLine
    case .lineByLine: .fullChord
    case .fullChord: .finish
    case .finish: nil
    }
  }

  var previous: ChordLessonStep? {
    switch self {
    case .introduction: nil
    case .lineByLine: .introduction
    case .fullChord: .lineByLine
    case .finish: .fullChord
    }
  }
}
