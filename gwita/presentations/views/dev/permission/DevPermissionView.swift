//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct DevPermissionView: View {
  var body: some View {
    BaseView(
      create: { DevPermissionViewModel(permissionCategories: [.microphone]) }
    ) { viewModel, state in
      PermissionView {
        VStack {
          Toolbar(title: "Permission")

          Form {
            ForEach(Array(state.keys), id: \.self) { category in
              if let permissionState = state[category] {
                Tile(title: "\(category)", subtitle: "\(permissionState)") {
                  viewModel.requestPermission(for: category)
                }
              }
            }
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    DevPermissionView()
  }
}
