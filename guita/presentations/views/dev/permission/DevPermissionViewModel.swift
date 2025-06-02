//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class DevPermissionViewModel: BaseViewModel<PermissionStates> {
  private let audioRecorderManager = AudioRecorderManager.shared
  private let speechToTextManager = SpeechToTextManager.shared

  init(permissionCategories: [PermissionCategory]) {
    var permissionViewState: PermissionStates = [:]
    for category in permissionCategories {
      permissionViewState[category] = switch category {
      case .microphone: audioRecorderManager.getRecordPermissionState()
      case .speechRecognition: speechToTextManager.getSpeechPermissionState()
      }
    }
    super.init(state: permissionViewState)
  }

  func requestPermission(for category: PermissionCategory) {
    switch category {
    case .microphone:
      audioRecorderManager.requestRecordPermission { isGranted in
        self.emit(self.state.copy([category: isGranted ? .granted : .denied]))
      }
    case .speechRecognition:
      speechToTextManager.requestSpeechPermission { isGranted in
        self.emit(self.state.copy([category: isGranted ? .granted : .denied]))
      }
    }
  }
}
