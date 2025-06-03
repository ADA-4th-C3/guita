//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct SectionLessonGuideView: View {
  @EnvironmentObject var router: Router

   var body: some View {
     VStack(spacing: 0) {
       // MARK: Toolbar
       Toolbar(title: "도움말")
         .padding(.bottom, 30)
       
       
       // MARK: Content
       ScrollView {
         VStack(alignment: .leading, spacing: 30) {
           
           GuideSection(
             title: "곡 구간 학습",
             titleSize: 26,
             contents: [
               "곡 구간 학습은 제공하는 음성 안내를 통해 곡을 구간별로 학습할 수 있습니다.",
               "이 화면은 사용자가 음성을 통해 조작할 수 있습니다."
             ]
           )
           
           GuideSection(
             title: "음성 학습 안내",
             titleSize: 20,
             contents: [
               "음성 안내와 곡 멜로디를 통해 곡을 단계별로 학습하는 데 도움을 줍니다.",
               "사용자가 음성으로 \"다시\"라고 명령하면 음성 안내를 다시 들을 수 있습니다.",
               "사용자가 음성으로 \"다음\"이라고 명령하면 다음 학습 단계로 넘어갈 수 있습니다.",
               "사용자가 음성으로 \"이전\"이라고 명령하면 이전 학습 단계로 되돌아갈 수 있습니다."
             ]
           )
           
           GuideSection(
             title: "조작 버튼",
             titleSize: 20,
             contents: [
               "사용자가 음성으로 제어가 힘든 경우 조작 버튼으로 학습을 진행할 수 있습니다.",
               "한 손가락으로 화면을 좌우로 쓸어넘기며 원하는 버튼을 선택할 수 있습니다.",
               "다음 버튼을 누르면 다음 학습 단계로 넘어갈 수 있습니다.",
               "다시 듣기 버튼을 누르면 방금 들었던 학습 안내 음성을 다시 들을 수 있습니다.",
               "곡 구간 학습 마지막 단계에서는 다음 버튼이 비활성화 상태가 됩니다.",
               "이전 버튼을 누르면 이전 학습 단계로 되돌아갈 수 있습니다.",
               "곡 구간 학습 첫 단계에서는 이전 버튼이 비활성화 상태가 됩니다."
             ]
           )
           
           GuideSection(
             title: "속도 조절 안내",
             titleSize: 20,
             contents: [
               "속도 조절 버튼을 통해 재생되는 안내 음성과 멜로디의 속도를 조절할 수 있습니다.",
               "한 손가락으로 화면을 좌우로 쓸어넘기며 원하는 버튼을 선택할 수 있습니다.",
               "속도 조절은 느리게, 빠르게로 조절 가능합니다."
             ]
           )
           
         }
         .padding(.horizontal, 20)
         .padding(.bottom, 32)
       }
     }
   }
}

#Preview {
  BasePreview {
    SectionLessonGuideView()
  }
}
