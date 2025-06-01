//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordLessonView: View {
  let chord: Chord
  var body: some View {
    BaseView(
      create: { ChordLessonViewModel(chord) }
    ) { _, state in
      PermissionView {
        VStack(spacing: 0) {
          // MARK: Toolbar
          Toolbar(title: "\(state.chord) 코드")
          Spacer()
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    ChordLessonView(chord: .A)
  }
}
