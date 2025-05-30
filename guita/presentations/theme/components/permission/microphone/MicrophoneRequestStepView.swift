//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

// MicrophoneRequestStepView.swift
struct MicrophoneRequestStepView: View {
  let onConfirm: () -> Void
  
  var body: some View {
    VStack(spacing: 24) {
      Text("'Guita'이(가) 마이크에\n접근하려고 합니다.")
        .font(.headline)
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
      
      Text("기타 연주 소리를 듣고 학습 피드백을 드리기 위해 마이크 접근 권한이 필요합니다.")
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
