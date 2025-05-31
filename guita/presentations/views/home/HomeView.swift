//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct HomeView: View {
  @EnvironmentObject var router: Router
  
  var body: some View {
    BaseView(
      create: { HomeViewModel() }
    ) { _, _ in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "Guita", isPopButton: false)
        Spacer()
        
        // 기타학습 버튼 제거하거나 숨김 처리
        // 필요시 다른 UI 요소들 추가
        
        Spacer()
      }
    }
  }
}

#Preview {
  BasePreview {
    HomeView()
  }
}
