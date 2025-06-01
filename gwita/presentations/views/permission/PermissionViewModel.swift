//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import UIKit

final class PermissionViewModel: BaseViewModel<PermissionViewState> {
  private let audioManager = AudioManager.shared
  private let speechToTextManager = SpeechToTextManager.shared
  private let permissionStatesListener: ((_ isGranted: Bool) -> Void)?

  init(
    permissionCategories: [PermissionCategory],
    permissionStatesListener: ((_ isGranted: Bool) -> Void)?
  ) {
    self.permissionStatesListener = permissionStatesListener
    var permissions: [PermissionCategory: PermissionResult] = [:]

    for category in permissionCategories {
      permissions[category] = switch category {
      case .microphone: audioManager.getRecordPermissionState()
      case .speechRecognition: speechToTextManager.getSpeechPermissionState()
      }
    }

    let showGuideDialog = permissions.values.contains { $0 == .undetermined }
    let showDeniedDialog = !showGuideDialog && permissions.values.contains { $0 == .denied }
    super.init(state: PermissionViewState(
      permissionStates: permissions,
      showGuideDialog: showGuideDialog,
      showDeniedDialog: showDeniedDialog
    ))
    permissionStatesListener?(state.isGranted)
  }

  func requestPermissions() {
    let permissionCategories = Array(state.permissionStates.keys)
    var updatedStates = state.permissionStates
    var remaining = permissionCategories.count

    for category in permissionCategories {
      let handleResult: (Bool) -> Void = { isGranted in
        updatedStates[category] = isGranted ? .granted : .denied
        remaining -= 1

        // 모든 요청이 끝난 경우
        if remaining == 0 {
          let showDeniedDialog = updatedStates.values.contains { $0 == .denied }
          let newState = self.state.copy(
            permissionStates: updatedStates,
            showDeniedDialog: showDeniedDialog
          )
          self.emit(newState)
          self.permissionStatesListener?(newState.isGranted)
        }
      }

      switch category {
      case .microphone:
        audioManager.requestRecordPermission { handleResult($0) }
      case .speechRecognition:
        speechToTextManager.requestSpeechPermission { handleResult($0) }
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
