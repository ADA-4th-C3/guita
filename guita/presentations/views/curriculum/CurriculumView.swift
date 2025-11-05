//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct CurriculumView: View {
  @EnvironmentObject var router: Router

  @AccessibilityFocusState private var focusedItem: String?

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
              .accessibilityFocused($focusedItem, equals: "info")
          },
          secondTrailing: {
            IconButton("gearshape", isSystemImage: true) {
              router.push(.setting)
            }.accessibilityAddTraits(.isButton)
              .accessibilityHint("설정 화면으로 이동")
              .accessibilityFocused($focusedItem, equals: "setting")
          }
        )
        ListDivider()
        ScrollView {
          LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(viewModel.state) { songInfo in
              CurriculumItemCell(
                songInfo: songInfo,
                focusedItem: focusedItem
              )
              .accessibilityFocused($focusedItem, equals: songInfo.title)
              ListDivider()
            }
          }
        }
      }
      .onTapGesture {
        focusedItem = nil
      }
    }
  }
}

#Preview {
  BasePreview {
    CurriculumView()
  }
}
