//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import AVFoundation

/// 곡 전체 학습 화면의 ViewModel
/// 오디오 재생 및 진행 상태를 관리
final class FullSongPracticeViewModel: BaseViewModel<FullSongPracticeViewState> {
  
  // MARK: - Dependencies
  
  private let audioPlayer = AudioPlayer()
  
  // MARK: - Private Properties
  
  private var progressTimer: Timer?
  
  // MARK: - Initializer
  
  init() {
    super.init(state: FullSongPracticeViewState())
    Logger.d("FullSongPracticeViewModel 초기화")
  }
  
  // MARK: - Public Methods
  
  /// 오디오 설정 및 초기화
  func setupAudio() {
    Logger.d("오디오 설정 시작")
    
    // 오디오 파일 설정
    if audioPlayer.setupAudio(fileName: "forStudyGuitar", fileExtension: "mp3") {
      emit(state.copy(
        totalTime: audioPlayer.totalTime,
        isAudioReady: true
      ))
      
      setupAudioHandlers()
      Logger.d("오디오 설정 완료")
    } else {
      Logger.e("오디오 파일 로드 실패")
      emit(state.copy(isAudioReady: false))
    }
  }
  
  /// 재생 시작
  func play() {
    guard state.isAudioReady else {
      Logger.d("오디오가 준비되지 않음")
      return
    }
    
    audioPlayer.play()
    startProgressTimer()
    Logger.d("재생 시작")
  }
  
  /// 재생 일시정지
  func pause() {
    audioPlayer.pause()
    stopProgressTimer()
    Logger.d("재생 일시정지")
  }
  
  /// 특정 위치로 이동
  func seekTo(progress: Double) {
    let seekTime = progress * state.totalTime
    audioPlayer.seek(to: seekTime)
    
    emit(state.copy(
      currentTime: seekTime,
      progress: progress
    ))
    
    Logger.d("재생 위치 변경: \(seekTime)초")
  }
  
  /// 재생 속도 설정
  func setPlaybackSpeed(_ speed: Double) {
    emit(state.copy(playbackSpeed: speed))
    Logger.d("재생 속도 변경: \(speed)X")
  }
  
  /// 정리 작업
  func cleanup() {
    Logger.d("FullSongPractice 정리 시작")
    stopProgressTimer()
    audioPlayer.dispose()
  }
  
  // MARK: - Time Formatting
  
  /// 시간을 mm:ss 형식으로 포맷팅
  func formatTime(_ time: TimeInterval) -> String {
    let seconds = Int(time) % 60
    let minutes = Int(time) / 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
  
  // MARK: - Private Methods
  
  /// 오디오 플레이어 핸들러 설정
  private func setupAudioHandlers() {
    audioPlayer.setProgressHandler { [weak self] currentTime in
      guard let self = self else { return }
      
      let progress = self.state.totalTime > 0 ? currentTime / self.state.totalTime : 0
      
      self.emit(self.state.copy(
        currentTime: currentTime,
        progress: progress
      ))
    }
    
    audioPlayer.setStateChangeHandler { [weak self] isPlaying in
      guard let self = self else { return }
      
      self.emit(self.state.copy(isPlaying: isPlaying))
      
      if isPlaying {
        self.startProgressTimer()
      } else {
        self.stopProgressTimer()
      }
    }
    
    Logger.d("오디오 핸들러 설정 완료")
  }
  
  /// 진행 상태 타이머 시작
  private func startProgressTimer() {
    stopProgressTimer()
    
    progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
      self?.updateProgress()
    }
  }
  
  /// 진행 상태 타이머 중지
  private func stopProgressTimer() {
    progressTimer?.invalidate()
    progressTimer = nil
  }
  
  /// 진행 상태 업데이트
  private func updateProgress() {
    let currentTime = audioPlayer.currentTime
    let progress = state.totalTime > 0 ? currentTime / state.totalTime : 0
    
    emit(state.copy(
      currentTime: currentTime,
      progress: progress
    ))
  }
  
  // MARK: - Cleanup
  
  override func dispose() {
    cleanup()
    super.dispose()
  }
}
