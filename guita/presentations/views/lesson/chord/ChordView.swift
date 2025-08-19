//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordView: View {
  @EnvironmentObject var router: Router
  //  @AccessibilityFocusState private var focusedChord: Chord?

  let songInfo: SongInfo

  @State private var selected: String? = nil

  var body: some View {
    BaseView(
      create: { ChordViewModel(songInfo) }
    ) { _, state in
      VStack(spacing: 0) {
        // MARK: Toolbar
        Toolbar(
          title: NSLocalizedString("코드 학습", comment: ""),
          accessibilityHint: String(
            format: NSLocalizedString("Chord.Hint", comment: ""),
            "\(state.songInfo.chords)"
          ),
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

        // MARK: Chord Button
        ListDivider()
        ForEach(state.songInfo.chords, id: \.self) { chord in
          Button(action: { router.push(.chordLesson(chord: chord, chords: state.songInfo.chords))
            selected = chord.rawValue
          }) {
            VStack {
              Text("\(chord.rawValue) 코드")
                .fontKoddi(26, color: selected == chord.rawValue ? .black : .light, weight: .bold)
                .padding(.vertical, 36)
            }
            .frame(maxWidth: .infinity)
          }
          .accessibilityLabel("\(chord.rawValue) 코드 학습하기")
          .accessibilityAddTraits(.isButton)
          .if(selected == chord.rawValue) {
            v in v.background(.accent)
          }
          ListDivider()
        }
        Spacer()
      }
      .contentShape(Rectangle())
      .onTapGesture {
        selected = ""
      }
    }
  }
}

#Preview {
  BasePreview {
    ChordView(songInfo: SongInfo.curriculum.first!)
  }
}
