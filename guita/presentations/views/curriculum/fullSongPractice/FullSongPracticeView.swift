//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 곡 전체 학습 화면
/// 완전한 음악 파일을 재생하며 전체 곡 연습을 제공
struct FullSongPracticeView: View {
  @EnvironmentObject var router: Router
  let song: SongModel
  
  var body: some View {
    BaseView(
      create: { FullSongPracticeViewModel() }
    ) { viewModel, state in
      VStack(spacing: 0) {
        // 커스텀 툴바
        customToolbar
        
        // 메인 콘텐츠
        mainContent(viewModel: viewModel, state: state)
      }
      .background(Color.black)
      .onAppear {
        viewModel.setupAudio()
      }
      .onDisappear {
        viewModel.cleanup()
      }
    }
  }
  
  // MARK: - Custom Toolbar
  
  /// 뒤로가기 버튼과 도움말 버튼이 있는 커스텀 툴바
  private var customToolbar: some View {
    HStack {
      IconButton("chevron.left") {
        router.pop()
      }
      
      Spacer()
      
      Text("곡 전체 학습")
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundColor(.white)
      
      Spacer()
      
      IconButton("info.circle") {
        router.push(.fullSongPracticeHelp)
      }
    }
    .padding(.horizontal, 16)
    .frame(height: 56)
  }
  
  // MARK: - Main Content
  
  /// 메인 콘텐츠 섹션
  private func mainContent(
    viewModel: FullSongPracticeViewModel,
    state: FullSongPracticeViewState
  ) -> some View {
    VStack(spacing: 60) {
      Spacer()
      
      // 음악 파일 아이콘
      musicFileIcon(state: state)
      
      // 재생 진행바와 시간 표시
      playbackSection(viewModel: viewModel, state: state)
      
      Spacer()
      
      // 재생 속도 조절
      playbackSpeedControl(viewModel: viewModel, state: state)
      
      Spacer()
      
      // 재생 컨트롤 버튼
      playbackControlButton(viewModel: viewModel, state: state)
      
      Spacer()
    }
    .padding(.horizontal, 20)
  }
  
  // MARK: - Music File Icon
  
  /// 음악 파일 아이콘
  private func musicFileIcon(state: FullSongPracticeViewState) -> some View {
    VStack(spacing: 12) {
      Image(systemName: "doc.text.below.ecg")
        .font(.system(size: 80))
        .foregroundColor(.white)
        .opacity(state.isAudioReady ? 1.0 : 0.5)
        .animation(.easeInOut(duration: 0.3), value: state.isAudioReady)
      
      if !state.isAudioReady {
        Text("오디오 로딩 중...")
          .font(.caption)
          .foregroundColor(.gray)
      }
    }
  }
  
  // MARK: - Playback Section
  
  /// 재생 진행바와 시간 표시 섹션
  private func playbackSection(
    viewModel: FullSongPracticeViewModel,
    state: FullSongPracticeViewState
  ) -> some View {
    VStack(spacing: 12) {
      // 재생 진행바
      playbackProgressBar(viewModel: viewModel, state: state)
      
      // 시간 표시
      timeDisplay(viewModel: viewModel, state: state)
    }
  }
  
  /// 재생 진행바
  private func playbackProgressBar(
    viewModel: FullSongPracticeViewModel,
    state: FullSongPracticeViewState
  ) -> some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        // 배경 트랙
        Rectangle()
          .frame(height: 4)
          .foregroundColor(.gray.opacity(0.3))
          .cornerRadius(2)
        
        // 진행 트랙
        Rectangle()
          .frame(width: geometry.size.width * CGFloat(state.progress), height: 4)
          .foregroundColor(.white)
          .cornerRadius(2)
          .animation(.linear(duration: 0.1), value: state.progress)
        
        // 드래그 핸들
        Circle()
          .frame(width: 16, height: 16)
          .foregroundColor(.white)
          .offset(x: geometry.size.width * CGFloat(state.progress) - 8)
          .animation(.linear(duration: 0.1), value: state.progress)
      }
    }
    .frame(height: 16)
    .padding(.horizontal, 20)
    .gesture(progressBarDragGesture(viewModel: viewModel))
  }
  
  /// 진행바 드래그 제스처
  private func progressBarDragGesture(viewModel: FullSongPracticeViewModel) -> some Gesture {
    DragGesture()
      .onChanged { value in
        let screenWidth = UIScreen.main.bounds.width - 80 // 패딩 고려
        let newProgress = min(max(0, value.location.x / screenWidth), 1)
        viewModel.seekTo(progress: newProgress)
      }
  }
  
  /// 시간 표시
  private func timeDisplay(
    viewModel: FullSongPracticeViewModel,
    state: FullSongPracticeViewState
  ) -> some View {
    HStack {
      Text(viewModel.formatTime(state.currentTime))
        .font(.caption)
        .foregroundColor(.gray)
      
      Spacer()
      
      Text(viewModel.formatTime(state.totalTime))
        .font(.caption)
        .foregroundColor(.gray)
    }
    .padding(.horizontal, 20)
  }
  
  // MARK: - Playback Speed Control
  
  /// 재생 속도 조절 섹션
  private func playbackSpeedControl(
    viewModel: FullSongPracticeViewModel,
    state: FullSongPracticeViewState
  ) -> some View {
    PlaybackSpeedControl(
      currentSpeed: state.playbackSpeed,
      speeds: [0.5, 1.0, 1.5],
      onSpeedChanged: { speed in
        viewModel.setPlaybackSpeed(speed)
      }
    )
  }
  
  // MARK: - Playback Control Button
  
  /// 재생/일시정지 컨트롤 버튼
  private func playbackControlButton(
    viewModel: FullSongPracticeViewModel,
    state: FullSongPracticeViewState
  ) -> some View {
    Button(action: {
      if state.isPlaying {
        viewModel.pause()
      } else {
        viewModel.play()
      }
    }) {
      Image(systemName: state.isPlaying ? "pause.fill" : "play.fill")
        .font(.system(size: 24))
        .foregroundColor(.yellow)
    }
    .frame(width: 80, height: 80)
    .background(Color.gray.opacity(0.3))
    .clipShape(Circle())
    .disabled(!state.isAudioReady)
    .opacity(state.isAudioReady ? 1.0 : 0.5)
    .scaleEffect(state.isPlaying ? 1.1 : 1.0)
    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: state.isPlaying)
  }
}
