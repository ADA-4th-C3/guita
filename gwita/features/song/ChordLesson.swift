//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class ChordLesson {
  private let textToSpeechManager = TextToSpeechManager.shared
  private let chord: Chord
  
  init(_ chord: Chord) {
    self.chord = chord
  }
  
  
  func startIntroduction(_ isReplay: Bool) async -> Void {
    let plets = chord.frets.map { $0.koreanOrdinal }
    let nFingers = chord.nFingers
    let contentText = "\(chord)코드는 \(plets) 플랫이 사용되고, \(nFingers)개의 손가락을 사용합니다."
    let functionText = "다음 학습으로 넘어가시려면 \"다음\"을, 다시 들으시려면 \"다시\"를 말씀해 주세요."
    let text = contentText + (isReplay ? "" : functionText)
    await textToSpeechManager.speak(text)
  }
  
  func startLineByLine(_ isReplay: Bool) async -> Void {
  }
  
  func startFullChord(_ isReplay: Bool) async -> Void {
  }
  
  
}
