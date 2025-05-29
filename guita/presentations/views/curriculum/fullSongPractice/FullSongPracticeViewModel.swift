//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import AVFoundation

final class FullSongPracticeViewModel: BaseViewModel<FullSongPracticeViewState> {
  
  private let audioPlayer = AudioPlayer()
  
  init() {
    super.init(state: FullSongPracticeViewState(
      isPlaying: false,
      currentTime: 0.0,
      totalTime: 0.0,
      progress: 0.0,
      playbackSpeed: 1.0,
      isAudioReady: false
    ))
    Logger.d("FullSongPracticeViewModel 초기화")
  }
  
  
  func setupAudio() {
    // 오디오 설정 로직
    emit(state.copy(isAudioReady: true))
  }
  
  func play() {
    audioPlayer.play()
    emit(state.copy(isPlaying: true))
  }
  
  func pause() {
    audioPlayer.pause()
    emit(state.copy(isPlaying: false))
  }
  
  func seekTo(progress: Double) {
    let newTime = state.totalTime * progress
    audioPlayer.seek(to: newTime)
    emit(state.copy(currentTime: newTime, progress: progress))
  }
  
  func setPlaybackSpeed(_ speed: Double) {
    emit(state.copy(playbackSpeed: speed))
  }
  
  func formatTime(_ time: TimeInterval) -> String {
    let seconds = Int(time) % 60
    let minutes = Int(time) / 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
  
  func cleanup() {
    audioPlayer.dispose()
  }
  
  override func dispose() {
    cleanup()
    super.dispose()
  }
}
