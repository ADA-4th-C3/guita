//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

enum AudioFile: String {
  // MARK: Guitar
  case strokeDown = "stroke-down.m4a"
  case strokeUp = "stroke-up.m4a"
  case strokeCalypso = "stroke-calypso.m4a"
  case A_1 = "A-1.m4a"
  case A_2 = "A-2.m4a"
  case A_3 = "A-3.m4a"
  case A_4 = "A-4.m4a"
  case A_5 = "A-5.m4a"
  case A_6 = "A-6.m4a"
  case A_strokeDown = "A-stroke-down.m4a"
  case A_strokeDownSlow = "A-stroke-down-slow.m4a"

  // MARK: Effect
  case positive = "positive.mp3"
  case nextPage = "next-page.mp3"

  var fileURL: URL? {
    let splitted = rawValue.split(separator: ".")
    guard splitted.count == 2 else { return nil }
    let name = String(splitted[0])
    let ext = String(splitted[1])
    return Bundle.main.url(forResource: name, withExtension: ext)
  }
}
