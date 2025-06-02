//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum RootPage {
  case splash
  case home
}

<<<<<<< HEAD
enum SubPage: Hashable, Equatable {

  case dev
  case pitchClassification
  case codeClassification
  case voiceControl
  
  // 기타 학습 관련 화면들
  case guitarLearning        // 기타 학습 메인
  case learningOptions(SongModel)  // 학습 옵션 선택 (노래 정보 포함)
  
  // 코드 학습 (ChordLessonModel 기반)
  case chordLearningList           // 코드 학습 리스트 (기존 codeLearningList 대체)
  case codeDetail(SongModel, Chord)  // 코드 상세 학습
  case codeHelp(Chord)    // 코드 도움말
  
  // 주법 학습
  case techniqueDetail(SongModel)       // 주법 학습
  case techniqueList
  case techniqueHelp         // 주법 도움말
  
  // 구간 학습
  case sectionPractice(SongModel)       // 곡 구간 학습
  case sectionPracticeHelp   // 곡 구간 학습 도움말
  
  // 곡 전체 학습
  case fullSongPractice(SongModel)      // 곡 전체 학습
  case fullSongPracticeHelp  // 곡 전체 학습 도움말
}

enum CodeType: String, CaseIterable {
  case a = "A"
  case b7 = "B7"
  case e = "E"
  case c = "C"
  case dm = "Dm"
  case em = "Em"
  case f = "F"
  case g = "G"
  case am = "Am"
  case bdim = "Bdim"
  case d = "D"
  
  var displayName: String {
    return rawValue + " 코드"
  }
  
  /// 코드의 기본 정보 (ChordLessonModel과 연동)
  var basicInfo: String {
    switch self {
    case .a: return "2번 프렛에 검지, 중지, 약지를 나란히 배치"
    case .e: return "가장 쉬운 기본 코드 중 하나"
    case .b7: return "세븐스 코드의 기본이 되는 중급 코드"
    case .c: return "다양한 곡에서 자주 사용되는 기본 코드"
    case .g: return "손가락을 넓게 펼쳐야 하는 중급 코드"
    case .f: return "바레 코드의 기본으로 고급 기술이 필요"
    case .d: return "높은 음역대의 밝은 사운드를 가진 코드"
    case .am: return "감정적인 마이너 코드의 대표격"
    case .dm: return "슬픈 감정을 표현하는 마이너 코드"
    case .em: return "가장 쉬운 마이너 코드 중 하나"
    case .bdim: return "디미니시드 코드로 고급 화성"
    }
  }
  
  /// 코드 난이도
  var difficulty: ChordDifficulty {
    switch self {
    case .a, .e, .c, .am, .em: return .beginner
    case .b7, .g, .d, .dm: return .intermediate
    case .f, .bdim: return .advanced
    }
  }
=======
enum SubPage: Hashable {
  case curriculum
  case lesson(songInfo: SongInfo)
  case chord(songInfo: SongInfo)
  case chordLesson(chord: Chord, chords: [Chord])
  case techniqueLesson
  case techniqueLessonGuide

  // MARK: Dev
  case dev
  case devNoteClassification
  case devCodeClassification
  case devVoiceCommand
  case devConfig
  case devPermission
  case devTextToSpeech
>>>>>>> 8690b84b1301a3c2d88814b9f221dd051c749701
}

struct RouterViewState {
  let rootPage: RootPage
  let subPages: [SubPage]
  
  func copy(
    rootPage: RootPage? = nil,
    subPages: [SubPage]? = nil
  ) -> RouterViewState {
    return RouterViewState(
      rootPage: rootPage ?? self.rootPage,
      subPages: subPages ?? self.subPages
    )
  }
}
