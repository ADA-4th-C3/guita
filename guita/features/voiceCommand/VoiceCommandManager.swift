//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// [SpeechToTextManager] 기반 음성 명령 인식기
final class VoiceCommandManager: BaseViewModel<VoiceCommandManagerState> {
  static let shared = VoiceCommandManager()
  private let speechToTextManager = SpeechToTextManager.shared

  private init() {
    super.init(state: .init(isRecognizing: false, previousText: "", history: []))
  }

  func start(
    commands: [VoiceCommand],
    sttResult: ((String) -> Void)? = nil,
    historyListener: (([VoiceCommandHistory]) -> Void)? = nil
  ) {
    if state.isRecognizing { return }

    // Start SpeechToText
    speechToTextManager.start { text in
      sttResult?(text)
      self.matchCommand(text, commands, historyListener)
    }
    emit(state.copy(
      isRecognizing: true,
      previousText: "",
      history: []
    ))
    Logger.w("🎙️ Voice Command - Started")
  }

  func stop() {
    if !state.isRecognizing { return }

    speechToTextManager.stop()
    emit(state.copy(
      isRecognizing: false,
      previousText: ""
    ))
    Logger.d("🎙️ Voice Command - Stopped")
  }

  func resetHistory() {
    emit(state.copy(history: []))
  }

  private func matchCommand(_ text: String, _ commands: [VoiceCommand], _ historyListener: (([VoiceCommandHistory]) -> Void)? = nil) {
    let previous = state.previousText

    let targetText: String
    if previous.isEmpty {
      targetText = text
    } else if let range = text.range(of: previous) {
      targetText = String(text[range.upperBound...])
    } else {
      // previousText not found, reset state
      emit(state.copy(previousText: text))
      return
    }

    for command in commands {
      for phrase in command.keyword.phrases {
        // Use regex to match whole word phrase
        let pattern = "\\b" + NSRegularExpression.escapedPattern(for: phrase) + "\\b"
        if let _ = targetText.range(of: pattern, options: .regularExpression) {
          Logger.d("🎙️ Voice Command - Executed: \(command.keyword)(\(phrase))")
          command.handler()
          let history = VoiceCommandHistory(
            keyword: command.keyword,
            rawText: targetText,
            phrase: phrase
          )
          emit(state.copy(
            previousText: text,
            history: state.history + [history]
          ))
          historyListener?(state.history)
          return
        }
      }
    }
  }
}
