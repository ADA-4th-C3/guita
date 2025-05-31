//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 권한 안내를 위한 커스텀 다이얼로그
struct PermissionDialog: View {
  
  @Binding var isPresented: Bool
  let type: PermissionDialogType
  let onOpenSettings: () -> Void
  let onRequestPermissions: () -> Void  // 권한 요청 콜백 추가
  @ObservedObject var permissionManager = PermissionManager.shared
  
  var body: some View {
    if permissionManager.showingPermissionDialog && permissionManager.currentStep == .introduction {
      CustomDialog(isPresented: $permissionManager.showingPermissionDialog) {
        permissionIntroductionContent
      }
    } else if permissionManager.showingPermissionDialog {
      CustomDialog(isPresented: $permissionManager.showingPermissionDialog) {
        dialogContent
      }
    }
  }
  
  @ViewBuilder
  private var dialogContent: some View {
    switch type {
    case .permissionIntroduction:
      permissionIntroductionContent
    case .microphoneDenied, .speechDenied:
      permissionDeniedContent
    }
  }
  
  // MARK: - Permission Introduction Content
  
  private var permissionIntroductionContent: some View {
    VStack(spacing: 0) {
      // 상단 아이콘 영역
      VStack(spacing: 16) {
        // 체크 아이콘
        ZStack {
          Circle()
            .fill(Color.yellow)
            .frame(width: 60, height: 60)
          
          Image(systemName: "checkmark")
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.black)
        }
        
        // 메인 메시지
        Text("Guita 앱의 편리한 이용을 위해\n아래 접근권한의 허용이 필요합니다")
          .font(.system(size: 16, weight: .medium))
          .multilineTextAlignment(.center)
          .foregroundColor(.black)
          .lineSpacing(4)
      }
      .padding(.top, 30)
      .padding(.horizontal, 20)
      
      // 권한 정보 영역
      VStack(spacing: 16) {
        VStack(alignment: .leading, spacing: 4) {
          Text("음성 인식(필수)")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Text("음성 명령으로 기능 제어시 사용")
            .font(.system(size: 12))
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        VStack(alignment: .leading, spacing: 4) {
          Text("마이크(필수)")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Text("기타 연주 소리를 듣고 학습 피드백 드리기 위해 마이크 접근 권한이 필요")
            .font(.system(size: 12))
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineSpacing(2)
        }
      }
      .padding(.top, 24)
      .padding(.horizontal, 20)
      
      // 설정 안내 텍스트
      Text("* 설정>Guita 앱에서 권한 변경이 가능합니다.")
        .font(.system(size: 12))
        .foregroundColor(.gray)
        .padding(.top, 16)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
      
      // 확인 버튼
      Button("확인") {
        permissionManager.proceedToNextStep()
      }
      .frame(maxWidth: .infinity)
      .frame(height: 50)
      .background(Color.yellow)
      .foregroundColor(.black)
      .font(.system(size: 16, weight: .medium))
    }
  }
  
  // MARK: - Permission Denied Content
  
  private var permissionDeniedContent: some View {
    VStack(spacing: 0) {
      // 상단 아이콘 영역
      VStack(spacing: 16) {
        // 경고 아이콘
        ZStack {
          Circle()
            .fill(Color.red.opacity(0.1))
            .frame(width: 60, height: 60)
          
          Image(systemName: iconName)
            .font(.system(size: 24))
            .foregroundColor(.red)
        }
        
        // 메인 메시지
        Text(mainMessage)
          .font(.system(size: 16, weight: .medium))
          .foregroundColor(.black)
          .multilineTextAlignment(.center)
          .lineSpacing(4)
      }
      .padding(.top, 30)
      .padding(.horizontal, 20)
      
      // 설명 텍스트
      Text(descriptionMessage)
        .font(.system(size: 14))
        .foregroundColor(.black)
        .multilineTextAlignment(.center)
        .lineSpacing(4)
        .padding(.top, 16)
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
      
      // 버튼 영역
      HStack(spacing: 0) {
        Button("취소") {
          permissionManager.permissionDialogType = .permissionIntroduction
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(Color.gray.opacity(0.1))
        .foregroundColor(.gray)
        .font(.system(size: 16, weight: .medium))
        
        Button("설정으로 이동") {
          isPresented = false
          onOpenSettings()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(Color.yellow)
        .foregroundColor(.black)
        .font(.system(size: 16, weight: .medium))
      }
    }
  }
  
  // MARK: - Computed Properties
  
  private var iconName: String {
    switch type {
    case .permissionIntroduction:
      return "checkmark"
    case .microphoneDenied:
      return "mic.slash.fill"
    case .speechDenied:
      return "speaker.slash.fill"
    }
  }
  
  private var mainMessage: String {
    switch type {
    case .permissionIntroduction:
      return "권한 허용이 필요합니다"
    case .microphoneDenied:
      return "마이크 접근 권한이 거부되었습니다"
    case .speechDenied:
      return "음성인식 접근 권한이 거부되었습니다"
    }
  }
  
  private var descriptionMessage: String {
    switch type {
    case .permissionIntroduction:
      return "기타 학습을 위해 마이크와 음성인식 권한이 필요합니다."
    case .microphoneDenied:
      return "기타 연주 소리를 듣고 학습 피드백을 드리기 위해 마이크 접근 권한이 필요합니다.\n\n설정에서 마이크 접근을 허용해주세요."
    case .speechDenied:
      return "음성 명령으로 기능을 제어하기 위해 음성인식 접근 권한이 필요합니다.\n\n설정에서 음성인식 접근을 허용해주세요."
    }
  }
}

/// 권한 다이얼로그 타입
enum PermissionDialogType {
  case permissionIntroduction  // 권한 안내
  case microphoneDenied
  case speechDenied
}

// MARK: - Preview

#Preview("권한 안내") {
  @State var isPresented = true
  
  return PermissionDialog(
    isPresented: $isPresented,
    type: .permissionIntroduction,
    onOpenSettings: { print("설정으로 이동") },
    onRequestPermissions: { print("권한 요청") }
  )
  .background(Color.black)
}

#Preview("마이크 권한 거부") {
  @State var isPresented = true
  
  return PermissionDialog(
    isPresented: $isPresented,
    type: .microphoneDenied,
    onOpenSettings: { print("설정으로 이동") },
    onRequestPermissions: { }
  )
  .background(Color.black)
}

#Preview("음성인식 권한 거부") {
  @State var isPresented = true
  
  return PermissionDialog(
    isPresented: $isPresented,
    type: .speechDenied,
    onOpenSettings: { print("설정으로 이동") },
    onRequestPermissions: { }
  )
  .background(Color.black)
}
