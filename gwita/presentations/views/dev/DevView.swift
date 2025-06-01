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
          // MARK: General
          Section(header: Text("General")) {
            Tile(title: "Config") {
              router.push(.config)
            }
            Tile(title: "Permission") {
              router.push(.devPermission)
            }
          }

          // MARK: Features
          Section(header: Text("Features")) {
            Tile(title: "Note Classification") {
              router.push(.noteClassification)
            }
            Tile(title: "Code Classification") {
              router.push(.codeClassification)
            }
            Tile(title: "Voice Command") {
              router.push(.voiceCommand)
            }
            Tile(title: "Text To Speech") {
              router.push(.devTextToSpeech)
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
