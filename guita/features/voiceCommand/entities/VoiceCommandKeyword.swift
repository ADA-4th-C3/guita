//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum VoiceCommandKeyword: CaseIterable {
  case start
  case stop
  case play
  case retry
  case next
  case previous

  var phrases: [String] {
    switch self {
    case .start: ["시작", "스타트"]
    case .stop: ["정지", "멈춰", "스탑"]
    case .play: ["재생", "플레이"]
    case .retry: ["다시", "처음부터"]
    case .next: ["다음"]
    case .previous: ["이전"]
    }
  }
}
