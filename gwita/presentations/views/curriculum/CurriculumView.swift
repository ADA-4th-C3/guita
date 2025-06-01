//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct CurriculumView: View {
  var body: some View {
    @EnvironmentObject var router: Router
    BaseView(
      create: { CurriculumViewModel() }
    ) { viewModel, _ in
      VStack {
        CustomToolbar(title: "학습 목록", onBack: {
          router.pop()
        }, showInfo: false)

        Spacer()
        ScrollView {
          LazyVStack(alignment: .leading, spacing: 8) {
            ForEach(viewModel.state) { item in
              CurriculumItemCell(item: item)
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
