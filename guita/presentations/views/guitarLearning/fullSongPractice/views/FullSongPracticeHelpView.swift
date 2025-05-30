//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 곡 전체 학습 도움말 화면
struct FullSongPracticeHelpView: View {
  @EnvironmentObject var router: Router
  
  var body: some View {
    VStack(spacing: 0) {
      // 툴바
      Toolbar(title: "곡 전체 학습 도움말")
      
      ScrollView {
        VStack(alignment: .leading, spacing: 24) {
          // 전체 학습 소개
          fullSongIntroSection
          
          // 기능 설명
          featureDescriptionSection
          
          // 학습 단계
          learningStepsSection
          
          Spacer(minLength: 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
      }
    }
    .background(Color.black)
  }
  
  private var fullSongIntroSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("곡 전체 학습이란?")
        .font(.headline)
        .foregroundColor(.white)
      
      Text("완전한 음악 파일과 함께 곡 전체를 연주하며 실전 연주 능력을 기르는 학습 방법입니다.")
        .foregroundColor(.gray)
        .fixedSize(horizontal: false, vertical: true)
    }
  }
  
  private var featureDescriptionSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("주요 기능")
        .font(.headline)
        .foregroundColor(.white)
      
      featureCard("재생/일시정지", "음악 파일의 재생을 제어할 수 있습니다")
      featureCard("재생 속도 조절", "0.5X ~ 1.5X 속도로 조절하여 연습할 수 있습니다")
      featureCard("구간 반복", "특정 구간을 반복하여 집중 연습할 수 있습니다")
      featureCard("진행바 조작", "원하는 위치로 이동하여 연습할 수 있습니다")
    }
  }
  
  private func featureCard(_ title: String, _ description: String) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title)
        .font(.subheadline)
        .fontWeight(.semibold)
        .foregroundColor(.yellow)
      
      Text(description)
        .font(.caption)
        .foregroundColor(.gray)
    }
    .padding(12)
    .background(Color.gray.opacity(0.1))
    .cornerRadius(8)
  }
  
  private var learningStepsSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("학습 단계")
        .font(.headline)
        .foregroundColor(.white)
      
      VStack(alignment: .leading, spacing: 8) {
        learningStep("1단계", "느린 속도로 코드 변경에 집중하여 연습")
        learningStep("2단계", "정상 속도로 리듬에 맞춰 연주")
        learningStep("3단계", "빠른 속도로 도전하여 실력 향상")
        learningStep("완성", "원곡과 함께 완벽한 연주 구현")
      }
    }
  }
  
  private func learningStep(_ stage: String, _ description: String) -> some View {
    HStack(alignment: .top, spacing: 12) {
      Text(stage)
        .font(.caption)
        .fontWeight(.bold)
        .foregroundColor(.yellow)
        .frame(width: 40, alignment: .leading)
      
      Text(description)
        .foregroundColor(.gray)
        .font(.caption)
        .fixedSize(horizontal: false, vertical: true)
      
      Spacer()
    }
  }
}
