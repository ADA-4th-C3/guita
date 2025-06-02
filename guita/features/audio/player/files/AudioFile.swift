//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

enum AudioFile: String {
  // MARK: Guitar
  case A_1 = "A_1.wav"
  case A_2 = "A_2.wav"
  case A_3 = "A_3.wav"
  case A_4 = "A_4.wav"
  case A_5 = "A_5.wav"
  case A_6 = "A_6.wav"
  case A_stroke_down = "A_stroke_down.wav"
  case A_voice = "A_voice.wav"
  case B7_1 = "B7_1.wav"
  case B7_2 = "B7_2.wav"
  case B7_3 = "B7_3.wav"
  case B7_4 = "B7_4.wav"
  case B7_5 = "B7_5.wav"
  case B7_6 = "B7_6.wav"
  case B7_stroke_down = "B7_stroke_down.wav"
  case B7_voice = "B7_voice.wav"
  case E_1 = "E_1.wav"
  case E_2 = "E_2.wav"
  case E_3 = "E_3.wav"
  case E_4 = "E_4.wav"
  case E_5 = "E_5.wav"
  case E_6 = "E_6.wav"
  case E_stroke_down = "E_stroke_down.wav"
  case E_voice = "E_voice.wav"
  case stroke_calipso_voice = "stroke_calipso_voice.wav"
  case stroke_calipso = "stroke_calipso.wav"
  case stroke_down = "stroke_down.wav"
  case stroke_up = "stroke_up.wav"

  // MARK: Effect
  case answer = "answer.wav"
  case next = "next.wav"

  var fileURL: URL? {
    let splitted = rawValue.split(separator: ".")
    guard splitted.count == 2 else { return nil }
    let name = String(splitted[0])
    let ext = String(splitted[1])
    return Bundle.main.url(forResource: name, withExtension: ext)
  }
}
