//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import AVFoundation

/// 텍스트를 음성으로 변환하는 TTS(Text-To-Speech) 기능을 제공하는 싱글톤 클래스
final class TextToSpeech: NSObject, ObservableObject, @unchecked Sendable {
  
  /// 싱글톤 인스턴스
  static let shared = TextToSpeech()
  
  /// AVSpeechSynthesizer 인스턴스 - 실제 TTS 작업을 수행
  private let synthesizer = AVSpeechSynthesizer()
  
  /// 현재 TTS가 실행 중인지 여부를 추적
  @Published private var isSpeaking = false
  
  /// TTS 시작 시 호출되는 콜백 핸들러
  private var speechStartHandler: ((String) -> Void)?
  
  /// TTS 완료 시 호출되는 콜백 핸들러
  private var speechFinishHandler: ((String) -> Void)?
  
  /// TTS 오류 발생 시 호출되는 콜백 핸들러
  private var speechErrorHandler: ((Error) -> Void)?
  
  private override init() {
    super.init()
    setupSynthesizer()
  }
  
  /// TTS 시작 이벤트 핸들러를 설정한다
  func setSpeechStartHandler(_ handler: @escaping (String) -> Void) {
    speechStartHandler = handler
  }
  
  /// TTS 완료 이벤트 핸들러를 설정한다
  func setSpeechFinishHandler(_ handler: @escaping (String) -> Void) {
    speechFinishHandler = handler
  }
  
  /// TTS 오류 이벤트 핸들러를 설정한다
  func setSpeechErrorHandler(_ handler: @escaping (Error) -> Void) {
    speechErrorHandler = handler
  }
  
  /// 주어진 텍스트를 음성으로 변환하여 재생한다
  func speak(
    _ text: String,
    language: String = "ko-KR",
    rate: Float = 0.5,
    pitch: Float = 1.0,
    volume: Float = 1.0
  ) {
    Logger.d("TTS speak 호출됨 - 텍스트: '\(text)', 언어: \(language), 속도: \(rate)")
    
    // 빈 텍스트는 처리하지 않음
    guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      Logger.e("TTS: 빈 텍스트로 인해 음성 재생을 건너뜀")
      return
    }
    
    // 이미 재생 중이면 현재 재생을 중단하고 새로운 텍스트 재생
    if isSpeaking {
      Logger.d("TTS: 기존 재생 중단 후 새 텍스트 재생")
      synthesizer.stopSpeaking(at: .immediate)
      isSpeaking = false
    }
    
    // AVAudioSession 설정
    do {
      let session = AVAudioSession.sharedInstance()
      // 카테고리를 playback으로 변경하여 TTS가 마이크로 들어가지 않도록 함
      try session.setCategory(.playback, mode: .default, options: [.duckOthers])
      try session.setActive(true)
      Logger.d("TTS: AVAudioSession playback 모드로 설정 완료")
    } catch {
      Logger.e("TTS: AVAudioSession 설정 실패 - \(error)")
    }
    
    // 사용 가능한 음성 확인 및 fallback 처리
    var selectedVoice: AVSpeechSynthesisVoice?
    
    // 1. 요청된 언어의 음성 찾기
    let availableVoices = AVSpeechSynthesisVoice.speechVoices()
    Logger.d("TTS: 사용 가능한 음성 개수: \(availableVoices.count)")
    
    // 한국어 음성 찾기
    if language.contains("ko") {
      let koreanVoices = AVSpeechSynthesisVoice.speechVoices().filter { $0.language.contains("ko") }
      selectedVoice = koreanVoices.max(by: { $0.quality.rawValue < $1.quality.rawValue })
      Logger.d("TTS: 한국어 음성 \(koreanVoices.count)개 중 선택: \(selectedVoice?.name ?? "없음")")
      if selectedVoice != nil {
        Logger.d("TTS: 한국어 음성 찾음")
      } else {
        Logger.d("TTS: 한국어 음성 없음 - 영어로 fallback")
        selectedVoice = availableVoices.first { $0.language.contains("en") }
      }
    } else {
      // 영어나 기타 언어
      selectedVoice = availableVoices.first { $0.language.contains(String(language.prefix(2))) }
    }
    
    /*
     사용 가능한 iOS 한국어 음성들:
     
     기본 음성 (항상 사용 가능):
     - Yuna (여성, ko-KR) - 기본 품질
     - Rocko (남성, ko-KR) - 기본 품질
     
     Enhanced 음성 (다운로드 필요할 수 있음):
     - Suhyun (여성, ko-KR) - 고품질, 자연스러운 발음
     - Jinwoo (남성, ko-KR) - 고품질, 자연스러운 발음
     - Sora (여성, ko-KR) - 고품질
     - Gyuri (여성, ko-KR) - 고품질
     - Hyunyoung (여성, ko-KR) - 고품질
     - Minsu (남성, ko-KR) - 고품질
     - Narae (여성, ko-KR) - 고품질
     
     특정 음성 선택 방법:
     selectedVoice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.compact.ko-KR.Yuna")
     selectedVoice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.enhanced.ko-KR.Suhyun")
     
     영어 음성들:
     - Samantha (여성, en-US) - 기본
     - Alex (남성, en-US) - 기본
     - Ava (여성, en-US) - Enhanced
     - Evan (남성, en-US) - Enhanced
     */
    
    // 최종 fallback - 시스템 기본 음성
    if selectedVoice == nil {
      selectedVoice = AVSpeechSynthesisVoice(language: "en-US")
      Logger.d("TTS: 시스템 기본 영어 음성 사용")
    }
    
    // AVSpeechUtterance 생성 및 설정
    let utterance = AVSpeechUtterance(string: text)
    utterance.voice = selectedVoice
    utterance.rate = rate
    utterance.pitchMultiplier = pitch
    utterance.volume = volume
    
    Logger.d("TTS: 음성 재생 시작 - '\(text)' (사용 음성: \(selectedVoice?.language ?? "unknown"), 속도: \(utterance.rate))")
    
    // 상태를 미리 설정
    isSpeaking = true
    
    // 재생 시작
    synthesizer.speak(utterance)
    
  }
  
  /// 현재 TTS 재생을 일시정지한다
  func pause() {
    guard isSpeaking else {
      Logger.d("TTS: 재생 중이 아니어서 일시정지 할 수 없음")
      return
    }
    
    synthesizer.pauseSpeaking(at: .immediate)
    Logger.d("TTS: 음성 재생 일시정지")
  }
  
  /// 일시정지된 TTS 재생을 재개한다
  func resume() {
    guard synthesizer.isPaused else {
      Logger.d("TTS: 일시정지 상태가 아니어서 재개할 수 없음")
      return
    }
    
    synthesizer.continueSpeaking()
    Logger.d("TTS: 음성 재생 재개")
  }
  
  /// 현재 TTS 재생을 완전히 중단한다
  func stop() {
    guard isSpeaking else {
      Logger.d("TTS: 재생 중이 아니어서 중단할 수 없음")
      return
    }
    
    synthesizer.stopSpeaking(at: .immediate)
    isSpeaking = false
    Logger.d("TTS: 음성 재생 중단")
  }
  
  /// 현재 TTS가 재생 중인지 여부를 반환한다
  var isCurrentlySpeaking: Bool {
    return isSpeaking
  }
  
  /// 현재 TTS가 일시정지 상태인지 여부를 반환한다
  var isPaused: Bool {
    return synthesizer.isPaused
  }
  
  // MARK: - Private Methods
  
  /// AVSpeechSynthesizer의 delegate를 설정하고 초기 설정을 수행한다
  private func setupSynthesizer() {
    synthesizer.delegate = self
    Logger.d("TTS: TextToSpeech 싱글톤 초기화 완료 - delegate 설정됨")
  }
}

// MARK: - AVSpeechSynthesizerDelegate

extension TextToSpeech: AVSpeechSynthesizerDelegate {
  
  /// TTS 재생이 시작될 때 호출되는 delegate 메서드
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    DispatchQueue.main.async {
      self.isSpeaking = true
      let text = utterance.speechString
      Logger.d("TTS Delegate: 음성 재생 시작 - '\(text)'")
      self.speechStartHandler?(text)
    }
  }
  
  /// TTS 재생이 완료될 때 호출되는 delegate 메서드
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    DispatchQueue.main.async {
      self.isSpeaking = false
      let text = utterance.speechString
      Logger.d("TTS Delegate: 음성 재생 완료 - '\(text)'")
      self.speechFinishHandler?(text)
    }
  }
  
  /// TTS 재생이 일시정지될 때 호출되는 delegate 메서드
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
    Logger.d("TTS Delegate: 음성 재생 일시정지 - '\(utterance.speechString)'")
  }
  
  /// TTS 재생이 재개될 때 호출되는 delegate 메서드
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
    Logger.d("TTS Delegate: 음성 재생 재개 - '\(utterance.speechString)'")
  }
  
  /// TTS 재생이 취소될 때 호출되는 delegate 메서드
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
    DispatchQueue.main.async {
      self.isSpeaking = false
      Logger.d("TTS Delegate: 음성 재생 취소 - '\(utterance.speechString)'")
    }
  }
}
