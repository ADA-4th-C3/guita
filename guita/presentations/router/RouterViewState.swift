//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum RootPage {
  case splash
  case home
}

enum SubPage: Hashable {
  case curriculum
  case lesson(songInfo: SongInfo)
  case chord(songInfo: SongInfo)
  case chordLesson(chord: Chord, chords: [Chord])
  case techniqueLesson
  case techniqueLessonGuide
  case sectionLesson

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
