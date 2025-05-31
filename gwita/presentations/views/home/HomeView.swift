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
        Button {
          router.push(.curriculum)
        } label: {
          VStack {
            Image("Guitarpick")
              .resizable()
              .frame(width: 46.95, height: 54.17)
              .padding(.vertical, 9.17)
            Text("기타 학습")
              .fontWeight(.bold)
              .font(.system(size: 32))
              .foregroundStyle(.white)
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
