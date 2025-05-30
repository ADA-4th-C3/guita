//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct CurriculumView: View {
  var body: some View {
    BaseView(
      create: { CurriculumViewModel() }
    ) { _, _ in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "Curriculum")
        Spacer()
      }
    }
  }
}

#Preview {
  BasePreview {
    CurriculumView()
  }
}
