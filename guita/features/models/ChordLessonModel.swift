//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 코드 레슨 모델 - 개별 기타 코드의 학습 정보를 담는 데이터 모델
struct ChordLessonModel: Identifiable {
  let id: String                    // 고유 식별자
  let chordType: CodeType           // 학습할 코드 타입 (A, E, B7 등)
  let fingerPositions: [FingerPosition]  // 손가락 위치 배열
  let fretPositions: [Int]          // 프렛 위치 배열
  let difficulty: ChordDifficulty   // 코드 난이도
  let isUnlocked: Bool              // 잠금 해제 여부
  let isCompleted: Bool             // 완료 여부
  let description: String           // 코드 설명
  
  init(
    id: String,
    chordType: CodeType,
    fingerPositions: [FingerPosition],
    fretPositions: [Int],
    difficulty: ChordDifficulty,
    isUnlocked: Bool = false,
    isCompleted: Bool = false,
    description: String = ""
  ) {
    self.id = id
    self.chordType = chordType
    self.fingerPositions = fingerPositions
    self.fretPositions = fretPositions
    self.difficulty = difficulty
    self.isUnlocked = isUnlocked
    self.isCompleted = isCompleted
    self.description = description.isEmpty ? "\(chordType.rawValue) 코드 학습" : description
  }
  
  /// 코드 표시명
  var displayName: String {
    return chordType.displayName
  }
  
  /// 코드 학습 제목
  var title: String {
    return "[\(difficulty.displayName)] \(chordType.rawValue) 코드"
  }
}

/// 손가락 위치 모델
struct FingerPosition {
  let finger: FingerType    // 검지, 중지, 약지, 소지
  let fret: Int            // 프렛 번호 (0: 개방현)
  let string: Int          // 줄 번호 (1-6번줄)
  
  /// 위치 설명
  var description: String {
    let fretDesc = fret == 0 ? "개방현" : "\(fret)번 프렛"
    return "\(finger.displayName): \(fretDesc) \(string)번줄"
  }
}

/// 손가락 타입
enum FingerType: String, CaseIterable {
  case thumb = "thumb"      // 엄지
  case index = "index"      // 검지
  case middle = "middle"    // 중지
  case ring = "ring"        // 약지
  case pinky = "pinky"      // 소지
  
  var displayName: String {
    switch self {
    case .thumb: return "엄지"
    case .index: return "검지"
    case .middle: return "중지"
    case .ring: return "약지"
    case .pinky: return "소지"
    }
  }
}

/// 코드 난이도
enum ChordDifficulty: String, CaseIterable {
  case beginner = "초급"
  case intermediate = "중급"
  case advanced = "고급"
  
  var displayName: String {
    return rawValue
  }
  
  var color: String {
    switch self {
    case .beginner: return "green"
    case .intermediate: return "orange"
    case .advanced: return "red"
    }
  }
}

/// 코드 레슨 데이터 팩토리 - 기본 코드 레슨 데이터를 생성
struct ChordLessonDataFactory {
  
  /// 기본 코드 레슨 목록 생성
  static func createDefaultChordLessons() -> [ChordLessonModel] {
    return [
      // A 코드 레슨
      ChordLessonModel(
        id: "chord_a",
        chordType: .a,
        fingerPositions: [
          FingerPosition(finger: .index, fret: 2, string: 4),
          FingerPosition(finger: .middle, fret: 2, string: 3),
          FingerPosition(finger: .ring, fret: 2, string: 2)
        ],
        fretPositions: [0, 0, 2, 2, 2, 0], // 6줄부터 1줄까지
        difficulty: .beginner,
        isUnlocked: true,
        description: "A 코드는 2번 프렛에 검지, 중지, 약지를 나란히 배치하는 기본 코드다"
      ),
      
      // E 코드 레슨
      ChordLessonModel(
        id: "chord_e",
        chordType: .e,
        fingerPositions: [
          FingerPosition(finger: .middle, fret: 2, string: 5),
          FingerPosition(finger: .ring, fret: 2, string: 4)
        ],
        fretPositions: [0, 2, 2, 1, 0, 0],
        difficulty: .beginner,
        isUnlocked: false,
        description: "E 코드는 가장 쉬운 기본 코드 중 하나다"
      ),
      
      // B7 코드 레슨
      ChordLessonModel(
        id: "chord_b7",
        chordType: .b7,
        fingerPositions: [
          FingerPosition(finger: .index, fret: 1, string: 4),
          FingerPosition(finger: .middle, fret: 2, string: 5),
          FingerPosition(finger: .ring, fret: 2, string: 3),
          FingerPosition(finger: .pinky, fret: 2, string: 1)
        ],
        fretPositions: [2, 0, 2, 1, 2, 2],
        difficulty: .intermediate,
        isUnlocked: false,
        description: "B7 코드는 세븐스 코드의 기본이 되는 중급 코드다"
      ),
      
      // C 코드 레슨
      ChordLessonModel(
        id: "chord_c",
        chordType: .c,
        fingerPositions: [
          FingerPosition(finger: .index, fret: 1, string: 2),
          FingerPosition(finger: .middle, fret: 2, string: 4),
          FingerPosition(finger: .ring, fret: 3, string: 5)
        ],
        fretPositions: [0, 1, 0, 2, 3, 0],
        difficulty: .beginner,
        isUnlocked: false,
        description: "C 코드는 다양한 곡에서 자주 사용되는 기본 코드다"
      ),
      
      // G 코드 레슨
      ChordLessonModel(
        id: "chord_g",
        chordType: .g,
        fingerPositions: [
          FingerPosition(finger: .middle, fret: 3, string: 6),
          FingerPosition(finger: .ring, fret: 3, string: 1)
        ],
        fretPositions: [3, 0, 0, 0, 0, 3],
        difficulty: .intermediate,
        isUnlocked: false,
        description: "G 코드는 손가락을 넓게 펼쳐야 하는 중급 코드다"
      ),
      
      // F 코드 레슨
      ChordLessonModel(
        id: "chord_f",
        chordType: .f,
        fingerPositions: [
          FingerPosition(finger: .index, fret: 1, string: 6),
          FingerPosition(finger: .index, fret: 1, string: 2),
          FingerPosition(finger: .index, fret: 1, string: 1),
          FingerPosition(finger: .middle, fret: 2, string: 3),
          FingerPosition(finger: .ring, fret: 3, string: 5),
          FingerPosition(finger: .pinky, fret: 3, string: 4)
        ],
        fretPositions: [1, 1, 2, 3, 3, 1],
        difficulty: .advanced,
        isUnlocked: false,
        description: "F 코드는 바레 코드의 기본으로 고급 기술이 필요한 코드다"
      ),
      
      // D 코드 레슨
      ChordLessonModel(
        id: "chord_d",
        chordType: .d,
        fingerPositions: [
          FingerPosition(finger: .index, fret: 2, string: 1),
          FingerPosition(finger: .middle, fret: 2, string: 3),
          FingerPosition(finger: .ring, fret: 3, string: 2)
        ],
        fretPositions: [0, 0, 0, 2, 3, 2],
        difficulty: .intermediate,
        isUnlocked: false,
        description: "D 코드는 높은 음역대의 밝은 사운드를 가진 코드다"
      ),
      
      // Am 코드 레슨
      ChordLessonModel(
        id: "chord_am",
        chordType: .am,
        fingerPositions: [
          FingerPosition(finger: .index, fret: 1, string: 2),
          FingerPosition(finger: .middle, fret: 2, string: 4),
          FingerPosition(finger: .ring, fret: 2, string: 3)
        ],
        fretPositions: [0, 0, 2, 2, 1, 0],
        difficulty: .beginner,
        isUnlocked: false,
        description: "Am 코드는 감정적인 마이너 코드의 대표격이다"
      ),
      
      // Dm 코드 레슨
      ChordLessonModel(
        id: "chord_dm",
        chordType: .dm,
        fingerPositions: [
          FingerPosition(finger: .index, fret: 1, string: 1),
          FingerPosition(finger: .middle, fret: 2, string: 3),
          FingerPosition(finger: .ring, fret: 3, string: 2)
        ],
        fretPositions: [0, 0, 0, 2, 3, 1],
        difficulty: .intermediate,
        isUnlocked: false,
        description: "Dm 코드는 슬픈 감정을 표현하는 마이너 코드다"
      ),
      
      // Em 코드 레슨
      ChordLessonModel(
        id: "chord_em",
        chordType: .em,
        fingerPositions: [
          FingerPosition(finger: .middle, fret: 2, string: 5),
          FingerPosition(finger: .ring, fret: 2, string: 4)
        ],
        fretPositions: [0, 2, 2, 0, 0, 0],
        difficulty: .beginner,
        isUnlocked: false,
        description: "Em 코드는 가장 쉬운 마이너 코드 중 하나다"
      )
    ]
  }
  
  /// 특정 코드 타입의 레슨 반환
  static func getChordLesson(for codeType: CodeType) -> ChordLessonModel? {
    return createDefaultChordLessons().first { $0.chordType == codeType }
  }
  
  /// 난이도별 코드 레슨 반환
  static func getChordLessons(for difficulty: ChordDifficulty) -> [ChordLessonModel] {
    return createDefaultChordLessons().filter { $0.difficulty == difficulty }
  }
}
