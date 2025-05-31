//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ConfigView: View {
  var body: some View {
    BaseView(
      create: { ConfigViewModel() }
    ) { viewModel, state in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "Config")

        Form {
          // MARK: FullTrackPlaySpeed
          Section(header: Text("FullTrackPlaySpeed")) {
            Text("곡 재생 속도 : \(state.fullTrackPlaySpeed.value.formatted(2))")
            Tile(title: "느리게", subtitle: "🐢", action: viewModel.speedDown)
            Tile(title: "빠르게", subtitle: "🐇", action: viewModel.speedUp)
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    ConfigView()
  }
}
