//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum VoiceCommandKeyword: CaseIterable {
  case start
  case stop
  case play
  case retry
  
  var phrases: [String] {
    switch self {
    case .start:
      return ["시작", "스타트"]
    case .stop:
      return ["정지", "멈춰", "스탑"]
    case .play:
      return ["재생", "플레이"]
    case .retry:
      return ["다시", "처음부터"]
    }
  }
}
