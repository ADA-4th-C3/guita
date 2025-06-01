//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 코드별 학습 단계 데이터를 생성하는 팩토리 클래스
struct ChordLearningStepFactory {
  
  /// A코드 학습 단계 생성 (6번줄부터 1번줄까지 순서대로)
  static func createAChordSteps() -> [LearningStep] {
    let chord = Chord.A
    let fingerCount = chord.coordinates.count
    
    return [
      // 1단계: 개요 설명
      LearningStep(
        id: "a_chord_overview",
        stepType: .overview,
        ttsContents: [
          TTSContent(
            text: "A코드는 두 번째 플랫이 사용되고, \(fingerCount)개의 손가락을 사용합니다.",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          ),
          TTSContent(
            text: "다음 학습으로 넘어가시려면 다음, 다시 들으시려면 다시라고 말씀해 주세요.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          )
        ],
        soundFiles: [],
        successSound: "",
        failSound: "",
        navigationSound: "click1"
      ),
      
      // 2단계: 6번줄 학습 (개방현)
      LearningStep(
        id: "a_chord_string_6",
        stepType: .singleString(stringNumber: 6),
        ttsContents: [
          TTSContent(
            text: "한 줄씩 코드를 잡아봅시다.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          ),
          TTSContent(
            text: "여섯 번째 줄은 손가락을 누르지 않고 개방현으로 튕겼을 때",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["A-6"],
        successSound: "success1",
        failSound: "fail1",
        navigationSound: "click1"
      ),
      
      // 3단계: 5번줄 학습 (개방현)
      LearningStep(
        id: "a_chord_string_5",
        stepType: .singleString(stringNumber: 5),
        ttsContents: [
          TTSContent(
            text: "다섯 번째 줄은 손가락을 누르지 않고 개방현으로 튕겼을 때",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["A-5"],
        successSound: "success1",
        failSound: "fail1",
        navigationSound: "click1"
      ),
      
      // 4단계: 4번줄 학습 (2프렛, 중지)
      LearningStep(
        id: "a_chord_string_4",
        stepType: .singleString(stringNumber: 4),
        ttsContents: [
          TTSContent(
            text: "두 번째 플랫, 아래에서 네 번째 줄을 중지손가락으로 잡으세요. 그리고 네 번째 줄을 튕겼을 때",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["A-4"],
        successSound: "success1",
        failSound: "fail1",
        navigationSound: "click1"
      ),
      
      // 5단계: 3번줄 학습 (2프렛, 약지)
      LearningStep(
        id: "a_chord_string_3",
        stepType: .singleString(stringNumber: 3),
        ttsContents: [
          TTSContent(
            text: "두 번째 플랫, 아래에서 세 번째 줄을 약지손가락으로 잡으세요. 그리고 세 번째 줄을 튕겼을 때",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["A-3"],
        successSound: "success1",
        failSound: "fail1",
        navigationSound: "click1"
      ),
      
      // 6단계: 2번줄 학습 (2프렛, 소지)
      LearningStep(
        id: "a_chord_string_2",
        stepType: .singleString(stringNumber: 2),
        ttsContents: [
          TTSContent(
            text: "두 번째 플랫, 아래에서 두 번째 줄을 소지손가락으로 잡으세요. 그리고 두 번째 줄을 튕겼을 때",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["A-2"],
        successSound: "success1",
        failSound: "fail1",
        navigationSound: "click1"
      ),
      
      // 7단계: 1번줄 학습 (개방현)
      LearningStep(
        id: "a_chord_string_1",
        stepType: .singleString(stringNumber: 1),
        ttsContents: [
          TTSContent(
            text: "첫 번째 줄은 손가락을 누르지 않고 개방현으로 튕겼을 때",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["A-1"],
        successSound: "success1",
        failSound: "fail1",
        navigationSound: "click1"
      ),
      
      // 8단계: 전체 코드 연주
      LearningStep(
        id: "a_chord_full",
        stepType: .fullChord,
        ttsContents: [
          TTSContent(
            text: "모든 손가락으로 코드를 연주해봅시다.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          ),
          TTSContent(
            text: "두 번째 플랫, 아래에서 두 번째 줄, 세 번째 줄, 네 번째 줄을 잡고 위에서 아래로 모든 줄을 쓸어내렸을 때",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.5
          )
        ],
        soundFiles: ["A_full"],
        successSound: "success2",
        failSound: "fail1",
        navigationSound: "click1"
      )
    ]
  }
  
  /// E코드 학습 단계 생성 (6번줄부터 1번줄까지 순서대로)
  static func createEChordSteps() -> [LearningStep] {
    let chord = Chord.E
    let fingerCount = chord.coordinates.count
    
    return [
      // 1단계: 개요 설명
      LearningStep(
        id: "e_chord_overview",
        stepType: .overview,
        ttsContents: [
          TTSContent(
            text: "E코드는 두 번째 플랫이 사용되고, \(fingerCount)개의 손가락을 사용합니다.",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          ),
          TTSContent(
            text: "다음 학습으로 넘어가시려면 다음, 다시 들으시려면 다시라고 말씀해 주세요.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          )
        ],
        soundFiles: [],
        successSound: "",
        failSound: "",
        navigationSound: "click1"
      ),
      
      // 2단계: 6번줄 학습 (개방현)
      LearningStep(
        id: "e_chord_string_6",
        stepType: .singleString(stringNumber: 6),
        ttsContents: [
          TTSContent(
            text: "한 줄씩 코드를 잡아봅시다.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          ),
          TTSContent(
            text: "여섯 번째 줄은 손가락을 누르지 않고 개방현으로 튕겼을 때",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["E-6"],
        successSound: "success1",
        failSound: "fail1",
        navigationSound: "click1"
      ),
      
      // 3단계: 5번줄 학습 (2프렛, 중지)
      LearningStep(
        id: "e_chord_string_5",
        stepType: .singleString(stringNumber: 5),
        ttsContents: [
          TTSContent(
            text: "두 번째 플랫, 아래에서 다섯 번째 줄을 중지손가락으로 잡으세요. 그리고 다섯 번째 줄을 튕겼을 때",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["E-5"],
        successSound: "success1",
        failSound: "fail1",
        navigationSound: "click1"
      ),
      
      // 4단계: 4번줄 학습 (2프렛, 약지)
      LearningStep(
        id: "e_chord_string_4",
        stepType: .singleString(stringNumber: 4),
        ttsContents: [
          TTSContent(
            text: "두 번째 플랫, 아래에서 네 번째 줄을 약지손가락으로 잡으세요. 그리고 네 번째 줄을 튕겼을 때",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["E-4"],
        successSound: "success1",
        failSound: "fail1",
        navigationSound: "click1"
      ),
      
      // 5단계: 3번줄 학습 (1프렛, 검지)
      LearningStep(
        id: "e_chord_string_3",
        stepType: .singleString(stringNumber: 3),
        ttsContents: [
          TTSContent(
            text: "첫 번째 플랫, 아래에서 세 번째 줄을 검지손가락으로 잡으세요. 그리고 세 번째 줄을 튕겼을 때",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["E-3"],
        successSound: "success1",
        failSound: "fail1",
        navigationSound: "click1"
      ),
      
      // 6단계: 2번줄 학습 (개방현)
      LearningStep(
        id: "e_chord_string_2",
        stepType: .singleString(stringNumber: 2),
        ttsContents: [
          TTSContent(
            text: "두 번째 줄은 손가락을 누르지 않고 개방현으로 튕겼을 때",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["E-2"],
        successSound: "success1",
        failSound: "fail1",
        navigationSound: "click1"
      ),
      
      // 7단계: 1번줄 학습 (개방현)
      LearningStep(
        id: "e_chord_string_1",
        stepType: .singleString(stringNumber: 1),
        ttsContents: [
          TTSContent(
            text: "첫 번째 줄은 손가락을 누르지 않고 개방현으로 튕겼을 때",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.0
          )
        ],
        soundFiles: ["E-1"],
        successSound: "success1",
        failSound: "fail1",
        navigationSound: "click1"
      ),
      
      // 8단계: 전체 코드 연주
      LearningStep(
        id: "e_chord_full",
        stepType: .fullChord,
        ttsContents: [
          TTSContent(
            text: "모든 손가락으로 코드를 연주해봅시다.",
            type: .function,
            canRepeat: false,
            pauseAfter: 0.5
          ),
          TTSContent(
            text: "첫 번째 플랫, 아래에서 세 번째 줄과 두 번째 플랫, 아래에서 네 번째 줄, 다섯 번째 줄을 잡고 위에서 아래로 모든 줄을 쓸어내렸을 때",
            type: .content,
            canRepeat: true,
            pauseAfter: 1.5
          )
        ],
        soundFiles: ["E_full"],
        successSound: "success2",
        failSound: "fail1",
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
