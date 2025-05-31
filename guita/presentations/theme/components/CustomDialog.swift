//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 커스텀 다이얼로그 컴포넌트
struct CustomDialog<Content: View>: View {
  
  @Binding var isPresented: Bool
  let content: () -> Content
  
  var body: some View {
    ZStack {
      // 배경 딤처리
      Color.black.opacity(0.6)
        .ignoresSafeArea()
        .onTapGesture {
          isPresented = false
        }
      
      // 다이얼로그 컨텐츠
      VStack(spacing: 0) {
        // 메인 콘텐츠 영역 (흰색 배경)
        VStack(spacing: 0) {
          content()
        }
        .background(Color.white)
        .cornerRadius(12)
        
      }
      .padding(.horizontal, 40)
    }
  }
}

// 특정 모서리만 라운드 처리를 위한 extension
extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
}

struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}

#Preview("권한 안내 다이얼로그") {
  @Previewable @State var isPresented = true
  
  return CustomDialog(isPresented: $isPresented) {
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
        isPresented = false
      }
      .frame(maxWidth: .infinity)
      .frame(height: 50)
      .background(Color.yellow)
      .foregroundColor(.black)
      .font(.system(size: 16, weight: .medium))
    }
  }
  .background(Color.black)
}

#Preview("권한 거부 다이얼로그") {
  @Previewable @State var isPresented = true
  
  return CustomDialog(isPresented: $isPresented) {
    VStack(spacing: 0) {
      // 상단 아이콘 영역
      VStack(spacing: 16) {
        // 경고 아이콘
        ZStack {
          Circle()
            .fill(Color.red.opacity(0.1))
            .frame(width: 60, height: 60)
          
          Image(systemName: "mic.slash.fill")
            .font(.system(size: 24))
            .foregroundColor(.red)
        }
        
        // 메인 메시지
        Text("마이크 접근 권한이 거부되었습니다")
          .font(.system(size: 16, weight: .medium))
          .foregroundColor(.black)
      }
      .padding(.top, 30)
      .padding(.horizontal, 20)
      
      // 설명 텍스트
      Text("기타 연주 소리를 듣고 학습 피드백을 드리기 위해 마이크 접근 권한이 필요합니다.\n\n설정에서 마이크 접근을 허용해주세요.")
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
          isPresented = false
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(Color.gray.opacity(0.1))
        .foregroundColor(.gray)
        .font(.system(size: 16, weight: .medium))
        
        Button("설정으로 이동") {
          isPresented = false
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(Color.yellow)
        .foregroundColor(.black)
        .font(.system(size: 16, weight: .medium))
      }
    }
  }
  .background(Color.black)
}

#Preview("간단한 다이얼로그") {
  @Previewable @State var isPresented = true
  
  return CustomDialog(isPresented: $isPresented) {
    VStack(spacing: 20) {
      Text("간단한 메시지")
        .font(.headline)
        .foregroundColor(.black)
        .padding(.top, 20)
      
      Text("이것은 간단한 다이얼로그 예시입니다.")
        .font(.subheadline)
        .foregroundColor(.gray)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 20)
      
      Button("확인") {
        isPresented = false
      }
      .frame(maxWidth: .infinity)
      .frame(height: 50)
      .background(Color.yellow)
      .foregroundColor(.black)
      .font(.system(size: 16, weight: .medium))
    }
  }
  .background(Color.black)
}
