//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct NoteClassificationView: View {
  var body: some View {
    BaseView(
      create: { NoteClassificationViewModel() }
    ) { viewModel, state in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "Note Classification")
        Spacer()

        switch state.recordPermissionState {
        case .undetermined:
          Loading()
        case .denied:
          VStack {
            Text("녹음 권한이 필요합니다.")
              .font(.headline)
              .multilineTextAlignment(.center)
              .padding()

            Button("설정으로 이동") {
              viewModel.openSettings()
            }
            .buttonStyle(.borderedProminent)
          }
        case .granted:
          if let note = state.note {
            VStack {
              Text("\(note)")
                .font(.headline)
                .foregroundStyle(.blue)
              Guitar(input: NoteOrChord.note(note))
            }
          } else {
            Text("")
          }
        }

        Spacer()
      }
      .onAppear {
        viewModel.requestRecordPermission()
      }
    }
  }
}

#Preview {
  BasePreview {
    NoteClassificationView()
  }
}
