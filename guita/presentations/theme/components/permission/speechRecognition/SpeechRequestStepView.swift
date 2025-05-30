//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct SpeechRequestStepView: View {
  let onConfirm: () -> Void
  
  var body: some View {
    VStack(spacing: 24) {
      Text("'Guita'이(가) 음성인식에\n접근하려고 합니다.")
        .font(.headline)
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
      
      Text("사용자의 음성을 처리하기 위해 이 앱이 음성\n데이터가 Apple에 전송됩니다. 이는 Apple\n의 음성인식 기능 향상에도 도움이 됩니다.\n\n음성 명령으로 기능을 제어하기 위해 음성 인\n식 권한이 필요합니다.")
        .font(.subheadline)
        .multilineTextAlignment(.center)
        .foregroundColor(.gray)
      
      HStack(spacing: 40) {
        Button("허용 안 함") {
          // 거부 처리는 시스템에서 자동으로 처리됨
        }
        .foregroundColor(.blue)
        
        Button("허용") {
          onConfirm()
        }
        .foregroundColor(.blue)
        .fontWeight(.semibold)
      }
      .padding(.top, 20)
    }
  }
}
