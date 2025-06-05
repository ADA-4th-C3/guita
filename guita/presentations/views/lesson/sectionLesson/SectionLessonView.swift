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
          Toolbar(title: "곡 구간 학습", accessibilityText: "칼립소 주법을 이용해 곡을 구간으로 나누어 학습할 수 있습니다. 레슨을 시작하려면 재생이라고 말하세요.", trailing: {
            IconButton("info", color: .light, isSystemImage: false) {
              router.push(.sectionLessonGuide)
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel("사용법 도움말")
          })
          Spacer()
            .aspectRatio(2.5, contentMode: .fit)

          // MARK: Index
          Text("\(state.currentStepIndex + 1)/\(state.steps.count) 단계")
            .fontKoddi(22, color: .darkGrey)
            .padding(.top, 16)
            .accessibilityHidden(true)

          // MARK: Step description
          if let firstInfo = state.currentStep.sectionLessonInfo.first {
            ChordProgressionBar(chords: firstInfo.chords)
              .accessibilityHidden(true)
          }

          Spacer()
            .aspectRatio(1, contentMode: .fit)

          // MARK: Controllers
          HStack {
            IconButton("chevron-left", size: 95, disabled: state.currentStepIndex == 0) {
              viewModel.previousStep()
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel(state.currentStepIndex == 0 ? "이전 (비활성화)" : "이전")
              .accessibilityAddTraits([.isButton, .startsMediaSession])

            IconButton("play", color: .accent, size: 95) {
              viewModel.play()
            }
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("재생")
            .accessibilityAddTraits([.isButton, .startsMediaSession])

            IconButton("chevron-right", size: 95, disabled: state.currentStepIndex == state.steps.count - 1) {
              viewModel.nextStep()
            }
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("다음")
            .accessibilityAddTraits([.isButton, .startsMediaSession])
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
