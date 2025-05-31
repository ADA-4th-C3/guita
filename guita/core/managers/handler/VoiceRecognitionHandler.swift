//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import AVFoundation
import Speech

/// 음성인식 처리를 담당하는 핸들러
final class VoiceRecognitionHandler {
  
  // MARK: - Properties
  private let voiceRecognitionManager = VoiceRecognitionManager.shared
  private let audioManager = AudioManager.shared
  private weak var delegate: VoiceRecognitionDelegate?
  
  private var currentRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var isSetup = false
  
  // MARK: - Initialization
  init(delegate: VoiceRecognitionDelegate) {
    self.delegate = delegate
  }
  
  // MARK: - Setup
  func setupVoiceRecognition() {
    guard !isSetup else { return }
    isSetup = true
    startVoiceRecognition()
  }
  
  // MARK: - Control
  func startVoiceRecognition() {
    guard voiceRecognitionManager.isAvailable else {
      Logger.e("음성인식 사용 불가")
      return
    }
    
    if currentRecognitionRequest != nil {
      Logger.d("기존 음성인식 중지 후 재시작")
      stopVoiceRecognition()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.startVoiceRecognition()
      }
      return
    }
    
    currentRecognitionRequest = voiceRecognitionManager.startRecognition { [weak self] text in
      Logger.d("음성인식 텍스트 수신: \(text)") // 디버그 로그 추가
      self?.delegate?.didRecognizeText(text)
    }
    
    guard currentRecognitionRequest != nil else {
      Logger.e("음성인식 요청 생성 실패")
      return
    }
    
    audioManager.start { [weak self] buffer, _ in
      self?.delegate?.didReceiveAudioBuffer(buffer)
      self?.currentRecognitionRequest?.append(buffer)
    }
    
    delegate?.voiceRecognitionDidStart()
    Logger.d("음성인식 시작됨")
  }
  
  func stopVoiceRecognition() {
    voiceRecognitionManager.stopRecognition()
    currentRecognitionRequest = nil
    audioManager.stop()
    delegate?.voiceRecognitionDidStop()
    Logger.d("음성인식 중지됨")
  }
}

/// VoiceRecognitionHandler의 델리게이트 프로토콜
protocol VoiceRecognitionDelegate: AnyObject {
  func didRecognizeText(_ text: String)
  func didReceiveAudioBuffer(_ buffer: AVAudioPCMBuffer)
  func voiceRecognitionDidStart()
  func voiceRecognitionDidStop()
}
