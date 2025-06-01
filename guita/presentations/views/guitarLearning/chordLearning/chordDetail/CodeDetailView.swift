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
        recognizedInputDisplay(state: state)
      }
      
      // 음성인식 텍스트 표시 (새로 추가)
      if !state.recognizedVoiceText.isEmpty {
        voiceRecognitionDisplay(state: state)
      }
    }
  }
  
  /// 음성인식 텍스트 표시 (새로 추가)
  private func voiceRecognitionDisplay(state: CodeDetailViewState) -> some View {
    VStack(spacing: 8) {
      HStack {
        Text("음성인식:")
          .font(.caption)
          .foregroundColor(.gray)
        
        Spacer()
      }
      
      Text(state.recognizedVoiceText)
        .font(.body)
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .fill(Color.blue.opacity(0.1))
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
        )
        .transition(.scale.combined(with: .opacity))
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: state.recognizedVoiceText)
    }
  }
  
  /// 인식된 코드 표시
  private func recognizedInputDisplay(state: CodeDetailViewState) -> some View {
    HStack {
      Text(getRecognitionTypeText(state))
        .font(.caption)
        .foregroundColor(.gray)
      
      Text(state.recognizedCode)
        .font(.headline)
        .fontWeight(.bold)
        .foregroundColor(isCorrectInput(state) ? .green : .yellow)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
    .background(Color.gray.opacity(0.1))
    .cornerRadius(8)
  }
  
  /// 인식 타입에 따른 텍스트 반환 (새로 추가)
  private func getRecognitionTypeText(_ state: CodeDetailViewState) -> String {
    // 현재 단계가 개별 줄 학습인지 확인
    if state.currentStep >= 2 && state.currentStep <= state.totalSteps - 1 {
      return "인식된 노트:"
    } else {
      return "인식된 코드:"
    }
  }

  
  /// 올바른 입력인지 확인
  private func isCorrectInput(_ state: CodeDetailViewState) -> Bool {
    // 현재 단계가 개별 줄 학습인지 확인
    if state.currentStep >= 2 && state.currentStep <= state.totalSteps - 1 {
      // 노트 인식 모드 - 특정 노트와 매칭
      return isCorrectNoteForCurrentStep(state.recognizedCode, currentStep: state.currentStep)
    } else {
      // 코드 인식 모드
      return state.recognizedCode.uppercased() == chord.rawValue.uppercased()
    }
  }
  
  /// 현재 단계에서 올바른 노트인지 확인 (새로 추가)
  private func isCorrectNoteForCurrentStep(_ recognizedNote: String, currentStep: Int) -> Bool {
    // A코드 예시: 2번 프렛 4번줄(F#), 3번줄(C#), 2번줄(E)
    switch currentStep {
    case 2: // 4번줄 학습
      return recognizedNote.contains("F#") || recognizedNote.contains("Gb")
    case 3: // 3번줄 학습
      return recognizedNote.contains("C#") || recognizedNote.contains("Db")
    case 4: // 2번줄 학습
      return recognizedNote.contains("E")
    default:
      return false
    }
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
        
        // 완료되었을 때 다음 코드 버튼, 아니면 다음 버튼
        if state.isCompleted, let nextChord = state.nextChord {
          nextChordButton(chord: nextChord)
        } else {
          navigationButton(
            iconName: "chevron.right",
            text: "다음",
            isEnabled: state.canProceed,
            action: { viewModel.nextStep() }
          )
        }
      }
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 40)
  }

  /// 다음 코드 학습 버튼
  private func nextChordButton(chord: Chord) -> some View {
    Button(action: {
      // B7 코드 학습으로 이동
      let nextSong = SongModel(
        id: "next_chord_\(chord.rawValue)",
        title: "\(chord.rawValue) 코드 학습",
        artist: "코드 학습",
        difficulty: .intermediate,
        requiredCodes: [chord],
        audioFileName: "forStudyGuitar",
        isUnlocked: true,
        isCompleted: false
      )
      router.push(.codeDetail(nextSong, chord))
    }) {
      Text(chord.rawValue)
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(.black)
        .frame(width: 60, height: 60)
        .background(Color.yellow)
        .clipShape(Circle())
    }
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
