//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 곡 구간 학습 화면
/// 코드 진행을 단계별로 연습하며 실시간 코드 인식을 제공
struct SectionPracticeView: View {
  @EnvironmentObject var router: Router
  let song: SongModel
  
  var body: some View {
    BaseView(
      create: { SectionPracticeViewModel() },
      needsPermissions: true
    ) { viewModel, state in
      VStack(spacing: 0) {
        // 커스텀 툴바
        Toolbar(
          title: "곡 구간 학습",
          trailing: {
            IconButton("info.circle") {
              router.push(.sectionPracticeHelp)
            }
          }
        )
        
        // 메인 콘텐츠
        mainContent(viewModel: viewModel, state: state)
      }
      .background(Color.black)
      .onAppear {
        viewModel.startPractice()
      }
      .onDisappear {
        viewModel.stopPractice()
      }
    }
  }
  
  // MARK: - Main Content
  
  /// 메인 콘텐츠 섹션
  private func mainContent(
    viewModel: SectionPracticeViewModel,
    state: SectionPracticeViewState
  ) -> some View {
    VStack(spacing: 40) {
      Spacer()
      
      // 단계 표시
      stepIndicator(state: state)
      
      // 곡 구간 콘텐츠
      sectionContent(state: state)
      
      Spacer()
      
      // 재생 속도 조절
      playbackSpeedControl(viewModel: viewModel, state: state)
      
      Spacer()
      
      // 하단 네비게이션
      bottomNavigation(viewModel: viewModel, state: state)
    }
    .padding(.horizontal, 20)
  }
  
  // MARK: - Step Indicator
  
  /// 현재 구간을 표시하는 인디케이터
  private func stepIndicator(state: SectionPracticeViewState) -> some View {
    Text("\(state.currentSection)/\(state.totalSections) 단계")
      .font(.caption)
      .foregroundColor(.gray)
  }
  
  // MARK: - Section Content
  
  /// 구간별 콘텐츠 (코드 진행 또는 완료 메시지)
  private func sectionContent(state: SectionPracticeViewState) -> some View {
    VStack(spacing: 24) {
      if state.currentSection <= state.totalSections {
        // 코드 진행 표시
        ChordProgressionView(
          chords: state.currentChordProgression,
          currentChordIndex: state.currentChordIndex
        )
      } else {
        // 완료 상태
        completionMessage
      }
    }
  }
  
  /// 완료 메시지
  private var completionMessage: some View {
    VStack(spacing: 16) {
      Text("🎵")
        .font(.system(size: 60))
      
      Text("곡 학습이\n종료되었습니다.")
        .font(.title2)
        .fontWeight(.medium)
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
    }
  }
  
  // MARK: - Playback Speed Control
  
  /// 재생 속도 조절 섹션
  private func playbackSpeedControl(
    viewModel: SectionPracticeViewModel,
    state: SectionPracticeViewState
  ) -> some View {
    PlaybackSpeedControl(
      currentSpeed: state.playbackSpeed,
      speeds: [0.5, 1.0, 1.5],
      onSpeedChanged: { speed in
        viewModel.setPlaybackSpeed(speed)
      }
    )
  }
  
  // MARK: - Bottom Navigation
  
  /// 하단 네비게이션 (이전/다음 버튼, 음성 시각화)
  private func bottomNavigation(
    viewModel: SectionPracticeViewModel,
    state: SectionPracticeViewState
  ) -> some View {
    HStack(spacing: 0) {
      // 이전 버튼
      navigationButton(
        iconName: "chevron.left",
        isEnabled: state.currentSection > 1,
        action: { viewModel.previousSection() }
      )
      
      Spacer()
      
      // 음성 시각화
      AudioVisualizationView(
        isListening: state.isListening,
        recognizedCode: state.recognizedCode
      )
      
      Spacer()
      
      // 다음 버튼
      navigationButton(
        iconName: "chevron.right",
        isEnabled: state.currentSection < state.totalSections,
        action: { viewModel.nextSection() }
      )
    }
    .padding(.horizontal, 40)
    .padding(.bottom, 40)
  }
  
  // MARK: - Navigation Button
  
  /// 네비게이션 버튼 (이전/다음)
  private func navigationButton(
    iconName: String,
    isEnabled: Bool,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Image(systemName: iconName)
        .font(.title)
        .foregroundColor(isEnabled ? .white : .gray)
    }
    .disabled(!isEnabled)
    .opacity(isEnabled ? 1.0 : 0.3)
  }
}
