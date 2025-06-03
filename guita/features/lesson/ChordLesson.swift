//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

final class ChordLesson: BaseLesson {
  private let audioPlayerManager = AudioPlayerManager.shared
  private let textToSpeechManager = TextToSpeechManager.shared
  private let chord: Chord
  private let totalStep: Int
  private let functionText = "다음 학습으로 넘어가시려면 \"다음\"을, 다시 들으시려면 \"다시\"를 말씀해 주세요."
  private var isNoteClassificationEnabled: Bool = false
  private var isChordClassificationEnabled: Bool = false

  init(_ chord: Chord, _ totalStep: Int) {
    self.chord = chord
    self.totalStep = totalStep
  }

  override func onLessonCancel(_: any Error) {
    audioPlayerManager.stop()
    textToSpeechManager.stop()
  }

  /// 현재 단계
  private func currentStep(_: Bool, _ index: Int) -> String {
    return "총 \(totalStep.koCard) 단계 중 \((index + 1).koOrd)단계"
  }

  /// Replay에서 읽지 않는 텍스트
  private func doNotReplayText(_ isReplay: Bool, _ text: String) -> String {
    return isReplay ? "" : text
  }

  /// 개요
  func startIntroduction(_ isReplay: Bool) async {
    isNoteClassificationEnabled = false
    isChordClassificationEnabled = false

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
      },
    ])
  }

  /// 한 줄씩 설명
  func startLineByLine(_ isReplay: Bool, index: Int) async {
    isNoteClassificationEnabled = false
    isChordClassificationEnabled = false

    let lineIndex = index - 1
    let coordinate = chord.coordinates[lineIndex]
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

      // MARK: 재생 - 한 줄 소리
      {
        let audioKey = "\(self.chord.rawValue)_\(nString).wav"
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
        self.isNoteClassificationEnabled = true
      },
    ])
  }

  /// 전체 코드 소리 확인
  func startFullChord(_ isReplay: Bool, index: Int) async {
    isNoteClassificationEnabled = false
    isChordClassificationEnabled = false

    await startLesson([
      // MARK: 단계
      {
        let text = self.currentStep(isReplay, index)
        await self.textToSpeechManager.speak(text)
      },

      // MARK: 개요
      {
        let text = self.doNotReplayText(isReplay, "\(self.chord) 코드를 잡고 소리를 확인해 봅시다..")
        await self.textToSpeechManager.speak(text)
      },

      // MARK: 설명
      {
        var text = ""
        for i in 0 ..< self.chord.coordinates.count {
          let isLast = i == self.chord.coordinates.count - 1
          let coordinate = self.chord.coordinates[i]
          let nFret = coordinate.0.first!.fret
          let nString = coordinate.0.first!.string
          let (fret, string) = (nFret.koOrd, nString.koOrd)
          text += "\(fret) 프렛, 아래서 \(string) 줄"
          if !isLast { text += ", " }
        }
        text += "을 잡고 위에서 아래로 모든 줄을 피크로 천천히 쓸어내렸을 때"
        await self.textToSpeechManager.speak(text)
      },

      // MARK: 재생 - 한 줄 소리
      {
        let audioKey = "\(self.chord.rawValue)_stroke_down.wav"
        if let audioFile = AudioFile(rawValue: audioKey) {
          await self.audioPlayerManager.start(audioFile: audioFile)
        } else {
          Logger.e("Invalid audio file name: \(audioKey)")
        }
      },

      // MARK: 설명
      {
        let text = "\(self.chord) 코드는 이런 소리가 들려야 해요. 이제 피크로 쓸어내려보세요."
        await self.textToSpeechManager.speak(text)
        self.isChordClassificationEnabled = true
      },
    ])
  }

  /// 종료
  func startFinish(_: Bool, nextChord: Chord?) async {
    isNoteClassificationEnabled = false
    isChordClassificationEnabled = false
    await startLesson([
      // MARK: 단계
      {
        var text = "\(self.chord)코드 학습이 종료되었습니다."
        if nextChord != nil {
          // 다음 chord 학습
          text += " 다음으로 \(nextChord!) 코드를 학습하고 싶으시면 \"다음\"이라고 말씀해 주세요."
        } else {
          // 화면 종료
          text += " \"다음\"이라고 말씀하시면 이전 \"코드 선택\"화면으로 이동됩니다."
        }
        await self.textToSpeechManager.speak(text)
      },
    ])
  }

  /// Chord 분류
  func onChordClassified(userChord: Chord?) {
    if !isChordClassificationEnabled { return }
    guard let userChord = userChord else { return }
    // Logger.d("Chord : \(chord), User Chord : \(userChord)")
    if chord == userChord {
      Task {
        await self.audioPlayerManager.start(audioFile: .answer)
      }
    }
  }

  /// Note 분류
  func onNoteClassified(userNote: Note?, index: Int) {
    if !isNoteClassificationEnabled { return }
    guard let userNote = userNote else { return }
    let lineIndex = index - 1
    guard lineIndex >= 0 && lineIndex < chord.notes.count else { return }
    let note = chord.notes[lineIndex]
    // Logger.d("Note : \(note), User Note : \(userNote)")
    if note == userNote {
      Task {
        await self.audioPlayerManager.start(audioFile: .answer)
      }
    }
  }
}
