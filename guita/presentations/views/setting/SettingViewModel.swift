//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import UIKit

final class SettingViewModel: BaseViewModel<SettingViewState> {
  private let permissionViewModel = PermissionViewModel(
    permissionCategories: PermissionCategory.allCases
  )
  private let configManager = ConfigManager.shared
  private let textToSpeechManager = TextToSpeechManager.shared
  private let speechToTextManager = SpeechToTextManager.shared

  init() {
    super.init(state: .init(
      config: configManager.state,
      showGuideDialog: false,
      showDeniedDialog: false
    ))

    permissionViewModel.permissionStatesListener = permissionStatesListener
    emit(state.copy(
      config: state.config.copy(
        isVoiceCommandEnabled: permissionViewModel.state.isGranted && state.config.isVoiceCommandEnabled
      )
    ))
  }

  override func emit(_ newState: SettingViewState) {
    super.emit(newState)
    configManager.updateConfig(newState.config)
  }

  func updateTtsSpeed(isSpeedUp: Bool) {
    emit(state.copy(
      config: state.config.copy(
        ttsSpeed: isSpeedUp ? state.config.ttsSpeed.next : state.config.ttsSpeed.previous
      )
    ))

    textToSpeechManager.stop()
    Task {
      try await Task.sleep(nanoseconds: 1_000_000_000)
      await textToSpeechManager.speak(NSLocalizedString("TTSSpeedTest", comment: ""))
    }
  }

  func requestPermissions() {
    permissionViewModel.requestPermissions()
  }

  // 음성 명령 사용자 설정 변경
  func updateUserWantsVoiceCommand(_ enabled: Bool) {
    // 권한 요청을 안한 경우
    if permissionViewModel.state.isUndetermined {
      emit(state.copy(showGuideDialog: true))
      return
    }

    // 거절된 경우
    if permissionViewModel.state.isDenied {
      emit(state.copy(showDeniedDialog: true))
      emit(state.copy(
        config: state.config.copy(
          isVoiceCommandEnabled: false
        )
      ))
      return
    }

    // 승인된 경우
    if permissionViewModel.state.isGranted {
      emit(state.copy(
        config: state.config.copy(
          isVoiceCommandEnabled: enabled
        )
      ))
    }
  }

  func onDeniedDialogCanceled() {
    emit(state.copy(showDeniedDialog: false))
  }

  func hideGuideDialog() {
    emit(state.copy(showGuideDialog: false))
  }

  func permissionStatesListener(_ isGranted: Bool) {
    emit(state.copy(
      config: state.config.copy(
        isVoiceCommandEnabled: isGranted
      )
    ))
  }

  // 설정 앱 열기
  func openSettings() {
    if let url = URL(string: UIApplication.openSettingsURLString),
       UIApplication.shared.canOpenURL(url)
    {
      UIApplication.shared.open(url)
    }
  }

  // 권한 상태 확인
  var hasVoicePermission: Bool {
    speechToTextManager.getSpeechPermissionState() == .granted
  }

  // 실제 음성인식 활성화 여부 (권한 && 사용자설정)
  var effectiveVoiceCommandEnabled: Bool {
    hasVoicePermission && state.config.isVoiceCommandEnabled
  }

  override func dispose() {
    textToSpeechManager.stop()
  }
}
