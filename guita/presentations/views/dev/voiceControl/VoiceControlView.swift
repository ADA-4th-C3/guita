//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct VoiceControlView: View {
  var body: some View {
    BaseView(
      create: { VoiceControlViewModel() }
    ) { viewModel, _ in
      VStack {
        Toolbar(title: "Voice Control")
        
        VStack {
          HStack {
            Button {
              if viewModel.isPlaying {
                viewModel.pause()
              } else {
                viewModel.play()
              }
            } label: {
              Image(systemName: viewModel.isPlaying ? "pause.circle" : "play.circle")
                .font(.largeTitle)
            }
            
            Slider(value: Binding(
              get: { viewModel.currentTime },
              set: { newValue in viewModel.currentTime = newValue }
            ), in: 0 ... viewModel.totalTime) { editing in
              if editing {
                if viewModel.isPlaying {
                  viewModel.pause()
                }
              } else {
                viewModel.player?.currentTime = viewModel.currentTime
                viewModel.play()
              }
            }
          }
          
          HStack {
            Text("\(formatTime(viewModel.currentTime))")
            Spacer()
            Text("\(formatTime(viewModel.totalTime))")
          }
        }
        .animation(.linear(duration: 0.1), value: viewModel.currentTime)
        .padding()
        
        Spacer()
        
        VStack(spacing: 8) {
          Button {
            if viewModel.isListening {
              viewModel.stopListening()
            } else {
              viewModel.startListening()
            }
          } label: {
            Image(systemName: viewModel.isListening ? "mic.fill" : "mic")
              .font(.largeTitle)
              .foregroundColor(viewModel.isListening ? .red : .blue)
              .padding()
          }
          
          Button {
            viewModel.clearRecognizedText()
          } label: {
            Image(systemName: "trash")
              .font(.title2)
              .foregroundColor(.red)
          }
          .disabled(viewModel.recognizedText.isEmpty)
          .padding()
          
          ScrollView {
            Text(viewModel.recognizedText.isEmpty ? "음성을 인식 중..." : viewModel.recognizedText)
              .padding()
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(Color.gray.opacity(0.1))
              .cornerRadius(8)
          }
          .frame(height: 150)
          
          // CoreML 예측 결과 (나중에 사용)
          VStack(spacing: 4) {
            Text("예측 결과: \(viewModel.predictedLabel)")
              .font(.headline)
            
            Text(String(format: "정확도: %.2f%%", viewModel.confidence * 100))
              .font(.subheadline)
          }
          .padding(.top, 8)
          .opacity(0.3) // 비활성화 표시
        }
        
        Spacer()
      }
    }
  }
  
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
