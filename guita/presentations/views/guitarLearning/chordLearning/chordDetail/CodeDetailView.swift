//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

/// 개별 코드의 상세 학습 화면
/// 단계별로 코드 학습을 진행하며 실시간 코드 인식 기능을 제공
struct CodeDetailView: View {
  
  // MARK: - Properties
  
  let song: SongModel           // 선택된 노래 정보
  let chord: Chord        // 학습할 코드 타입
  @EnvironmentObject var router: Router
  
  // MARK: - Body
  
  var body: some View {
    BaseView(
      create: {
        CodeDetailViewModel.create(song: song, chord: chord)
      },
      needsPermissions: true
    ) { viewModel, state in
      VStack(spacing: 0) {
        // 커스텀 툴바
        Toolbar(
          title: "\(chord) 코드",
          subtitle: song.displayTitle,
          trailing: {
            IconButton("info.circle") {
              router.push(.codeHelp(chord))
            }
          }
        )
        
        // 메인 콘텐츠
        mainContent(viewModel: viewModel, state: state)
      }
      .background(Color.black)
      .onAppear {
        viewModel.startLearning()
      }
      .onDisappear {
        viewModel.stopLearning()
      }
    }
  }
  
  // MARK: - Main Content
  
  /// 메인 콘텐츠 섹션
  private func mainContent(
    viewModel: CodeDetailViewModel,
    state: CodeDetailViewState
  ) -> some View {
    VStack(spacing: 40) {
      Spacer()
      
      // 단계 표시
      stepIndicator(state: state)
      
      // 오디오 상태 표시 (디버그용)
      audioStateIndicator(state: state)
      
      // 단계별 콘텐츠
      stepContent(viewModel: viewModel, state: state)
      
      Spacer()
      
      // 하단 네비게이션
      bottomNavigation(viewModel: viewModel, state: state)
    }
    .padding(.horizontal, 20)
  }
  
  // MARK: - Step Indicator
  
  /// 현재 단계를 표시하는 인디케이터
  private func stepIndicator(state: CodeDetailViewState) -> some View {
    VStack(spacing: 8) {
      Text("\(state.currentStep)/\(state.totalSteps) 단계")
        .font(.caption)
        .foregroundColor(.gray)
      
      // 진행률 바
      ProgressView(value: Double(state.currentStep), total: Double(state.totalSteps))
        .progressViewStyle(LinearProgressViewStyle(tint: .yellow))
        .frame(width: 200)
    }
  }
  
  // MARK: - Audio State Indicator (디버그용)
  
  /// 오디오 상태 표시 (개발/테스트용)
  private func audioStateIndicator(state: CodeDetailViewState) -> some View {
    HStack(spacing: 16) {
      // 오디오 상태
      Text(audioStateText(state.audioState))
        .font(.caption)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(audioStateColor(state.audioState))
        .cornerRadius(4)
      
      // 마지막 TTS
      if let lastTTS = state.lastContentTTS {
        Text("마지막: \(lastTTS.prefix(20))...")
          .font(.caption2)
          .foregroundColor(.gray)
          .lineLimit(1)
      }
    }
  }
  
  private func audioStateText(_ audioState: AudioState) -> String {
    switch audioState {
    case .idle: return "대기"
    case .playingTTS: return "TTS 재생"
    case .playingSound: return "사운드 재생"
    case .listeningVoice: return "음성인식 중"
    }
  }
  
  private func audioStateColor(_ audioState: AudioState) -> Color {
    switch audioState {
    case .idle: return .gray
    case .playingTTS: return .blue
    case .playingSound: return .orange
    case .listeningVoice: return .green
    }
  }
  
  // MARK: - Step Content
  
  /// 현재 단계에 맞는 콘텐츠를 표시
  private func stepContent(
    viewModel: CodeDetailViewModel,
    state: CodeDetailViewState
  ) -> some View {
    VStack(spacing: 24) {
      if state.currentStep == state.totalSteps {
        // 완료 단계
        CompletionView(chord: chord)
      } else {
        // 일반 학습 단계
        LearningContentView(
          instruction: state.currentInstruction,
          chord: chord
        )
      }
      
      // 코드 인식 상태 표시
      if !state.recognizedCode.isEmpty {
        recognizedCodeDisplay(state: state)
      }
    }
  }
  
  /// 인식된 코드 표시
  private func recognizedCodeDisplay(state: CodeDetailViewState) -> some View {
    HStack {
      Text("인식된 코드:")
        .font(.caption)
        .foregroundColor(.gray)
      
      Text(state.recognizedCode)
        .font(.headline)
        .fontWeight(.bold)
        .foregroundColor(isCorrectChord(state) ? .green : .red)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
    .background(Color.gray.opacity(0.1))
    .cornerRadius(8)
  }
  
  private func isCorrectChord(_ state: CodeDetailViewState) -> Bool {
    return state.recognizedCode.uppercased() == chord.rawValue.uppercased()
  }
  
  // MARK: - Bottom Navigation
  
  /// 하단 네비게이션 (이전/다음 버튼, 음성 시각화)
  private func bottomNavigation(
    viewModel: CodeDetailViewModel,
    state: CodeDetailViewState
  ) -> some View {
    VStack(spacing: 20) {
      // 음성 명령 안내
      voiceCommandGuide()
      
      // 네비게이션 버튼들
      HStack(spacing: 40) {
        // 이전 버튼
        navigationButton(
          iconName: "chevron.left",
          text: "이전",
          isEnabled: state.currentStep > 1,
          action: { viewModel.previousStep() }
        )
        
        // 음성 시각화
        AudioVisualizationView(
          isListening: state.isListening,
          recognizedCode: state.recognizedCode
        )
        
        // 다음 버튼
        navigationButton(
          iconName: "chevron.right",
          text: "다음",
          isEnabled: state.canProceed,
          action: { viewModel.nextStep() }
        )
      }
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 40)
  }
  
  /// 음성 명령 안내
  private func voiceCommandGuide() -> some View {
    VStack(spacing: 4) {
      Text("음성 명령어")
        .font(.caption)
        .foregroundColor(.gray)
      
      HStack(spacing: 16) {
        commandText("다음")
        commandText("이전")
        commandText("다시")
        commandText("정지")
      }
    }
  }
  
  private func commandText(_ command: String) -> some View {
    Text(command)
      .font(.caption2)
      .padding(.horizontal, 6)
      .padding(.vertical, 2)
      .background(Color.yellow.opacity(0.2))
      .cornerRadius(3)
  }
  
  // MARK: - Navigation Button
  
  /// 네비게이션 버튼 (이전/다음)
  private func navigationButton(
    iconName: String,
    text: String,
    isEnabled: Bool,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      VStack(spacing: 4) {
        Image(systemName: iconName)
          .font(.title2)
        
        Text(text)
          .font(.caption)
      }
      .foregroundColor(isEnabled ? .white : .gray)
    }
    .disabled(!isEnabled)
    .opacity(isEnabled ? 1.0 : 0.3)
  }
}
