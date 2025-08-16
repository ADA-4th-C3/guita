//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct BottomController: View {

  let previousDisabled: Bool
  let isIntroduction: Bool
  let description: String
  let nextChordAccessibilityHint: String

  let goPrevious: () -> Void
  let play: () -> Void
  let goNext: () -> Void

  init(
    previousDisabled: Bool,
    isIntroduction: Bool,
    description: String,
    nextChordAccessibilityHint: String,
    goPrevious: @escaping () -> Void,
    play: @escaping () -> Void,
    goNext: @escaping () -> Void,
  ) {
    self.previousDisabled = previousDisabled
    self.isIntroduction = isIntroduction
    self.description = description
    self.nextChordAccessibilityHint = nextChordAccessibilityHint
    self.goPrevious = goPrevious
    self.play = play
    self.goNext = goNext
  }

  var body: some View {
    HStack(spacing: 42) {
      // MARK: goPrevious
      Button(action: goPrevious) {
        Image("chevron-left")
          .resizable()
          .scaledToFit()
          .frame(width: 75, height: 75)
      }
      .disabled(previousDisabled)
      .opacity(previousDisabled ? 0.5 : 1.0)
      .accessibilityRespondsToUserInteraction(!previousDisabled)
      .accessibilityLabel(
        NSLocalizedString("ChordLesson.Button.Previous.Label", comment: "")
      )
      .accessibilityHint(
        NSLocalizedString(
          isIntroduction ? "ChordLesson.Button.Previous.Hint.Inactive" : "",
          comment: ""
        )
      )

      // MARK: Play
      Button(action: play) {
        Image("play")
          .resizable()
          .scaledToFit()
          .frame(width: 95, height: 95)
      }

      .accessibilityLabel(
        NSLocalizedString("ChordLesson.Button.Play.Label", comment: "")
      )
      .accessibilityHint(
        String(
          format: NSLocalizedString(
            "ChordLesson.Button.Play.Hint",
            comment: ""
          ),
          description
        )
      )
      
      // MARK: Next Button
      Button(action: goNext) {
        Image("chevron-right")
          .resizable()
          .scaledToFit()
          .frame(width: 75, height: 75)
      }
      .accessibilityLabel(
        NSLocalizedString("ChordLesson.Button.Next.Label", comment: "")
      )
      .accessibilityHint(nextChordAccessibilityHint)


    }
  }
}
#Preview {
  BottomController(
    previousDisabled: true,
    isIntroduction: false,
    description: "",
    nextChordAccessibilityHint: "",
    goPrevious: {},
    play: {},
    goNext: {}
  )
}
