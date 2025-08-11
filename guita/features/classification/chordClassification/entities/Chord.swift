//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

enum Chord: String, CaseIterable, CustomStringConvertible {
  case C, D, E, F, G, A, B
  case C7, D7, E7, F7, G7, A7, B7
  case Cm, Dm, Em, Fm, Gm, Am, Bm
  case Cm7, Dm7, Em7, Fm7, Gm7, Am7, Bm7
  case CM7, DM7, EM7, FM7, GM7, AM7, BM7

  /// 사용하는 fret
  var frets: [Int] {
    let uniqueFrets = Set(coordinates.flatMap { $0.0.map { $0.fret } })
    return Array(uniqueFrets).sorted()
  }

  /// 사용하는 손가락 개수
  var nFingers: Int {
    Set(coordinates.map { $0.finger }).count
  }

  var notes: [Note] {
    let positions = coordinates.flatMap { $0.0 }
    return positions.compactMap { position in
      Note.allCases.first(where: { note in
        note.coordinates.contains(where: { $0.fret == position.fret && $0.string == position.string })
      })
    }
  }

  var coordinates: [([(fret: Int, string: Int)], finger: Int)] {
    switch self {
    // MARK: Major
    case .C: return [([(1, 2)], 2), ([(2, 4)], 3), ([(3, 5)], 4)]
    case .D: return [([(2, 3)], 2), ([(2, 1)], 3), ([(3, 2)], 4)]
    case .E: return [([(1, 3)], 2), ([(2, 5)], 3), ([(2, 4)], 4)]
    case .F: return [([(1, 1), (1, 2), (1, 6)], 2), ([(2, 3)], 3), ([(3, 5)], 4), ([(3, 4)], 5)]
    case .G: return [([(2, 5)], 2), ([(3, 6)], 3), ([(3, 1)], 5)]
    case .A: return [([(2, 4)], 3), ([(2, 3)], 4), ([(2, 2)], 5)]
    case .B: return [([(2, 1), (2, 5), (2, 6)], 2), ([(4, 4)], 3), ([(4, 3)], 4), ([(4, 2)], 5)]
    // MARK: 7
    case .B7: return [([(1, 4)], 2), ([(2, 5)], 3), ([(2, 3)], 4) /* , ([(2, 1)], 5) */ ] // 약식으로 잡음
    case .C7: return [([(1, 2)], 1), ([(2, 4)], 2), ([(3, 5)], 3), ([(3, 3)], 4)]
    case .D7: return [([(1, 2)], 1), ([(2, 3)], 2), ([(2, 1)], 3)]
    case .E7: return [([(1, 3)], 1), ([(2, 5)], 2)]
    case .F7: return [([(1, 1), (1, 2), (1, 4), (1, 6)], 1), ([(2, 3)], 2), ([(3, 5)], 3)]
    case .G7: return [([(1, 1)], 1), ([(2, 5)], 2), ([(3, 6)], 3)]
    case .A7: return [([(2, 4)], 1), ([(2, 2)], 2)]
    // MARK: Minor
    case .Cm: return [([(1, 1), (1, 5), (1, 6)], 1), ([(2, 4)], 2), ([(3, 4)], 3), ([(3, 3)], 4)]
    case .Dm: return [([(1, 1)], 1), ([(2, 3)], 2), ([(3, 2)], 3)]
    case .Em: return [([(2, 5)], 1), ([(2, 4)], 2)]
    case .Fm: return [([(1, 1), (1, 2), (1, 3), (1, 6)], 1), ([(3, 5)], 3), ([(3, 4)], 4)]
    case .Gm: return [([(1, 1), (1, 2), (1, 3), (1, 6)], 1), ([(3, 5)], 3), ([(3, 4)], 4)]
    case .Am: return [([(1, 2)], 1), ([(2, 4)], 2), ([(2, 3)], 3)]
    case .Bm: return [([(2, 1), (2, 5), (2, 6)], 1), ([(3, 2)], 2), ([(4, 4)], 3), ([(4, 3)], 4)]
    // MARK: Minor7
    case .Cm7: return [([(1, 1), (1, 3), (1, 5), (1, 6)], 1), ([(2, 2)], 2), ([(3, 4)], 3)]
    case .Dm7: return [([(1, 1), (1, 2)], 1), ([(2, 3)], 2)]
    case .Em7: return [([(2, 5)], 1)]
    case .Fm7: return [([(1, 1), (1, 2), (1, 3), (1, 4), (1, 6)], 1), ([(3, 5)], 3)]
    case .Gm7: return [([(1, 1), (1, 2), (1, 3), (1, 4), (1, 6)], 1), ([(3, 5)], 3)]
    case .Am7: return [([(1, 2)], 1), ([(2, 4)], 2)]
    case .Bm7: return [([(2, 1), (2, 3), (2, 5), (2, 6)], 1), ([(3, 2)], 2), ([(3, 4)], 3)]
    // MARK: Major7
    case .CM7: return [([(2, 4)], 2), ([(3, 5)], 3)]
    case .DM7: return [([(2, 1), (2, 2), (2, 3)], 1)]
    case .EM7: return [([(1, 4)], 1), ([(1, 3)], 2), ([(2, 5)], 3)]
    case .FM7: return [([(1, 2)], 1), ([(2, 3)], 2), ([(3, 4)], 3)]
    case .GM7: return [([(2, 1)], 1), ([(2, 5)], 2), ([(3, 6)], 3)]
    case .AM7: return [([(1, 3)], 1), ([(2, 4)], 2), ([(2, 2)], 3)]
    case .BM7: return [([(2, 1), (2, 5), (2, 6)], 1),  ([(3, 3)], 2), ([(4, 4)], 3), ([(4, 2)], 4)]
    }
  }

  /// 기본 12음 배열
  /// ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
  var chroma: [Float] {
    func chromaVector(for notes: [Int], weights: [Float]? = nil) -> [Float] {
      var vector = [Float](repeating: 0.0, count: 12)
      for (i, note) in notes.enumerated() {
        let weight = weights?[i] ?? 1.0
        vector[note % 12] = weight
      }
      return vector
    }

    switch self {
    // MARK: Major
    case .C: return chromaVector(for: [0, 4, 7], weights: [1.0, 0.7, 0.7])
    case .D: return chromaVector(for: [2, 6, 9, 0], weights: [1.0, 0.7, 0.7, 0.5])
    case .E: return chromaVector(for: [4, 8, 11], weights: [1.0, 0.7, 0.7])
    case .F: return chromaVector(for: [5, 9, 0], weights: [1.0, 0.7, 0.7])
    case .G: return chromaVector(for: [7, 11, 2], weights: [1.0, 0.7, 0.7])
    case .A: return chromaVector(for: [9, 1, 4], weights: [1.0, 0.7, 0.7])
    case .B: return chromaVector(for: [11, 3, 6], weights: [1.0, 0.7, 0.7])
    // MARK: 7
    case .C7: return chromaVector(for: [0, 4, 7, 10], weights: [1.0, 0.7, 0.7, 0.5])
    case .D7: return chromaVector(for: [2, 6, 9, 0], weights: [1.0, 0.7, 0.7, 0.5])
    case .E7: return chromaVector(for: [4, 8, 11, 2], weights: [1.0, 0.7, 0.7, 0.5])
    case .F7: return chromaVector(for: [5, 9, 0, 3], weights: [1.0, 0.7, 0.7, 0.5])
    case .G7: return chromaVector(for: [7, 11, 2, 5], weights: [1.0, 0.7, 0.7, 0.5])
    case .A7: return chromaVector(for: [9, 1, 4, 7], weights: [1.0, 0.7, 0.7, 0.5])
    case .B7: return chromaVector(for: [11, 3, 6, 9], weights: [1.0, 0.7, 0.7, 0.5])
    // MARK: Minor
    case .Cm: return chromaVector(for: [0, 3, 7], weights: [1.0, 0.7, 0.7])
    case .Dm: return chromaVector(for: [2, 5, 9], weights: [1.0, 0.7, 0.7])
    case .Em: return chromaVector(for: [4, 7, 11], weights: [1.0, 0.7, 0.7])
    case .Fm: return chromaVector(for: [5, 8, 0], weights: [1.0, 0.7, 0.7])
    case .Gm: return chromaVector(for: [7, 10, 2], weights: [1.0, 0.7, 0.7])
    case .Am: return chromaVector(for: [9, 0, 4], weights: [1.0, 0.7, 0.7])
    case .Bm: return chromaVector(for: [11, 2, 6], weights: [1.0, 0.7, 0.7])
    // MARK: Minor7
    case .Cm7: return chromaVector(for: [0, 3, 7, 10], weights: [1.0, 0.7, 0.7, 0.5])
    case .Dm7: return chromaVector(for: [2, 5, 9, 0], weights: [1.0, 0.7, 0.7, 0.5])
    case .Em7: return chromaVector(for: [4, 7, 11, 2], weights: [1.0, 0.7, 0.7, 0.5])
    case .Fm7: return chromaVector(for: [5, 8, 0, 3], weights: [1.0, 0.7, 0.7, 0.5])
    case .Gm7: return chromaVector(for: [7, 10, 2, 5], weights: [1.0, 0.7, 0.7, 0.5])
    case .Am7: return chromaVector(for: [9, 0, 4, 7], weights: [1.0, 0.7, 0.7, 0.5])
    case .Bm7: return chromaVector(for: [11, 2, 6, 9], weights: [1.0, 0.7, 0.7, 0.5])
    // MARK: Major7
    case .CM7: return chromaVector(for: [0, 4, 7, 11], weights: [1.0, 0.7, 0.7, 0.5])
    case .DM7: return chromaVector(for: [2, 6, 9, 1], weights: [1.0, 0.7, 0.7, 0.5])
    case .EM7: return chromaVector(for: [4, 8, 11, 3], weights: [1.0, 0.7, 0.7, 0.5])
    case .FM7: return chromaVector(for: [5, 9, 0, 4], weights: [1.0, 0.7, 0.7, 0.5])
    case .GM7: return chromaVector(for: [7, 11, 2, 6], weights: [1.0, 0.7, 0.7, 0.5])
    case .AM7: return chromaVector(for: [9, 1, 4, 8], weights: [1.0, 0.7, 0.7, 0.5])
    case .BM7: return chromaVector(for: [11, 3, 6, 10], weights: [1.0, 0.7, 0.7, 0.5])
    }
  }

  var description: String {
    let name = rawValue
      .replacingOccurrences(of: "m", with: " " + NSLocalizedString("Chord.Minor", comment: ""))
      .replacingOccurrences(of: "7", with: " " + NSLocalizedString("Chord.Seven", comment: ""))
    return name
  }
}
