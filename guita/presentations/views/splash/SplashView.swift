//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct SplashView: View {
  @EnvironmentObject var router: Router
  
  var body: some View {
    BaseView(
      create: { SplashViewModel() }
    ) { viewModel, _ in
      VStack {
        Spacer()
        
        // 기타 아이콘 추가
        Image(systemName: "guitars")
          .font(.system(size: 80))
          .foregroundColor(.yellow)
          .padding(.bottom, 20)
        
        // 기타학습 텍스트 표시
        Text("기타 학습")
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.black)
          .padding(.vertical, 18)
          .padding(.horizontal, 40)
          .background(Color.yellow)
          .cornerRadius(12)
        
        Spacer().frame(height: 40)
        
        Loading()
        
        Spacer()
      }
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // 2초간 기타학습 텍스트 보여줌
          viewModel.onLoaded()
          router.setRoot(.home) // 홈으로 이동 후
          
          // 바로 기타학습으로 자동 이동
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
