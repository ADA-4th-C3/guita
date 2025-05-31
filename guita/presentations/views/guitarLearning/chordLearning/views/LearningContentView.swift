//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 코드 학습 단계별 콘텐츠를 표시하는 컴포넌트
/// 3-5단계의 학습 안내 텍스트를 담당
struct LearningContentView: View {
  
  // MARK: - Properties
  
  let instruction: String             // 표시할 안내 문구
  let chord: Chord             // 학습 중인 코드 타입
  
  // MARK: - Body
  
  var body: some View {
    VStack(spacing: 24) {
      // 안내 문구
      instructionText
      
      // 추가 시각적 힌트 (필요시)
      if !instruction.isEmpty {
        visualHint
      }
    }
  }
  
  // MARK: - Instruction Text
  
  /// 메인 안내 문구
  private var instructionText: some View {
    Text(instruction)
      .font(.title2)
      .fontWeight(.medium)
      .foregroundColor(.white)
      .multilineTextAlignment(.center)
      .lineLimit(nil)
      .lineSpacing(4)
      .fixedSize(horizontal: false, vertical: true)
  }
  
  // MARK: - Visual Hint
  
  /// 시각적 힌트 (코드 이름 강조)
  private var visualHint: some View {
    VStack(spacing: 12) {
      Text("연습할 코드")
        .font(.caption)
        .foregroundColor(.gray)
      
      Text(chord.rawValue)
        .font(.largeTitle)
        .fontWeight(.bold)
        .foregroundColor(.yellow)
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
        )
    }
    .padding(.top, 16)
  }
}

/// 학습 완료를 표시하는 컴포넌트
struct CompletionView: View {
  
  // MARK: - Properties
  
  let chord: Chord
  
  // MARK: - Body
  
  var body: some View {
    VStack(spacing: 24) {
      // 완료 이모지
      Text("🎉")
        .font(.system(size: 60))
      
      // 완료 메시지
      Text("\(chord)코드 학습이\n종료되었습니다.")
        .font(.title2)
        .fontWeight(.medium)
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
        .lineSpacing(4)
      
      // 성취 표시
      achievementBadge
    }
  }
  
  // MARK: - Achievement Badge
  
  /// 성취 배지
  private var achievementBadge: some View {
    VStack(spacing: 8) {
      Text("완료!")
        .font(.headline)
        .fontWeight(.bold)
        .foregroundColor(.black)
      
      Text("\(chord) 코드")
        .font(.caption)
        .foregroundColor(.black.opacity(0.7))
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(Color.yellow)
    .cornerRadius(12)
  }
}

// MARK: - Preview

#Preview {
  VStack(spacing: 40) {
    // 학습 콘텐츠 프리뷰
    LearningContentView(
      instruction: "검지를 2번 프렛\n4번 줄에 올리고\n해당 줄을 한번 쳐보세요.",
      chord: .A
    )
    
    Divider()
    
    // 완료 화면 프리뷰
    CompletionView(chord: .A)
  }
  .padding()
  .background(Color.black)
}
