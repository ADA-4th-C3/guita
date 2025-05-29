//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 레슨 목록에서 사용되는 개별 레슨 행 컴포넌트
/// 레슨 정보를 표시하고 탭 액션을 처리
struct LessonRowView: View {
  
  // MARK: - Properties
  
  let lesson: LessonModel         // 표시할 레슨 데이터
  let onTap: () -> Void          // 탭 액션 핸들러
  
  // MARK: - Body
  
  var body: some View {
    Button(action: onTap) {
      HStack(spacing: 16) {
        // 레슨 정보 섹션
        lessonInfoSection
        
        Spacer()
        
        // 코드 태그 섹션
        codeTagsSection
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
      .background(backgroundStyle)
      .disabled(!lesson.isUnlocked)
      .opacity(lesson.isUnlocked ? 1.0 : 0.5)
    }
    .buttonStyle(PlainButtonStyle())
    .overlay(bottomDivider, alignment: .bottom)
  }
  
  // MARK: - Private Views
  
  /// 레슨 정보 섹션 (제목, 부제목)
  private var lessonInfoSection: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(lesson.title)
        .font(.headline)
        .fontWeight(.medium)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Text(lesson.subtitle)
        .font(.caption)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
  
  /// 코드 태그들 섹션
  private var codeTagsSection: some View {
    HStack(spacing: 6) {
      ForEach(lesson.codes, id: \.self) { code in
        codeTag(code)
      }
    }
  }
  
  /// 개별 코드 태그
  private func codeTag(_ code: String) -> some View {
    Text(code)
      .font(.caption)
      .fontWeight(.medium)
      .foregroundColor(.black)
      .padding(.horizontal, 6)
      .padding(.vertical, 2)
      .background(Color.white)
      .cornerRadius(3)
  }
  
  /// 배경 스타일 (완료된 레슨은 하이라이트)
  private var backgroundStyle: Color {
    lesson.isCompleted ? Color.yellow.opacity(0.1) : Color.clear
  }
  
  /// 하단 구분선
  private var bottomDivider: some View {
    Rectangle()
      .frame(height: 1)
      .foregroundColor(.gray.opacity(0.2))
  }
}

// MARK: - Preview

#Preview {
  VStack(spacing: 0) {
    LessonRowView(
      lesson: LessonModel(
        id: "1",
        title: "[초급1] 여행을 떠나요",
        subtitle: "A B7 E",
        codes: ["A", "E", "B7"],
        isUnlocked: true,
        isCompleted: true,
        codeType: .a,
        difficulty: .beginner
      )
    ) {
      print("레슨 선택됨")
    }
    
    LessonRowView(
      lesson: LessonModel(
        id: "2",
        title: "[초급2] 바람이 불어오는 곳",
        subtitle: "G C D",
        codes: ["G", "C", "D"],
        isUnlocked: false,
        isCompleted: false,
        codeType: .g,
        difficulty: .beginner
      )
    ) {
      print("잠금된 레슨")
    }
  }
  .background(Color.black)
}
