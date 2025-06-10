//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct FullLessonGuideView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    BaseView(
      create: { FullLessonGuideViewModel() }
    ) { viewModel, _ in
      GuideView(
        title: NSLocalizedString("곡 전체 학습", comment: ""),
        sections: [
          GuideSection(
            title: NSLocalizedString("곡 전체 학습 개요", comment: ""),
            content: {
              Text("""
              곡 전체 학습은 제공하는 음성 안내를 통해 곡을 구간별로 학습할 수 있습니다.
              """)
            }
          ),
          GuideSection(
            title: NSLocalizedString("음성 명령어 사용법", comment: ""),
            content: {
              Text("""
              음성 명령을 통해 코드 학습 화면을 조작할 수 있으며, 사용할 수 있는 음성 명령은 총 5가지가 있습니다.

              첫 번째로 "재생"이라고 음성으로 명령하면 곡을 재생할 수 있습니다.

              두 번째로 "정지"이라고 음성으로 명령하면 곡 재생을 멈출 수 있습니다.

              세 번째로 "다시"이라고 음성으로 명령하면 곡을 처음부터 재생할 수 있습니다.

              네 번째로 "느리게"이라고 음성으로 명령하면 곡을 느리게 재생할 수 있습니다.

              다섯 번째로 "빠르게"이라고 음성으로 명령하면 곡을 빠르게 재생할 수 있습니다.
              
              음성 명령어를 사용하기 위해선 마이크 사용 권한과 음성 인식 권한이 필요합니다.
              """)
            }
          ),
          GuideSection(
            title: NSLocalizedString("재생 위치 조절 방법", comment: ""),
            content: {
              Text("""
              음원 재생 구간을 조절하고 싶으면 슬라이더가 선택된 상태에서 한손가락으로 원하는 쪽으로 밀면 값이 증가하고, 아래로 쓸어내리면 값이 감소합니다.

              이러한 제스쳐를 통해 재생 위치를 10%씩 이동시킬 수 있습니다.
              """)
            }
          ),
          GuideSection(
            title: NSLocalizedString("속도 조절 방법", comment: ""),
            content: {
              Text("""
              속도 조절 버튼을 통해 재생되는 안내 음성과 멜로디의 속도를 조절할 수 있습니다.

              한 손가락으로 화면을 좌우로 쓸어내리며 원하는 버튼을 선택할 수 있습니다.

              속도 조절은 느리게, 빠르게로 조절 가능합니다.
              """)   
            }
          )
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
