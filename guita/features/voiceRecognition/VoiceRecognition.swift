//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

final class VoiceRecognition {
  private var textHandler: ((String) -> Void)?
  private var commandHandler: ((VoiceCommand) -> Void)?
  private var lastRecognizedText = ""
  private var commandCooldown = false
  
  func setTextRecognitionHandler(_ handler: @escaping (String) -> Void) {
    textHandler = handler
  }
  
  func setCommandHandler(_ handler: @escaping (VoiceCommand) -> Void) {
    commandHandler = handler
  }
  
  func processRecognizedText(_ text: String) {
    // 중복 텍스트 필터링
    guard text != lastRecognizedText else { return }
    lastRecognizedText = text
    
    textHandler?(text)
    processVoiceCommand(text)
  }
  
    private func processVoiceCommand(_ text: String) {
        guard !commandCooldown else { return }
        
        let cleanText = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        Logger.d("음성 인식: '\(text)'")
        
        // 정확한 명령어만 매칭
        for (commandText, command) in VoiceCommand.commandMap {
            if cleanText == commandText {  // 완전 일치만 허용
                Logger.d("인식된 명령어: \(command)")
                commandHandler?(command)
                startCommandCooldown()
                return
            }
        }
        
        Logger.d("인식된 명령어 없음")
    }
  
  private func startCommandCooldown() {
    commandCooldown = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.commandCooldown = false
    }
  }
  
  /// 텍스트 인식 상태 초기화
  func resetRecognitionState() {
    lastRecognizedText = ""
    commandCooldown = false
  }
}
