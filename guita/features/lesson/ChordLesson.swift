//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

final class ChordLesson: BaseLesson {
  private let voiceCommandManager = VoiceCommandManager.shared
  private let audioPlayerManager = AudioPlayerManager.shared
  private let textToSpeechManager = TextToSpeechManager.shared
  private let voiceCommandGuide = NSLocalizedString("ChordLesson.VoiceCommandGuide", comment: "")
  private var isNoteClassificationEnabled: Bool = false
  private var isChordClassificationEnabled: Bool = false
  let chord: Chord
  let steps: [ChordLessonStep]
  var totalStep: Int { steps.count }
  private var coordIdx: Int = 0
  
  init(_ chord: Chord) {
    self.chord = chord
    
    var result: [ChordLessonStep] = []
    
    // Add intro
    result.append(.introduction)
    
    // Add lineFingering & lineSoundCheck
    var isFirst = true
    for coordIdx in chord.coordinates.indices {
      let coordinate = chord.coordinates[coordIdx]
      let nFret = coordinate.0.first!.fret
      let nString = coordinate.0.first!.string
      let nFinger = coordinate.1
      result.append(.lineFingering(nString: nString, nFret: nFret, nFinger: nFinger, coordIdx: coordIdx, isFirst: isFirst))
      isFirst = false
      
      result.append(.lineSoundCheck(nString: nString, nFret: nFret, nFinger: nFinger, coordIdx: coordIdx))
    }
    
    // Add chord fingering
    result.append(.chordFingering)
    
    // Add chord sound check
    result.append(.chordSoundCheck)
    
    // Add finish
    result.append(.finish)
    steps = result
  }
  
  override func onLessonCancel(_: any Error) {
    audioPlayerManager.stop()
    textToSpeechManager.stop()
  }
  
  /// 현재 단계
  private func currentStep(_ isReplay: Bool, _ index: Int) -> String {
    return isReplay
    ? ""
    : String(
      format: NSLocalizedString("ChordLesson.OnlyCurrentStep", comment: ""),
      (index + 1).ordinal
    )
    
    /// verbose version
    // return isReplay
    // ? ""
    // : String(
    //   format: NSLocalizedString("ChordLesson.CurrentStep", comment: ""),
    //   (index + 1).ordinal,
    //   totalStep.ordinal
    // )
  }
  
  /// Replay에서 읽지 않는 텍스트
  private func doNotReplayText(_ isReplay: Bool, _ text: String) -> String {
    return isReplay ? "" : text
  }
  
  /// 개요
  func startIntroduction(_ isReplay: Bool, announceVoiceCommand: Bool) async {
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
        let plets = self.chord.frets.map { $0.ordinal }.joined(separator: ", ")
        let nFingers = self.chord.nFingers
        let text = String(
          format: NSLocalizedString("ChordLesson.Intro.Desc", comment: ""),
          "\(self.chord)",
          "\(plets)",
          "\(nFingers)"
        )
        await self.textToSpeechManager.speak(text)
      },
      
      // MARK: Voice Command 기능 설명
      {
        if announceVoiceCommand {
          let text = self.doNotReplayText(isReplay, self.voiceCommandGuide)
          
          // TTS feedback loop 이슈 해결
          await self.voiceCommandManager.pause {
            await self.textToSpeechManager.speak(text)
          }
        }
      },
    ])
  }
  
  /// 한 줄씩 운지법 설명
  func startLineFingering(isFirst: Bool, isReplay: Bool, index: Int, nString: Int, nFret: Int, nFinger: Int, coordIdx _: Int) async {
    isNoteClassificationEnabled = false
    isChordClassificationEnabled = false
    let (fret, string, finger) = (nFret.ordinal, nString.ordinal, nFinger.fingerName)
    await startLesson([
      // MARK: 단계
      {
        let text = self.currentStep(isReplay, index)
        await self.textToSpeechManager.speak(text)
      },
      
      // MARK: 개요
      {
        if isFirst, !isReplay {
          let text = String(
            format: NSLocalizedString("ChordLesson.LineFingering.Intro", comment: ""),
            "\(self.chord)"
          )
          await self.voiceCommandManager.pause {
            await self.textToSpeechManager.speak(text)
          }
        }
      },
      
      // MARK: 운지법 설명
      {
        let text = String(
          format: NSLocalizedString("ChordLesson.LineFingering.Desc", comment: ""),
          fret,
          string,
          finger
        )
        await self.textToSpeechManager.speak(text)
      },
    ])
  }
  
  /// 한 줄씩 사운드 체크
  func startLineSoundCheck(_ isReplay: Bool, index: Int, nString: Int, nFret _: Int, nFinger _: Int, coordIdx: Int) async {
    isNoteClassificationEnabled = false
    isChordClassificationEnabled = false
    let string = nString.ordinal
    await startLesson([
      // MARK: 단계
      {
        let text = self.currentStep(isReplay, index)
        await self.textToSpeechManager.speak(text)
      },
      
      // MARK: 설명1
      {
        let text = String(
          format: NSLocalizedString("ChordLesson.LineSoundCheck.Desc", comment: ""),
          "\(string)"
        )
        await self.textToSpeechManager.speak(text)
      },
      
      // MARK: 재생 - 한 줄 소리
      {
        self.coordIdx = coordIdx
        let audioKey = "\(self.chord.rawValue)_\(nString).wav"
        if let audioFile = AudioFile(rawValue: audioKey) {
          await self.audioPlayerManager.start(audioFile: audioFile)
        } else {
          Logger.e("Invalid audio file name: \(audioKey)")
        }
      },
      
      // MARK: 설명2
      {
        let text = String(
          format: NSLocalizedString("ChordLesson.LineSoundCheck.Desc2", comment: ""),
          "\(string)"
        )
        await self.textToSpeechManager.speak(text)
        self.isNoteClassificationEnabled = true
      },
    ])
  }
  
  /// 코드 운지법 확인
  func startChordFingering(_ isReplay: Bool, index: Int) async {
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
        let text = self.doNotReplayText(
          isReplay,
          String(
            format: NSLocalizedString("ChordLesson.ChordFingering.Intro", comment: ""),
            "\(self.chord)"
          )
        )
        await self.voiceCommandManager.pause {
          await self.textToSpeechManager.speak(text)
        }
      },
      
      // MARK: 설명
      {
        var text = ""
        for i in 0 ..< self.chord.coordinates.count {
          let isFirst = i == 0
          let isLast = i == self.chord.coordinates.count - 1
          let order = NSLocalizedString(
            isFirst ? "Order.First"
            : isLast ? "Order.Last"
            : "Order.Next",
            comment: ""
          )
          let coordinate = self.chord.coordinates[i]
          let nFret = coordinate.0.first!.fret
          let nString = coordinate.0.first!.string
          let nFinger = coordinate.finger
          let (fret, string, finger) = (nFret.ordinal, nString.ordinal, nFinger.fingerName)
          text += String(
            format: NSLocalizedString("ChordLesson.ChordFingering.Desc", comment: ""),
            finger,
            fret,
            string,
            order
          )
        }
        await self.voiceCommandManager.pause {
          await self.textToSpeechManager.speak(text)
        }
      },
    ])
  }
  
  /// 코드 소리 확인
  func startChordSoundCheck(_ isReplay: Bool, index: Int) async {
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
        let text = self.doNotReplayText(
          isReplay,
          String(
            format: NSLocalizedString("ChordLesson.ChordSoundCheck.Intro", comment: ""),
            "\(self.chord)"
          )
        )
        await self.textToSpeechManager.speak(text)
      },
      
      // MARK: 설명
      {
        let text = String(
          format: NSLocalizedString("ChordLesson.ChordSoundCheck.Desc", comment: ""),
          "\(self.chord)"
        )
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
        let text = NSLocalizedString("ChordLesson.ChordSoundCheck2", comment: "")
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
        var text = String(
          format: NSLocalizedString("ChordLesson.Finish.Intro", comment: ""),
          "\(self.chord)"
        )
        if nextChord != nil {
          // 다음 chord 학습
          text += String(
            format: NSLocalizedString("ChordLesson.Finish.Next", comment: ""),
            "\(nextChord!)"
          )
        } else {
          // 화면 종료
          text += NSLocalizedString("ChordLesson.Finish.Done", comment: "")
        }
        await self.voiceCommandManager.pause {
          await self.textToSpeechManager.speak(text)
        }
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
  func onNoteClassified(userNote: Note?) {
    if !isNoteClassificationEnabled { return }
    guard let userNote = userNote else { return }
    guard coordIdx >= 0 && coordIdx < chord.notes.count else { return }
    let note = chord.notes[coordIdx]
    // Logger.d("Note : \(note), User Note : \(userNote)")
    if note == userNote {
      Task {
        await self.audioPlayerManager.start(audioFile: .answer)
      }
    }
  }
}
