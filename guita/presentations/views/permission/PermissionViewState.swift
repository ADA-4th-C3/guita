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
  var isGranted: Bool {
    permissionStates.values.count { $0 == .granted } == permissionStates.values.count
  }

  var isDenied: Bool {
    permissionStates.values.contains { $0 == .denied }
  }

  var isUndetermined: Bool {
    permissionStates.values.contains { $0 == .undetermined }
  }

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
