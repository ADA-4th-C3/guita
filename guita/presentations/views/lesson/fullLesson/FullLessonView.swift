//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct FullLessonView: View {
  @EnvironmentObject var router: Router
  let songInfo: SongInfo

  var body: some View {
    BaseView(
      create: { FullLessonViewModel(router, songInfo) }
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
            title: NSLocalizedString("곡 전체 학습", comment: ""),
            accessibilityHint: NSLocalizedString(state.isPermissionGranted ? "FullLesson.Title.Hint.Granted" : "FullLesson.Title.Hint.NotGranted", comment: ""),
            trailing: {
              IconButton("info", color: .light, isSystemImage: false) {
                router.push(.fullLessonGuide)
              }.accessibilityAddTraits(.isButton)
                .accessibilityLabel("사용법 도움말")
            }
          )

          // MARK: Full Song description
          Image("audio-file")
            .resizable()
            .scaledToFit()
            .accessibilityHidden(true)
            .frame(height: 95)
            .padding(87)

          // MARK: Full Song ProgressBar
          SongProgressBar(
            currentTime: Binding(
              get: { state.currentTime },
              set: viewModel.setCurrentTime
            ),
            totalDuration: state.totalDuration,
            onSliderIncrease: {
              let newCurrentTime = min(state.totalDuration, state.currentTime + state.totalDuration / 10)
              viewModel.setCurrentTime(newCurrentTime)
            },
            onSliderDecrease: {
              let newCurrentTime = max(0, state.currentTime - state.totalDuration / 10)
              viewModel.setCurrentTime(newCurrentTime)
            }
          )

          Spacer()

          Button(action: {
            viewModel.setCurrentTime(0)
          }) {
            Text("다시 듣기")
              .fontKoddi(26, color: .darkGrey, weight: .bold)
          }
          .accessibilityLabel("다시 듣기")

          Spacer()

          // MARK: Controllers
          HStack {
            // MARK: Slow
            IconButton("slow", color: .accent, size: 75, disabled: viewModel.isMinPlaybackRate()) {
              viewModel.decreasePlaybackRate()
            }
            .accessibilityLabel("느리게")

            Spacer()

            // MARK: Play or Pause or Resume
            IconButton(state.playerState.isPlaying ? "pause" : "play", color: .accent, size: 95) {
              switch state.playerState {
              case .paused: viewModel.resume()
              case .stopped: viewModel.play()
              case .playing: viewModel.pause()
              }
            }
            .accessibilityLabel(state.playerState.isPlaying ? "일시정지" : "재생")

            Spacer()

            // MARK: Fast
            IconButton("fast", color: .accent, size: 75, disabled: viewModel.isMaxPlaybackRate()) {
              viewModel.increasePlaybackRate()
            }
            .accessibilityLabel("빠르게")
          }
          .padding(.horizontal, 32)
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    FullLessonView(songInfo: SongInfo.curriculum.first!)
  }
}
