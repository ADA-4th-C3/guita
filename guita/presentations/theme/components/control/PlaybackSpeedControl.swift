//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 재생 속도를 조절하는 컴포넌트
/// 0.5X, 1X, 1.5X 속도 선택을 제공
struct PlaybackSpeedControl: View {
  
  // MARK: - Properties
  
  let currentSpeed: Double               // 현재 선택된 속도
  let speeds: [Double]                   // 사용 가능한 속도 배열
  let onSpeedChanged: (Double) -> Void   // 속도 변경 콜백
  
  // MARK: - Body
  
  var body: some View {
    VStack(spacing: 12) {
      // 속도 조절 제목
      Text("재생 속도")
        .font(.caption)
        .foregroundColor(.gray)
      
      // 속도 선택 버튼들
      HStack(spacing: 40) {
        ForEach(speeds, id: \.self) { speed in
          speedButton(for: speed)
        }
      }
    }
  }
  
  // MARK: - Speed Button
  
  /// 개별 속도 선택 버튼
  private func speedButton(for speed: Double) -> some View {
    Button(action: {
      onSpeedChanged(speed)
    }) {
      Text(formatSpeed(speed))
        .font(.caption)
        .fontWeight(.medium)
        .foregroundColor(speed == currentSpeed ? .black : .white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
          RoundedRectangle(cornerRadius: 6)
            .fill(speed == currentSpeed ? Color.yellow : Color.gray.opacity(0.3))
        )
    }
    .buttonStyle(PlainButtonStyle())
  }
  
  // MARK: - Helper Methods
  
  /// 속도를 문자열로 포맷팅
  private func formatSpeed(_ speed: Double) -> String {
    if speed == 1.0 {
      return "1X"
    } else if speed.truncatingRemainder(dividingBy: 1) == 0 {
      return "\(Int(speed))X"
    } else {
      return String(format: "%.1fX", speed)
    }
  }
}

// MARK: - Preview

#Preview {
  VStack(spacing: 20) {
    PlaybackSpeedControl(
      currentSpeed: 1.0,
      speeds: [0.5, 1.0, 1.5]
    ) { speed in
      print("Speed changed to: \(speed)")
    }
    
    PlaybackSpeedControl(
      currentSpeed: 0.5,
      speeds: [0.5, 1.0, 1.5, 2.0]
    ) { speed in
      print("Speed changed to: \(speed)")
    }
  }
  .padding()
  .background(Color.black)
}
