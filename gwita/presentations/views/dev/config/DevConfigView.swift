//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct DevConfigView: View {
  var body: some View {
    BaseView(
      create: { DevConfigViewModel() }
    ) { viewModel, state in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "Config")

        Form {
          // MARK: FullTrackPlaySpeed
          Section(header: Text("TTS Speed")) {
            Text("곡 재생 속도 : \(state.ttsSpeed.value.formatted(2))")
            Tile(title: "느리게", subtitle: "🐢", action: { viewModel.updateTtsSpeed(isSpeedUp: false) })
            Tile(title: "빠르게", subtitle: "🐇", action: { viewModel.updateTtsSpeed(isSpeedUp: true) })
          }

          // MARK: FullTrackPlaySpeed
          Section(header: Text("FullTrackPlaySpeed")) {
            Text("곡 재생 속도 : \(state.fullTrackPlaySpeed.value.formatted(2))")
            Tile(title: "느리게", subtitle: "🐢", action: { viewModel.updateFullTrackPlaySpeed(isSpeedUp: false) })
            Tile(title: "빠르게", subtitle: "🐇", action: { viewModel.updateFullTrackPlaySpeed(isSpeedUp: true) })
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    DevConfigView()
  }
}
