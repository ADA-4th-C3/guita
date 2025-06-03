//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct DevNoteClassificationView: View {
  var body: some View {
    BaseView(
      create: { DevNoteClassificationViewModel() }
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
        case .granted, .restricted:
          VStack {
            Text(state.note == nil ? " " : "\(state.note!) (\(state.confidence.truncated(2)))")
              .font(.headline)
              .foregroundStyle(.blue)
            Guitar(input: state.note == nil ? nil : NoteOrChord.note(state.note!))
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
    DevNoteClassificationView()
  }
}
