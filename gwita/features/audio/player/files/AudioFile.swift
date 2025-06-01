//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

enum AudioFile: String {
  case strokeDown = "stroke-down"
  case strokeUp = "stroke-up"
  
  var fileExtension: String {
    switch self {
    case .strokeDown: return "m4a"
    case .strokeUp: return "mp4a"
    }
  }
  
  var fileURL: URL? {
    Bundle.main.url(forResource: rawValue, withExtension: fileExtension)
  }
}
