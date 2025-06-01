//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

final class ChordLesson: BaseLesson {
  private let audioPlayerManager = AudioPlayerManager.shared
  private let textToSpeechManager = TextToSpeechManager.shared
  private let chord: Chord
  private let totalStep: Int
  private let functionText = "다음 학습으로 넘어가시려면 \"다음\"을, 다시 들으시려면 \"다시\"를 말씀해 주세요."
  
  init(_ chord: Chord, _ totalStep: Int) {
    self.chord = chord
    self.totalStep = totalStep
  }
  
  /// 현재 단계
  private func currentStep(_ isReplay: Bool, _ index: Int) -> String {
    return "총 \(totalStep) 단계 중 \(index+1)단계"
  }
  
  /// Replay에서 읽지 않는 텍스트
  private func doNotReplayText(_ isReplay: Bool, _ text: String) -> String {
    return isReplay ? "" : text
  }
  
  /// 개요
  func startIntroduction(_ isReplay: Bool) async {
    await startLesson([
      // MARK: 단계
      {
        let text = self.currentStep(isReplay, 0)
        await self.textToSpeechManager.speak(text)
      },
      // MARK: 설명
      {
        let plets = self.chord.frets.map { $0.koOrd }
        let nFingers = self.chord.nFingers
        let text = "\(self.chord)코드는 \(plets) 플랫이 사용되고, \(nFingers)개의 손가락을 사용합니다."
        await self.textToSpeechManager.speak(text)
      },
      // MARK: 기능
      {
        let text = self.doNotReplayText(isReplay, self.functionText)
        await self.textToSpeechManager.speak(text)
      }
    ])
  }
  
  /// 한 줄씩 설명
  func startLineByLine(_ isReplay: Bool, index: Int) async {
    let lineIndex = index - 1
    
    // ([(fret: Int, string: Int)], finger: Int)
    let coordinate = self.chord.coordinates[lineIndex]
    let nFret = coordinate.0.first!.fret
    let nString = coordinate.0.first!.string
    let nFinger = coordinate.1
    let (fret, string, finger) = (nFret.koOrd, nString.koOrd, nFinger.koOrd)
    await startLesson([
      // MARK: 단계
      {
        let text = self.currentStep(isReplay, index)
        await self.textToSpeechManager.speak(text)
      },
      // MARK: 개요
      {
        if lineIndex != 0 { return }
        let text = self.doNotReplayText(isReplay, "\(self.chord) 코드를 한 줄씩 잡아봅시다.")
        await self.textToSpeechManager.speak(text)
      },
      // MARK: 운지법 설명
      // TODO: F, B 같은 BarreChord인 경우 향후 지원 예정
      {
        // let isBarreChord = coordinate.0.count > 1
        let text = "\(fret) 플랫, 아래에서 \(string) 줄을 \(finger) 손가락으로 잡으세요. 그리고 \(string) 줄을 튕겼을 때"
        await self.textToSpeechManager.speak(text)
      },
      // MARK: 한 줄 소리 재생
      {
        let audioKey = "A-\(nString)"
        if let audioFile = AudioFile(rawValue: audioKey) {
            await self.audioPlayerManager.start(audioFile: audioFile)
        } else {
          Logger.e("Invalid audio file name: \(audioKey)")
        }
      },
      // MARK: 설명
      {
        let text = "이런 소리가 들려야 해요. 이제 \(string) 줄을 튕겨볼까요?"
        await self.textToSpeechManager.speak(text)
      },
      // MARK: 기능
      {
        let text = self.doNotReplayText(isReplay, self.functionText)
        await self.textToSpeechManager.speak(text)
      }
    ])
  }
  
  func startFullChord(_ isReplay: Bool) {
  }
}
