//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct MicrophoneDeniedStepView: View {
  let onOpenSettings: () -> Void
  
  var body: some View {
    VStack(spacing: 24) {
      Text("음성 명령 기능을 사용하려면\n'음성인식' 접근권한을 허용해주세요.\n음성 명령 기능을 사용하고 싶으면 '설정'\n버튼을 눌러 '음성인식' 접근을 허용해주세\n요.")
        .font(.headline)
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
      
      HStack(spacing: 40) {
        Button("취소") {
          // 취소 처리는 시스템에서 자동으로 처리됨
        }
        .foregroundColor(.blue)
        
        Button("설정") {
          onOpenSettings()
        }
        .foregroundColor(.blue)
        .fontWeight(.semibold)
      }
      .padding(.top, 20)
    }
  }
}
