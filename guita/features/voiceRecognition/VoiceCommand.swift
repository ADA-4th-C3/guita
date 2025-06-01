//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum VoiceCommand {
  case play, pause, next, previous, replay
  case volumeUp, volumeDown
  case seekForward, seekBackward
  case speedUp, speedDown
  
  static let commandMap: [String: VoiceCommand] = [
    // 재생 제어
    "재생": .play, "플레이": .play, "시작": .play,
    "정지": .pause, "멈춰라": .pause, "스톱": .pause,
    
    // 탐색
    "다음": .next, "다음곡": .next, "넥스트": .next,
    "이전": .previous, "이전곡": .previous, "백": .previous,
    "다시": .replay, "반복": .replay, "리플레이": .replay,
    
    // 볼륨
    "크게": .volumeUp, "볼륨업": .volumeUp, "소리크게": .volumeUp,
    "작게": .volumeDown, "볼륨다운": .volumeDown, "소리작게": .volumeDown,
    
    // 탐색
    "앞으로": .seekForward,
    "뒤로": .seekBackward, "되감기": .seekBackward,
    
    "빠르게": .speedUp, "빨리": .speedUp,
    "느리게": .speedDown, "천천히": .speedDown,
    
    
  ]
  
  // 빠른 매칭을 위한 핵심 명령어 목록
  static let priorityCommands = ["다음", "이전", "다시", "재생", "정지", "빨리", "천천히", "느리게", "빠르게"]
  
  // 명령어 감지 최적화 함수
  static func quickMatch(_ text: String) -> VoiceCommand? {
    let cleanText = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    
    // 우선순위 명령어 먼저 확인 (더 빠름)
    for command in priorityCommands {
      if cleanText.contains(command) {
        return commandMap[command]
      }
    }
    
    // 정확한 매치 확인
    return commandMap[cleanText]
  }
  
  
}


