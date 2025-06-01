//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

extension Dictionary {
  func copy(_ values: [Key: Value]) -> [Key: Value] {
    merging(values) { _, new in new }
  }
}
