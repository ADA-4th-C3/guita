//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct CurriculumView: View {
  var body: some View {
    @EnvironmentObject var router: Router
    BaseView(
      create: { CurriculumViewModel() }
    ) { viewModel, _ in
      VStack {
        Toolbar(title: "학습 목록", accessibilityText: "총 1개의 곡으로 이루어져 있습니다. 화면을 좌우로 쓸어넘기며 학습을 희망하는 곡을 선택해주십시오.")
        Divider()
        Spacer()
        ScrollView {
          LazyVStack(alignment: .leading, spacing: 8) {
            ForEach(viewModel.state) { item in
              CurriculumItemCell(songInfo: item)
              Divider()
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
