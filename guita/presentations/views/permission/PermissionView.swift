//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct PermissionView<Content: View>: View {
  @EnvironmentObject var router: Router
  var permissionListener: ((_ isGranted: Bool) -> Void)?
  var content: () -> Content

  var body: some View {
    BaseView(
      create: {
        PermissionViewModel(
          permissionCategories: PermissionCategory.allCases,
          permissionStatesListener: permissionListener
        )
      }
    ) { viewModel, state in
      ZStack {
        // MARK: Content

        if state.isGranted {
          content()
        }

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
              viewModel.requestPermissions()
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
      .onAppear {
        permissionListener?(state.isGranted)
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
