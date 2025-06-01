//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class DevPermissionViewModel: BaseViewModel<PermissionStates> {
  private let audioManager = AudioManager.shared

  init(permissionCategories: [PermissionCategory]) {
    var permissionViewState: PermissionStates = [:]
    for category in permissionCategories {
      permissionViewState[category] = switch category {
      case .microphone: audioManager.getRecordPermissionState()
      }
    }
    super.init(state: permissionViewState)
  }

  func requestPermission(for category: PermissionCategory) {
    switch category {
    case .microphone:
      audioManager.requestRecordPermission { isGranted in
        self.emit(self.state.copy([category: isGranted ? .granted : .denied]))
      }
    }
  }
}
