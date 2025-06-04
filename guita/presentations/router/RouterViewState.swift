//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum RootPage {
  case splash
  case home
  var title: String {
      switch self {
      case .home:
        return "귀타 시작"
      case .splash:
              return "스플래쉬"
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
      return "학습 목록"
    case .lesson(let songInfo):
      return "\(songInfo.level)"
    case .chord:
      return "코드 학습"
    case .chordLesson(let songInfo):
      return "\(songInfo.chord)코드"
    case .chordLessonGuide:
      return "코드 학습 도움말"
    case .techniqueLesson:
      return "주법 학습"
    case .techniqueLessonGuide:
      return "주법 학습 도움말"
    case .sectionLesson:
      return "곡 구간 학습 "
    case .sectionLessonGuide:
      return "곡 구간 학습 도움말"
    case .fullLesson(let songInfo):
      return "\(songInfo.title) 곡 전체 학습"
    case .fullLessonGuide:
      return "곡 전체 학습 도움말"
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
