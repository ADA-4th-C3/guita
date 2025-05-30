//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 주법 도움말 화면
struct TechniqueHelpView: View {
  @EnvironmentObject var router: Router
  
  var body: some View {
    VStack(spacing: 0) {
      // 툴바
      Toolbar(title: "주법 학습 도움말")
      
      ScrollView {
        VStack(alignment: .leading, spacing: 24) {
          // 주법 소개
          techniqueIntroSection
          
          // 주법별 설명
          techniqueDescriptionSection
          
          // 연습 방법
          practiceMethodSection
          
          Spacer(minLength: 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
      }
    }
    .background(Color.black)
  }
  
  private var techniqueIntroSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("주법 학습 소개")
        .font(.headline)
        .foregroundColor(.white)
      
      Text("다양한 기타 연주 기법을 배워 표현력 있는 연주를 할 수 있습니다.")
        .foregroundColor(.gray)
        .fixedSize(horizontal: false, vertical: true)
    }
  }
  
  private var techniqueDescriptionSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("주법 종류")
        .font(.headline)
        .foregroundColor(.white)
      
      techniqueCard("스트러밍", "코드를 위아래로 치는 기본 기법")
      techniqueCard("핑거피킹", "손가락으로 개별 줄을 뜯는 기법")
      techniqueCard("아르페지오", "코드 음을 순차적으로 연주하는 기법")
      techniqueCard("팜뮤팅", "손바닥으로 소리를 줄이는 기법")
    }
  }
  
  private func techniqueCard(_ title: String, _ description: String) -> some View {
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
  
  private var practiceMethodSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("연습 방법")
        .font(.headline)
        .foregroundColor(.white)
      
      VStack(alignment: .leading, spacing: 8) {
        practiceStep("1. 천천히 시작하여 정확한 동작을 익히세요")
        practiceStep("2. 메트로놈을 사용해 리듬감을 기르세요")
        practiceStep("3. 점진적으로 속도를 올려가세요")
        practiceStep("4. 다양한 코드 진행으로 연습하세요")
      }
    }
  }
  
  private func practiceStep(_ step: String) -> some View {
    HStack(alignment: .top) {
      Text("📝")
        .font(.caption)
      
      Text(step)
        .foregroundColor(.gray)
        .font(.caption)
        .fixedSize(horizontal: false, vertical: true)
      
      Spacer()
    }
  }
}
