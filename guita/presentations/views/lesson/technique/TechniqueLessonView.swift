//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct TechniqueLessonView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    PermissionView {
      BaseView(
        create: { TechniqueLessonViewModel() }
      ) { viewModel, state in
        VStack {
          // MARK: Toolbar
          Toolbar(
            title: NSLocalizedString("주법 학습", comment: ""),
            accessibilityHint: NSLocalizedString("주법을 학습하는 화면입니다. 학습을 시작하고자 하시는 재생버튼을 눌러주세요.", comment: ""),
            trailing: {
            IconButton("info", color: .light, isSystemImage: false) {
              router.push(.techniqueLessonGuide)
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel("사용법 도움말")

          })

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

          // MARK: Button(back/play/next)

          HStack {
            let isFirstStep = (state.currentStepIndex == 0)
            Button(action: {
              if !isFirstStep {
                viewModel.previousStep()
              }
            }) {
              Image("chevron-left")
                .resizable()
                .frame(width: 75, height: 75)
                .padding(.trailing, 42)
            }
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel(isFirstStep ? "이전 (비활성화)" : "이전")
            .opacity(isFirstStep ? 0.5 : 1.0)
            .accessibilityAddTraits([.isButton, .startsMediaSession])

            Button(action: { viewModel.play() }) {
              Image("play")
                .resizable()
                .frame(width: 95, height: 95)
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel("재생")
              .accessibilityAddTraits([.isButton, .startsMediaSession])

            Button(action: {
              viewModel.nextStep()
            }) {
              Image("chevron-right")
                .resizable()
                .frame(width: 75, height: 75)
                .padding(.leading, 42)
            }
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("다음")
            .accessibilityAddTraits([.isButton, .startsMediaSession])
          }
        }.padding(.bottom, 5)
          .onAppear {
            viewModel.startVoiceCommand()
          }
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
