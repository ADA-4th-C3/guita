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
        Toolbar(title: "Guita", accessibilityText: "귀로 치는 기타, 귀타가 시작되었습니다. 기타 학습을 시작하기 위해서는 기타 학습 버튼을 눌러주십시오.", isPopButton: false, trailing: {
          
          // MARK: Dev Button
          Text("Dev")
          .opacity(0.01)
          .onLongPressGesture {
            router.push(.dev)
          }
        })
        Spacer()
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
      }
    }
  }
}

#Preview {
  BasePreview {
    HomeView()
  }
}
