//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct FontManager {
  static func applyGlobalFont() {
    // UILabel 폰트 설정
    UILabel.appearance().font = UIFont(name: "KoddiUDOnGothic-Regular", size: 18)
    
    // UIButton 폰트 설정
    UIButton.appearance().titleLabel?.font = UIFont(name: "KoddiUDOnGothic-Bold", size: 22)
    
    // Navigation 폰트 설정
    UINavigationBar.appearance().titleTextAttributes = [
      .font: UIFont(name: "KoddiUDOnGothic-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22)
    ]
  }
}

// SwiftUI용 KoddiUD OnGothic 폰트 확장
extension Font {
  // Regular 폰트들
  static let koddiRegular18 = Font.custom("KoddiUDOnGothic-Regular", size: 18)  // 도움말 설명/단계 안내
  static let koddiRegular22 = Font.custom("KoddiUDOnGothic-Regular", size: 22)
  static let koddiRegular24 = Font.custom("KoddiUDOnGothic-Regular", size: 24)  // 메리말
  static let koddiRegular26 = Font.custom("KoddiUDOnGothic-Regular", size: 26)
  static let koddiRegular32 = Font.custom("KoddiUDOnGothic-Regular", size: 32)
  
  // Bold 폰트들
  static let koddiBold18 = Font.custom("KoddiUDOnGothic-Bold", size: 18)
  static let koddiBold22 = Font.custom("KoddiUDOnGothic-Bold", size: 22)       // 도움말 세분화
  static let koddiBold26 = Font.custom("KoddiUDOnGothic-Bold", size: 26)       // 학습안내
  static let koddiBold32 = Font.custom("KoddiUDOnGothic-Bold", size: 32)       // 큰 버튼
  
  // Extra Bold 폰트들
  static let koddiExtraBold18 = Font.custom("KoddiUDOnGothic-ExtraBold", size: 18)
  static let koddiExtraBold22 = Font.custom("KoddiUDOnGothic-ExtraBold", size: 22)
  static let koddiExtraBold26 = Font.custom("KoddiUDOnGothic-ExtraBold", size: 26)
  static let koddiExtraBold32 = Font.custom("KoddiUDOnGothic-ExtraBold", size: 32)
  
  // 용도별 폰트 정의
  static let appTitle = koddiExtraBold32        // 앱 제목
  static let sectionTitle = koddiBold26         // 섹션 제목/학습안내
  static let buttonLarge = koddiBold32          // 큰 버튼
  static let buttonMedium = koddiBold22         // 중간 버튼
  static let bodyText = koddiRegular18          // 본문/설명
  static let subTitle = koddiRegular24          // 부제목/메리말
  static let caption = koddiRegular18           // 캡션
}
