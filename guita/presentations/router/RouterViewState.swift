//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

enum RootPage {
  case splash
  case home
  var title: String {
    switch self {
    case .home:
      return NSLocalizedString("Router.Home", comment: "귀타 시작")
    case .splash:
      return NSLocalizedString("Router.Splash", comment: "스플래쉬")
    }
  }
}

enum SubPage: Hashable {
  case curriculum
  case lesson(songInfo: SongInfo)
  case chord(songInfo: SongInfo)
  case chordLesson(chord: Chord, chords: [Chord])
  case chordLessonGuide
  case techniqueLesson
  case techniqueLessonGuide
  case sectionLesson
  case sectionLessonGuide
  case fullLesson(songInfo: SongInfo)
  case fullLessonGuide

  // MARK: Dev
  case dev
  case devNoteClassification
  case devCodeClassification
  case devVoiceCommand
  case devConfig
  case devPermission
  case devTextToSpeech
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

extension SubPage {
  var title: String {
    switch self {
    case .curriculum:
      return NSLocalizedString("Router.Curriculum", comment: "학습 목록")
    case let .lesson(songInfo):
      return String(
        format: NSLocalizedString("Router.Lesson", comment: ""),
        "\(songInfo.level)"
      )
    case .chord:
      return NSLocalizedString("Router.Chord", comment: "코드 학습")
    case let .chordLesson(chord, _):
      return String(
        format: NSLocalizedString("Router.ChordLesson", comment: ""),
        "\(chord)"
      )
    case .chordLessonGuide:
      return NSLocalizedString("Router.ChordLessonGuide", comment: "코드 학습 도움말")
    case .techniqueLesson:
      return NSLocalizedString("Router.TechniqueLesson", comment: "주법 학습")
    case .techniqueLessonGuide:
      return NSLocalizedString("Router.TechniqueLessonGuide", comment: "")
    case .sectionLesson:
      return NSLocalizedString("Router.SectionLesson", comment: "")
    case .sectionLessonGuide:
      return NSLocalizedString("Router.SectionLessonGuide", comment: "")
    case let .fullLesson(songInfo):
      return String(
        format: NSLocalizedString("Router.FullLesson", comment: ""),
        "\(songInfo.title)"
      )
    case .fullLessonGuide:
      return NSLocalizedString("Router.FullLessonGuide", comment: "")
    case .dev:
      return "개발"
    case .devNoteClassification:
      return "노트 분류"
    case .devCodeClassification:
      return "코드 분류"
    case .devVoiceCommand:
      return "음성 명령"
    case .devConfig:
      return "설정"
    case .devPermission:
      return "권한"
    case .devTextToSpeech:
      return "TTS"
    }
  }
}
