//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordView: View {
  let songInfo: SongInfo

  var body: some View {
    BaseView(
      create: { ChordViewModel(songInfo) }
    ) { _, state in
      VStack(spacing: 0) {
        // MARK: Toolbar
        Toolbar(title: "코드 학습")

        // MARK: Chord Button
        dividerView()
        ForEach(state.songInfo.chords, id: \.self) { chord in
          Button(action: {}) {
            VStack {
              Text("\(chord) 코드")
                .fontKoddi(26, color: .darkGrey, weight: .bold)
                .padding(.vertical, 36)
            }
          }
          dividerView()
        }
        Spacer()
      }
    }
  }

  private func dividerView() -> some View {
    Rectangle()
      .fill(.darkGrey)
      .frame(height: 0.5)
  }
}

#Preview {
  BasePreview {
    ChordView(songInfo: SongInfo(level: "초급1", title: "여행을 떠나요", chords: [.A, .E, .B7]))
  }
}
