//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

extension Float {
  /// Returns the float formatted to the specified number of decimal places as a string
  func formatted(_ decimals: Int) -> String {
    String(format: "%.\(decimals)f", self)
  }
  
  /// Returns the string truncated to the specified number of decimal places
  func truncated(_ decimals: Int) -> String {
    return String(format: "%.\(decimals)f", self)
  }
}
