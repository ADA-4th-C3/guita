//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

enum VoiceCommandKeyword: CaseIterable {
  case start
  case stop
  case play
  case retry
  case next
  case previous
  case slow
  case fast

  var phrases: [String] {
    let isKo = Locale.current.isKo
    switch self {
    case .start: return isKo ? ["시작"] : ["start"]
    case .stop: return isKo ? ["정지", "멈춰", "스탑"] : ["stop"]
    case .play: return isKo ? ["재생", "플레이"] : ["play"]
    case .retry: return isKo ? ["다시", "처음부터"] : ["retry", "replay"]
    case .next: return isKo ? ["다음"] : ["next"]
    case .previous: return isKo ? ["이전"] : ["previous"]
    case .slow: return isKo ? ["느리게"] : ["slow"]
    case .fast: return isKo ? ["빠르게"] : ["fast"]
    }
  }
}
