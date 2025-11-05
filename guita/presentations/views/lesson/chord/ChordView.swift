//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordView: View {
  @EnvironmentObject var router: Router
  @AccessibilityFocusState private var focusedChord: String?

  let songInfo: SongInfo

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

        // MARK: Chord Button
        ListDivider()
        ForEach(state.songInfo.chords, id: \.self) { chord in
          Button(action: {
            router.push(.chordLesson(chord: chord, chords: state.songInfo.chords))
          }) {
            Text("\(chord.rawValue) 코드")
              .fontKoddi(26, color: focusedChord == chord.rawValue ? .black : .light, weight: .bold)
              .padding(.vertical, 36)
              .frame(maxWidth: .infinity)
              .background(focusedChord == chord.rawValue ? Color.accent : Color.clear)
          }
          .accessibilityLabel("\(chord.rawValue) 코드 학습하기")
          .accessibilityAddTraits(.isButton)
          .accessibilityFocused($focusedChord, equals: chord.rawValue)
          ListDivider()
        }
        Spacer()
      }
      .contentShape(Rectangle())
      .onTapGesture {
        focusedChord = nil
      }
    }
  }
}

#Preview {
  BasePreview {
    ChordView(songInfo: SongInfo.curriculum.first!)
  }
}
