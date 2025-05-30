//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 학습 옵션을 선택하는 버튼 컴포넌트
/// 기타 학습 메인 화면에서 사용되며, 하이라이트 기능을 지원
struct LearningOptionButton: View {
  
  // MARK: - Properties
  
  let title: String           // 버튼 제목
  let subtitle: String        // 버튼 부제목
  let isHighlighted: Bool     // 하이라이트 여부 (노란색 배경)
  let action: () -> Void      // 탭 액션
  
  // MARK: - Initializer
  
  init(
    title: String,
    subtitle: String,
    isHighlighted: Bool = false,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.subtitle = subtitle
    self.isHighlighted = isHighlighted
    self.action = action
  }
  
  // MARK: - Body
  
  var body: some View {
    Button(action: action) {
      VStack(spacing: 8) {
        // 제목
        Text(title)
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(titleColor)
        
        // 부제목
        Text(subtitle)
          .font(.caption)
          .foregroundColor(subtitleColor)
          .multilineTextAlignment(.center)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 16)
      .background(backgroundColor)
      .overlay(borderOverlay)
    }
    .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일 제거
  }
  
  // MARK: - Private Computed Properties
  
  /// 제목 텍스트 색상
  private var titleColor: Color {
    isHighlighted ? .black : .white
  }
  
  /// 부제목 텍스트 색상
  private var subtitleColor: Color {
    isHighlighted ? .black.opacity(0.7) : .white.opacity(0.7)
  }
  
  /// 배경색
  private var backgroundColor: some View {
    RoundedRectangle(cornerRadius: 12)
      .fill(isHighlighted ? Color.yellow : Color.gray.opacity(0.2))
  }
  
  /// 테두리 오버레이
  private var borderOverlay: some View {
    RoundedRectangle(cornerRadius: 12)
      .stroke(
        isHighlighted ? Color.clear : Color.gray.opacity(0.3),
        lineWidth: 1
      )
  }
}

// MARK: - Preview

#Preview {
  VStack(spacing: 16) {
    LearningOptionButton(
      title: "코드 학습",
      subtitle: "기본 코드를 배워보세요",
      isHighlighted: true
    ) {
      print("코드 학습 선택")
    }
    
    LearningOptionButton(
      title: "주법 학습",
      subtitle: "다양한 연주 기법을 익혀보세요"
    ) {
      print("주법 학습 선택")
    }
  }
  .padding()
  .background(Color.black)
}
