enum TTSSpeed: Codable {
  case x0_25
  case x0_5
  case x0_75
  case x1_0
  case x1_25
  case x1_5

  var value: Float {
    switch self {
    case .x0_25: 0.25
    case .x0_5: 0.5
    case .x0_75: 0.75
    case .x1_0: 1.0
    case .x1_25: 1.25
    case .x1_5: 1.5
    }
  }

  var previous: TTSSpeed? {
    switch self {
    case .x0_25: nil
    case .x0_5: .x0_25
    case .x0_75: .x0_5
    case .x1_0: .x0_75
    case .x1_25: .x1_0
    case .x1_5: .x1_25
    }
  }

  var next: TTSSpeed? {
    switch self {
    case .x0_25: .x0_5
    case .x0_5: .x0_75
    case .x0_75: .x1_0
    case .x1_0: .x1_25
    case .x1_25: .x1_5
    case .x1_5: nil
    }
  }
}
