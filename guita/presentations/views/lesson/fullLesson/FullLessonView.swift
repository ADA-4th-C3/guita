//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct FullLessonView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    BaseView(
      create: { FullLessonViewModel(router) }
    ) { viewModel, state in
//      PermissionView(
//        permissionListener: { isGranted in
//          if isGranted {
//            viewModel.onPermissionGranted()
//          }
//        }
//      ) {
      VStack(spacing: 0) {
        // MARK: Toolbar
        Toolbar(title: "곡 전체 학습", trailing: {
          IconButton("info", color: .light, isSystemImage: false) {
            router.push(.fullLessonGuide)
          }
        })
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel("사용법 도움말")

        // MARK: Full Song description
        Image("audio-file")
          .resizable()
          .scaledToFit()
          .frame(height: 100)
          .accessibilityHidden(true)
          .padding(87)

        // MARK: Full Song ProgressBar
        SongProgressBar(
          currentTime: state.currentTime,
          totalDuration: state.totalDuration, isPlaying: state.isPlaying
        )
        .accessibilityHidden(true)

        Spacer()
          .padding(.top, 218)

        Button(action: {
          viewModel.play()
        }) {
          Text("다시 듣기")
            .fontKoddi(26, color: .darkGrey, weight: .bold)
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel("다시 듣기")

        Spacer()
          .padding(.bottom, 71)

        // MARK: Controllers
        HStack {
          Button(action: {
            viewModel.decreasePlaybackRate()
          }) {
            Image(viewModel.isMinPlaybackRate() ? "slow-inactive" : "slow-active")
              .renderingMode(.template)
              .resizable()
              .frame(width: 95, height: 95)
              .foregroundColor(.light)
          }
          .disabled(viewModel.isMinPlaybackRate())
          .accessibilityAddTraits(.isButton)
          .accessibilityLabel("느리게")

          Button(action: {
            if state.isPlaying {
              viewModel.pause()
            } else {
              viewModel.play()
            }
          }) {
            Image(state.isPlaying ? "pause" : "play")
              .resizable()
              .frame(width: 95, height: 95)
          }
          .accessibilityAddTraits(.isButton)
          .accessibilityLabel(state.isPlaying ? "일시정지" : "재생")

          Button(action: {
            viewModel.increasePlaybackRate()
          }) {
            Image(viewModel.isMaxPlaybackRate() ? "fast-inactive" : "fast-active")
              .renderingMode(.template)
              .resizable()
              .frame(width: 95, height: 95)
              .foregroundColor(.light)
          }
          .disabled(viewModel.isMaxPlaybackRate())
          .accessibilityAddTraits(.isButton)
          .accessibilityLabel("빠르게")
        }
        .padding(.bottom, 39)
      }
    }
  }
}

// }

#Preview {
  BasePreview {
    FullLessonView()
  }
}
