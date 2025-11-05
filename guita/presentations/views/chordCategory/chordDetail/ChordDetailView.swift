//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordDetailView: View {
  @EnvironmentObject var router: Router
  @AccessibilityFocusState private var focusedChord: String?

  let chord: Chord
  let chords: [Chord]

  var body: some View {
    BaseView(
      create: {
        ChordDetailViewModel()
      }
    ) { _, _ in
      ZStack {
        VStack(spacing: 0) {
          toolbar

          chordDetailList

          Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
          focusedChord = nil
        }
      }
    }
  }

  private var toolbar: some View {
    Toolbar(
      title: "\(chord) 코드 배우기",
      firstTrailing: {
        IconButton("info") {
          router.push(.chordLessonGuide)
        }.accessibilityAddTraits(.isButton)
          .accessibilityLabel("사용법 도움말")
          .accessibilityFocused($focusedChord, equals: "info")
      },
      secondTrailing: {
        IconButton("gearshape", isSystemImage: true) {
          router.push(.setting)
        }.accessibilityAddTraits(.isButton)
          .accessibilityHint("설정 화면으로 이동")
          .accessibilityFocused($focusedChord, equals: "setting")
      }
    )
  }

  private var chordDetailList: some View {
    let rootChords: [Chord] = chords

    return ScrollView {
      VStack(spacing: 0) {
        ListDivider()

        ForEach(rootChords, id: \.self) { root in
          Button(action: {
            // TODO: - 루트별 코드 리스트로 routing
            router.push(.chordLesson(chord: root, chords: chords))
          }) {
            Text("\(root.rawValue) 코드")
              .fontKoddi(
                26,
                color: focusedChord == root.rawValue ? .black : .lightGrey,
                weight: .bold
              )
              .accessibilityAddTraits(.isButton)
              .accessibilityLabel("\(root.rawValue) 코드 학습하기")
              .frame(height: 110)
              .frame(maxWidth: .infinity)
              .background(focusedChord == root.rawValue ? Color.accent : Color.clear)
          }
          .accessibilityFocused($focusedChord, equals: root.rawValue)

          ListDivider()
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    ChordDetailView(chord: .C, chords: [.C, .C7, .Cm, .Cm7, .CM7])
  }
}
