//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct BasePreview<Content: View>: View {
  let content: () -> Content

  var body: some View {
    content()
      .environmentObject(Router())
  }
}
