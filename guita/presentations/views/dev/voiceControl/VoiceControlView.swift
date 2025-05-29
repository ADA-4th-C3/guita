// VoiceControlView.swift
import SwiftUI

struct VoiceControlView: View {
  var body: some View {
    BaseView(
      create: { VoiceControlViewModel() }
    ) { viewModel, state in
      VStack {
        // MARK: - Navigation
        Toolbar(title: "Voice Control")
        
        // MARK: - Permission State Handling
        switch state.recordPermissionState {
        case .undetermined:
          Loading()
          
        case .denied:
          // 권한 거부 상태 - 설정으로 안내
          permissionDeniedSection(viewModel: viewModel)
          
        case .granted:
          // 권한 허용 상태 - 메인 기능 표시
          VStack(spacing: 20) {
            audioPlayerSection(viewModel: viewModel, state: state)
            Spacer()
            voiceRecognitionSection(viewModel: viewModel, state: state)
          }
        }
        
        Spacer()
      }
      .onAppear {
        // 뷰가 나타날 때 권한이 미결정 상태면 권한 요청
        if state.recordPermissionState == .undetermined {
          viewModel.requestRecordPermission()
        }
      }
    }
  }
  
  // MARK: - Permission Denied UI
  /// 권한이 거부됐을 때 보여주는 안내 화면
  private func permissionDeniedSection(viewModel: VoiceControlViewModel) -> some View {
    VStack {
      Text("녹음 권한이 필요합니다.")
        .font(.headline)
        .multilineTextAlignment(.center)
        .padding()
      
      Button("설정으로 이동") {
        viewModel.openSettings()
      }
      .buttonStyle(.borderedProminent)
    }
  }
  
  // MARK: - Audio Player UI
  /// MP3 파일 재생 컨트롤 섹션 (재생/일시정지, 진행바, 시간 표시)
  private func audioPlayerSection(viewModel: VoiceControlViewModel, state: VoiceControlViewState) -> some View {
    VStack {
      HStack {
        // 재생/일시정지 버튼
        Button {
          if state.isPlaying {
            viewModel.pause()
          } else {
            viewModel.play()
          }
        } label: {
          Image(systemName: state.isPlaying ? "pause.circle" : "play.circle")
            .font(.largeTitle)
        }
        
        // 재생 위치 조절 슬라이더
        Slider(
          value: Binding(
            get: { state.currentTime },
            set: { viewModel.seek(to: $0) }
          ),
          in: 0...state.totalTime
        )
      }
      
      // 현재 시간 / 총 시간 표시
      HStack {
        Text(formatTime(state.currentTime))
        Spacer()
        Text(formatTime(state.totalTime))
      }
    }
    .padding()
  }
  
  // MARK: - Voice Recognition UI
  /// 음성 인식 컨트롤 섹션 (마이크 버튼, 텍스트 표시, 초기화 버튼)
  private func voiceRecognitionSection(viewModel: VoiceControlViewModel, state: VoiceControlViewState) -> some View {
    VStack(spacing: 16) {
      // 마이크 ON/OFF 버튼
      Button {
        if state.isListening {
          viewModel.stopListening()
        } else {
          viewModel.startListening()
        }
      } label: {
        Image(systemName: state.isListening ? "mic.fill" : "mic")
          .font(.largeTitle)
          .foregroundColor(state.isListening ? .red : .blue)
          .padding()
      }
      
      // 인식된 텍스트 초기화 버튼 (휴지통)
      Button {
        viewModel.clearRecognizedText()
      } label: {
        Image(systemName: "trash")
          .font(.title2)
          .foregroundColor(.red)
      }
      .disabled(state.recognizedText.isEmpty)
      
      // 인식된 음성 텍스트 표시 영역
      ScrollView {
        VStack {
          Text("디버그: '\(state.recognizedText)'")  // 디버그용 텍스트 추가
            .font(.caption)
            .foregroundColor(.red)
          
          Text(state.recognizedText.isEmpty ? "음성을 인식 중..." : state.recognizedText)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
      }
      .frame(height: 150)
    }
  }
  
  // MARK: - Helper Functions
  /// 시간을 mm:ss 형식으로 포맷팅
  private func formatTime(_ time: TimeInterval) -> String {
    let seconds = Int(time) % 60
    let minutes = Int(time) / 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
}

#Preview {
  BasePreview {
    VoiceControlView()
  }
}
