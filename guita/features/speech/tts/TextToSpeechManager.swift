//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation

final class TextToSpeechManager: BaseViewModel<TextToSpeechState>, AVSpeechSynthesizerDelegate, @unchecked Sendable {
  static let shared = TextToSpeechManager()
  private let configManager = ConfigManager.shared
  private let speechSynthesizer = AVSpeechSynthesizer()
  private var continuation: CheckedContinuation<Void, Never>?

  private init() {
    super.init(state: .init(isSpeaking: false))
    speechSynthesizer.delegate = self
  }

  /// init()에 있는 경우 화면 진입시 느려지는 원인으로 확인되어 SplashView에서 호출하여 해결
  /// TTS와 Mic 함께 사용시 TTS 소리가 작아지는 문제 해결
  func configureAudioSession() {
    let session = AVAudioSession.sharedInstance()
    guard session.category != .playAndRecord else { return }
    do {
      try session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .mixWithOthers])
      try session.setActive(true)
    } catch {
      Logger.e("❗️Failed to set audio session: \(error)")
    }
  }

  func speak(_ text: String, locale: Locale = Locale.current, rate: Float? = nil) async {
    stop()
    if text.isEmpty { return }
    await withTaskCancellationHandler(operation: {
      await withCheckedContinuation { continuation in
        self.continuation = continuation
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: locale.ttsLanguage)
        utterance.rate = rate ?? configManager.state.ttsSpeed.value
        speechSynthesizer.speak(utterance)
      }
    }, onCancel: {
      stop()
    })
  }

  func stop() {
    speechSynthesizer.stopSpeaking(at: .immediate)
    continuation?.resume()
    continuation = nil
  }

  func speechSynthesizer(_: AVSpeechSynthesizer, didFinish _: AVSpeechUtterance) {
    continuation?.resume()
    continuation = nil
  }
}
