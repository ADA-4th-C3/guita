//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct TechniqueLessonView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    BaseView(
      create: { TechniqueLessonViewModel(router) }
    ) { viewModel, state in
      PermissionView(
        permissionListener: { isGranted in
          if isGranted {
            viewModel.onPermissionGranted()
          }
        }
      ) {
        VStack {
          // MARK: Toolbar
          Toolbar(
            title: NSLocalizedString("주법 학습", comment: ""),
            accessibilityHint: NSLocalizedString(
              state.isPermissionGranted
                ? "TechniqueLesson.Title.Hint.Granted"
                : "TechniqueLesson.Title.Hint.NotGranted",
              comment: ""
            ),
            trailing: {
              IconButton("info", color: .light, isSystemImage: false) {
                router.push(.techniqueLessonGuide)
              }
              .accessibilityLabel("사용법 도움말")
            }
          )

          Spacer()

          // MARK: Step/TotalStep
          Text("\(state.currentStepIndex + 1)/\(state.totalStep) 단계")
            .fontKoddi(22, color: .darkGrey, weight: .regular)
            .accessibilityHidden(true)

          // MARK: description
          VStack {
            if let image = viewModel.currentImage() {
              image
                .resizable()
                .scaledToFit()
                .frame(width: 87, height: 95)
            }

            Text(state.currentStep.description)
              .fontKoddi(26, color: .light, weight: .bold)
              .padding(.horizontal, 30)
              .multilineTextAlignment(.center)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .accessibilityHidden(true)

          // MARK: Buttons
          HStack {
            let isFirstStep = (state.currentStepIndex == 0)

            // MARK: Prebious Button
            IconButton("chevron-left", color: .light, size: 95, disabled: isFirstStep) {
              viewModel.previousStep()
            }
            .accessibilityLabel(
              NSLocalizedString("ChordLesson.Button.Previous.Label", comment: "")
            )
            .accessibilityHint(
              NSLocalizedString(isFirstStep ? "ChordLesson.Button.Previous.Hint.Inactive" : "", comment: "")
            )

            // MARK: Play Button
            IconButton("play", color: .accent, size: 95) {
              viewModel.play()
            }
            .accessibilityLabel(NSLocalizedString("ChordLesson.Button.Play.Label", comment: ""))

            // MARK: Next Button
            IconButton("chevron-right", size: 95) {
              viewModel.nextStep()
            }
            .accessibilityLabel(
              NSLocalizedString("ChordLesson.Button.Next.Label", comment: "")
            )
          }
        }
        .padding(.bottom, 5)
        .onDisappear {
          viewModel.dispose()
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    TechniqueLessonView()
  }
}
