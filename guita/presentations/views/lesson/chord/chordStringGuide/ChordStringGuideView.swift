//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordStringGuideView: View {
  let chord: Chord
  private let maxDisplayStep: Int?
  @Binding private var currentStep: Int?

  init(chord: Chord) {
    self.chord = chord
    maxDisplayStep = nil
    _currentStep = .constant(nil)
  }

  init(chord: Chord, maxDisplayStep: Int) {
    self.chord = chord
    self.maxDisplayStep = maxDisplayStep
    _currentStep = .constant(nil)
  }

  init(chord: Chord, currentStep: Binding<Int>) {
    self.chord = chord
    maxDisplayStep = nil
    _currentStep = Binding(
      get: { currentStep.wrappedValue },
      set: { currentStep.wrappedValue = $0 ?? 0 }
    )
  }

  init(chord: Chord, maxDisplayStep: Int? = nil, currentStep: Binding<Int?>? = nil) {
    self.chord = chord
    self.maxDisplayStep = maxDisplayStep
    _currentStep = currentStep ?? .constant(nil)
  }

  private let fretCount = 4
  private let stringCount = 6
  private let fretSpacing: CGFloat = 80
  private let stringSpacing: CGFloat = 50
  private let firstFretWidth: CGFloat = 20

  private var firstFretHeight: CGFloat {
    let height = CGFloat(stringCount - 1) * stringSpacing + 3
    let hasString1 = displayedCoordinates
      .flatMap { $0.0 }
      .contains { $0.string == 1 }
    let hasString6 = displayedCoordinates
      .flatMap { $0.0 }
      .contains { $0.string == 6 }

    if hasString1 || hasString6 {
      return height + 1
    }
    return height
  }

  private var displayedCoordinates: [([(fret: Int, string: Int)], finger: Int)] {
    if let step = currentStep {
      let clampedStep = max(0, min(step, chord.coordinates.count - 1))
      return Array(chord.coordinates.prefix(clampedStep + 1))
    } else if let maxStep = maxDisplayStep {
      let clampedStep = max(0, min(maxStep, chord.coordinates.count - 1))
      return Array(chord.coordinates.prefix(clampedStep + 1))
    } else {
      return chord.coordinates
    }
  }

  // 시작 프렛 (코드가 3프렛부터면 3)
  private var startFret: Int {
    if let minFret = chord.frets.min(), minFret >= 3 {
      return minFret
    }
    return 1
  }

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
      .frame(width: CGFloat(fretCount) * fretSpacing + 40, height: CGFloat(stringCount - 1) * stringSpacing + 40)
    }
    .padding()
    .accessibilityHidden(true)
  }

  // 프렛보드 뷰
  private var fretboardView: some View {
    ZStack {
      // 세로 줄 (프렛) - 왼쪽에서 오른쪽으로
      ForEach(1 ... fretCount - 1, id: \.self) { fret in
        Rectangle()
          .fill(.lightGrey)
          .frame(
            width: fret == 0 ? (startFret == 1 ? firstFretWidth : 6) : 6,
            height: CGFloat(stringCount - 1) * stringSpacing + 3
          )
          .offset(x: CGFloat(fret) * fretSpacing - CGFloat(fretCount) * fretSpacing / 2)
      }

      // 가로 줄 (스트링) - 위에서 아래로 1번~6번
      ForEach(0 ..< stringCount, id: \.self) { string in
        Rectangle()
          .fill(
            displayedCoordinates
              .flatMap { $0.0 }
              .contains(where: { $0.string == string + 1 }) ? .accent : .lightGrey
          )
          .frame(
            width: CGFloat(fretCount) * fretSpacing,
            height: displayedCoordinates
              .flatMap { $0.0 }
              .contains(where: { $0.string == string + 1 }) ? 4 : 3
          )
          .offset(
            y: CGFloat(string) * stringSpacing - CGFloat(stringCount - 1) * stringSpacing / 2
          )
      }

      Rectangle()
        .fill(.lightGrey)
        .frame(
          width: startFret == 1 ? firstFretWidth : 6,
          height: firstFretHeight
        )
        .offset(x: -CGFloat(fretCount) * fretSpacing / 2)

      // 스트링 번호 표시 (왼쪽에)
      ForEach(0 ..< stringCount, id: \.self) { string in
        Text("\(string + 1)")
          .fontKoddi(24, color: .white, weight: .bold)
          .offset(
            x: -CGFloat(fretCount) * fretSpacing / 2 - 20,
            y: CGFloat(string) * stringSpacing - CGFloat(stringCount - 1) * stringSpacing / 2
          )
          .padding(.trailing, 20)
      }

      // 시작 프렛 표기 (예: 3)
      if startFret > 1 {
        Text("\(startFret)")
          .fontKoddi(22, color: .black, weight: .bold)
          .padding(6)
          .background(.white, in: Circle())
          .offset(
            x: -CGFloat(fretCount) * fretSpacing / 2 + 6,
            y: CGFloat(stringCount - 1) * stringSpacing / 2 + stringSpacing / 2
          )
      }
    }
  }

  // 손가락 위치 표시 뷰
  private var fingerPositionsView: some View {
    ZStack {
      ForEach(Array(displayedCoordinates.enumerated()), id: \.offset) { _, coordinate in
        let positions = coordinate.0
        let finger = coordinate.1

        // 연속된 스트링 그룹으로 나누기
        let groups = groupConsecutiveStrings(positions)

        ForEach(Array(groups.enumerated()), id: \.offset) { _, group in
          if group.count == 1 {
            // 단일 위치는 동그라미로 표시
            let position = group.first!
            Circle()
              .fill(.accent)
              .frame(width: 40, height: 42)
              .overlay(
                Text(fingerLabel(finger))
                  .fontKoddi(24, color: .black, weight: .bold)
              )
              .offset(
                x: {
                  let visibleIndex = max(1, min(fretCount, position.fret - startFret + 1))
                  return CGFloat(visibleIndex) * fretSpacing - CGFloat(fretCount) * fretSpacing / 2 - fretSpacing / 2
                }(),
                y: CGFloat(position.string - 1) * stringSpacing - CGFloat(stringCount - 1) * stringSpacing / 2
              )
          } else {
            // 연속된 스트링들은 라인으로 표시
            let minString = group.map { $0.string }.min() ?? 1
            let maxString = group.map { $0.string }.max() ?? 1
            let fret = group.first?.fret ?? 1

            let startY = CGFloat(minString - 1) * stringSpacing - CGFloat(stringCount - 1) * stringSpacing / 2
            let endY = CGFloat(maxString - 1) * stringSpacing - CGFloat(stringCount - 1) * stringSpacing / 2
            let visibleIndex = max(1, min(fretCount, fret - startFret + 1))
            let x = CGFloat(visibleIndex) * fretSpacing - CGFloat(fretCount) * fretSpacing / 2 - fretSpacing / 2

            // 바레 라인
            RoundedRectangle(cornerSize: .init(width: 21, height: 21))
              .fill(.accent)
              .frame(width: 44, height: endY - startY + 25)
              .offset(x: x, y: (startY + endY) / 2)

            // 손가락 번호 표시
            Text("\(finger)")
              .fontKoddi(24, color: .black, weight: .bold)
              .offset(x: x, y: (startY + endY) / 2)
          }
        }
      }
    }
  }

  private func fingerLabel(_ finger: Int) -> String {
    [1: "엄", 2: "검", 3: "중", 4: "약", 5: "소"][finger] ?? "\(finger)"
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
}

#Preview {
  // 전체 코드 확인 Preview
//  ScrollView {
//    VStack(spacing: 30) {
//      ForEach(Chord.allCases, id: \.self) { chord in
//        ChordStringGuideView(chord: chord)
//      }
//    }
//  }
  @Previewable @State var currentStep: Int? = 0
  ChordStringGuideView(chord: .C, maxDisplayStep: 1, currentStep: $currentStep)
}
