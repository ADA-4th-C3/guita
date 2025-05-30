enum Chord: CaseIterable {
  case C, D, E, F, G, A, B
  case Dm, Em, Am
  case B7

  var coordinates: [([(fret: Int, string: Int)], finger: Int)] {
    switch self {
    // MARK: Major
    case .C: return [([(1, 2)], 2), ([(2, 4)], 3), ([(3, 5)], 4)]
    case .D: return [([(2, 1)], 3), ([(2, 3)], 2), ([(3, 2)], 4)]
    case .E: return [([(1, 3)], 2), ([(2, 4)], 4), ([(2, 5)], 3)]
    case .F: return [([(1, 1), (1, 2), (1, 6)], 2), ([(2, 3)], 3), ([(3, 4)], 5), ([(3, 5)], 4)]
    case .G: return [([(2, 5)], 2), ([(3, 1)], 5), ([(3, 6)], 3)]
    case .A: return [([(2, 2)], 5), ([(2, 3)], 4), ([(2, 4)], 3)]
    case .B: return [([(2, 1), (2, 5), (2, 6)], 2), ([(4, 2)], 5), ([(4, 3)], 4), ([(4, 4)], 3)]
    // MARK: Minor
    case .Dm: return [([(1, 1)], 2), ([(2, 3)], 3), ([(3, 2)], 4)]
    case .Em: return [([(2, 4)], 4), ([(2, 5)], 3)]
    case .Am: return [([(1, 2)], 2), ([(2, 3)], 4), ([(2, 4)], 3)]
    // MARK: 7
    case .B7: return [([(1, 4)], 2), ([(2, 1)], 5), ([(2, 3)], 4), ([(2, 5)], 3)]
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
    case .C: return chromaVector(for: [0, 4, 7], weights: [1.0, 0.7, 0.7])
    case .D: return chromaVector(for: [2, 6, 9, 0], weights: [1.0, 0.7, 0.7, 0.5])
    case .E: return chromaVector(for: [4, 8, 11], weights: [1.0, 0.7, 0.7])
    case .F: return chromaVector(for: [5, 9, 0], weights: [1.0, 0.7, 0.7])
    case .G: return chromaVector(for: [7, 11, 2], weights: [1.0, 0.7, 0.7])
    case .A: return chromaVector(for: [9, 1, 4], weights: [1.0, 0.7, 0.7])
    case .B: return chromaVector(for: [11, 3, 6], weights: [1.0, 0.7, 0.7])
    case .Dm: return chromaVector(for: [2, 5, 9], weights: [1.0, 0.7, 0.7])
    case .Em: return chromaVector(for: [4, 7, 11], weights: [1.0, 0.7, 0.7])
    case .Am: return chromaVector(for: [9, 0, 4], weights: [1.0, 0.7, 0.7])
    case .B7: return chromaVector(for: [11, 3, 6, 9], weights: [1.0, 0.7, 0.7, 0.5])
    }
  }
}
