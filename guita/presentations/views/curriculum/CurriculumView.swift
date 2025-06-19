//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct CurriculumView: View {
  var body: some View {
    @EnvironmentObject var router: Router
    BaseView(
      create: { CurriculumViewModel() }
    ) { viewModel, _ in
      VStack {
        Toolbar(
          title: NSLocalizedString("Curriculum.title", comment: ""),
          accessibilityHint: NSLocalizedString("Curriculum.Hint", comment: "")
        )
        ListDivider()
          .padding(.top, 32)
        Spacer()
        ScrollView {
          LazyVStack(alignment: .leading, spacing: 8) {
            ForEach(viewModel.state) { item in
              CurriculumItemCell(songInfo: item)
              ListDivider()
            }
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    CurriculumView()
  }
}
