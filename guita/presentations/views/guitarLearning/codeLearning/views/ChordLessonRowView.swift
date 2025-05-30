//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 코드 레슨 목록에서 사용되는 개별 코드 레슨 행 컴포넌트
/// 코드 레슨 정보를 표시하고 탭 액션을 처리
struct ChordLessonRowView: View {
  
  // MARK: - Properties
  
  let chordLesson: ChordLessonModel   // 표시할 코드 레슨 데이터
  let onTap: () -> Void              // 탭 액션 핸들러
  
  // MARK: - Body
  
  var body: some View {
    Button(action: onTap) {
      HStack(spacing: 16) {
        // 코드 아이콘
        chordIcon
        
        // 코드 레슨 정보 섹션
        chordLessonInfoSection
        
        Spacer()
        
        // 난이도 표시
        difficultyBadge
        
        // 상태 아이콘
        statusIcon
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
      .background(backgroundStyle)
      .disabled(!chordLesson.isUnlocked)
      .opacity(chordLesson.isUnlocked ? 1.0 : 0.5)
    }
    .buttonStyle(PlainButtonStyle())
    .overlay(bottomDivider, alignment: .bottom)
  }
  
  // MARK: - Private Views
  
  /// 코드 아이콘
  private var chordIcon: some View {
    Text(chordLesson.chordType.rawValue)
      .font(.title)
      .fontWeight(.bold)
      .foregroundColor(.yellow)
      .frame(width: 50, height: 50)
      .background(
        Circle()
          .fill(Color.yellow.opacity(0.1))
          .overlay(
            Circle()
              .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
          )
      )
  }
  
  /// 코드 레슨 정보 섹션 (제목, 설명)
  private var chordLessonInfoSection: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(chordLesson.title)
        .font(.headline)
        .fontWeight(.medium)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Text(chordLesson.description)
        .font(.caption)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(2)
      
      // 손가락 위치 요약
      fingerPositionSummary
    }
  }
  
  /// 손가락 위치 요약
  private var fingerPositionSummary: some View {
    HStack(spacing: 8) {
      // 손가락 개수
      Text("손가락 \(chordLesson.fingerPositions.count)개")
        .font(.caption2)
        .foregroundColor(.gray.opacity(0.8))
      
      // 프렛 범위
      if let minFret = chordLesson.fretPositions.filter({ $0 > 0 }).min(),
         let maxFret = chordLesson.fretPositions.max(),
         maxFret > 0 {
        Text("• \(minFret == maxFret ? "\(minFret)" : "\(minFret)-\(maxFret)")번 프렛")
          .font(.caption2)
          .foregroundColor(.gray.opacity(0.8))
      }
    }
  }
  
  /// 난이도 배지
  private var difficultyBadge: some View {
    Text(chordLesson.difficulty.displayName)
      .font(.caption)
      .fontWeight(.medium)
      .foregroundColor(.black)
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .background(difficultyColor)
      .cornerRadius(8)
  }
  
  /// 난이도별 색상
  private var difficultyColor: Color {
    switch chordLesson.difficulty {
    case .beginner: return .green
    case .intermediate: return .orange
    case .advanced: return .red
    }
  }
  
  /// 상태 아이콘
  private var statusIcon: some View {
    Group {
      if !chordLesson.isUnlocked {
        Image(systemName: "lock.fill")
          .foregroundColor(.gray)
      } else if chordLesson.isCompleted {
        Image(systemName: "checkmark.circle.fill")
          .foregroundColor(.green)
      } else {
        Image(systemName: "chevron.right")
          .foregroundColor(.gray)
      }
    }
    .font(.system(size: 16))
  }
  
  /// 배경 스타일 (완료된 레슨은 하이라이트)
  private var backgroundStyle: Color {
    chordLesson.isCompleted ? Color.yellow.opacity(0.1) : Color.clear
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
    ChordLessonRowView(
      chordLesson: ChordLessonModel(
        id: "chord_a",
        chordType: .a,
        fingerPositions: [
          FingerPosition(finger: .index, fret: 2, string: 4),
          FingerPosition(finger: .middle, fret: 2, string: 3),
          FingerPosition(finger: .ring, fret: 2, string: 2)
        ],
        fretPositions: [0, 0, 2, 2, 2, 0],
        difficulty: .beginner,
        isUnlocked: true,
        isCompleted: true
      )
    ) {
      print("A 코드 레슨 선택됨")
    }
    
    ChordLessonRowView(
      chordLesson: ChordLessonModel(
        id: "chord_f",
        chordType: .f,
        fingerPositions: [
          FingerPosition(finger: .index, fret: 1, string: 6),
          FingerPosition(finger: .middle, fret: 2, string: 3),
          FingerPosition(finger: .ring, fret: 3, string: 5),
          FingerPosition(finger: .pinky, fret: 3, string: 4)
        ],
        fretPositions: [1, 1, 2, 3, 3, 1],
        difficulty: .advanced,
        isUnlocked: false,
        isCompleted: false
      )
    ) {
      print("F 코드 레슨 (잠금)")
    }
  }
  .background(Color.black)
}
