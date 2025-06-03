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
          Toolbar(title: "Song", trailing: {
            IconButton("info", color: .light, isSystemImage: false) {
              // TODO: IconButton 키우기
              router.push(.sectionLessonGuide)
            }
          })

          Spacer()
            .aspectRatio(2.5, contentMode: .fit)

          // MARK: Index
          Text("\(state.currentStepIndex + 1)/\(state.steps.count) 단계")
            .fontKoddi(22, color: .darkGrey)
            .padding(.top, 16)

          // MARK: Step description
          if let firstInfo = state.currentStep.sectionLessonInfo.first {
            ChordProgressionBar(chords: firstInfo.chords)
          }
          Spacer()
            .aspectRatio(1, contentMode: .fit)

          // MARK: Controllers
          HStack {
            IconButton("chevron-left", color: .light, size: 95, isSystemImage: false) {
              viewModel.previousStep()
            }
            IconButton("play", size: 95, isSystemImage: false) {
              viewModel.play()
            }
            IconButton("chevron-right", color: .light, size: 95, isSystemImage: false) {
              viewModel.nextStep()
            }
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
