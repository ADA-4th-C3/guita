//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

final class ChordLesson: BaseLesson {
  private let audioPlayerManager = AudioPlayerManager.shared
  private let textToSpeechManager = TextToSpeechManager.shared
  private let chord: Chord
  
  init(_ chord: Chord) {
    self.chord = chord
  }
  
  func startIntroduction(_ isReplay: Bool) async {
    await startLesson([
      {
        let plets = self.chord.frets.map { $0.koreanOrdinal }
        let nFingers = self.chord.nFingers
        let contentText = "\(self.chord)코드는 \(plets) 플랫이 사용되고, \(nFingers)개의 손가락을 사용합니다."
        let functionText = "다음 학습으로 넘어가시려면 \"다음\"을, 다시 들으시려면 \"다시\"를 말씀해 주세요."
        let text = contentText + (isReplay ? "" : functionText)
        await self.textToSpeechManager.speak(text)
      }
    ])
  }
  
  func startLineByLine(_ isReplay: Bool) async {
    await startLesson([
      {
        let text = "기타 몸통에 있는 구멍을 찾아보세요. 이 구멍을 사운드 홀이라고 부릅니다. 사운드 홀 위에서 아래로 줄을 쓸어내려 보세요."
        await self.textToSpeechManager.speak(text)
      },
      {
        await self.audioPlayerManager.start(audioFile: .strokeDown)
      }
    ])
  }
  
  func startFullChord(_ isReplay: Bool) {
  }
}
