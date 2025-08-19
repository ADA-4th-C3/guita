//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordDetailView: View {
  @EnvironmentObject var router: Router
  @State var selected: String? = nil

  var body: some View {
    BaseView(
      create: {
        ChordDetailViewModel()
      }
    ) { _, _ in
      VStack {}
    }
  }
}

#Preview {
  BasePreview {
    ChordDetailView()
  }
}
