//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 곡 전체 학습 화면의 상태를 관리하는 ViewState
struct FullSongPracticeViewState {
  
  // MARK: - Properties
  
  let isPlaying: Bool              // 재생 중인지 여부
  let isAudioReady: Bool          // 오디오 파일 준비 완료 여부
  let currentTime: TimeInterval   // 현재 재생 시간
  let totalTime: TimeInterval     // 전체 재생 시간
  let progress: Double            // 재생 진행률 (0.0 ~ 1.0)
  let playbackSpeed: Double       // 재생 속도 (0.5, 1.0, 1.5)
  
  // MARK: - Initializer
  
  init(
    isPlaying: Bool = false,
    isAudioReady: Bool = false,
    currentTime: TimeInterval = 0.0,
    totalTime: TimeInterval = 0.0,
    progress: Double = 0.0,
    playbackSpeed: Double = 1.0
  ) {
    self.isPlaying = isPlaying
    self.isAudioReady = isAudioReady
    self.currentTime = currentTime
    self.totalTime = totalTime
    self.progress = progress
    self.playbackSpeed = playbackSpeed
  }
  
  // MARK: - Copy Method
  
  /// 상태 복사 메서드 - 불변성을 유지하면서 상태 업데이트
  func copy(
    isPlaying: Bool? = nil,
    totalTime: TimeInterval? = nil,
    isAudioReady: Bool? = nil,
    currentTime: TimeInterval? = nil,
    progress: Double? = nil,
    playbackSpeed: Double? = nil
  ) -> FullSongPracticeViewState {
    return FullSongPracticeViewState(
      isPlaying: isPlaying ?? self.isPlaying,
      isAudioReady: isAudioReady ?? self.isAudioReady,
      currentTime: currentTime ?? self.currentTime,
      totalTime: totalTime ?? self.totalTime,
      progress: progress ?? self.progress,
      playbackSpeed: playbackSpeed ?? self.playbackSpeed
    )
  }
}

// MARK: - Computed Properties Extension

extension FullSongPracticeViewState {
  
  /// 남은 시간
  var remainingTime: TimeInterval {
    return totalTime - currentTime
  }
  
  /// 재생 완료 여부
  var isCompleted: Bool {
    return progress >= 1.0
  }
  
  /// 재생 가능 여부
  var canPlay: Bool {
    return isAudioReady && !isPlaying
  }
  
  /// 일시정지 가능 여부
  var canPause: Bool {
    return isAudioReady && isPlaying
  }
  
  /// 재생 속도 레이블
  var playbackSpeedLabel: String {
    if playbackSpeed == 1.0 {
      return "1X"
    } else if playbackSpeed.truncatingRemainder(dividingBy: 1) == 0 {
      return "\(Int(playbackSpeed))X"
    } else {
      return String(format: "%.1fX", playbackSpeed)
    }
  }
  
  /// 진행률을 백분율로 표시
  var progressPercentage: Int {
    return Int(progress * 100)
  }
}
