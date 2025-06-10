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
        Toolbar(
          title: NSLocalizedString("코드 학습", comment: ""),
          accessibilityText: String(
            format: NSLocalizedString("Lesson.Accessibility.Description", comment: ""),
            "\(state.songInfo.chords)"
          )
        )
        
        // MARK: Chord Button
        ListDivider()
          .padding(.top, 32)
        ForEach(state.songInfo.chords, id: \.self) { chord in
          Button(action: { router.push(.chordLesson(chord: chord, chords: state.songInfo.chords)) }) {
            VStack {
              Text("\(chord.rawValue) 코드")
                .fontKoddi(26, color: .light, weight: .regular)
                .padding(.vertical, 36)
            }
            .frame(maxWidth: .infinity)
          }
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
