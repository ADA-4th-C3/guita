//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum PlaySpeed: Codable {
  case x0_5
  case x0_75
  case x1_0
  case x1_25
  case x1_5

  var value: Float {
    switch self {
    case .x0_5: return 0.5
    case .x0_75: return 0.75
    case .x1_0: return 1.0
    case .x1_25: return 1.25
    case .x1_5: return 1.5
    }
  }

  var previous: PlaySpeed? {
    switch self {
    case .x0_5: return nil
    case .x0_75: return .x0_5
    case .x1_0: return .x0_75
    case .x1_25: return .x1_0
    case .x1_5: return .x1_25
    }
  }

  var next: PlaySpeed? {
    switch self {
    case .x0_5: return .x0_75
    case .x0_75: return .x1_0
    case .x1_0: return .x1_25
    case .x1_25: return .x1_5
    case .x1_5: return nil
    }
  }
}
