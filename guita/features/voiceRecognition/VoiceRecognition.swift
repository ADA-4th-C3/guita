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
    // 쿨다운 중이면 명령 무시
    guard !commandCooldown else { return }
    
    let words = text.lowercased().components(separatedBy: " ")
    Logger.d("음성 인식: '\(text)'")
    
    // 명령어 우선순위 (더 구체적인 명령어를 먼저 찾기)
    let prioritizedCommands: [VoiceCommand] = [.seekForward, .seekBackward, .volumeUp, .volumeDown, .next, .previous, .play, .pause, .replay]
    
    for command in prioritizedCommands {
      let commandWords = VoiceCommand.commandMap.compactMap { $0.value == command ? $0.key : nil }
      
      if words.contains(where: { commandWords.contains($0) }) {
        Logger.d("인식된 명령어: \(command)")
        commandHandler?(command)
        
        // 명령 실행 후 1초 쿨다운
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
