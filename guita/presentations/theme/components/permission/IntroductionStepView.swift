//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct IntroductionStepView: View {
  let onConfirm: () -> Void
  
  var body: some View {
    VStack(spacing: 24) {
      Image(systemName: "checkmark.shield.fill")
        .font(.system(size: 60))
        .foregroundColor(.yellow)
      
      Text("Guita 앱의 편리한 이용을 위해\n아래 접근권한의 허용이 필요합니다")
        .font(.headline)
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
      
      VStack(alignment: .leading, spacing: 16) {
        PermissionInfoRow(
          title: "음성 인식(필수)",
          description: "음성 명령으로 기능 제어시 사용"
        )
        
        PermissionInfoRow(
          title: "마이크(필수)",
          description: "기타 연주 소리를 듣고 학습 피드백 드리기 위해 마이크 접근 권한이 필요"
        )
      }
      .padding(.top, 20)
      
      Text("* 설정>Guita 앱에서 권한 변경이 가능합니다.")
        .font(.caption)
        .foregroundColor(.gray)
        .padding(.top, 10)
      
      Button("확인") {
        onConfirm()
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 16)
      .background(Color.yellow)
      .foregroundColor(.black)
      .cornerRadius(8)
      .padding(.top, 20)
    }
  }
}
