//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct CodeClassificationView: View {
  var body: some View {
    BaseView(
      create: { CodeClassificationViewModel() }
    ) { _, _ in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "Code Classification")
        Spacer()
      }
    }
  }
}

#Preview {
  BasePreview {
    CodeClassificationView()
  }
}
