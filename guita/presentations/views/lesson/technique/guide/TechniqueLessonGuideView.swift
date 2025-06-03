//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct TechniqueLessonGuideView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    BaseView(
      create: { TechniqueLessonGuideViewModel() }
    ) { viewModel, _ in
      GuideView(
        title: "주법 학습",
        sections: [
          GuideSection(
            title: "주법 학습 개요",
            content: {
              Text("""
              주법 학습 화면에선 줄을 위아래로 튕겨서 소리를 내는 방법을 음성 안내를 통해 학습할 수 있습니다.
              """)
            }
          ),
          GuideSection(
            title: "음성 학습 안내",
            content: {
              Text("""
              음성 명령을 통해 주법 학습 화면을 조작할 수 있으며, 사용할 수 있는 음성 명령은 총 3가지가 있습니다.

              첫 번째로 "다시" 또는 "재생"이라고 음성으로 명령하면 음성 안내를 다시 들을 수 있습니다.

              두 번째로 "다음"이라고 음성으로 명령하면 다음 학습 단계로 넘어갈 수 있습니다.

              세 번째로 "이전"이라고 음성으로 명령하면 이전 학습 단계로 되돌아갈 수 있습니다.
              """)
            }
          ),
          GuideSection(
            title: "주법 학습 화면 효과음 안내",
            content: {
              VStack(alignment: .leading, spacing: 25.2) {
                Text("""
                주법 학습 화면에선 다음 학습 단계로 넘어갈 때 페이지가 넘어가는 효과음이 실행됩니다.
                """)

                Button(action: { viewModel.playSound(.next) }) {
                  Text("페이지 전환 효과음 재생 ▶")
                }
              }
            }
          ),
        ]
      )
    }
  }
}

#Preview {
  BasePreview {
    TechniqueLessonGuideView()
  }
}
