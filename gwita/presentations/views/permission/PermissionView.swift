//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct PermissionView<Content: View>: View {
  @EnvironmentObject var router: Router
  var content: () -> Content
  var onPermissionStatesChanged: ((PermissionStates) -> Void)?

  var body: some View {
    BaseView(
      create: {
        PermissionViewModel(
          permissionCategories: [.microphone],
          onPermissionStatesChanged: onPermissionStatesChanged
        )
      }
    ) { viewModel, state in
      ZStack {
        // MARK: Content
        content()

        // MARK: Background
        if state.showGuideDialog || state.showDeniedDialog {
          Color.dark.opacity(0.2)
            .ignoresSafeArea()
        }

        // MARK: Guide dialog
        if state.showGuideDialog {
          PermissionGuideDialog(
            onConfirm: {
              withAnimation {
                viewModel.hideGuideDialog()
              }
              viewModel.requestPermission()
            }
          )
        }

        // MARK: Denied dialog
        if state.showDeniedDialog {
          PermissionDeniedDialog(
            onConfirm: viewModel.openSettings,
            onCancel: router.pop
          )
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    PermissionView {
      Text("Hello")
    }
  }
}
