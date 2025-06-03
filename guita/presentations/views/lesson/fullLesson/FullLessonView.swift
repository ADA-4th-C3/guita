//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct FullLessonView: View {
  @EnvironmentObject var router: Router
  
  var body: some View {
    BaseView(
      create: { FullLessonViewModel(router) }
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
          Toolbar(title: "곡 전체 학습", trailing: {
            IconButton("info", color: .light, isSystemImage: false) {
              router.push(.fullLessonGuide)
            }
          })
          .accessibilityAddTraits(.isButton)
          .accessibilityLabel("사용법 도움말")
          
          Spacer()
            .aspectRatio(2.5, contentMode: .fit)
          
          // MARK: Full Song description
          Image("audio-file")
            .scaledToFit()
            .accessibilityHidden(true)
          
          // MARK: Full Song ProgressBar
          SongProgressBar(
            currentTime: state.currentTime,
            totalDuration: state.totalDuration, isPlaying: state.isPlaying
          )
          .accessibilityHidden(true)
          
          Spacer()
            .aspectRatio(1, contentMode: .fit)
          
          Button(action: {
            viewModel.play()
          }) {
            Text("다시 듣기")
              .fontKoddi(26, color: .darkGrey, weight: .bold)
          }
          .accessibilityAddTraits(.isButton)
          .accessibilityLabel("다시 듣기")
          
          Spacer()
            .aspectRatio(0.5, contentMode: .fit)
          
          // MARK: Controllers
          HStack {
            IconButton(viewModel.isMinPlaybackRate() ? "slow-inactive" : "slow-active",
                       color: .light,
                       size: 95,
                       disabled: viewModel.isMinPlaybackRate() == true,
                       isSystemImage: false) {
              viewModel.decreasePlaybackRate()
            }
                       .accessibilityAddTraits(.isButton)
                       .accessibilityLabel("느리게")
            
            IconButton(
              state.isPlaying ? "pause" : "play",
              size: 95,
              isSystemImage: false
            ) {
              if state.isPlaying {
                viewModel.pause()
              } else {
                viewModel.play()
              }
            }
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel(state.isPlaying ? "일시정지" : "재생")
            
            IconButton(viewModel.isMaxPlaybackRate() ? "fast-inactive" : "fast-active",
                       color: .light,
                       size: 95,
                       disabled: viewModel.isMaxPlaybackRate() == true,
                       isSystemImage: false) {
              viewModel.increasePlaybackRate()
            }
                       .accessibilityAddTraits(.isButton)
                       .accessibilityLabel("빠르게")
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    FullLessonView()
  }
}
