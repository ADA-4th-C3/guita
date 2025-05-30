//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 코드 도움말 화면
struct CodeHelpView: View {
  let codeType: CodeType
  @EnvironmentObject var router: Router
  
  var body: some View {
    VStack(spacing: 0) {
      // 툴바
      Toolbar(title: "\(codeType.rawValue) 코드 도움말")
      
      ScrollView {
        VStack(alignment: .leading, spacing: 24) {
          // 코드 다이어그램
          codeDigramSection
          
          // 손가락 배치 설명
          fingerPositionSection
          
          // 연주 팁
          playingTipsSection
          
          Spacer(minLength: 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
      }
    }
    .background(Color.black)
  }
  
  private var codeDigramSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("코드 다이어그램")
        .font(.headline)
        .foregroundColor(.white)
      
      // 코드 다이어그램 표시 영역
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.gray.opacity(0.2))
        .frame(height: 200)
        .overlay(
          Text("🎸\n\(codeType.rawValue) 코드 다이어그램")
            .font(.title2)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
        )
    }
  }
  
  private var fingerPositionSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("손가락 배치")
        .font(.headline)
        .foregroundColor(.white)
      
      VStack(alignment: .leading, spacing: 8) {
        fingerPositionRow("검지", "2번 프렛 4번줄")
        fingerPositionRow("중지", "2번 프렛 3번줄")
        fingerPositionRow("약지", "2번 프렛 2번줄")
      }
    }
  }
  
  private func fingerPositionRow(_ finger: String, _ position: String) -> some View {
    HStack {
      Text("• \(finger):")
        .foregroundColor(.yellow)
        .fontWeight(.medium)
      
      Text(position)
        .foregroundColor(.white)
      
      Spacer()
    }
  }
  
  private var playingTipsSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("연주 팁")
        .font(.headline)
        .foregroundColor(.white)
      
      VStack(alignment: .leading, spacing: 8) {
        tipRow("손가락을 프렛 바로 뒤에 정확히 배치하세요")
        tipRow("손목을 곧게 펴고 자연스럽게 유지하세요")
        tipRow("처음에는 천천히, 정확하게 연습하세요")
        tipRow("각 줄이 명확하게 울리는지 확인하세요")
      }
    }
  }
  
  private func tipRow(_ tip: String) -> some View {
    HStack(alignment: .top) {
      Text("💡")
        .font(.caption)
      
      Text(tip)
        .foregroundColor(.gray)
        .font(.caption)
        .fixedSize(horizontal: false, vertical: true)
      
      Spacer()
    }
  }
}

