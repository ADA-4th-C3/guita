//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct FullLessonGuideView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    BaseView(
      create: { FullLessonGuideViewModel() }
    ) { _, _ in
      GuideView(
        title: "곡 전체 학습",
        sections: [
          GuideSection(
            title: "곡 전체 학습",
            content: {
              Text("""
              곡 전체 학습은 제공하는 음성 안내를 통해 곡을 구간별로 학습할 수 있습니다.

              이 화면은 사용자가 음성을 통해 조작할 수 있습니다.
              """)
            }
          ),
          GuideSection(
            title: "구간 조절 안내",
            content: {
              Text("""
              음원 재생 구간을 조절하고 싶으면 슬라이더가 선택된 상태에서 한손가락으로 원하는 쪽으로 밀면 값이 증가하고, 아래로 쓸어내리면 값이 감소합니다.

              이러한 제스쳐를 통해 재생 위치를 알뜰로 이동시킬 수 있습니다
              """)
            }
          ),
          GuideSection(
            title: "속도 조절 안내",
            content: {
              Text("""
              속도 조절 버튼을 통해 재생되는 안내 음성과 멜로디의 속도를 조절할 수 있습니다.

              한 손가락으로 화면을 좌우로 쓸어내리며 원하는 버튼을 선택할 수 있습니다.

              속도 조절은 느리게, 빠르게로 조절 가능합니다.
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
    FullLessonGuideView()
  }
}
