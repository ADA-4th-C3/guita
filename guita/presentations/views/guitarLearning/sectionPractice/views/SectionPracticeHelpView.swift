//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 곡 구간 학습 도움말 화면
struct SectionPracticeHelpView: View {
  @EnvironmentObject var router: Router
  
  var body: some View {
    VStack(spacing: 0) {
      // 툴바
      Toolbar(title: "곡 구간 학습 도움말")
      
      ScrollView {
        VStack(alignment: .leading, spacing: 24) {
          // 구간 학습 소개
          sectionIntroSection
          
          // 사용법 안내
          usageGuideSection
          
          // 연습 팁
          practiceTipsSection
          
          Spacer(minLength: 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
      }
    }
    .background(Color.black)
  }
  
  private var sectionIntroSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("곡 구간 학습이란?")
        .font(.headline)
        .foregroundColor(.white)
      
      Text("곡을 여러 구간으로 나누어 각 구간의 코드 진행을 집중적으로 연습하는 방법입니다.")
        .foregroundColor(.gray)
        .fixedSize(horizontal: false, vertical: true)
    }
  }
  
  private var usageGuideSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("사용법")
        .font(.headline)
        .foregroundColor(.white)
      
      VStack(alignment: .leading, spacing: 8) {
        usageStep("1. 화면에 표시되는 코드 진행을 확인하세요")
        usageStep("2. 현재 연주해야 할 코드가 노란색으로 표시됩니다")
        usageStep("3. 마이크가 코드를 인식하면 다음 코드로 진행됩니다")
        usageStep("4. 재생 속도를 조절하여 연습할 수 있습니다")
      }
    }
  }
  
  private func usageStep(_ step: String) -> some View {
    HStack(alignment: .top) {
      Text("▶")
        .foregroundColor(.yellow)
        .font(.caption)
      
      Text(step)
        .foregroundColor(.gray)
        .font(.caption)
        .fixedSize(horizontal: false, vertical: true)
      
      Spacer()
    }
  }
  
  private var practiceTipsSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("연습 팁")
        .font(.headline)
        .foregroundColor(.white)
      
      VStack(alignment: .leading, spacing: 8) {
        tipItem("느린 속도부터 시작하여 점진적으로 빠르게 연습하세요")
        tipItem("코드 변경 시 손목과 손가락의 움직임에 집중하세요")
        tipItem("정확한 코드 연주가 속도보다 중요합니다")
        tipItem("반복 연습을 통해 근육 기억을 만드세요")
      }
    }
  }
  
  private func tipItem(_ tip: String) -> some View {
    HStack(alignment: .top) {
      Text("💡")
        .font(.caption)
      
      Text(tip)
        .foregroundColor(.gray)
        .font(.caption)
        .fixedSize(horizontal: false, vertical: true)
      
      Spacer()
    }
  }
}
