//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

extension Int {
  var ordinal: String {
    switch self {
    case 1:
      return NSLocalizedString("첫 번째", comment: "")
    case 2:
      return NSLocalizedString("두 번째", comment: "")
    case 3:
      return NSLocalizedString("세 번째", comment: "")
    case 4:
      return NSLocalizedString("네 번째", comment: "")
    case 5:
      return NSLocalizedString("다섯 번째", comment: "")
    case 6:
      return NSLocalizedString("여섯 번째", comment: "")
    case 7:
      return NSLocalizedString("일곱 번째", comment: "")
    case 8:
      return NSLocalizedString("여덟 번째", comment: "")
    case 9:
      return NSLocalizedString("아홉 번째", comment: "")
    case 10:
      return NSLocalizedString("열 번째", comment: "")
    default:
      return String(
        format: NSLocalizedString("ordinal", comment: ""),
        "\(self)"
      )
    }
  }

  var cardinal: String {
    switch self {
    case 1:
      return NSLocalizedString("하나", comment: "")
    case 2:
      return NSLocalizedString("둘", comment: "")
    case 3:
      return NSLocalizedString("셋", comment: "")
    case 4:
      return NSLocalizedString("넷", comment: "")
    case 5:
      return NSLocalizedString("다섯", comment: "")
    case 6:
      return NSLocalizedString("여섯", comment: "")
    case 7:
      return NSLocalizedString("일곱", comment: "")
    case 8:
      return NSLocalizedString("여덟", comment: "")
    case 9:
      return NSLocalizedString("아홉", comment: "")
    case 10:
      return NSLocalizedString("열", comment: "")
    default:
      return "\(self)"
    }
  }

  var fingerName: String {
    switch self {
    case 1:
      return NSLocalizedString("Finger.1", comment: "")
    case 2:
      return NSLocalizedString("Finger.2", comment: "")
    case 3:
      return NSLocalizedString("Finger.3", comment: "")
    case 4:
      return NSLocalizedString("Finger.4", comment: "")
    default:
      return NSLocalizedString("Finger.5", comment: "")
    }
  }
}
