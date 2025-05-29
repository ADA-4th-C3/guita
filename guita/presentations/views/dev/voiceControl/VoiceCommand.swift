//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum VoiceCommand {
  case play, pause, next, previous, replay
  case volumeUp, volumeDown
  case seekForward, seekBackward
  
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
    "앞으로": .seekForward, "빨리감기": .seekForward,
    "뒤로": .seekBackward, "되감기": .seekBackward
  ]
}
