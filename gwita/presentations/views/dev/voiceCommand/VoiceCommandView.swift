//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct VoiceCommandView: View {
  var body: some View {
    BaseView(
      create: { VoiceCommandViewModel() }
    ) { viewModel, state in
      PermissionView(
        permissionListener: { isGranted in
          if isGranted {
            viewModel.start()
          }
        }
      ) {
        VStack {
          // MARK: Toolbar
          Toolbar(title: "Voice Command")

          Form {
            // MARK: Voice Command
            Section(header: Text("Commands")) {
              ForEach(state.commands.indices, id: \.self) { i in
                let command = state.commands[i]
                let keyword = command.keyword
                let phrases = command.keyword.phrases
                HStack {
                  Text("\(keyword)")
                  Spacer()
                  Text("\(phrases)")
                }
              }
            }

            // MARK: History
            Section(header: Text("History")) {
              ForEach(state.history.reversed(), id: \.id) { history in
                VStack {
                  HStack {
                    Text("\(history.keyword)")
                    Spacer()
                    Text("\(history.phrase)")
                  }
                  Text("\(history.rawText)")
                    .fontKoddi(13, color: .lightGrey)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
              }
            }

            // MARK: Speech To Text
            Section(header: Text("Speech To Text")) {
              Text(state.text)
            }
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    VoiceCommandView()
  }
}
