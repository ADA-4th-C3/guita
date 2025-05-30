//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

/// 레슨 모델 - 개별 기타 학습 레슨의 정보를 담는 데이터 모델
struct LessonModel: Identifiable {
  
  
  let id: String                    // 고유 식별자
  let title: String                 // 레슨 제목
  let subtitle: String              // 레슨 부제목 (코드 정보)
  let codes: [String]               // 사용되는 코드 배열
  let isUnlocked: Bool              // 잠금 해제 여부
  let isCompleted: Bool             // 완료 여부
  let codeType: CodeType            // 주요 코드 타입
  let difficulty: LessonDifficulty  // 난이도
  
  
  init(
    id: String,
    title: String,
    subtitle: String,
    codes: [String],
    isUnlocked: Bool = false,
    isCompleted: Bool = false,
    codeType: CodeType,
    difficulty: LessonDifficulty = .beginner
  ) {
    self.id = id
    self.title = title
    self.subtitle = subtitle
    self.codes = codes
    self.isUnlocked = isUnlocked
    self.isCompleted = isCompleted
    self.codeType = codeType
    self.difficulty = difficulty
  }
}

/// 레슨 난이도
enum LessonDifficulty: String, CaseIterable {
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

/// 레슨 데이터 팩토리 - 기본 레슨 데이터를 생성
struct LessonDataFactory {
  
  /// 기본 레슨 목록 생성
  static func createDefaultLessons() -> [LessonModel] {
    return [
      // A 코드 레슨
      LessonModel(
        id: "lesson_a_1",
        title: "[초급1] 여행을 떠나요",
        subtitle: "A B7 E",
        codes: ["A", "B7", "E"],
        isUnlocked: true,  // 첫 번째 레슨은 기본적으로 해제
        isCompleted: false,
        codeType: .a,
        difficulty: .beginner
      ),
      
      // E 코드 레슨
      LessonModel(
        id: "lesson_e_1",
        title: "[초급2] 바람이 불어오는 곳",
        subtitle: "E A B7",
        codes: ["E", "A", "B7"],
        isUnlocked: false,
        isCompleted: false,
        codeType: .e,
        difficulty: .beginner
      ),
      
      // B7 코드 레슨
      LessonModel(
        id: "lesson_b7_1",
        title: "[초급3] 작은 별",
        subtitle: "B7 E A",
        codes: ["B7", "E", "A"],
        isUnlocked: false,
        isCompleted: false,
        codeType: .b7,
        difficulty: .beginner
      ),
      
      // C 코드 레슨
      LessonModel(
        id: "lesson_c_1",
        title: "[중급1] 학교종이 땡땡땡",
        subtitle: "C G F",
        codes: ["C", "G", "F"],
        isUnlocked: false,
        isCompleted: false,
        codeType: .c,
        difficulty: .intermediate
      ),
      
      // G 코드 레슨
      LessonModel(
        id: "lesson_g_1",
        title: "[중급2] 고향의 봄",
        subtitle: "G C D",
        codes: ["G", "C", "D"],
        isUnlocked: false,
        isCompleted: false,
        codeType: .g,
        difficulty: .intermediate
      ),
      
      // F 코드 레슨
      LessonModel(
        id: "lesson_f_1",
        title: "[중급3] 아리랑",
        subtitle: "F C G",
        codes: ["F", "C", "G"],
        isUnlocked: false,
        isCompleted: false,
        codeType: .f,
        difficulty: .intermediate
      ),
      
      // D 코드 레슨
      LessonModel(
        id: "lesson_d_1",
        title: "[고급1] 동백아가씨",
        subtitle: "D A G",
        codes: ["D", "A", "G"],
        isUnlocked: false,
        isCompleted: false,
        codeType: .d,
        difficulty: .advanced
      ),
      
      // Am 코드 레슨
      LessonModel(
        id: "lesson_am_1",
        title: "[고급2] 섬집아기",
        subtitle: "Am F C G",
        codes: ["Am", "F", "C", "G"],
        isUnlocked: false,
        isCompleted: false,
        codeType: .am,
        difficulty: .advanced
      ),
      
      // Dm 코드 레슨
      LessonModel(
        id: "lesson_dm_1",
        title: "[고급3] 그리운 금강산",
        subtitle: "Dm A F",
        codes: ["Dm", "A", "F"],
        isUnlocked: false,
        isCompleted: false,
        codeType: .dm,
        difficulty: .advanced
      ),
      
      // Em 코드 레슨
      LessonModel(
        id: "lesson_em_1",
        title: "[고급4] 진달래꽃",
        subtitle: "Em Am D G",
        codes: ["Em", "Am", "D", "G"],
        isUnlocked: false,
        isCompleted: false,
        codeType: .em,
        difficulty: .advanced
      )
    ]
  }
}
