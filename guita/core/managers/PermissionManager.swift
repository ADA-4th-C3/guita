//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation
import Speech
import UIKit

final class PermissionManager: ObservableObject {
  static let shared = PermissionManager()
  
  @Published var microphonePermission: PermissionState = .undetermined
  @Published var speechPermission: PermissionState = .undetermined
  
  private init() {
    checkCurrentPermissions()
  }
  
  func checkCurrentPermissions() {
    // 마이크 권한 상태 확인
    microphonePermission = AudioManager.shared.getRecordPermissionState()
    
    // 음성인식 권한 상태 확인
    speechPermission = VoiceRecognitionManager.shared.getSpeechPermissionState()
  }
  
  func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
    AudioManager.shared.requestRecordPermission { [weak self] granted in
      DispatchQueue.main.async {
        self?.microphonePermission = granted ? .granted : .denied
        completion(granted)
      }
    }
  }
  
  func requestSpeechPermission(completion: @escaping (Bool) -> Void) {
    VoiceRecognitionManager.shared.requestSpeechPermission { [weak self] granted in
      DispatchQueue.main.async {
        self?.speechPermission = granted ? .granted : .denied
        completion(granted)
      }
    }
  }
  
  func openSettings() {
    if let url = URL(string: UIApplication.openSettingsURLString) {
      UIApplication.shared.open(url)
    }
  }
  
  var needsPermissions: Bool {
    return microphonePermission != .granted || speechPermission != .granted
  }
}
