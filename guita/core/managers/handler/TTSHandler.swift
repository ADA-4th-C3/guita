//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// TTS 재생을 담당하는 핸들러
final class TTSHandler {
  
  // MARK: - Properties
  private let tts = TextToSpeech.shared
  private weak var delegate: TTSHandlerDelegate?
  private var micSoundPlayer: AudioPlayer?
  private var hasPlayedMicOn = false  // 중복 방지 플래그 추가
  
  private var ttsQueue: [TTSContent] = []
  private var currentTTSIndex = 0
  private var isTTSSequencePlaying = false
  
  // MARK: - Initialization
  init(delegate: TTSHandlerDelegate) {
    self.delegate = delegate
    setupTTS()
  }
  
  // MARK: - Setup
  private func setupTTS() {
    tts.setSpeechStartHandler { [weak self] text in
      Logger.d("TTS 시작: \(text)")
      self?.delegate?.ttsDidStart(text)
    }
    
    tts.setSpeechFinishHandler { [weak self] text in
      Logger.d("TTS 완료: \(text)")
      self?.onTTSFinished()
    }
    
    tts.setSpeechErrorHandler { [weak self] error in
      Logger.e("TTS 오류: \(error)")
      self?.onTTSFinished()
    }
  }
  
  // MARK: - Public Methods
  func playTTSSequence(contents: [TTSContent]) {
          guard !contents.isEmpty else { return }
          
          // 새로운 시퀀스 시작 시 플래그 리셋
          hasPlayedMicOn = false
          
          ttsQueue = contents
          currentTTSIndex = 0
          isTTSSequencePlaying = true
          
          delegate?.ttsSequenceDidStart()
          playNextTTS()
      }
      
      private func playMicOnSound() {
          micSoundPlayer?.dispose()
          micSoundPlayer = AudioPlayer()
          
          if micSoundPlayer?.setupAudio(fileName: "micOn", fileExtension: "mp3") == true {
              micSoundPlayer?.volume = 0.7
              micSoundPlayer?.play()
              Logger.d("TTS 완료 후 micOn.mp3 재생")
          } else {
              Logger.e("micOn.mp3 파일을 찾을 수 없음")
          }
      }
  
  func stop() {
    tts.stop()
    isTTSSequencePlaying = false
    ttsQueue.removeAll()
    currentTTSIndex = 0
    delegate?.ttsDidStop()
  }
  
  // MARK: - Private Methods
  private func playNextTTS() {
    guard currentTTSIndex < ttsQueue.count else {
      onTTSSequenceCompleted()
      return
    }
    
    let content = ttsQueue[currentTTSIndex]
    
    if content.type == .content {
      delegate?.ttsContentDidPlay(content.text)
    }
    
    Logger.d("TTS 재생: \(content.text)")
    tts.speak(content.text)
  }
  
  private func onTTSFinished() {
    guard isTTSSequencePlaying else { return }
    
    let currentContent = ttsQueue[currentTTSIndex]
    currentTTSIndex += 1
    
    let totalDelay = currentContent.pauseAfter + 0.5 // 0.5초 딜레이
    
    DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay) {
      self.playNextTTS()
    }
  }
  
  private func onTTSSequenceCompleted() {
    isTTSSequencePlaying = false
    ttsQueue.removeAll()
    currentTTSIndex = 0
    
    // micOn 소리가 이미 재생되었으면 재생하지 않음
    if !hasPlayedMicOn {
      hasPlayedMicOn = true
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        self.playMicOnSound()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.delegate?.ttsSequenceDidComplete()
          Logger.d("TTS 시퀀스 완료 - 음성인식 복원")
          
          // 플래그 리셋
          self.hasPlayedMicOn = false
        }
      }
    } else {
      // 이미 재생했으면 바로 완료 처리
      delegate?.ttsSequenceDidComplete()
      Logger.d("TTS 시퀀스 완료 - micOn 이미 재생됨")
    }
  }
  
  /// TTS 시작 시 마이크 꺼짐 사운드 재생
  private func playTTSStartSound() {
    micSoundPlayer?.dispose()
    micSoundPlayer = AudioPlayer()
    
    if micSoundPlayer?.setupAudio(fileName: "micOff", fileExtension: "mp3") == true {
      micSoundPlayer?.volume = 0.7
      micSoundPlayer?.play()
      Logger.d("TTS 시작 전 micOff.mp3 재생")
    } else {
      Logger.e("micOff.mp3 파일을 찾을 수 없음")
    }
  }
  
  
  func dispose() {
    micSoundPlayer?.dispose()
    hasPlayedMicOn = false
  }
  
  
}

/// TTSHandler의 델리게이트 프로토콜
protocol TTSHandlerDelegate: AnyObject {
  func ttsDidStart(_ text: String)
  func ttsDidStop()
  func ttsContentDidPlay(_ text: String)
  func ttsSequenceDidStart()
  func ttsSequenceDidComplete()
}
