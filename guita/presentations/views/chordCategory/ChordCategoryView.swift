//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordCategoryView: View {
  @EnvironmentObject var router: Router
  @State var selected: String? = nil

  var body: some View {
    BaseView(
      create: {
        ChordCategoryViewModel()
      }
    ) { _, _ in
      VStack {}
    }
  }
}

#Preview {
  ChordCategoryView()
}
