//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct CodeClassificationView: View {
  var body: some View {
    BaseView(
      create: { CodeClassificationViewModel() }
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
          Text(state.code)
            .font(.headline)
            .foregroundStyle(.blue)
          
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
    CodeClassificationView()
  }
}
