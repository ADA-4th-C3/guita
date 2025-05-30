//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct PermissionInfoRow: View {
  let title: String
  let description: String
  
  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      // 아이콘
      Image(systemName: "checkmark.circle.fill")
        .font(.system(size: 16))
        .foregroundColor(.yellow)
        .padding(.top, 2)
      
      // 텍스트 정보
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.subheadline)
          .fontWeight(.medium)
          .foregroundColor(.white)
        
        Text(description)
          .font(.caption)
          .foregroundColor(.gray)
          .fixedSize(horizontal: false, vertical: true)
      }
      
      Spacer()
    }
  }
}

#Preview {
  VStack(spacing: 16) {
    PermissionInfoRow(
      title: "음성 인식(필수)",
      description: "음성 명령으로 기능 제어시 사용"
    )
    
    PermissionInfoRow(
      title: "마이크(필수)",
      description: "기타 연주 소리를 듣고 학습 피드백 드리기 위해 마이크 접근 권한이 필요"
    )
  }
  .padding()
  .background(Color.black)
}
