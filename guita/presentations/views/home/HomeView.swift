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

        Button("코드 학습") {
          router.push(.codeClassification)
        } .padding(.top, 16)
        
        // 메인 기타 학습 버튼
        Button("기타 학습") {
          router.push(.guitarLearning)
        }
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundColor(.black)
        .padding(.vertical, 18)
        .padding(.horizontal, 40)
        .background(Color.yellow)
        .cornerRadius(12)
        
        Button("기타 학습") {
          router.push(.curriculum)
        }

        Button("Development") {
          router.push(.dev)
        }
        .padding(.top, 16)

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
