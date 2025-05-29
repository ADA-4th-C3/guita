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
          
          // 학습 옵션 버튼들
          VStack(spacing: 16) {
            LearningOptionButton(
              title: "코드 학습",
              subtitle: "기본 코드를 배워보세요",
              isHighlighted: true
            ) {
              router.push(.codeLearningList)
            }
            
            LearningOptionButton(
              title: "주법 학습",
              subtitle: "다양한 연주 기법을 익혀보세요"
            ) {
              router.push(.techniqueList)
            }
            
            LearningOptionButton(
              title: "곡 구간 학습",
              subtitle: "곡의 일부분을 집중 연습하세요"
            ) {
              router.push(.sectionPractice)
            }
            
            LearningOptionButton(
              title: "곡 전체 학습",
              subtitle: "완전한 곡을 연주해보세요"
            ) {
              router.push(.fullSongPractice)
            }
          }
          
          Spacer()
        }
        .padding(.horizontal, 24)
      }
      .background(Color.black)
    }
  }
}
