//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum Note: CaseIterable {
  case E2, F2, Gb2, G2, Ab2, A2, Bb2, B2, C3, Db3, D3, Eb3, E3, F3, Gb3, G3, Ab3, A3, Bb3, B3, C4
  case Db4, D4, Eb4, E4, F4
  case Gb4, G4, Ab4, A4, Bb4
  case B4, C5, Db5, D5, Eb5, E5, F5, Gb5, G5, Ab5, A5, Bb5, B5, C6

  var coordinates: [(string: Int, fret: Int)] {
    switch self {
    case .E2: return [(6, 0)] // Line6
    case .F2: return [(6, 1)]
    case .Gb2: return [(6, 2)]
    case .G2: return [(6, 3)]
    case .Ab2: return [(6, 4)]
    case .A2: return [(6, 5), (5, 0)] // Line5
    case .Bb2: return [(6, 6), (5, 1)]
    case .B2: return [(6, 7), (5, 2)]
    case .C3: return [(6, 8), (5, 3)]
    case .Db3: return [(6, 9), (5, 4)]
    case .D3: return [(6, 10), (5, 5), (4, 0)] // Line4
    case .Eb3: return [(6, 11), (5, 6), (4, 1)]
    case .E3: return [(6, 12), (5, 7), (4, 2)]
    case .F3: return [(6, 13), (5, 8), (4, 3)]
    case .Gb3: return [(6, 14), (5, 9), (4, 4)]
    case .G3: return [(3, 0), (6, 15), (5, 10), (4, 5)] // Line3
    case .Ab3: return [(3, 1), (6, 16), (5, 11), (4, 6)]
    case .A3: return [(3, 2), (6, 17), (5, 12), (4, 7)]
    case .Bb3: return [(3, 3), (6, 18), (5, 13), (4, 8)]
    case .B3: return [(2, 0), (3, 4), (6, 19), (5, 14), (4, 9)] // Line2
    case .C4: return [(2, 1), (3, 5), (6, 20), (5, 15), (4, 10)]
    case .Db4: return [(2, 2), (3, 6), (5, 16), (4, 11)]
    case .D4: return [(2, 3), (3, 7), (5, 17), (4, 12)]
    case .Eb4: return [(2, 4), (3, 8), (5, 18), (4, 13)]
    case .E4: return [(2, 5), (3, 9), (5, 19), (4, 14), (1, 0)] // Line1
    case .F4: return [(2, 6), (3, 10), (5, 20), (4, 15), (1, 1)]
    case .Gb4: return [(2, 7), (3, 11), (4, 16), (1, 2)]
    case .G4: return [(2, 8), (3, 12), (4, 17), (1, 3)]
    case .Ab4: return [(2, 9), (3, 13), (4, 18), (1, 4)]
    case .A4: return [(2, 10), (3, 14), (4, 19), (1, 5)]
    case .Bb4: return [(2, 11), (3, 15), (4, 20), (1, 6)]
    case .B4: return [(2, 12), (3, 16), (1, 7)]
    case .C5: return [(2, 13), (3, 17), (1, 8)]
    case .Db5: return [(2, 14), (3, 18), (1, 9)]
    case .D5: return [(2, 15), (3, 19), (1, 10)]
    case .Eb5: return [(2, 16), (3, 20), (1, 11)]
    case .E5: return [(2, 17), (1, 12)]
    case .F5: return [(2, 18), (1, 13)]
    case .Gb5: return [(2, 19), (1, 14)]
    case .G5: return [(2, 20), (1, 15)]
    case .Ab5: return [(1, 16)]
    case .A5: return [(1, 17)]
    case .Bb5: return [(1, 18)]
    case .B5: return [(1, 19)]
    case .C6: return [(1, 20)]
    }
  }

  var frequency: Double {
    switch self {
    case .E2: return 82.41
    case .F2: return 87.31
    case .Gb2: return 92.50
    case .G2: return 98.00
    case .Ab2: return 103.83
    case .A2: return 110.00
    case .Bb2: return 116.54
    case .B2: return 123.47
    case .C3: return 130.81
    case .Db3: return 138.59
    case .D3: return 146.83
    case .Eb3: return 155.56
    case .E3: return 164.81
    case .F3: return 174.61
    case .Gb3: return 185.00
    case .G3: return 196.00
    case .Ab3: return 207.65
    case .A3: return 220.00
    case .Bb3: return 233.08
    case .B3: return 246.94
    case .C4: return 261.63
    case .Db4: return 277.18
    case .D4: return 293.66
    case .Eb4: return 311.13
    case .E4: return 329.63
    case .F4: return 349.23
    case .Gb4: return 369.99
    case .G4: return 392.00
    case .Ab4: return 415.30
    case .A4: return 440.00
    case .Bb4: return 466.16
    case .B4: return 493.88
    case .C5: return 523.25
    case .Db5: return 554.37
    case .D5: return 587.33
    case .Eb5: return 622.25
    case .E5: return 659.26
    case .F5: return 698.46
    case .Gb5: return 739.99
    case .G5: return 783.99
    case .Ab5: return 830.61
    case .A5: return 880.00
    case .Bb5: return 932.33
    case .B5: return 987.77
    case .C6: return 1046.50
    }
  }
}
