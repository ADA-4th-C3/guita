enum TTSSpeed: Codable {
  case x0_25
  case x0_3
  case x0_35
  case x0_4
  case x0_45
  case x0_5
  case x0_55
  case x0_6
  case x0_65
  case x0_7
  case x0_75
  case x0_8
  case x0_85
  case x0_9
  case x0_95
  case x1_0

  var value: Float {
    switch self {
    case .x0_25: 0.25
    case .x0_3: 0.3
    case .x0_35: 0.35
    case .x0_4: 0.4
    case .x0_45: 0.45
    case .x0_5: 0.5
    case .x0_55: 0.55
    case .x0_6: 0.6
    case .x0_65: 0.65
    case .x0_7: 0.7
    case .x0_75: 0.75
    case .x0_8: 0.8
    case .x0_85: 0.85
    case .x0_9: 0.9
    case .x0_95: 0.95
    case .x1_0: 1.0
    }
  }

  var previous: TTSSpeed? {
    switch self {
    case .x0_25: nil
    case .x0_3: .x0_25
    case .x0_35: .x0_3
    case .x0_4: .x0_35
    case .x0_45: .x0_4
    case .x0_5: .x0_45
    case .x0_55: .x0_5
    case .x0_6: .x0_55
    case .x0_65: .x0_6
    case .x0_7: .x0_65
    case .x0_75: .x0_7
    case .x0_8: .x0_75
    case .x0_85: .x0_8
    case .x0_9: .x0_85
    case .x0_95: .x0_9
    case .x1_0: .x0_95
    }
  }

  var next: TTSSpeed? {
    switch self {
    case .x0_25: .x0_3
    case .x0_3: .x0_35
    case .x0_35: .x0_4
    case .x0_4: .x0_45
    case .x0_45: .x0_5
    case .x0_5: .x0_55
    case .x0_55: .x0_6
    case .x0_6: .x0_65
    case .x0_65: .x0_7
    case .x0_7: .x0_75
    case .x0_75: .x0_8
    case .x0_8: .x0_85
    case .x0_85: .x0_9
    case .x0_9: .x0_95
    case .x0_95: .x1_0
    case .x1_0: nil
    }
  }
}
