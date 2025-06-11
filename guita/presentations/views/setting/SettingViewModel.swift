//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import UIKit

final class SettingViewModel: BaseViewModel<Config> {
  private let configManager = ConfigManager.shared
  private let textToSpeechManager = TextToSpeechManager.shared
  private let speechToTextManager = SpeechToTextManager.shared

  init() {
    super.init(state: configManager.state)
  }

  override func emit(_ config: Config) {
    super.emit(config)
    configManager.updateConfig(config)
  }

  func updateTtsSpeed(isSpeedUp: Bool) {
    emit(state.copy(ttsSpeed: isSpeedUp ? state.ttsSpeed.next : state.ttsSpeed.previous))
    
    textToSpeechManager.stop()
    Task {
      try await Task.sleep(nanoseconds: 1000_000_000)
      await textToSpeechManager.speak(NSLocalizedString("TTSSpeedTest", comment: ""))
    }
  }

  // 음성 명령 사용자 설정 변경
  func updateUserWantsVoiceCommand(_ enabled: Bool) {
    emit(state.copy(isVoiceCommandEnabled: enabled))
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
    hasVoicePermission && state.isVoiceCommandEnabled
  }

  override func dispose() {
    textToSpeechManager.stop()
  }
}
