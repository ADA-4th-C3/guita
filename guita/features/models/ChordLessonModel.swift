//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 코드 레슨 모델 - 개별 기타 코드의 학습 정보를 담는 데이터 모델
struct ChordLessonModel: Identifiable {
  let id: String                    // 고유 식별자
  let chordType: Chord             // 학습할 코드 타입 (A, E, B7 등)
  let difficulty: ChordDifficulty   // 코드 난이도
  let isUnlocked: Bool              // 잠금 해제 여부
  let isCompleted: Bool             // 완료 여부
  let description: String           // 코드 설명
  
  init(
    id: String,
    chordType: Chord,
    difficulty: ChordDifficulty,
    isUnlocked: Bool = false,
    isCompleted: Bool = false,
    description: String = ""
  ) {
    self.id = id
    self.chordType = chordType
    self.difficulty = difficulty
    self.isUnlocked = isUnlocked
    self.isCompleted = isCompleted
    self.description = description.isEmpty ? "\(chordType) 코드 학습" : description
  }
  
  /// 코드 표시명
  var displayName: String {
    return "\(chordType) 코드"
  }
  
  /// 코드 학습 제목
  var title: String {
    return "[\(difficulty.displayName)] \(chordType) 코드"
  }
  
  /// Chord.swift의 coordinates 활용
  var fingerPositions: [([(fret: Int, string: Int)], finger: Int)] {
    return chordType.coordinates
  }
  
  /// Chord.swift의 chroma 활용
  var chroma: [Float] {
    return chordType.chroma
  }
  
  /// Chord.swift의 coordinates에서 fretPositions 추출
  var fretPositions: [Int] {
    // 6줄부터 1줄까지의 프렛 번호를 배열로 반환
    // coordinates에서 각 줄별 최소 프렛 번호를 찾아서 배열로 만들기
    var frets = [Int](repeating: 0, count: 6) // 6줄 기타
    
    for (positions, _) in fingerPositions {
      for position in positions {
        let stringIndex = 6 - position.string // 6줄(인덱스0)부터 1줄(인덱스5)까지
        if stringIndex >= 0 && stringIndex < 6 {
          frets[stringIndex] = position.fret
        }
      }
    }
    
    return frets
  }
  
}
  

/// 손가락 타입 - Chord.swift의 finger 번호와 매칭
enum FingerType: Int, CaseIterable {
  case first = 1      // 검지
  case second = 2     // 중지
  case third = 3      // 약지
  case fourth = 4     // 소지
  case fifth = 5      // 엄지
  
  var displayName: String {
    switch self {
    case .first: return "검지"
    case .second: return "중지"
    case .third: return "약지"
    case .fourth: return "소지"
    case .fifth: return "엄지"
    }
  }
  
  
  
}

/// 손가락 위치 모델 (Chord.swift의 coordinates와 호환)
struct FingerPosition {
  let finger: FingerType
  let fret: Int
  let string: Int
  
  var description: String {
    let fretDesc = fret == 0 ? "개방현" : "\(fret)번 프렛"
    return "\(finger.displayName): \(fretDesc) \(string)번줄"
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

/// 코드 레슨 데이터 팩토리
struct ChordLessonDataFactory {
  
  /// 기본 코드 레슨 목록 생성
  static func createDefaultChordLessons() -> [ChordLessonModel] {
    return [
      ChordLessonModel(
        id: "chord_a",
        chordType: .A,
        difficulty: .beginner,
        isUnlocked: true,
        description: "A 코드는 2번 프렛에 검지, 중지, 약지를 나란히 배치하는 기본 코드다"
      ),
      
      ChordLessonModel(
        id: "chord_e",
        chordType: .E,
        difficulty: .beginner,
        isUnlocked: false,
        description: "E 코드는 가장 쉬운 기본 코드 중 하나다"
      ),
      
      ChordLessonModel(
        id: "chord_b7",
        chordType: .B7,
        difficulty: .intermediate,
        isUnlocked: false,
        description: "B7 코드는 세븐스 코드의 기본이 되는 중급 코드다"
      ),
      
      ChordLessonModel(
        id: "chord_c",
        chordType: .C,
        difficulty: .beginner,
        isUnlocked: false,
        description: "C 코드는 다양한 곡에서 자주 사용되는 기본 코드다"
      ),
      
      ChordLessonModel(
        id: "chord_g",
        chordType: .G,
        difficulty: .intermediate,
        isUnlocked: false,
        description: "G 코드는 손가락을 넓게 펼쳐야 하는 중급 코드다"
      ),
      
      ChordLessonModel(
        id: "chord_f",
        chordType: .F,
        difficulty: .advanced,
        isUnlocked: false,
        description: "F 코드는 바레 코드의 기본으로 고급 기술이 필요한 코드다"
      ),
      
      ChordLessonModel(
        id: "chord_d",
        chordType: .D,
        difficulty: .intermediate,
        isUnlocked: false,
        description: "D 코드는 높은 음역대의 밝은 사운드를 가진 코드다"
      ),
      
      ChordLessonModel(
        id: "chord_am",
        chordType: .Am,
        difficulty: .beginner,
        isUnlocked: false,
        description: "Am 코드는 감정적인 마이너 코드의 대표격이다"
      ),
      
      ChordLessonModel(
        id: "chord_dm",
        chordType: .Dm,
        difficulty: .intermediate,
        isUnlocked: false,
        description: "Dm 코드는 슬픈 감정을 표현하는 마이너 코드다"
      ),
      
      ChordLessonModel(
        id: "chord_em",
        chordType: .Em,
        difficulty: .beginner,
        isUnlocked: false,
        description: "Em 코드는 가장 쉬운 마이너 코드 중 하나다"
      )
    ]
  }
  
  /// 특정 코드 타입의 레슨 반환
  static func getChordLesson(for chord: Chord) -> ChordLessonModel? {
    return createDefaultChordLessons().first { $0.chordType == chord }
  }
  
  /// 난이도별 코드 레슨 반환
  static func getChordLessons(for difficulty: ChordDifficulty) -> [ChordLessonModel] {
    return createDefaultChordLessons().filter { $0.difficulty == difficulty }
  }
}
