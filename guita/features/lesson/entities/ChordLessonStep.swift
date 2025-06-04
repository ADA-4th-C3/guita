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

  func getDescription(_ chord: Chord, index: Int) -> String {
    switch self {
    case .introduction:
      return "\(chord.rawValue) 코드 개요"
    case .lineByLine:
      let lineIndex = (index - 1) / 2
      guard index > 0, lineIndex < chord.coordinates.count else { return "" }
      let coordinate = chord.coordinates[lineIndex]
      let nFret = coordinate.0.first!.fret
      let nString = coordinate.0.first!.string
      let (fret, string) = (nFret.koOrd, nString.koOrd)
      return "\(chord.rawValue) 코드 \(fret) 프렛\n아래서 \(string) 줄 운지 연습"
    case .fullChord:
      return "\(chord.rawValue) 코드 소리 확인"
    case .finish:
      return "\(chord.rawValue) 코드 학습 종료"
    }
  }
}
