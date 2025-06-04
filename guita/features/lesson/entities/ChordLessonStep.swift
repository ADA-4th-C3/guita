//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum ChordLessonStep: Equatable {
  case introduction
  case lineFingering(nString: Int, nFret: Int, nFinger: Int)
  case lineSoundCheck(nString: Int, nFret: Int, nFinger: Int)
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
      return "\(chord.rawValue) 코드 개요"
    case let .lineFingering(nString, _, _):
      return "\(chord.rawValue) 코드 \(nString.koOrd) 줄 운지법 설명"
    case let .lineSoundCheck(nString, _, _):
      return "\(chord.rawValue) 코드 \(nString.koOrd) 줄 소리 확인"
    case .chordFingering:
      return "\(chord.rawValue) 코드 운지법 설명"
    case .chordSoundCheck:
      return "\(chord.rawValue) 코드 소리 확인"
    case .finish:
      return "\(chord.rawValue) 코드 학습 종료"
    }
  }
}
