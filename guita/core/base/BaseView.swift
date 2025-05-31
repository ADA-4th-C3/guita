//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

typealias Builder<Content, S, VM> = (_ viewModel: VM, _ state: S) -> Content

struct BaseView<Content: View, State: Any, ViewModel: BaseViewModel<State>>: View {
  @StateObject private var viewModel: ViewModel
  @StateObject private var permissionManager = PermissionManager.shared
  
  let builder: Builder<Content, State, ViewModel>
  let needsPermissions: Bool
  let navigationBarHidden: Bool
  let navigationBarBackButtonHidden: Bool
  
  init(
    create: @escaping () -> ViewModel,
    needsPermissions: Bool = false,
    builder: @escaping Builder<Content, State, ViewModel>,
    navigationBarHidden: Bool = true,
    navigationBarBackButtonHidden: Bool = true
  ) {
    _viewModel = StateObject(wrappedValue: create())
    self.needsPermissions = needsPermissions
    self.builder = builder
    self.navigationBarHidden = navigationBarHidden
    self.navigationBarBackButtonHidden = navigationBarBackButtonHidden
  }
  
  var body: some View {
    Layout {
      builder(viewModel, viewModel.state)
        .navigationBarBackButtonHidden(navigationBarBackButtonHidden)
        .navigationBarHidden(navigationBarHidden)
        .overlay(
          needsPermissions ? permissionManager.permissionDialogOverlay() : nil
        )
    }
    .onAppear {
      if needsPermissions {
        permissionManager.checkPermissionsForLearning()
      }
    }
    .onDisappear {
      viewModel.dispose()
    }
  }
}
