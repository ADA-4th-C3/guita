//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct TechniqueUserGuideView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    BaseView(
      create: { TechniqueUserGuideViewModel() }
    ) { _, _ in
      VStack {
        // Toolbar
        Toolbar(title: "도움말")

        ScrollView {
          VStack(alignment: .leading, spacing: 20) {
            // MARK: 주법 학습 도움말
            VStack(alignment: .leading) {
              Text("주법 학습")
                .font(.custom("KoddiUDOnGothic-Bold", size: 26))

              Divider()
                .frame(height: 2)
                .background(Color.yellow)

              Text("주법 학습은 제공하는 음성 안내를 통해 곡에 쓰이는 주법을 학습할 수 있습니다.\n\n이 화면은 사용자가 음성을 통해 조작할 수 있습니다.")
                .font(.custom("KoddiUDOnGothic-Regular", size: 18))

            }.padding(.bottom, 32)

            // MARK: 음성 학습 안내
            VStack(alignment: .leading, spacing: 20) {
              Text("음성 학습 안내")
                .font(.custom("KoddiUDOnGothic-Bold", size: 20))

              Divider()
                .frame(height: 2)
                .background(Color.yellow)

              Text("""
              음성 안내를 통해 주법을 단계 별로 학습하는데 도움을 줍니다.

              사용자가 음성으로 "다시" 라고 명령하면 음성 안내를 다시 들을 수 있습니다.

              사용자가 음성으로 "다음"이라고 명령하면 다음 학습 단계로 넘어갈 수 있습니다.

              사용자가 음성으로 "이전"이라고 명령하면 이전 학습 단계로 되돌아갈 수 있습니다.
              """)
              .font(.custom("KoddiUDOnGothic-Regular", size: 18))
            }
            .padding(.bottom, 32)

            // MARK: 조작 버튼 안내
            VStack(alignment: .leading, spacing: 20) {
              Text("조작 버튼")
                .font(.custom("KoddiUDOnGothic-Bold", size: 20))

              Divider()
                .frame(height: 2)
                .background(Color.yellow)

              Text("""
              사용자가 음성으로 제어가 힘든 경우 조작 버튼으로 학습을 진행할 수 있습니다.

              한 손가락으로 화면 좌우를 스와이프하여 원하는 버튼을 선택할 수 있습니다.

              다음 버튼을 누르면 다음 학습 단계로 넘어갈 수 있습니다.

              다시 듣기 버튼을 누르면 방금 들었던 학습 안내 음성을 다시 들을 수 있습니다.

              학습 학습 마지막 단계에서는 다음 버튼이 비활성화가 됩니다.

              이전 버튼을 누르면 이전 학습 단계로 되돌아갈 수 있습니다.

              주법 학습 첫 단계에서는 이전 버튼이 비활성화 상태가 됩니다.
              """)
              .font(.custom("KoddiUDOnGothic-Regular", size: 18))
            }
          }
          .padding(.bottom, 32)
        }
        .padding(.horizontal, 20)
      }
    }
  }
}

#Preview {
  BasePreview {
    TechniqueUserGuideView()
  }
}
