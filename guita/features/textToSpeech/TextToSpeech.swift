//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import AVFoundation

/// 텍스트를 음성으로 변환하는 TTS(Text-To-Speech) 기능을 제공하는 클래스
/// VoiceRecognition과 유사한 패턴으로 설계되어 일관성 있는 사용법을 제공한다
final class TextToSpeech {
  
  
  /// AVSpeechSynthesizer 인스턴스 - 실제 TTS 작업을 수행
  private let synthesizer = AVSpeechSynthesizer()
  
  /// 현재 TTS가 실행 중인지 여부를 추적
  private var isSpeaking = false
  
  /// TTS 시작 시 호출되는 콜백 핸들러
  /// - Parameter text: 읽기 시작하는 텍스트
  private var speechStartHandler: ((String) -> Void)?
  
  /// TTS 완료 시 호출되는 콜백 핸들러
  /// - Parameter text: 읽기 완료된 텍스트
  private var speechFinishHandler: ((String) -> Void)?
  
  /// TTS 오류 발생 시 호출되는 콜백 핸들러
  /// - Parameter error: 발생한 오류 정보
  private var speechErrorHandler: ((Error) -> Void)?
  
  
  init() {
    setupSynthesizer()
  }
  
  // MARK: - Public Methods
  
  /// TTS 시작 이벤트 핸들러를 설정한다
  /// - Parameter handler: TTS가 시작될 때 호출될 클로저
  /// - Usage: textToSpeech.setSpeechStartHandler { text in print("시작: \(text)") }
  func setSpeechStartHandler(_ handler: @escaping (String) -> Void) {
    speechStartHandler = handler
  }
  
  /// TTS 완료 이벤트 핸들러를 설정한다
  /// - Parameter handler: TTS가 완료될 때 호출될 클로저
  /// - Usage: textToSpeech.setSpeechFinishHandler { text in print("완료: \(text)") }
  func setSpeechFinishHandler(_ handler: @escaping (String) -> Void) {
    speechFinishHandler = handler
  }
  
  /// TTS 오류 이벤트 핸들러를 설정한다
  /// - Parameter handler: TTS 오류 발생 시 호출될 클로저
  /// - Usage: textToSpeech.setSpeechErrorHandler { error in print("오류: \(error)") }
  func setSpeechErrorHandler(_ handler: @escaping (Error) -> Void) {
    speechErrorHandler = handler
  }
  
  /// 주어진 텍스트를 음성으로 변환하여 재생한다
  /// - Parameters:
  ///   - text: 읽을 텍스트 (빈 문자열이면 아무것도 하지 않음)
  ///   - language: 언어 코드 (기본값: "ko-KR")
  ///   - rate: 읽기 속도 (0.0~1.0, 기본값: 0.5)
  ///   - pitch: 음높이 (0.5~2.0, 기본값: 1.0)
  ///   - volume: 볼륨 (0.0~1.0, 기본값: 1.0)
  /// - Usage: textToSpeech.speak("안녕하세요", rate: 0.6, pitch: 1.2)
  func speak(
    _ text: String,
    language: String = "ko-KR",
    rate: Float = 0.5,
    pitch: Float = 1.0,
    volume: Float = 1.0
  ) {
    // 빈 텍스트는 처리하지 않음
    guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      Logger.d("TTS: 빈 텍스트로 인해 음성 재생을 건너뜀")
      return
    }
    
    // 이미 재생 중이면 현재 재생을 중단하고 새로운 텍스트 재생
    if isSpeaking {
      Logger.d("TTS: 기존 재생 중단 후 새 텍스트 재생")
      stop()
    }
    
    // AVSpeechUtterance 생성 및 설정
    let utterance = AVSpeechUtterance(string: text)
    utterance.voice = AVSpeechSynthesisVoice(language: language)
    utterance.rate = rate
    utterance.pitchMultiplier = pitch
    utterance.volume = volume
    
    Logger.d("TTS: 음성 재생 시작 - '\(text)'")
    synthesizer.speak(utterance)
  }
  
  /// 현재 TTS 재생을 일시정지한다
  /// - Note: 일시정지된 TTS는 resume()으로 재개할 수 있다
  func pause() {
    guard isSpeaking else {
      Logger.d("TTS: 재생 중이 아니어서 일시정지 할 수 없음")
      return
    }
    
    synthesizer.pauseSpeaking(at: .immediate)
    Logger.d("TTS: 음성 재생 일시정지")
  }
  
  /// 일시정지된 TTS 재생을 재개한다
  /// - Note: pause()로 일시정지된 상태에서만 동작한다
  func resume() {
    guard synthesizer.isPaused else {
      Logger.d("TTS: 일시정지 상태가 아니어서 재개할 수 없음")
      return
    }
    
    synthesizer.continueSpeaking()
    Logger.d("TTS: 음성 재생 재개")
  }
  
  /// 현재 TTS 재생을 완전히 중단한다
  /// - Note: 중단된 TTS는 재개할 수 없으며, 새로 speak()를 호출해야 한다
  func stop() {
    guard isSpeaking else {
      Logger.d("TTS: 재생 중이 아니어서 중단할 수 없음")
      return
    }
    
    synthesizer.stopSpeaking(at: .immediate)
    Logger.d("TTS: 음성 재생 중단")
  }
  
  /// 현재 TTS가 재생 중인지 여부를 반환한다
  /// - Returns: 재생 중이면 true, 아니면 false
  var isCurrentlySpeaking: Bool {
    return isSpeaking
  }
  
  /// 현재 TTS가 일시정지 상태인지 여부를 반환한다
  /// - Returns: 일시정지 중이면 true, 아니면 false
  var isPaused: Bool {
    return synthesizer.isPaused
  }
  
  // MARK: - Private Methods
  
  /// AVSpeechSynthesizer의 delegate를 설정하고 초기 설정을 수행한다
  /// - Note: 앱 시작 시 한 번만 호출되며, TTS 이벤트 처리를 위해 필요하다
  private func setupSynthesizer() {
    synthesizer.delegate = self
    Logger.d("TTS: TextToSpeech 초기화 완료")
  }
}

// MARK: - AVSpeechSynthesizerDelegate

/// AVSpeechSynthesizerDelegate를 구현하여 TTS 이벤트를 처리한다
/// 각 이벤트에 대해 사용자가 설정한 핸들러를 호출하고 내부 상태를 업데이트한다
extension TextToSpeech: AVSpeechSynthesizerDelegate {
  
  /// TTS 재생이 시작될 때 호출되는 delegate 메서드
  /// - Parameter utterance: 재생이 시작된 AVSpeechUtterance 객체
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    isSpeaking = true
    let text = utterance.speechString
    Logger.d("TTS Delegate: 음성 재생 시작 - '\(text)'")
    speechStartHandler?(text)
  }
  
  /// TTS 재생이 완료될 때 호출되는 delegate 메서드
  /// - Parameter utterance: 재생이 완료된 AVSpeechUtterance 객체
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    isSpeaking = false
    let text = utterance.speechString
    Logger.d("TTS Delegate: 음성 재생 완료 - '\(text)'")
    speechFinishHandler?(text)
  }
  
  /// TTS 재생이 일시정지될 때 호출되는 delegate 메서드
  /// - Parameter utterance: 일시정지된 AVSpeechUtterance 객체
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
    Logger.d("TTS Delegate: 음성 재생 일시정지 - '\(utterance.speechString)'")
  }
  
  /// TTS 재생이 재개될 때 호출되는 delegate 메서드
  /// - Parameter utterance: 재개된 AVSpeechUtterance 객체
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
    Logger.d("TTS Delegate: 음성 재생 재개 - '\(utterance.speechString)'")
  }
  
  /// TTS 재생이 취소될 때 호출되는 delegate 메서드
  /// - Parameter utterance: 취소된 AVSpeechUtterance 객체
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
    isSpeaking = false
    Logger.d("TTS Delegate: 음성 재생 취소 - '\(utterance.speechString)'")
  }
}

// MARK: - 사용 예시

/*
 사용 방법 예시:
 
 1. 기본 사용법
 let tts = TextToSpeech()
 tts.speak("안녕하세요. 기타 연습을 시작하겠습니다.")
 
 2. 이벤트 핸들러 설정
 tts.setSpeechStartHandler { text in
 print("음성 시작: \(text)")
 }
 
 tts.setSpeechFinishHandler { text in
 print("음성 완료: \(text)")
 // 다음 단계로 진행하는 로직
 }
 
 3. 세부 설정과 함께 사용
 tts.speak(
 "A코드를 연주해보세요",
 rate: 0.6,     // 조금 느리게
 pitch: 1.2,    // 조금 높은 음성
 volume: 0.8    // 조금 작은 볼륨
 )
 
 4. 재생 제어
 tts.pause()  // 일시정지
 tts.resume() // 재개
 tts.stop()   // 완전 중단
 
 5. 상태 확인
 if tts.isCurrentlySpeaking {
 print("현재 음성 재생 중")
 }
 */
