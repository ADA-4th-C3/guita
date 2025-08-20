//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordDetailView: View {
  @EnvironmentObject var router: Router
  @State var selected: String? = nil

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
          selected = nil
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
      },
      secondTrailing: {
        IconButton("gearshape", isSystemImage: true) {
          router.push(.setting)
        }.accessibilityAddTraits(.isButton)
          .accessibilityHint("설정 화면으로 이동")
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
            selected = root.rawValue
            router.push(.chordLesson(chord: chord, chords: chords))
          }) {
            Text("\(root.rawValue) 코드")
              .fontKoddi(
                26,
                color: selected == root.rawValue ? .black : .lightGrey,
                weight: .bold
              )
              .accessibilityAddTraits(.isButton)
              .accessibilityLabel("\(root.rawValue) 코드 학습하기")
          }
          .frame(height: 110)
          .frame(maxWidth: .infinity)
          .if(selected == root.rawValue) {
            v in v.background(.accent)
          }

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
