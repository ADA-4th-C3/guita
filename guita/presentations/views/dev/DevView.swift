//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct DevView: View {
  var body: some View {
    BaseView(
      create: { DevViewModel() }
    ) { viewModel, state in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "Development")
        
        Form {
          // MARK: Features
          Section(header: Text("Features")) {
            Tile(title: "플랫 주파수 분석") {
            }
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    DevView()
  }
}
