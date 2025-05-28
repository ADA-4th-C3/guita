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

        Button("기타 학습") {
          router.push(.curriculum)
        }

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
