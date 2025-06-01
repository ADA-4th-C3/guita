//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

enum AudioFile: String {
  case strokeDown = "stroke-down"
  case strokeUp = "stroke-up"
  case A_1 = "A-1"
  case A_2 = "A-2"
  case A_3 = "A-3"
  case A_4 = "A-4"
  case A_5 = "A-5"
  case A_6 = "A-6"
  
  var fileExtension: String {
    switch self {
    case .strokeDown: "m4a"
    case .strokeUp: "m4a"
    case .A_1: "m4a"
    case .A_2: "m4a"
    case .A_3: "m4a"
    case .A_4: "m4a"
    case .A_5: "m4a"
    case .A_6: "m4a"
    }
  }
  
  var fileURL: URL? {
    Bundle.main.url(forResource: rawValue, withExtension: fileExtension)
  }
}
