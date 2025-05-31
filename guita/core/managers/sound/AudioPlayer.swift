//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVKit
import Foundation

final class AudioPlayer {
  private var player: AVAudioPlayer?
  private var timer: Timer?
  
  var isPlaying: Bool {
    player?.isPlaying ?? false
  }
  
  var currentTime: TimeInterval {
    player?.currentTime ?? 0.0
  }
  
  var totalTime: TimeInterval {
    player?.duration ?? 0.0
  }
  
  var volume: Float {
    get { player?.volume ?? 1.0 }
    set { player?.volume = newValue }
  }
  
  private var progressHandler: ((TimeInterval) -> Void)?
  private var stateChangeHandler: ((Bool) -> Void)?
  
  func setupAudio(fileName: String, fileExtension: String) -> Bool {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
      Logger.e("Audio file not found: \(fileName).\(fileExtension)")
      return false
    }
    
    do {
      // AVAudioSession 설정 추가
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.playback, mode: .default, options: [])
      try session.setActive(true)
      
      player = try AVAudioPlayer(contentsOf: url)
      player?.prepareToPlay()
      Logger.d("Audio setup successful: \(fileName).\(fileExtension)")
      return true
    } catch {
      Logger.e("Error loading audio: \(error)")
      return false
    }
  }
  
  func setProgressHandler(_ handler: @escaping (TimeInterval) -> Void) {
    progressHandler = handler
  }
  
  func setStateChangeHandler(_ handler: @escaping (Bool) -> Void) {
    stateChangeHandler = handler
  }
  
  func play() {
    player?.play()
    stateChangeHandler?(true)
    startTimer()
  }
  
  func pause() {
    player?.pause()
    stateChangeHandler?(false)
    stopTimer()
  }
  
  func seek(to time: TimeInterval) {
    player?.currentTime = time
    progressHandler?(time)
  }
  
  func volumeUp() {
    volume = min(volume + 0.1, 1.0)
  }
  
  func volumeDown() {
    volume = max(volume - 0.1, 0.0)
  }
  
  func seekForward(seconds: TimeInterval = 10) {
    guard let player = player else { return }
    seek(to: min(player.currentTime + seconds, player.duration))
  }
  
  func seekBackward(seconds: TimeInterval = 10) {
    guard let player = player else { return }
    seek(to: max(player.currentTime - seconds, 0))
  }
  
  func replay() {
    seek(to: 0)
    play()
  }
  
  func nextTrack() {
    seek(to: 0)
    if !isPlaying { play() }
  }
  
  func previousTrack() {
    seek(to: 0)
    if !isPlaying { play() }
  }
  
  private func startTimer() {
    stopTimer()
    timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
      self?.updateProgress()
    }
  }
  
  private func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
  
  private func updateProgress() {
    guard let player = player else { return }
    
    let currentTime = player.currentTime
    progressHandler?(currentTime)
    
    if !player.isPlaying && isPlaying {
      stateChangeHandler?(false)
      progressHandler?(0)
      stopTimer()
    }
  }
  
  func dispose() {
    stopTimer()
    player?.stop()
    player = nil
  }
}
