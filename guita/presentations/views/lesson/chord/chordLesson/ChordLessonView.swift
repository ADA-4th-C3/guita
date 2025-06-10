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
            accessibilityText: String(
              format: NSLocalizedString("ChordLessonView.Accessibility.Description", comment: ""),
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
            .fontKoddi(26, color: .light)
            .lineSpacing(1.45)
            .multilineTextAlignment(.center)
            .accessibilityHidden(true)

          Spacer()

          // MARK: Controllers
          HStack {
            IconButton("chevron-left", color: .light, size: 95, disabled: state.step == .introduction) {
              viewModel.goPrevious()
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel(state.step == .introduction ? "이전 (비활성화)" : "이전")
              .accessibilityAddTraits([.isButton, .startsMediaSession])

            IconButton("play", color: .accent, size: 95) {
              viewModel.play()
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel("\(state.description) 재생")
              .accessibilityAddTraits([.isButton, .startsMediaSession])

            IconButton("chevron-right", size: 95) {
              viewModel.goNext()
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel(state.nextChordAccessibilityLabel)
              .accessibilityAddTraits([.isButton, .startsMediaSession])
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
