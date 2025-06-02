//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct TechniqueView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    PermissionView {
      BaseView(
        create: { TechniqueViewModel() }
      ) { viewModel, _ in
        VStack {
          // MARK: Toolbar
          Toolbar(title: "주법 학습", trailing: {
            IconButton("info", color: .light, isSystemImage: false) {
              router.push(.techniqueGuide)
            }
          })

          Spacer()

          // MARK: Step/TotalStep
          Text("\(viewModel.state.currentStep.step)/\(viewModel.state.currentStep.totalSteps) 단계")
            .fontKoddi(22, color: .darkGrey, weight: .regular)

          // MARK: description
          VStack {
            if let image = viewModel.currentImage() {
              image
                .resizable()
                .scaledToFit()
                .frame(width: 87, height: 95)
            }

            Text(viewModel.state.currentStep.description)
              .fontKoddi(26, color: .light, weight: .bold)
              .padding(.horizontal, 30)
          }
          .frame(width: 393, height: 550)

          // MARK: Button(back/play/next)
          HStack {
            Button(action: {
              viewModel.previousStep()
            }) {
              Image("chevron-left")
                .resizable()
                .frame(width: 75, height: 75)
                .padding(.trailing, 42)
            }
            Button(action: { viewModel.play() }) {
              Image("play")
                .resizable()
                .frame(width: 95, height: 95)
            }
            Button(action: {
              viewModel.nextStep()
            }) {
              Image("chevron-right")
                .resizable()
                .frame(width: 75, height: 75)
                .padding(.leading, 42)
            }
            .padding(.vertical, 15)
            .background(Color.black)
          }
        }
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
    TechniqueView()
  }
}
