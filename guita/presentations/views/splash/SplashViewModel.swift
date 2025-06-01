//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.


import Foundation
import AVFoundation


final class SplashViewModel: BaseViewModel<SplashViewState> {
  private let audioPlayer = AudioPlayer()
  private let hapticManager = HapticManager.shared
  
  init() {
    super.init(state: .init(loaded: false))
  }
  
  func onAppear() {
    
    
    configureSplashAudioSession()
    
    // 오디오 파일 존재 여부 확인
    guard let url = Bundle.main.url(forResource: "startSound", withExtension: "mp3") else {
      Logger.e("startSound.mp3 파일을 찾을 수 없음")
      playHapticFeedback()
      return
    }
    
    Logger.d("오디오 파일 경로: \(url)")
    
    // 시작 사운드 설정
    if audioPlayer.setupAudio(fileName: "startSound", fileExtension: "mp3") {
      // 볼륨을 0부터 시작해서 페이드인
      audioPlayer.volume = 0.1
      Logger.d("오디오 재생 시작 (페이드인)")
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
        self.audioPlayer.play()
        self.fadeInAudio(targetVolume: 0.7, duration: 1.0)
      }
    } else {
      Logger.e("오디오 설정 실패")
    }
    
    playHapticFeedback()
  }
  
  
  private func playHapticFeedback() {
    // 햅틱 2번
    hapticManager.playSuccess()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.hapticManager.playSuccess()
    }
  }
  
  func onLoaded() {
    emit(state.copy(loaded: true))
  }
  
  func onDisappear() {
    // 페이드아웃 효과로 볼륨 감소
    fadeOutAndStop()
  }
  
  
  private func fadeOutAndStop() {
    let fadeDuration: TimeInterval = 2.0  // 1.0 → 2.0초로 연장
    let fadeSteps = 50                    // 20 → 50으로 증가하여 더 부드럽게
    let stepDuration = fadeDuration / Double(fadeSteps)
    let initialVolume = audioPlayer.volume
    let volumeStep = initialVolume / Float(fadeSteps)
    
    var currentStep = 0
    
    Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { timer in
      currentStep += 1
      
      // 지수 함수적 감소로 더 자연스러운 페이드아웃
      let progress = Float(currentStep) / Float(fadeSteps)
      let exponentialCurve = pow(1.0 - progress, 2.0)  // 제곱 곡선 적용
      let newVolume = max(0, initialVolume * exponentialCurve)
      
      self.audioPlayer.volume = newVolume
      
      if currentStep >= fadeSteps || newVolume <= 0.01 {
        timer.invalidate()
        self.audioPlayer.volume = 0
        self.audioPlayer.dispose()
        Logger.d("페이드아웃 완료 - 오디오 정리됨")
      }
    }
  }
  // 페이드인 메서드 추가
  private func fadeInAudio(targetVolume: Float, duration: TimeInterval) {
    let fadeSteps = 40 // 부드러운 페이드를 위해 단계 수 증가
    let stepDuration = duration / Double(fadeSteps)
    let volumeStep = targetVolume / Float(fadeSteps)
    
    var currentStep = 0
    
    Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { timer in
      currentStep += 1
      let newVolume = min(targetVolume, Float(currentStep) * volumeStep)
      self.audioPlayer.volume = newVolume
      
      if currentStep >= fadeSteps || newVolume >= targetVolume {
        timer.invalidate()
        Logger.d("페이드인 완료 - 최종 볼륨: \(newVolume)")
      }
    }
  }
  
  private func configureSplashAudioSession() {
    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.playback, mode: .default, options: [])
      try session.setActive(true)
      Logger.d("Splash 전용 오디오 세션 설정 완료 (무음 모드 무시)")
    } catch {
      Logger.e("Splash 오디오 세션 설정 실패: \(error)")
    }
  }
  
  override func dispose() {
    audioPlayer.dispose()
    super.dispose()
  }
}
