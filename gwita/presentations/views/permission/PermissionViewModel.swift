//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import UIKit

final class PermissionViewModel: BaseViewModel<PermissionViewState> {
  private let audioManager = AudioManager.shared
  private let onPermissionStatesChanged: ((PermissionStates) -> Void)?

  init(
    permissionCategories: [PermissionCategory],
    onPermissionStatesChanged: ((PermissionStates) -> Void)?
  ) {
    self.onPermissionStatesChanged = onPermissionStatesChanged
    var permissions: [PermissionCategory: PermissionResult] = [:]

    for category in permissionCategories {
      permissions[category] = switch category {
      case .microphone: audioManager.getRecordPermissionState()
      }
    }

    let showGuideDialog = permissions.values.contains { $0 == .undetermined }
    let showDeniedDialog = !showGuideDialog && permissions.values.contains { $0 == .denied }
    super.init(state: PermissionViewState(
      permissionStates: permissions,
      showGuideDialog: showGuideDialog,
      showDeniedDialog: showDeniedDialog
    ))
  }

  func requestPermission() {
    for category in state.permissionStates.keys {
      switch category {
      case .microphone:
        audioManager.requestRecordPermission { isGranted in
          self.emit(self.state.copy(
            permissionStates: self.state.permissionStates.copy([category: isGranted ? .granted : .denied]),
            showDeniedDialog: !isGranted
          ))
        }
      }
    }
  }

  func hideGuideDialog() {
    emit(state.copy(showGuideDialog: false))
  }

  func openSettings() {
    if let url = URL(string: UIApplication.openSettingsURLString),
       UIApplication.shared.canOpenURL(url)
    {
      UIApplication.shared.open(url)
    }
  }
}
