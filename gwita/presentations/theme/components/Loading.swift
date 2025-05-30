//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct Loading: View {
  var body: some View {
    ProgressView()
      .progressViewStyle(CircularProgressViewStyle())
      .tint(.accentColor)
  }
}

#Preview {
  Loading()
}
