//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct VoiceControlView: View {
  var body: some View {
    BaseView(
      create: { VoiceControlViewModel() }
    ) { _, state in
      PermissionView {
        VStack {
          // MARK: Toolbar
          Toolbar(title: "Voice Controll")
          Spacer()
          Text(state.text)
          Spacer()
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    VoiceControlView()
  }
}
