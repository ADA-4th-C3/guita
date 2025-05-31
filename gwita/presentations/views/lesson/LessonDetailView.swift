//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct LessonDetailView: View {
  let item: CurriculumViewState
  var body: some View {
    BaseView(
      create: { LessonDetailViewModel(item: item) }
    ) { _, _ in
      VStack {
        // MARK: Toolbar
        Toolbar(title: item.level)
        Spacer()
      }
    }
  }
}
