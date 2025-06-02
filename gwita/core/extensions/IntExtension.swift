//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

extension Int {
  var koOrd: String {
    switch self {
    case 1:
      return "첫 번째"
    case 2:
      return "두 번째"
    case 3:
      return "세 번째"
    case 4:
      return "네 번째"
    case 5:
      return "다섯 번째"
    case 6:
      return "여섯 번째"
    case 7:
      return "일곱 번째"
    case 8:
      return "여덟 번째"
    case 9:
      return "아홉 번째"
    case 10:
      return "열 번째"
    default:
      return "\(self)번째"
    }
  }
  
  var koCard: String {
    switch self {
    case 1:
      return "하나"
    case 2:
      return "둘"
    case 3:
      return "셋"
    case 4:
      return "넷"
    case 5:
      return "다섯"
    case 6:
      return "여섯"
    case 7:
      return "일곱"
    case 8:
      return "여덟"
    case 9:
      return "아홉"
    case 10:
      return "열"
    default:
      return "\(self)"
    }
  }
  
}
