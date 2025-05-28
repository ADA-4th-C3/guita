//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct DevView: View {
  @EnvironmentObject var router: Router
  
  var body: some View {
    BaseView(
      create: { DevViewModel() }
    ) { _, _ in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "Development")

        Form {
          // MARK: Features
          Section(header: Text("Features")) {
            Tile(title: "Pitch Classification") {
              router.push(.pitchClassification)
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
