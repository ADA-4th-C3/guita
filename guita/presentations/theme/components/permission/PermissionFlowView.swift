//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct PermissionFlowView: View {
  @StateObject private var permissionManager = PermissionManager.shared
  @State private var currentStep: PermissionStep = .introduction
  
  let onCompletion: (Bool) -> Void
  
  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      
      VStack(spacing: 40) {
        // 단계 표시
        Text("\(currentStep.stepNumber)/5 단계")
          .font(.caption)
          .foregroundColor(.gray)
        
        Spacer()
        
        // 단계별 콘텐츠
        currentStepContent
        
        Spacer()
      }
      .padding(.horizontal, 20)
    }
    .onAppear {
      checkAndProceedToNextStep()
    }
  }
  
  @ViewBuilder
  private var currentStepContent: some View {
    switch currentStep {
    case .introduction:
      IntroductionStepView {
        nextStep()
      }
      
    case .microphoneRequest:
      MicrophoneRequestStepView {
        requestMicrophonePermission()
      }
      
    case .microphoneDenied:
      MicrophoneDeniedStepView {
        permissionManager.openSettings()
      }
      
    case .speechRequest:
      SpeechRequestStepView {
        requestSpeechPermission()
      }
      
    case .speechDenied:
      SpeechDeniedStepView {
        permissionManager.openSettings()
      }
    }
  }
  
  private func checkAndProceedToNextStep() {
    permissionManager.checkCurrentPermissions()
    
    if permissionManager.microphonePermission == .granted &&
        permissionManager.speechPermission == .granted {
      onCompletion(true)
      return
    }
    
    if permissionManager.microphonePermission == .undetermined {
      currentStep = .microphoneRequest
    } else if permissionManager.microphonePermission == .denied {
      currentStep = .microphoneDenied
    } else if permissionManager.speechPermission == .undetermined {
      currentStep = .speechRequest
    } else if permissionManager.speechPermission == .denied {
      currentStep = .speechDenied
    }
  }
  
  private func nextStep() {
    checkAndProceedToNextStep()
  }
  
  private func requestMicrophonePermission() {
    permissionManager.requestMicrophonePermission { granted in
      if granted {
        nextStep()
      } else {
        currentStep = .microphoneDenied
      }
    }
  }
  
  private func requestSpeechPermission() {
    permissionManager.requestSpeechPermission { granted in
      if granted {
        onCompletion(true)
      } else {
        currentStep = .speechDenied
      }
    }
  }
}

enum PermissionStep: CaseIterable {
  case introduction
  case microphoneRequest
  case microphoneDenied
  case speechRequest
  case speechDenied
  
  var stepNumber: Int {
    switch self {
    case .introduction: return 1
    case .microphoneRequest: return 2
    case .microphoneDenied: return 3
    case .speechRequest: return 4
    case .speechDenied: return 5
    }
  }
}
