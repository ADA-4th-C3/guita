//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct PitchClassificationView: View {
  var body: some View {
    BaseView(
      create: { PitchClassificationViewModel() }
    ) { viewModel, state in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "Pitch Classification")
        Spacer()
      }
    }
  }
}

#Preview {
  BasePreview {
    PitchClassificationView()
  }
}
