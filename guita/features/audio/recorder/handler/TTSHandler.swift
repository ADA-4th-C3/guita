//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// TTS 재생을 담당하는 핸들러
final class TTSHandler {
  
  // MARK: - Properties
  private let tts = TextToSpeech.shared
  private weak var delegate: TTSHandlerDelegate?
  
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
    
    ttsQueue = contents
    currentTTSIndex = 0
    isTTSSequencePlaying = true
    
    delegate?.ttsSequenceDidStart()
    playNextTTS()
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
    
    // TTS 완료 후 음성인식 상태로 복원하기 위해 딜레이 추가
    DispatchQueue.main.asyncAfter(deadline: .now()) {
      self.delegate?.ttsSequenceDidComplete()
      Logger.d("TTS 시퀀스 완료 - 음성인식 복원")
    }
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
