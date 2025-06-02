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
        Toolbar(title: "Guita", isPopButton: false, trailing: {
          Button("Dev") {
            router.push(.dev)
          }
        })
        Spacer()
<<<<<<< HEAD
        
        // 기타학습 버튼 제거하거나 숨김 처리
        // 필요시 다른 UI 요소들 추가
        
        Spacer()
=======
        Button {
          router.push(.curriculum)
        } label: {
          VStack {
            Image("pick")
              .resizable()
              .frame(width: 46.95, height: 54.17)
              .padding(.vertical, 9.17)
            Text("기타 학습")
              .fontWeight(.bold)
              .font(.system(size: 32))
              .foregroundStyle(.light)
          }.offset(y: -40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
>>>>>>> 8690b84b1301a3c2d88814b9f221dd051c749701
      }
    }
  }
}

#Preview {
  BasePreview {
    HomeView()
  }
}
