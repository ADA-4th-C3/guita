//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum PermissionDialog {
  case guide
  case denied
  case granted
}

struct PermissionViewState {
  let permissionStates: PermissionStates
  var showGuideDialog: Bool = false
  var showDeniedDialog: Bool = false

  func copy(
    permissionStates: [PermissionCategory: PermissionResult]? = nil,
    showGuideDialog: Bool? = nil,
    showDeniedDialog: Bool? = nil
  ) -> PermissionViewState {
    return PermissionViewState(
      permissionStates: permissionStates ?? self.permissionStates,
      showGuideDialog: showGuideDialog ?? self.showGuideDialog,
      showDeniedDialog: showDeniedDialog ?? self.showDeniedDialog
    )
  }
}
