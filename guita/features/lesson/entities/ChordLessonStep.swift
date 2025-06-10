//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

enum ChordLessonStep: Equatable {
  case introduction
  case lineFingering(nString: Int, nFret: Int, nFinger: Int, coordIdx: Int, isFirst: Bool)
  case lineSoundCheck(nString: Int, nFret: Int, nFinger: Int, coordIdx: Int)
  case chordFingering
  case chordSoundCheck
  case finish

  static func == (lhs: ChordLessonStep, rhs: ChordLessonStep) -> Bool {
    switch (lhs, rhs) {
    case (.introduction, .introduction),
         (.lineFingering, .lineFingering),
         (.lineSoundCheck, .lineSoundCheck),
         (.chordFingering, .chordFingering),
         (.chordSoundCheck, .chordSoundCheck),
         (.finish, .finish):
      return true
    default:
      return false
    }
  }

  func getDescription(_ chord: Chord, index _: Int) -> String {
    switch self {
    case .introduction:
      return String(
        format: NSLocalizedString("ChordLesson.Step.Intro", comment: ""),
        "\(chord.rawValue)"
      )
    case let .lineFingering(_, _, nFinger, _, _):
      return String(
        format: NSLocalizedString("ChordLesson.Step.LineFingering", comment: ""),
        "\(chord.rawValue)",
        "\(nFinger.ordinal)"
      )
    case let .lineSoundCheck(nString, _, _, _):
      return String(
        format: NSLocalizedString("ChordLesson.Step.LineSoundCheck", comment: ""),
        "\(chord.rawValue)",
        "\(nString.ordinal)"
      )
    case .chordFingering:
      return String(
        format: NSLocalizedString("ChordLesson.Step.ChordFingering", comment: ""),
        "\(chord.rawValue)"
      )
    case .chordSoundCheck:
      return String(
        format: NSLocalizedString("ChordLesson.Step.ChordSoundCheck", comment: ""),
        "\(chord.rawValue)"
      )
    case .finish:
      return String(
        format: NSLocalizedString("ChordLesson.Step.Finish", comment: ""),
        "\(chord.rawValue)"
      )
    }
  }
}
