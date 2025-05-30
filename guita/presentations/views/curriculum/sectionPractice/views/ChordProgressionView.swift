//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 코드 진행을 시각적으로 표시하는 컴포넌트
/// 현재 연주 중인 코드를 하이라이트하고 진행 상태를 보여줌
struct ChordProgressionView: View {
  
  // MARK: - Properties
  
  let chords: [String]           // 코드 진행 배열
  let currentChordIndex: Int     // 현재 연주 중인 코드 인덱스
  
  // MARK: - Body
  
  var body: some View {
    VStack(spacing: 24) {
      // 코드 진행 타임라인
      chordProgressionTimeline
      
      // 현재 코드 강조 표시
      currentChordHighlight
    }
  }
  
  // MARK: - Chord Progression Timeline
  
  /// 코드 진행을 수평으로 표시하는 타임라인
  private var chordProgressionTimeline: some View {
    HStack(spacing: 0) {
      ForEach(Array(chords.enumerated()), id: \.offset) { index, chord in
        HStack(spacing: 0) {
          // 코드 표시
          chordItem(chord: chord, index: index)
          
          // 연결선 (마지막 코드가 아닌 경우)
          if index < chords.count - 1 {
            connectionLine(index: index)
          }
        }
        .frame(maxWidth: .infinity)
      }
    }
    .padding(.horizontal, 20)
  }
  
  /// 개별 코드 아이템
  private func chordItem(chord: String, index: Int) -> some View {
    VStack(spacing: 8) {
      // 코드명
      Text(chord)
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(chordTextColor(for: index))
        .scaleEffect(index == currentChordIndex ? 1.2 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentChordIndex)
      
      // 진행 인디케이터 점
      Circle()
        .frame(width: 8, height: 8)
        .foregroundColor(progressIndicatorColor(for: index))
        .scaleEffect(index == currentChordIndex ? 1.5 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentChordIndex)
    }
  }
  
  /// 코드 간 연결선
  private func connectionLine(index: Int) -> some View {
    Rectangle()
      .frame(height: 2)
      .foregroundColor(connectionLineColor(for: index))
      .frame(maxWidth: .infinity)
      .animation(.easeInOut(duration: 0.3), value: currentChordIndex)
  }
  
  // MARK: - Current Chord Highlight
  
  /// 현재 코드를 크게 강조 표시
  private var currentChordHighlight: some View {
    VStack(spacing: 12) {
      Text("현재 코드")
        .font(.caption)
        .foregroundColor(.gray)
      
      Text(currentChord)
        .font(.system(size: 48, weight: .bold, design: .rounded))
        .foregroundColor(.yellow)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(
          RoundedRectangle(cornerRadius: 16)
            .fill(Color.yellow.opacity(0.1))
            .overlay(
              RoundedRectangle(cornerRadius: 16)
                .stroke(Color.yellow.opacity(0.3), lineWidth: 2)
            )
        )
        .transition(.scale.combined(with: .opacity))
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentChord)
    }
  }
  
  // MARK: - Computed Properties
  
  /// 현재 연주 중인 코드
  private var currentChord: String {
    guard currentChordIndex < chords.count else { return "" }
    return chords[currentChordIndex]
  }
  
  /// 코드 텍스트 색상
  private func chordTextColor(for index: Int) -> Color {
    switch index {
    case currentChordIndex:
      return .yellow
    case let i where i < currentChordIndex:
      return .white.opacity(0.6)
    default:
      return .white.opacity(0.4)
    }
  }
  
  /// 진행 인디케이터 색상
  private func progressIndicatorColor(for index: Int) -> Color {
    switch index {
    case currentChordIndex:
      return .yellow
    case let i where i < currentChordIndex:
      return .green
    default:
      return .gray
    }
  }
  
  /// 연결선 색상
  private func connectionLineColor(for index: Int) -> Color {
    return index < currentChordIndex ? .green : .gray.opacity(0.3)
  }
}

// MARK: - Preview

#Preview {
  VStack(spacing: 40) {
    // 첫 번째 코드 진행
    ChordProgressionView(
      chords: ["A", "A", "E", "E"],
      currentChordIndex: 0
    )
    
    // 중간 진행
    ChordProgressionView(
      chords: ["A", "A", "E", "E"],
      currentChordIndex: 2
    )
    
    // 마지막 코드
    ChordProgressionView(
      chords: ["A", "A", "E", "E"],
      currentChordIndex: 3
    )
  }
  .padding()
  .background(Color.black)
}
