//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct SectionLessonView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    BaseView(
      create: { SectionLessonViewModel(router) }
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
            title: NSLocalizedString("곡 구간 학습", comment: ""),
            accessibilityHint: NSLocalizedString(
              state.isPermissionGranted
                ? "SectionLesson.Title.Hint.Granted"
                : "SectionLesson.Title.Hint.NotGranted", comment: ""
            ),
            trailing: {
              IconButton("info", color: .light, isSystemImage: false) {
                router.push(.sectionLessonGuide)
              }.accessibilityAddTraits(.isButton)
                .accessibilityLabel("사용법 도움말")
            }
          )

          // MARK: Index
          Text("\(state.currentStepIndex + 1)/\(state.steps.count) 단계")
            .fontKoddi(22, color: .darkGrey)
            .padding(.top, 16)
            .accessibilityHidden(true)

          Spacer()
            .aspectRatio(2.5, contentMode: .fit)

          // MARK: Step description
          if let firstInfo = state.currentStep.sectionLessonInfo.first {
            ChordProgressionBar(chords: firstInfo.chords)
              .accessibilityHidden(true)
          }

          Spacer()
            .aspectRatio(1, contentMode: .fit)

          // MARK: Controllers
          HStack {
            // MARK: Previous Button
            IconButton("chevron-left", size: 95, disabled: state.currentStepIndex == 0) {
              viewModel.previousStep()
            }
            .accessibilityLabel(
              NSLocalizedString("ChordLesson.Button.Previous.Label", comment: "")
            )
            .accessibilityHint(
              NSLocalizedString(state.currentStepIndex == 0 ? "ChordLesson.Button.Previous.Hint.Inactive" : "", comment: "")
            )

            // MARK: Play Button
            IconButton("play", color: .accent, size: 95) {
              viewModel.play()
            }
            .accessibilityLabel(NSLocalizedString("ChordLesson.Button.Play.Label", comment: ""))

            // MARK: Next Button
            IconButton("chevron-right", size: 95, disabled: state.currentStepIndex == state.steps.count - 1) {
              viewModel.nextStep()
            }
            .accessibilityLabel(
              NSLocalizedString("ChordLesson.Button.Next.Label", comment: "")
            )
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    SectionLessonView()
  }
}
