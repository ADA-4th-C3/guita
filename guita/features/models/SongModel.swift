//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

struct SongModel: Identifiable, Hashable {
  let id: String
  let title: String
  let artist: String
  let difficulty: DifficultyLevel
  let requiredCodes: [Chord]
  let audioFileName: String
  let isUnlocked: Bool
  let isCompleted: Bool
  
  var displayTitle: String {
    return "[\(difficulty.displayName)] \(title)"
  }
  
  var subtitle: String {
    return requiredCodes.map { $0.rawValue }.joined(separator: " ")
  }
}

enum DifficultyLevel: String, CaseIterable {
  case beginner = "초급"
  case intermediate = "중급"
  case advanced = "고급"
  
  var displayName: String {
    switch self {
    case .beginner: return "초급1"
    case .intermediate: return "중급1"
    case .advanced: return "고급1"
    }
  }
}

// 샘플 데이터 팩토리
struct SongDataFactory {
  static func createDefaultSongs() -> [SongModel] {
    return [
      SongModel(
        id: "song_01",
        title: "여행을 떠나요",
        artist: "조용필",
        difficulty: .beginner,
        requiredCodes: [.A, .E, .B7],
        audioFileName: "forStudyGuitar",
        isUnlocked: true,
        isCompleted: false
      ),
      SongModel(
        id: "song_02",
        title: "바람이 불어오는 곳",
        artist: "이승환",
        difficulty: .beginner,
        requiredCodes: [.G, .C, .D],
        audioFileName: "song_02",
        isUnlocked: false,
        isCompleted: false
      ),
      SongModel(
        id: "song_03",
        title: "그대에게",
        artist: "무한궤도",
        difficulty: .intermediate,
        requiredCodes: [.C, .Dm, .Em, .F],
        audioFileName: "song_03",
        isUnlocked: false,
        isCompleted: false
      )
    ]
  }
}
