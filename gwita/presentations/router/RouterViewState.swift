//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum RootPage {
  case splash
  case home
}

enum SubPage: Hashable {
  case curriculum

  // MARK: Dev
  case dev
  case noteClassification
  case codeClassification
  case voiceControl
  case lesson(item: SongInfo)
  case technique
  case config
  case devPermission
  case techniqueGuide
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
