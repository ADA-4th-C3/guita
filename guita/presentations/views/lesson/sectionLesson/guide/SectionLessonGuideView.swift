//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct SectionLessonGuideView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    BaseView(
      create: { SectionLessonGuideViewModel() }
    ) { _, _ in
      GuideView(
        title: "곡 구간 학습",
        sections: [
          GuideSection(
            title: "코드 학습 개요",
            content: {
              Text("""
              곡 구간 학습은 제공하는 음성 안내를 통해 곡을 구간별로 학습할 수 있습니다.
              """)
            }
          ),
          GuideSection(
            title: "음성 명령어 사용법",
            content: {
              Text("""
              음성 명령을 통해 코드 학습 화면을 조작할 수 있으며, 사용할 수 있는 음성 명령은 총 3가지가 있습니다.

              첫 번째로 "다시" 또는 "재생"이라고 음성으로 명령하면 음성 안내를 다시 들을 수 있습니다.

              두 번째로 "다음"이라고 음성으로 명령하면 다음 학습 단계로 넘어갈 수 있습니다.

              세 번째로 "이전"이라고 음성으로 명령하면 이전 학습 단계로 되돌아갈 수 있습니다.
              """)
            }
          ),
        ]
      )
    }
  }
}

#Preview {
  BasePreview {
    SectionLessonGuideView()
  }
}
