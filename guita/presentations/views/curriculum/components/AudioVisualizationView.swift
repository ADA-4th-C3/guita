//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 오디오 인식 상태와 인식된 코드를 시각화하는 컴포넌트
/// 파형 애니메이션과 코드 표시를 담당
struct AudioVisualizationView: View {
  
  // MARK: - Properties
  
  let isListening: Bool              // 오디오 인식 중인지 여부
  let recognizedCode: String         // 인식된 코드명
  
  // MARK: - Animation Properties
  
  @State private var animationPhase = 0.0
  
  // MARK: - Body
  
  var body: some View {
    VStack(spacing: 12) {
      // 파형 시각화
      waveformVisualization
      
      // 인식된 코드 표시
      if !recognizedCode.isEmpty {
        recognizedCodeDisplay
      }
    }
  }
  
  // MARK: - Waveform Visualization
  
  /// 파형 시각화 - 5개의 막대로 구성된 오디오 파형
  private var waveformVisualization: some View {
    HStack(spacing: 3) {
      ForEach(0..<5, id: \.self) { index in
        waveformBar(index: index)
      }
    }
    .onAppear {
      startAnimation()
    }
    .onChange(of: isListening) { _, newValue in
      if newValue {
        startAnimation()
      } else {
        stopAnimation()
      }
    }
  }
  
  /// 개별 파형 막대
  private func waveformBar(index: Int) -> some View {
    RoundedRectangle(cornerRadius: 1.5)
      .frame(width: 3, height: barHeight(for: index))
      .foregroundColor(barColor)
      .animation(.easeInOut(duration: 0.5 + Double(index) * 0.1).repeatForever(autoreverses: true), value: animationPhase)
  }
  
  /// 막대별 높이 계산
  private func barHeight(for index: Int) -> CGFloat {
    if !isListening {
      return 8 // 비활성 상태의 기본 높이
    }
    
    // 애니메이션 위상에 따른 높이 변화
    let baseHeight: CGFloat = 10
    let maxHeight: CGFloat = 25
    let variation = sin(animationPhase + Double(index) * 0.5) * 0.5 + 0.5
    return baseHeight + (maxHeight - baseHeight) * CGFloat(variation)
  }
  
  /// 막대 색상
  private var barColor: Color {
    isListening ? .yellow : .gray
  }
  
  // MARK: - Recognized Code Display
  
  /// 인식된 코드 표시
  private var recognizedCodeDisplay: some View {
    Text(recognizedCode)
      .font(.title2)
      .fontWeight(.bold)
      .foregroundColor(.yellow)
      .padding(.horizontal, 12)
      .padding(.vertical, 6)
      .background(
        RoundedRectangle(cornerRadius: 8)
          .fill(Color.yellow.opacity(0.1))
          .overlay(
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
          )
      )
      .transition(.scale.combined(with: .opacity))
      .animation(.spring(response: 0.3, dampingFraction: 0.6), value: recognizedCode)
  }
  
  // MARK: - Animation Control
  
  /// 애니메이션 시작
  private func startAnimation() {
    guard isListening else { return }
    
    withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
      animationPhase = .pi * 2
    }
  }
  
  /// 애니메이션 중지
  private func stopAnimation() {
    withAnimation(.easeOut(duration: 0.3)) {
      animationPhase = 0
    }
  }
}

// MARK: - Preview

#Preview {
  VStack(spacing: 40) {
    // 비활성 상태
    AudioVisualizationView(
      isListening: false,
      recognizedCode: ""
    )
    
    // 활성 상태 (코드 인식 없음)
    AudioVisualizationView(
      isListening: true,
      recognizedCode: ""
    )
    
    // 활성 상태 (코드 인식됨)
    AudioVisualizationView(
      isListening: true,
      recognizedCode: "A"
    )
  }
  .padding()
  .background(Color.black)
}
