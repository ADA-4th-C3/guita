//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation

final class TextToSpeechManager: BaseViewModel<TextToSpeechState>, AVSpeechSynthesizerDelegate, @unchecked Sendable {
  static let shared = TextToSpeechManager()
  private let speechSynthesizer = AVSpeechSynthesizer()
  private var continuation: CheckedContinuation<Void, Never>?

  private init() {
    super.init(state: .init(isSpeaking: false))
    configureAudioSession()
    speechSynthesizer.delegate = self
  }

  /// TTS와 Mic 함께 사용시 TTS 소리가 작아지는 문제 해결
  private func configureAudioSession() {
    let session = AVAudioSession.sharedInstance()
    do {
      try session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .mixWithOthers])
      try session.setActive(true)
    } catch {
      print("❗️Failed to set audio session: \(error)")
    }
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

  func speechSynthesizer(_: AVSpeechSynthesizer, didFinish _: AVSpeechUtterance) {
    continuation?.resume()
    continuation = nil
  }
}
