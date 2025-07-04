//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordLessonGuideView: View {
  var body: some View {
    BaseView(
      create: { ChordLessonGuideViewModel() }
    ) { viewModel, _ in
      GuideView(
        title: NSLocalizedString("코드 학습", comment: ""),
        sections: [
          GuideSection(
            title: NSLocalizedString("코드 학습 개요", comment: ""),
            content: {
              Text("""
              코드 학습 화면에선 코드를 잡는데 필요한 운지 방법을 음성 안내를 통해 학습할 수 있습니다.
              """)
            }
          ),
          GuideSection(
            title: NSLocalizedString("음성 명령어 사용법", comment: ""),
            content: {
              Text("""
              음성 명령을 통해 코드 학습 화면을 조작할 수 있으며, 사용할 수 있는 음성 명령은 총 3가지가 있습니다.

              첫 번째로 "다시" 또는 "재생"이라고 음성으로 명령하면 음성 안내를 다시 들을 수 있습니다.

              두 번째로 "다음"이라고 음성으로 명령하면 다음 학습 단계로 넘어갈 수 있습니다.

              세 번째로 "이전"이라고 음성으로 명령하면 이전 학습 단계로 되돌아갈 수 있습니다.

              음성 명령어를 사용하기 위해선 마이크 사용 권한과 음성 인식 권한이 필요합니다.
              """)
            }
          ),
          GuideSection(
            title: NSLocalizedString("코드 학습 진행 순서", comment: ""),
            content: {
              Text("""
              코드 학습은 다음과 같은 순서로 진행됩니다.

              첫 번째 단계에선, 선택한 코드를 잡는데 사용되는 전체 프렛의 번호와 필요한 손가락 개수를 알려드립니다.

              두 번째 단계에선, 낮은 프렛의 낮은 줄부터 한 손가락씩 코드를 잡는 과정이 진행됩니다. 이 단계에는 줄을 올바르게 잘 잡았는지 줄을 튕겨서 소리를 확인하는 과정이 포함되어 있으며, 코드를 잡는데 필요한 모든 손가락 잡을 때 까지 반복 진행됩니다. 

              세 번째 단계에선, 모든 손가락으로 잡은 뒤 모든 줄을 튕겨서 소리를 확인하는 과정이 진행됩니다.

              하나의 코드 학습이 끝나면 다음 코드 학습으로 넘어갑니다.
              """)
            }
          ),
          GuideSection(
            title: NSLocalizedString("손가락 번호 안내", comment: ""),
            content: {
              Text("""
              코드 학습에서 안내드리는 손가락 번호는 엄지, 검지, 중지, 약지, 소지 순서대로 첫 번째 두 번째, 세 번째, 네 번째, 다섯 번째로 부르고 있습니다.
              """)
            }
          ),
          GuideSection(
            title: NSLocalizedString("기타 줄 번호 안내", comment: ""),
            content: {
              Text("""
              기타는 총 여섯 개의 줄로 구성되어 있으며, 코드 학습시 사용하는 기타 줄 번호는 가장 아래쪽에 얇은 줄을 1번 줄로, 그 다음 윗 줄을 2번 줄로, 순서대로 올라가서 가장 위쪽에 두꺼운 줄을 6번 줄로 안내 드리고 있습니다.

              피크를 사용하지 않을 때 6, 5, 4번줄은 엄지 손가락으로 연주하고 3번 줄은 중지, 2번 줄은 약지, 1번 줄은 소지로 연주하는 것을 권장드립니다.
              """)
            }
          ),
          GuideSection(
            title: NSLocalizedString("프렛 안내", comment: ""),
            content: {
              Text("""
              코드 학습시 안내드리는 프렛에 대해 알려드리겠습니다.

              기타를 세로로 세웠을 때, 기타 목 부분에는 가로 방향으로 튀어나온 금속 막대들이 줄 아래에 배치되어 있습니다.

              이 막대들 사이의 공간을 프렛이라고 부릅니다. 이 금속 막대는 총 20개 있으며, 기타 몸통 쪽으로 올 수록 프렛 공간이 좁아지는 형태로 배치되어 있습니다.

              첫 번째 프렛은 기타를 세로로 세웠을 때 가장 위쪽에 첫 번째 금속 막대 위쪽의 공간을 말합니다.

              다음 두 번째 프렛은 첫 번째 프렛이 끝나는 금속 막대와 다음 금속 막대 사이의 공간을 말합니다.

              프렛의 위치는 엄지 손가락으로 가장 두꺼운 줄인 여섯 번째 줄 아래를 쓸거나 새끼 손가락으로 가장 얇은 줄인 첫 번째 줄 아래를 쓸어서 파악할 수 있습니다.
              """)
            }
          ),
          GuideSection(
            title: NSLocalizedString("코드 소리를 깔끔하게 연주하는 방법", comment: ""),
            content: {
              Text("""
              코드를 잡은 뒤 6번 줄부터 차례대로 한 줄씩 튕기며 어떤 줄의 소리가 제대로 안나는지 확인할 수 있습니다.

              만약 프렛을 잡지 않은 줄에서 소리가 안 나는 경우, 해당 줄의 위나 아래 줄을 잡은 손가락이 해당 줄에 간섭하여 소리가 안날 수 있습니다. 줄을 잡은 손가락이 다른 줄에 닿지 않도록 손끝으로 지판에 수직이 되도록 세워서 잡아보시기 바랍니다. 

              만약 프렛을 잡은 줄에서 소리가 안 나는 경우, 금속 막대 자체를 손가락으로 누르고 있는 경우 소리가 안날 수 있습니다. 특정 프렛을 잡을 때 손가락의 위치가 다음 프렛의 금속 막대에 가까울수록 적은 힘으로 깔끔한 소리를 얻을 수 있지만 금속 막대 자체를 누르진 않도록 프렛 내 손가락의 위치를 옮겨 보시기 바랍니다. 혹은 프렛을 너무 약하게 눌러서 소리가 나지 않을 수 있습니다.

              처음에는 소리가 안날 수 있으나 매일 연습하다 보면 점점 소리를 잘 내는 방법을 몸으로 체득하실 수 있습니다.
              """)
            }
          ),
          GuideSection(
            title: NSLocalizedString("효과음 안내", comment: ""),
            content: {
              VStack(alignment: .leading, spacing: 25.2) {
                Text("""
                코드 학습 화면에는 다양한 효과음이 준비되어 있습니다.

                첫 번째로 다음 학습 단계로 넘어갈 때 페이지가 넘어가는 효과음이 실행됩니다.
                """)

                Button(action: {
                  viewModel.playSound(.next)
                }) {
                  Text("페이지 전환 효과음 재생 ▶")
                }
                .accessibilityLabel("페이지 전환 효과음 재생")
                .accessibilityAddTraits([.isButton, .startsMediaSession])

                Button(action: {
                  viewModel.playSound(.answer)
                }) {
                  Text("올바른 소리 효과음 재생 ▶")
                }
                .accessibilityLabel("올바른 소리 효과음 재생")
                .accessibilityAddTraits([.isButton, .startsMediaSession])
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
    ChordLessonGuideView()
  }
}
