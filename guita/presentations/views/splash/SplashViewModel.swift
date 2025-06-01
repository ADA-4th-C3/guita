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
            playHapticFeedback()
            return
        }
        
        Logger.d("오디오 파일 경로: \(url)")
        
        // 시작 사운드 설정
        if audioPlayer.setupAudio(fileName: "startSound", fileExtension: "mp3") {
            // 볼륨을 0부터 시작해서 페이드인
            audioPlayer.volume = 0.0
            Logger.d("오디오 재생 시작 (페이드인)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.audioPlayer.play()
                self.fadeInAudio(targetVolume: 0.3, duration: 1.0)
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

  
  override func dispose() {
    audioPlayer.dispose()
    super.dispose()
  }
}
