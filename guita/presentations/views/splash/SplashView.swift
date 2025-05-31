//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct SplashView: View {
  @EnvironmentObject var router: Router
  
  var body: some View {
    BaseView(
      create: { SplashViewModel() }
    ) { viewModel, _ in
      VStack {
        // 기타학습 텍스트 추가
        Text("기타 학습")
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.black)
          .padding(.vertical, 18)
          .padding(.horizontal, 40)
          .background(Color.yellow)
          .cornerRadius(12)
        
        Spacer().frame(height: 20)
        
        Loading()
      }
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // 시간 늘림
          viewModel.onLoaded()
          router.setRoot(.home)
          
          // 추가 딜레이 후 자동으로 기타학습으로 이동
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            router.push(.guitarLearning)
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    SplashView()
  }
}
