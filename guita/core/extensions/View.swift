//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

extension View {
  @ViewBuilder
  func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content)
    -> some View
  {
    if condition {
      transform(self)
    } else {
      self
    }
  }
}
