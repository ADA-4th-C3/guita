//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct DevTextToSpeechView: View {
  var body: some View {
    BaseView(
      create: { DevTextToSpeechViewModel() }
    ) { viewModel, state in
      VStack {
        Toolbar(title: "Text To Speech")
        Form {
          ForEach(state.samples.indices, id: \.self) { i in
            Text(state.samples[i])
              .fontKoddi(15, color: i == state.index ? .accent : nil)
          }
        }
        Spacer()
        HStack {
          IconButton("chevron-left", color: .light, size: 95, isSystemImage: false) {
            viewModel.goPrevious()
          }
          IconButton("play", size: 95, isSystemImage: false) {
            viewModel.play()
          }
          IconButton("chevron-right", color: .light, size: 95, isSystemImage: false) {
            viewModel.goNext()
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview{
    DevTextToSpeechView()
  }
}
