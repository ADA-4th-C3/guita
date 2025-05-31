//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation
import Speech
import UIKit
import SwiftUI

final class PermissionManager: ObservableObject {
  static let shared = PermissionManager()
  
  @Published var microphonePermission: PermissionState = .undetermined
  @Published var speechPermission: PermissionState = .undetermined
  @Published var currentStep: PermissionFlowStep = .introduction
  
  @Published var showingPermissionDialog = false
  @Published var permissionDialogType: PermissionDialogType?
  
  
  private init() {
    checkCurrentPermissions()
  }
  
  /// 권한 플로우 시작
  func startPermissionFlow() {
    currentStep = .introduction
    showingPermissionDialog = true
  }
  
  /// 다음 단계로 진행
  func proceedToNextStep() {
    switch currentStep {
    case .introduction:
      currentStep = .microphoneRequest
      showingPermissionDialog = false
      
      // 약간의 딜레이 후 마이크 권한 요청
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        self.requestMicrophonePermission { granted in
          if granted {
            // 마이크 권한이 허용되면 음성인식 권한 요청
            self.currentStep = .speechRequest
            self.requestSpeechPermission { speechGranted in
              if speechGranted {
                self.currentStep = .completed
                // 모든 권한이 허용되면 다이얼로그 닫기
              } else {
                // 음성인식 권한이 거부되면 거부 다이얼로그 표시
                self.permissionDialogType = .speechDenied
                self.showingPermissionDialog = true
              }
            }
          } else {
            // 마이크 권한이 거부되면 거부 다이얼로그 표시
            self.permissionDialogType = .microphoneDenied
            self.showingPermissionDialog = true
          }
        }
      }
      
    case .microphoneRequest, .speechRequest:
      break // 시스템 권한 다이얼로그가 처리
      
    case .completed:
      showingPermissionDialog = false
    }
  }
  func checkCurrentPermissions() {
    microphonePermission = AudioManager.shared.getRecordPermissionState()
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
  
  /// 학습 화면 진입 시 권한 체크 및 다이얼로그 표시
  func checkPermissionsForLearning() {
    checkCurrentPermissions()
    
    // 모든 권한이 허용된 경우 다이얼로그 표시하지 않음
    if microphonePermission == .granted && speechPermission == .granted {
      return
    }
    
    // 권한이 하나라도 부족하면 항상 안내 다이얼로그부터 시작
    permissionDialogType = .permissionIntroduction
    showingPermissionDialog = true
  }
  
  /// 권한 안내 다이얼로그에서 확인 버튼 클릭 시 호출
  func requestAllPermissions() {
    showingPermissionDialog = false // 다이얼로그 먼저 닫기
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 약간의 딜레이 추가
      self.requestMicrophonePermission { [weak self] micGranted in
        guard let self = self else { return }
        
        if micGranted {
          self.requestSpeechPermission { speechGranted in
            if !speechGranted {
              self.permissionDialogType = .speechDenied
              self.showingPermissionDialog = true
            }
          }
        } else {
          self.permissionDialogType = .microphoneDenied
          self.showingPermissionDialog = true
        }
      }
    }
  }
  
  /// 설정으로 이동
  func openSettings() {
    if let url = URL(string: UIApplication.openSettingsURLString) {
      UIApplication.shared.open(url)
    }
    showingPermissionDialog = false
  }
  
  /// 다이얼로그 닫기
  func dismissDialog() {
    showingPermissionDialog = false
  }
  
  var needsPermissions: Bool {
    return microphonePermission != .granted || speechPermission != .granted
  }
  
  /// 권한 다이얼로그 오버레이 View
  @ViewBuilder
  func permissionDialogOverlay() -> some View {
    if showingPermissionDialog, let dialogType = permissionDialogType {
      PermissionDialog(
        isPresented: Binding(
          get: { self.showingPermissionDialog },
          set: { self.showingPermissionDialog = $0 }
        ),
        type: dialogType,
        onOpenSettings: {
          self.openSettings()
        },
        onRequestPermissions: {
          self.requestAllPermissions()
        }
      )
    }
  }
}
