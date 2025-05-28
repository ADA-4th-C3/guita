//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum RootPage {
  case splash
  case home
}

enum SubPage {
  case curriculum
  case dev
  case pitchClassification
  case codeClassification
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
