//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct CurriculumView: View {
  @EnvironmentObject var router: Router

  @State private var selected: String? = nil

  var body: some View {
    BaseView(
      create: { CurriculumViewModel() }
    ) { viewModel, _ in
      VStack(spacing: 0) {
        Toolbar(
          title: NSLocalizedString("Curriculum.title", comment: ""),
          accessibilityHint: NSLocalizedString("Curriculum.Hint", comment: ""),
          firstTrailing: {
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
        ScrollView {
          LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(viewModel.state) { songInfo in
              CurriculumItemCell(songInfo: songInfo, selected: $selected)
              ListDivider()
            }
          }
        }
      }
      .onTapGesture {
        selected = nil
      }
    }
  }
}

#Preview {
  BasePreview {
    CurriculumView()
  }
}
