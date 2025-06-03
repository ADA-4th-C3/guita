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
          Toolbar(title: "\(state.chord.rawValue) 코드", accessibilityText: "\(state.chord.rawValue) 코드를 학습하는 화면입니다. 학습을 시작하고자 하시면 재생버튼을 눌러주세요.", trailing: {
            IconButton("info") {
              router.push(.chordLessonGuide)
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel("사용법 도움말")
          })

          // MARK: Index
          Text("\(state.index + 1)/\(state.totalStep) 단계")
            .fontKoddi(22, color: .darkGrey)
            .padding(.top, 16)
            .accessibilityHidden(true)
          Spacer()

          // MARK: Step description
          Text("\(state.step.getDescription(state.chord, index: state.index))")
            .fontKoddi(26, color: .light)
            .lineSpacing(1.45)
            .multilineTextAlignment(.center)
            .accessibilityHidden(true)

          Spacer()

          // MARK: Controllers
          HStack {
            IconButton("chevron-left", color: .light, size: 95, isSystemImage: false) {
              viewModel.goPrevious()
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel("이전")

            IconButton("play", size: 95, isSystemImage: false) {
              viewModel.play()
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel("재생")

            IconButton("chevron-right", color: .light, size: 95, isSystemImage: false) {
              viewModel.goNext()
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel(viewModel.nextChordAccessibilityLabel)
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
