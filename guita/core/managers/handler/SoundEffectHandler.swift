//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 효과음 재생을 담당하는 핸들러
final class SoundEffectHandler {
  
  // MARK: - Properties
  private let soundPlayer = AudioPlayer()
  private weak var delegate: SoundEffectDelegate?
  
  // MARK: - Initialization
  init(delegate: SoundEffectDelegate) {
    self.delegate = delegate
  }
  
  // MARK: - Public Methods
  func playEffectSound(_ fileName: String, fileExtension: String = "mp3") {
    guard !fileName.isEmpty else {
      Logger.d("사운드 파일명이 비어있음 - 건너뛰기")
      return
    }
    
    delegate?.soundEffectWillStart()
    
    if soundPlayer.setupAudio(fileName: fileName, fileExtension: fileExtension) {
      soundPlayer.play()
      
      soundPlayer.setStateChangeHandler { [weak self] isPlaying in
        if !isPlaying {
          self?.delegate?.soundEffectDidComplete()
        }
      }
      
      // 사운드 재생 타임아웃 (10초)
      DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
        if self.soundPlayer.isPlaying {
          Logger.d("사운드 재생 타임아웃 - 강제 완료")
          self.delegate?.soundEffectDidComplete()
        }
      }
      
      Logger.d("사운드 재생 시작: \(fileName).\(fileExtension)")
    } else {
      Logger.e("사운드 재생 실패: \(fileName).\(fileExtension)")
      delegate?.soundEffectDidComplete()
    }
  }
  
  func stop() {
    soundPlayer.pause()
    delegate?.soundEffectDidStop()
  }
  
  func dispose() {
    soundPlayer.dispose()
  }
}

/// SoundEffectHandler의 델리게이트 프로토콜
protocol SoundEffectDelegate: AnyObject {
  func soundEffectWillStart()
  func soundEffectDidComplete()
  func soundEffectDidStop()
}
