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
        Group {
          content()
        }
        .accessibilityElement(children: .contain)
        .accessibilityHidden(state.showGuideDialog)

        // MARK: Background
        if state.showGuideDialog {
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
        // 거절되어도 앱 사용 가능하도록 설정으로 보내는 팝업 안띄움
        // if state.showDeniedDialog {
        //   PermissionDeniedDialog(
        //     onConfirm: viewModel.openSettings,
        //     onCancel: router.pop
        //   )
        // }
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
