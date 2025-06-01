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
  var onPermissionsCompleted: (() -> Void)?
  
  
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
            showingPermissionDialog = false
            checkAndRequestPermissions()
            
        case .microphoneRequest, .speechRequest:
            showingPermissionDialog = false
            // 재요청 로직 단순화
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.checkAndRequestPermissions()
            }
            
        case .completed:
            showingPermissionDialog = false
            onPermissionsCompleted?()
        }
    }
    
    private func checkAndRequestPermissions() {
        checkCurrentPermissions()
        
        // 1. 마이크 권한이 거부된 경우
        if microphonePermission == .denied {
            permissionDialogType = .microphoneDenied
            showingPermissionDialog = true
            return
        }
        
        // 2. 음성인식 권한이 거부된 경우
        if speechPermission == .denied {
            permissionDialogType = .speechDenied
            showingPermissionDialog = true
            return
        }
        
        // 3. 마이크 권한이 미결정인 경우 - 권한 요청
        if microphonePermission == .undetermined {
            currentStep = .microphoneRequest
            requestMicrophonePermission { granted in
                if granted {
                    // 마이크 허용됨 - 음성인식 권한 확인
                    self.checkSpeechPermissionNext()
                } else {
                    // 마이크 거부됨 - 거부 다이얼로그
                    self.permissionDialogType = .microphoneDenied
                    self.showingPermissionDialog = true
                }
            }
            return
        }
        
        // 4. 마이크는 허용됐지만 음성인식이 미결정인 경우
        if microphonePermission == .granted && speechPermission == .undetermined {
            currentStep = .speechRequest
            requestSpeechPermission { granted in
                if granted {
                    self.currentStep = .completed
                    self.onPermissionsCompleted?()
                } else {
                    self.permissionDialogType = .speechDenied
                    self.showingPermissionDialog = true
                }
            }
            return
        }
        
        // 5. 모든 권한이 허용된 경우
        if microphonePermission == .granted && speechPermission == .granted {
            currentStep = .completed
            onPermissionsCompleted?()
        }
    }

    private func checkSpeechPermissionNext() {
        if speechPermission == .undetermined {
            requestSpeechPermission { granted in
                if granted {
                    self.currentStep = .completed
                    self.onPermissionsCompleted?()
                } else {
                    self.permissionDialogType = .speechDenied
                    self.showingPermissionDialog = true
                }
            }
        } else if speechPermission == .denied {
            permissionDialogType = .speechDenied
            showingPermissionDialog = true
        } else {
            currentStep = .completed
            onPermissionsCompleted?()
        }
    }
    
    
  func checkCurrentPermissions() {
    microphonePermission = AudioManager.shared.getRecordPermissionState()
    speechPermission = VoiceRecognitionManager.shared.getSpeechPermissionState()
    Logger.e("microphonePermission \(microphonePermission)")
    Logger.e("speechPermission \(speechPermission)")
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
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 약간의 딜레이 추가
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
