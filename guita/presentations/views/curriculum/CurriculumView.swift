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
          ,firstTrailing: {
            IconButton("info") {
              router.push(.chordLessonGuide)
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel("사용법 도움말")
          },
          secondTrailing: {
            IconButton("gearshape", isSystemImage: true) {
              router.push(.setting)
            }.accessibilityAddTraits(.isButton)
              .accessibilityHint("설정 화면으로 이동")
          }
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
