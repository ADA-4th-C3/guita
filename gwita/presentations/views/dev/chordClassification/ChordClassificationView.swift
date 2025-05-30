//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordClassificationView: View {
  var body: some View {
    BaseView(
      create: { ChordClassificationViewModel() }
    ) { viewModel, state in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "Code Classification")
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
          if let chord = state.chord {
            VStack {
              Text("\(chord)")
                .font(.headline)
                .foregroundStyle(.blue)
              Guitar(input: NoteOrChord.chord(chord))
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
    ChordClassificationView()
  }
}
