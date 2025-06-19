//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordLessonView: View {
  @EnvironmentObject var router: Router
  let chord: Chord
  let chords: [Chord]

  var body: some View {
    BaseView(
      create: { ChordLessonViewModel(router, chord, chords) }
    ) { viewModel, state in
      PermissionView(
        permissionListener: { isGranted in
          if isGranted {
            viewModel.onPermissionGranted()
          }
        }
      ) {
        VStack(spacing: 0) {
          // MARK: Toolbar
          Toolbar(
            title: String(
              format: NSLocalizedString("%@ 코드", comment: ""),
              "\(state.chord.rawValue)"
            ),
            accessibilityHint: String(
              format: NSLocalizedString(
                state.isPermissionGranted ? "ChordLessonView.Accessibility.Description"
                  : "ChordLessonView.Accessibility.Description.NoPermission",
                comment: ""
              ),
              "\(state.chord.rawValue)"
            ),
            trailing: {
              IconButton("info") {
                router.push(.chordLessonGuide)
              }.accessibilityAddTraits(.isButton)
                .accessibilityLabel("사용법 도움말")
            }
          )

          // MARK: Index
          Text("\(state.index + 1)/\(state.totalStep) 단계")
            .fontKoddi(22, color: .darkGrey)
            .padding(.top, 16)
            .accessibilityHidden(true)
          Spacer()

          // MARK: Step description
          Text(state.description)
            .fontKoddi(26, color: .light, weight: .bold)
            .lineSpacing(1.45)
            .multilineTextAlignment(.center)
            .accessibilityHidden(true)

          Spacer()

          // MARK: Controllers
          HStack {
            // MARK: Previous Button
            IconButton("chevron-left", color: .light, size: 95, disabled: state.step == .introduction) {
              viewModel.goPrevious()
            }
            .accessibilityLabel(
              NSLocalizedString("ChordLesson.Button.Previous.Label", comment: "")
            )
            .accessibilityHint(
              NSLocalizedString(state.step == .introduction ? "ChordLesson.Button.Previous.Hint.Inactive" : "", comment: "")
            )

            // MARK: Play Button
            IconButton("play", color: .accent, size: 95) {
              viewModel.play()
            }
            .accessibilityLabel(NSLocalizedString("ChordLesson.Button.Play.Label", comment: ""))
            .accessibilityHint(
              String(
                format: NSLocalizedString("ChordLesson.Button.Play.Hint", comment: ""),
                state.description
              )
            )

            // MARK: Next Button
            IconButton("chevron-right", size: 95) {
              viewModel.goNext()
            }
            .accessibilityLabel(
              NSLocalizedString("ChordLesson.Button.Next.Label", comment: "")
            )
            .accessibilityHint(state.nextChordAccessibilityHint)
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    ChordLessonView(chord: .A, chords: [.A, .E, .B7])
  }
}
