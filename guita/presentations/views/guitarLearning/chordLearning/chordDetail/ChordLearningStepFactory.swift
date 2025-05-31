//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 코드별 학습 단계 데이터를 생성하는 팩토리 클래스
struct ChordLearningStepFactory {
  
  /// A코드 학습 단계 생성
  static func createAChordSteps() -> [LearningStep] {
    return [
      // 1단계: 개요 설명
      LearningStep(
        id: "a_chord_overview",
        stepType: .overview,
        ttsContents: [
          TTSContent(
            text: "A코드 학습을 시작합니다.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          ),
          TTSContent(
            text: "A코드는 2번 프렛에 검지, 중지, 약지를 나란히 배치하는 기본 코드입니다.",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          ),
          TTSContent(
            text: "총 4단계로 나누어 학습하겠습니다. 다음이라고 말하면 다음 단계로 넘어갑니다.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          )
        ],
        soundFiles: [],
        successSound: "success1",
        failSound: "",
        navigationSound: "click1"
      ),
      
      // 2단계: 4번줄 학습
      LearningStep(
        id: "a_chord_string_4",
        stepType: .singleString(stringNumber: 4),
        ttsContents: [
          TTSContent(
            text: "4번줄을 연습해보겠습니다.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          ),
          TTSContent(
            text: "검지를 2번 프렛 4번줄에 올리고 해당 줄을 한번 쳐보세요.",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["a_chord_string_4.mp3"],
        successSound: "success1",
        failSound: "fail1",
        navigationSound: "click1"
      ),
      
      // 3단계: 3번줄 학습
      LearningStep(
        id: "a_chord_string_3",
        stepType: .singleString(stringNumber: 3),
        ttsContents: [
          TTSContent(
            text: "3번줄을 연습해보겠습니다.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          ),
          TTSContent(
            text: "중지를 2번 프렛 3번줄에 올리고 해당 줄을 한번 쳐보세요.",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["a_chord_string_3.mp3"],
        successSound: "success1",
        failSound: "textSoundColor",
        navigationSound: "click1"
      ),
      
      // 4단계: 2번줄 학습
      LearningStep(
        id: "a_chord_string_2",
        stepType: .singleString(stringNumber: 2),
        ttsContents: [
          TTSContent(
            text: "2번줄을 연습해보겠습니다.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          ),
          TTSContent(
            text: "약지를 2번 프렛 2번줄에 올리고 해당 줄을 한번 쳐보세요.",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["a_chord_string_2.mp3"],
        successSound: "success1",
        failSound: "textSoundColor",
        navigationSound: "click1"
      ),
      
      // 5단계: 전체 코드 연주
      LearningStep(
        id: "a_chord_full",
        stepType: .fullChord,
        ttsContents: [
          TTSContent(
            text: "마지막 단계입니다.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          ),
          TTSContent(
            text: "이제 A코드 전체를 연주해보세요. 모든 손가락을 올바른 위치에 놓고 스트러밍해주세요.",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.5
          )
        ],
        soundFiles: ["a_chord_full.mp3"],
        successSound: "success2",
        failSound: "textSoundColor",
        navigationSound: "click1"
      )
    ]
  }
  
  /// E코드 학습 단계 생성
  static func createEChordSteps() -> [LearningStep] {
    return [
      // 1단계: 개요 설명
      LearningStep(
        id: "e_chord_overview",
        stepType: .overview,
        ttsContents: [
          TTSContent(
            text: "E코드 학습을 시작합니다.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          ),
          TTSContent(
            text: "E코드는 가장 쉬운 기본 코드 중 하나입니다. 2번 프렛에 중지와 약지를 사용합니다.",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          ),
          TTSContent(
            text: "총 3단계로 나누어 학습하겠습니다.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          )
        ],
        soundFiles: [],
        successSound: "success1",
        failSound: "",
        navigationSound: "click1"
      ),
      
      // 2단계: 5번줄 학습
      LearningStep(
        id: "e_chord_string_5",
        stepType: .singleString(stringNumber: 5),
        ttsContents: [
          TTSContent(
            text: "5번줄을 연습해보겠습니다.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          ),
          TTSContent(
            text: "중지를 2번 프렛 5번줄에 올리고 해당 줄을 한번 쳐보세요.",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["e_chord_string_5.mp3"],
        successSound: "success1",
        failSound: "textSoundColor",
        navigationSound: "click1"
      ),
      
      // 3단계: 4번줄 학습
      LearningStep(
        id: "e_chord_string_4",
        stepType: .singleString(stringNumber: 4),
        ttsContents: [
          TTSContent(
            text: "4번줄을 연습해보겠습니다.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          ),
          TTSContent(
            text: "약지를 2번 프렛 4번줄에 올리고 해당 줄을 한번 쳐보세요.",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["e_chord_string_4.mp3"],
        successSound: "success1",
        failSound: "textSoundColor",
        navigationSound: "click1"
      ),
      
      // 4단계: 전체 코드 연주
      LearningStep(
        id: "e_chord_full",
        stepType: .fullChord,
        ttsContents: [
          TTSContent(
            text: "마지막 단계입니다.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          ),
          TTSContent(
            text: "이제 E코드 전체를 연주해보세요. 1, 2, 3, 6번줄은 개방현으로 두고 스트러밍해주세요.",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.5
          )
        ],
        soundFiles: ["e_chord_full.mp3"],
        successSound: "success2",
        failSound: "textSoundColor",
        navigationSound: "click1"
      )
    ]
  }
  
  /// 코드별 학습 단계 반환
  static func createStepsForChord(_ chord: Chord) -> [LearningStep] {
    switch chord {
    case .A:
      return createAChordSteps()
    case .E:
      return createEChordSteps()
    default:
      // 다른 코드들은 추후 구현
      return createDefaultSteps(for: chord)
    }
  }
  
  /// 기본 학습 단계 (다른 코드들용 임시)
  private static func createDefaultSteps(for chord: Chord) -> [LearningStep] {
    return [
      LearningStep(
        id: "\(chord.rawValue.lowercased())_chord_default",
        stepType: .overview,
        ttsContents: [
          TTSContent(
            text: "\(chord.rawValue)코드 학습을 시작합니다. 아직 구현 중입니다.",
            type: .content,
            canRepeat: true
          )
        ],
        soundFiles: [],
        successSound: "success1",
        failSound: "",
        navigationSound: "click1"
      )
    ]
  }
}
