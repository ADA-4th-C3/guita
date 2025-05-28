//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct VoiceControlView: View {
  var body: some View {
    BaseView(
      create: { VoiceControlViewModel() }
    ) { _, _ in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "Voice Controll")
        Spacer()
      }
    }
  }
}

#Preview {
  BasePreview {
    VoiceControlView()
  }
}
