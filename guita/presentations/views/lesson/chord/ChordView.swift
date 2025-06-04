//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordView: View {
  @EnvironmentObject var router: Router
//  @AccessibilityFocusState private var focusedChord: Chord?

  let songInfo: SongInfo

  var body: some View {
    BaseView(
      create: { ChordViewModel(songInfo) }
    ) { _, state in
      VStack(spacing: 0) {
        // MARK: Toolbar
        Toolbar(title: "코드 학습", accessibilityText: "\(state.songInfo.chords) 를 배우는 화면입니다. 기타를 들고 배우고 싶은 코드를 선택해 주세요.")

        // MARK: Chord Button
        ListDivider()
          .padding(.top, 32)
        ForEach(state.songInfo.chords, id: \.self) { chord in
          Button(action: { router.push(.chordLesson(chord: chord, chords: state.songInfo.chords)) }) {
            VStack {
              Text("\(chord.rawValue) 코드")
                .fontKoddi(26, color: .darkGrey, weight: .bold)
                .padding(.vertical, 36)
            }
            .frame(maxWidth: .infinity)
          }
//          .accessibilityFocused($focusedChord, equals: chord)
//          .background(focusedChord == chord ? Color.yellow.opacity(0.9) : Color.clear)
          .accessibilityLabel("\(chord.rawValue) 코드 학습하기")
          .accessibilityAddTraits(.isButton)

          ListDivider()
        }
        Spacer()
      }
    }
  }
}

#Preview {
  BasePreview {
    ChordView(songInfo: SongInfo.curriculum.first!)
  }
}
