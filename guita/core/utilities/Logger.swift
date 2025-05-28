//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

enum Logger {
  static func d(_ message: String, file: String = #file, line: Int = #line) {
    #if DEBUG
      let fileName = (file as NSString).lastPathComponent
      print("🟢 [DEBUG] \(fileName):\(line) - \(message)")
    #endif
  }

  static func e(_ message: String, file: String = #file, line: Int = #line) {
    #if DEBUG
      let fileName = (file as NSString).lastPathComponent
      print("🔴 [ERROR] \(fileName):\(line) - \(message)")
    #endif
  }
}
