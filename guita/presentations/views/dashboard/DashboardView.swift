//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct DashboardView: View {
  @EnvironmentObject var router: Router
  @State private var selected: String? = nil

  var body: some View {
    BaseView(
      create: {
        DashboardViewModel()
      }
    ) { _, _ in
      VStack {}
    }
  }
}

#Preview {
  BasePreview {
    DashboardView()
  }
}
