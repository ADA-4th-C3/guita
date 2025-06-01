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
  case A_strokeDown = "A-stroke-down"
  case A_strokeDownSlow = "A-stroke-down-slow"

  var fileURL: URL? {
    Bundle.main.url(forResource: rawValue, withExtension: "m4a")
  }
}
