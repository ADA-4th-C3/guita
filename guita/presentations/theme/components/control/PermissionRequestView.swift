//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 권한 요청 및 코드 설명을 표시하는 컴포넌트
/// 1-2단계에서 사용되며, 마이크 권한 요청과 코드 설명을 담당
struct PermissionRequestView: View {
  
  // MARK: - Properties
  
  let step: Int                       // 현재 단계 (1 또는 2)
  let codeType: CodeType             // 학습할 코드 타입
  let onPermissionGranted: () -> Void // 권한 승인 시 호출될 콜백
  
  // MARK: - Body
  
  var body: some View {
    VStack(spacing: 24) {
      if step == 1 {
        microphonePermissionRequest
      } else if step == 2 {
        codeDescriptionView
      }
    }
  }
  
  // MARK: - Microphone Permission Request (Step 1)
  
  /// 1단계: 마이크 권한 요청 화면
  private var microphonePermissionRequest: some View {
    VStack(spacing: 16) {
      // 권한 요청 메시지
      Text("'Guita'이(가) 마이크에\n접근하려고 합니다.")
        .font(.headline)
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
      
      // 권한 필요성 설명
      Text("음성 명령을 사용하려면\n마이크 권한이 필요합니다.")
        .font(.subheadline)
        .foregroundColor(.gray)
        .multilineTextAlignment(.center)
      
      // 권한 선택 버튼들
      HStack(spacing: 20) {
        Button("허용 안 함") {
          Logger.d("마이크 권한 거부")
        }
        .foregroundColor(.blue)
        
        Button("확인") {
          Logger.d("마이크 권한 승인")
          onPermissionGranted()
        }
        .foregroundColor(.blue)
        .fontWeight(.semibold)
      }
      .padding(.top, 16)
    }
  }
  
  // MARK: - Code Description View (Step 2)
  
  /// 2단계: 코드 설명 화면
  private var codeDescriptionView: some View {
    VStack(spacing: 16) {
      // 코드 설명 텍스트
      Text(codeDescriptionText)
        .font(.headline)
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
        .lineSpacing(4)
      
      // 액션 버튼들
      VStack(spacing: 12) {
        Button("취소") {
          Logger.d("코드 설명 취소")
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.3))
        .foregroundColor(.blue)
        .cornerRadius(8)
        
        Button("설정") {
          Logger.d("코드 설명 확인")
          onPermissionGranted()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
      }
      .padding(.top, 8)
    }
  }
  
  // MARK: - Computed Properties
  
  /// 코드별 설명 텍스트
  private var codeDescriptionText: String {
    return "\(codeType.rawValue)코드는 2번 프렛 위에\n검지, 중지, 약지\n총 3 손가락을\n사용하는 코드입니다."
  }
}

// MARK: - Preview

#Preview {
  VStack(spacing: 40) {
    // 1단계 프리뷰
    PermissionRequestView(
      step: 1,
      codeType: .a
    ) {
      print("1단계 권한 승인")
    }
    
    Divider()
    
    // 2단계 프리뷰
    PermissionRequestView(
      step: 2,
      codeType: .a
    ) {
      print("2단계 권한 승인")
    }
  }
  .padding()
  .background(Color.black)
}
