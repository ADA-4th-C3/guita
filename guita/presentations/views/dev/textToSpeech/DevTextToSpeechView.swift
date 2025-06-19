//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct DevTextToSpeechView: View {
  var body: some View {
    BaseView(
      create: { DevTextToSpeechViewModel() }
    ) { viewModel, state in
      PermissionView(
        permissionListener: { isGranted in
          if !isGranted { return }
          if state.isVoiceCommandEnabled {
            viewModel.startVoiceCommand()
          }
        }
      ) {
        VStack {
          Toolbar(title: "Text To Speech")
          Form {
            Section {
              Tile(title: "음성명령", subtitle: state.isVoiceCommandEnabled ? "ON" : "OFF") {
                state.isVoiceCommandEnabled ? viewModel.stopVoiceCommand() : viewModel.startVoiceCommand()
              }

              Text("재생 / 다시 / 다음 / 이전")
            }

            ForEach(state.samples.indices, id: \.self) { i in
              Text(state.samples[i])
                .fontKoddi(15, color: i == state.index ? .accent : nil)
            }
          }
          Spacer()
          HStack {
            IconButton("chevron-left", size: 95) {
              viewModel.goPrevious()
            }
            IconButton("play", size: 95) {
              viewModel.play()
            }
            IconButton("chevron-right", size: 95) {
              viewModel.goNext()
            }
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    DevTextToSpeechView()
  }
}
