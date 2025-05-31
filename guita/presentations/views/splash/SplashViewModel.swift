//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.


import Foundation

final class SplashViewModel: BaseViewModel<SplashViewState> {
  private let audioPlayer = AudioPlayer()
  private let hapticManager = HapticManager.shared
  
  init() {
    super.init(state: .init(loaded: false))
  }
  
  func onAppear() {
    // 오디오 파일 존재 여부 확인
    guard let url = Bundle.main.url(forResource: "startSound", withExtension: "mp3") else {
      Logger.e("startSound.mp3 파일을 찾을 수 없음")
      // 파일이 없어도 햅틱은 실행
      playHapticFeedback()
      return
    }
    
    Logger.d("오디오 파일 경로: \(url)")
    
    // 시작 사운드 설정 및 재생
    if audioPlayer.setupAudio(fileName: "startSound", fileExtension: "mp3") {
      audioPlayer.volume = 0.3
      Logger.d("오디오 재생 시작")
      audioPlayer.play()
    } else {
      Logger.e("오디오 설정 실패")
    }
    
    playHapticFeedback()
  }
  
  private func playHapticFeedback() {
    // 햅틱 2번
    hapticManager.playSuccess()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
    let fadeDuration: TimeInterval = 1.0
    let fadeSteps = 20
    let stepDuration = fadeDuration / Double(fadeSteps)
    let volumeStep = audioPlayer.volume / Float(fadeSteps)
    
    var currentStep = 0
    
    Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { timer in
      currentStep += 1
      let newVolume = max(0, self.audioPlayer.volume - volumeStep)
      self.audioPlayer.volume = newVolume
      
      if currentStep >= fadeSteps || newVolume <= 0 {
        timer.invalidate()
        self.audioPlayer.dispose()
      }
    }
  }
  
  override func dispose() {
    audioPlayer.dispose()
    super.dispose()
  }
}
