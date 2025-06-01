//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation

final class TextToSpeechManager: BaseViewModel<TextToSpeechState>, AVSpeechSynthesizerDelegate, @unchecked Sendable {
  static let shared = TextToSpeechManager()
  private let speechSynthesizer = AVSpeechSynthesizer()
  private var continuation: CheckedContinuation<Void, Never>?
  
  private init() {
    super.init(state: .init(isSpeaking: false))
    speechSynthesizer.delegate = self
  }
  
  func speak(_ text: String, language: String = "ko-KR") async {
    await withCheckedContinuation { continuation in
      self.continuation = continuation
      let utterance = AVSpeechUtterance(string: text)
      utterance.voice = AVSpeechSynthesisVoice(language: language)
      speechSynthesizer.speak(utterance)
    }
  }
  
  func stop() {
    if speechSynthesizer.isSpeaking {
      speechSynthesizer.stopSpeaking(at: .immediate)
      continuation?.resume()
      continuation = nil
    }
  }
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    continuation?.resume()
    continuation = nil
  }
}
