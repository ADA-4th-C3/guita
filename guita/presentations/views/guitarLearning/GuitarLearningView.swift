//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 기타 학습 메인 화면 - 4개의 학습 옵션을 제공
struct GuitarLearningView: View {
  @EnvironmentObject var router: Router
  
  var body: some View {
    BaseView(
      create: { GuitarLearningViewModel() }
    ) { viewModel, state in
      VStack(spacing: 0) {
        // 상단 툴바
        Toolbar(title: "기타 학습")
        
        // 메인 콘텐츠
        VStack(spacing: 20) {
          Spacer()
          
          // 기타 아이콘
          Text("🎸")
            .font(.system(size: 80))
            .padding(.bottom, 20)
          
          // 제목
          Text("기타 학습")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.bottom, 40)
          
          // 곡 선택 버튼
          VStack(spacing: 16) {
            LearningOptionButton(
              title: "곡 선택하기",
              subtitle: "연습할 곡을 선택하고\n다양한 방법으로 학습해보세요",
              isHighlighted: true
            ) {
              router.push(.songList)
            }
            
            Spacer()
          }
          .padding(.horizontal, 24)
        }
        .background(Color.black)
      }
    }
  }
}
