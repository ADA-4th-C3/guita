//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

final class VoiceRecognition {
  private var textHandler: ((String) -> Void)?
  private var commandHandler: ((VoiceCommand) -> Void)?
  
  func setTextRecognitionHandler(_ handler: @escaping (String) -> Void) {
    textHandler = handler
  }
  
  func setCommandHandler(_ handler: @escaping (VoiceCommand) -> Void) {
    commandHandler = handler
  }
  
  func processRecognizedText(_ text: String) {
    textHandler?(text)
    processVoiceCommand(text)
  }
  
  private func processVoiceCommand(_ text: String) {
    let words = text.lowercased().components(separatedBy: " ")
    Logger.d("음성 인식: '\(text)'")
    
    guard let command = words.compactMap({ VoiceCommand.commandMap[$0] }).first else {
      Logger.d("인식된 명령어 없음")
      return
    }
    
    commandHandler?(command)
  }
}
