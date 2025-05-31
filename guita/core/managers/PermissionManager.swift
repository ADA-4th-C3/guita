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
      Logger.d("권한 안내 다이얼로그에서 확인 버튼 클릭")
      showingPermissionDialog = false
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        Logger.d("권한 요청 단계 시작")
        self.checkCurrentPermissions()
        Logger.d("현재 권한 상태 - 마이크: \(self.microphonePermission), 음성인식: \(self.speechPermission)")
        
        if self.microphonePermission == .undetermined {
          Logger.d("마이크 권한이 미결정 상태 - 권한 요청 시작")
          self.currentStep = .microphoneRequest
          self.requestMicrophonePermission { granted in
            Logger.d("마이크 권한 요청 결과: \(granted)")
            if granted {
              Logger.d("마이크 권한 허용됨 - 음성인식 권한 확인")
              // 마이크 허용됨 - 음성인식 권한 확인
              if self.speechPermission == .undetermined {
                Logger.d("음성인식 권한이 미결정 상태 - 권한 요청 시작")
                self.currentStep = .speechRequest
                self.requestSpeechPermission { speechGranted in
                  Logger.d("음성인식 권한 요청 결과: \(speechGranted)")
                  if speechGranted {
                    Logger.d("모든 권한이 허용됨 - 완료 상태로 전환")
                    self.currentStep = .completed
                  } else {
                    Logger.d("음성인식 권한 거부됨 - 거부 다이얼로그 표시")
                    // 음성인식 거부 - 음성인식 거부 다이얼로그
                    self.permissionDialogType = .speechDenied
                    self.showingPermissionDialog = true
                  }
                }
              } else if self.speechPermission == .granted {
                Logger.d("음성인식 권한이 이미 허용됨 - 완료 상태로 전환")
                self.currentStep = .completed
              } else {
                Logger.d("음성인식 권한이 이미 거부됨 - 거부 다이얼로그 표시")
                // 음성인식이 이미 거부된 상태
                self.permissionDialogType = .speechDenied
                self.showingPermissionDialog = true
              }
            } else {
              Logger.d("마이크 권한 거부됨 - 거부 다이얼로그 표시")
              // 마이크 거부 - 마이크 거부 다이얼로그
              self.permissionDialogType = .microphoneDenied
              self.showingPermissionDialog = true
            }
          }
        } else if self.microphonePermission == .denied {
          Logger.d("마이크 권한이 이미 거부됨 - 거부 다이얼로그 표시")
          // 이미 마이크가 거부된 상태
          self.permissionDialogType = .microphoneDenied
          self.showingPermissionDialog = true
        } else if self.microphonePermission == .granted {
          Logger.d("마이크 권한이 이미 허용됨 - 음성인식 권한 확인")
          // 마이크는 허용됨, 음성인식 확인
          if self.speechPermission == .undetermined {
            Logger.d("음성인식 권한이 미결정 상태 - 권한 요청 시작")
            self.currentStep = .speechRequest
            self.requestSpeechPermission { speechGranted in
              Logger.d("음성인식 권한 요청 결과: \(speechGranted)")
              if speechGranted {
                Logger.d("음성인식 권한 허용됨 - 완료 상태로 전환")
                self.currentStep = .completed
              } else {
                Logger.d("음성인식 권한 거부됨 - 거부 다이얼로그 표시")
                self.permissionDialogType = .speechDenied
                self.showingPermissionDialog = true
              }
            }
          } else if self.speechPermission == .denied {
            Logger.d("음성인식 권한이 이미 거부됨 - 거부 다이얼로그 표시")
            self.permissionDialogType = .speechDenied
            self.showingPermissionDialog = true
          } else {
            Logger.d("모든 권한이 이미 허용됨 - 완료 상태로 전환")
            self.currentStep = .completed
          }
        }
      }
        
    case .microphoneRequest:
      Logger.d("마이크 거부 다이얼로그에서 취소 버튼 클릭 - 마이크 권한 재요청")
      showingPermissionDialog = false
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        self.requestMicrophonePermission { granted in
          Logger.d("마이크 권한 재요청 결과: \(granted)")
          if granted {
            // 마이크 허용되면 음성인식 권한 확인
            if self.speechPermission == .undetermined {
              self.currentStep = .speechRequest
              self.requestSpeechPermission { speechGranted in
                if speechGranted {
                  self.currentStep = .completed
                } else {
                  self.permissionDialogType = .speechDenied
                  self.showingPermissionDialog = true
                }
              }
            } else if self.speechPermission == .denied {
              self.permissionDialogType = .speechDenied
              self.showingPermissionDialog = true
            } else {
              self.currentStep = .completed
            }
          } else {
            // 다시 거부되면 같은 거부 다이얼로그 표시
            Logger.d("마이크 권한 재거부 - 거부 다이얼로그 다시 표시")
            self.permissionDialogType = .microphoneDenied
            self.showingPermissionDialog = true
          }
        }
      }
      
    case .speechRequest:
      Logger.d("음성인식 거부 다이얼로그에서 취소 버튼 클릭 - 음성인식 권한 재요청")
      showingPermissionDialog = false
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        self.requestSpeechPermission { granted in
          Logger.d("음성인식 권한 재요청 결과: \(granted)")
          if granted {
            self.currentStep = .completed
          } else {
            // 다시 거부되면 같은 거부 다이얼로그 표시
            Logger.d("음성인식 권한 재거부 - 거부 다이얼로그 다시 표시")
            self.permissionDialogType = .speechDenied
            self.showingPermissionDialog = true
          }
        }
      }
      
    case .completed:
      showingPermissionDialog = false
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
