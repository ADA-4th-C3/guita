//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordStringGuideView: View {
  let chord: Chord

  private let fretCount = 4
  private let stringCount = 6
  private let fretSpacing: CGFloat = 50
  private let stringSpacing: CGFloat = 40

  var body: some View {
    VStack(spacing: 20) {
      Text(chord.description)
        .font(.title2)
        .fontWeight(.semibold)

      ZStack {
        // 기타 프렛보드 그리기
        fretboardView

        // 손가락 위치 표시
        fingerPositionsView
      }
      .frame(width: CGFloat(fretCount) * fretSpacing + 40,
             height: CGFloat(stringCount - 1) * stringSpacing + 40)
    }
    .padding()
  }

  // 프렛보드 뷰
  private var fretboardView: some View {
    ZStack {
      // 가로 줄 (스트링) - 위에서 아래로 1번~6번
      ForEach(0 ..< stringCount, id: \.self) { string in
        Rectangle()
          .fill(Color.white)
          .frame(width: CGFloat(fretCount) * fretSpacing, height: 2)
          .offset(y: CGFloat(string) * stringSpacing - CGFloat(stringCount - 1) * stringSpacing / 2)
      }

      // 세로 줄 (프렛) - 왼쪽에서 오른쪽으로
      ForEach(0 ... fretCount, id: \.self) { fret in
        Rectangle()
          .fill(chord.frets.contains(fret) ? Color.yellow : Color.white)
          .frame(width: 2, height: CGFloat(stringCount - 1) * stringSpacing)
          .offset(x: CGFloat(fret) * fretSpacing - CGFloat(fretCount) * fretSpacing / 2)
      }

      // 프렛 번호 표시 (위쪽에)
      ForEach(1 ... fretCount, id: \.self) { fret in
        Text("\(fret)")
          .font(.caption)
          .foregroundColor(.gray)
          .offset(
            x: CGFloat(fret) * fretSpacing - CGFloat(fretCount) * fretSpacing / 2 - fretSpacing / 2,
            y: -CGFloat(stringCount - 1) * stringSpacing / 2 - 20
          )
      }

      // 스트링 번호 표시 (왼쪽에)
      ForEach(0 ..< stringCount, id: \.self) { string in
        Text("\(string + 1)")
          .font(.caption)
          .foregroundColor(.gray)
          .offset(
            x: -CGFloat(fretCount) * fretSpacing / 2 - 20,
            y: CGFloat(string) * stringSpacing - CGFloat(stringCount - 1) * stringSpacing / 2
          )
      }
    }
  }

  // 손가락 위치 표시 뷰
  private var fingerPositionsView: some View {
    ZStack {
      ForEach(Array(chord.coordinates.enumerated()), id: \.offset) { _, coordinate in
        let positions = coordinate.0
        let finger = coordinate.1

        // 연속된 스트링 그룹으로 나누기
        let groups = groupConsecutiveStrings(positions)

        ForEach(Array(groups.enumerated()), id: \.offset) { _, group in
          if group.count == 1 {
            // 단일 위치는 동그라미로 표시
            let position = group.first!
            Circle()
              .fill(fingerColor(finger))
              .frame(width: 25, height: 25)
              .overlay(
                Text("\(finger)")
                  .foregroundColor(.white)
                  .font(.caption)
                  .fontWeight(.bold)
              )
              .offset(
                x: CGFloat(position.fret) * fretSpacing - CGFloat(fretCount) * fretSpacing / 2 - fretSpacing / 2,
                y: CGFloat(position.string - 1) * stringSpacing - CGFloat(stringCount - 1) * stringSpacing / 2
              )
          } else {
            // 연속된 스트링들은 라인으로 표시
            let minString = group.map { $0.string }.min() ?? 1
            let maxString = group.map { $0.string }.max() ?? 1
            let fret = group.first?.fret ?? 1

            let startY = CGFloat(minString - 1) * stringSpacing - CGFloat(stringCount - 1) * stringSpacing / 2
            let endY = CGFloat(maxString - 1) * stringSpacing - CGFloat(stringCount - 1) * stringSpacing / 2
            let x = CGFloat(fret) * fretSpacing - CGFloat(fretCount) * fretSpacing / 2 - fretSpacing / 2

            // 바레 라인
            Rectangle()
              .fill(fingerColor(finger))
              .frame(width: 8, height: endY - startY + 25)
              .offset(x: x, y: (startY + endY) / 2)

            // 손가락 번호 표시
            Text("\(finger)")
              .foregroundColor(.white)
              .font(.caption)
              .fontWeight(.bold)
              .offset(x: x, y: (startY + endY) / 2)
          }
        }
      }
    }
  }

  // 연속된 스트링들을 그룹으로 나누는 함수
  private func groupConsecutiveStrings(_ positions: [(fret: Int, string: Int)]) -> [[(fret: Int, string: Int)]] {
    let sortedPositions = positions.sorted { $0.string < $1.string }
    var groups: [[(fret: Int, string: Int)]] = []
    var currentGroup: [(fret: Int, string: Int)] = []

    for position in sortedPositions {
      if currentGroup.isEmpty {
        currentGroup.append(position)
      } else {
        let lastString = currentGroup.last!.string
        if position.string == lastString + 1 {
          // 연속된 스트링
          currentGroup.append(position)
        } else {
          // 연속되지 않음, 새 그룹 시작
          groups.append(currentGroup)
          currentGroup = [position]
        }
      }
    }

    if !currentGroup.isEmpty {
      groups.append(currentGroup)
    }

    return groups
  }

  // 손가락 번호에 따른 색상 반환
  private func fingerColor(_ finger: Int) -> Color {
    switch finger {
    case 1: return .red
    case 2: return .blue
    case 3: return .green
    case 4: return .orange
    case 5: return .purple
    default: return .gray
    }
  }
}

#Preview {
  VStack(spacing: 30) {
    ChordStringGuideView(chord: .Cm)
    ChordStringGuideView(chord: .F)
  }
}
