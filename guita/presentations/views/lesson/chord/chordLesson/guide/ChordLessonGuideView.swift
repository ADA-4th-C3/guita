//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordLessonGuideView: View {
  var body: some View {
    BaseView(
      create: { ChordLessonGuideViewModel() }
    ) { viewModel, state in
      GuideView(
        title: "코드 학습",
        description: """
        코드 학습은 제공하는 음성 안내를 통해 원하는 코드를 학습할 수 있습니다.
        
        이 화면은 사용자가 음성을 통해 조작할 수 있습니다.
        """,
        sections: [
          GuideSection(
            title: "음성 학습 안내",
            content: {
              Text("""
              음성 안내를 통해 코드를 단계별로 학습하는 데 도움을 줍니다.
              
              사용자가 음성으로 "다시" 또는 "재생"이라고 명령하면 음성 안내를 다시 들을 수 있습니다.
              
              사용자가 음성으로 "다음"이라고 명령하면 다음 학습 단계로 넘어갈 수 있습니다.
              
              사용자가 음성으로 "이전"이라고 명령하면 이전 학습 단계로 되돌아갈 수 있습니다.
              """)
            }
          ),
          GuideSection(
            title: "조작 버튼",
            content: {
              Text("""
              사용자가 음성으로 제어가 힘든 경우 조작 버튼으로 학습을 진행할 수 있습니다.
              
              한 손가락으로 화면을 좌우로 쓸어넘기며 원하는 버튼을 선택할 수 있습니다.
              
              다음 버튼을 누르면 다음 학습 단계로 넘어갈 수 있습니다.
              
              다시 듣기 버튼을 누르면 방금 들었던 학습 안내 음성을 다시 들을 수 있습니다.
              
              이전 버튼을 누르면 이전 학습 단계로 되돌아갈 수 있습니다.
              
              코드 학습 첫 단계에서는 이전 버튼이 비활성화 상태가 됩니다.
              """)
            }
          ),
          GuideSection(
            title: "음정 확인",
            content: {
              VStack(alignment: .leading, spacing: 25.2) {
                Text("""
                사용자가 기타를 쳤을 때 올바른 음정이 나는지 확인해줍니다.

                기타 음정이 올바른 경우 다음 소리가 납니다.
                """)
                
                Button(action: viewModel.playAnswerSound) {
                  Text("소리 듣기 ▶")
                }
                
                Text("음정이 계속 틀릴 경우 음성 안내를 통해 음정을 바로 잡는 팁을 알려드립니다.")
              }
            }
          )
        ]
      )
    }
  }
}

#Preview {
  BasePreview{
    ChordLessonGuideView()
  }
}
