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
              router.push(.devConfig)
            }
            Tile(title: "Permission") {
              router.push(.devPermission)
            }
          }

          // MARK: Classification
          Section(header: Text("Classification")) {
            Tile(title: "Note Classification") {
              router.push(.devNoteClassification)
            }
            Tile(title: "Code Classification with Similarity") {
              router.push(.devCodeClassificationWithSimilarity)
            }
            Tile(title: "Code Classification with Regression") {
              router.push(.devChordClassificationWithRegression)
            }
          }

          // MARK: Etc
          Section(header: Text("Etc")) {
            Tile(title: "Voice Command") {
              router.push(.devVoiceCommand)
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
