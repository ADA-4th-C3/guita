//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

final class Router: BaseViewModel<RouterViewState> {
  init() {
    super.init(state: RouterViewState(
      rootPage: .splash,
      subPages: []
    ))
  }

  /// Change root page
  func setRoot(_ rootPage: RootPage) {
    withAnimation(.easeInOut(duration: 0.5)) {
      emit(state.copy(
        rootPage: rootPage,
        subPages: []
      ))
    }
  }

  /// Change all sub pages
  func setSubPages(_ subPages: [SubPage]) {
    emit(state.copy(
      subPages: subPages
    ))
  }

  /// Push to sub page list
  func push(_ subPage: SubPage) {
    if !state.subPages.isEmpty && state.subPages.last == subPage {
      return
    }
    emit(
      state.copy(subPages: state.subPages + [subPage])
    )
  }

  /// Pop from sub page list
  func pop() {
    emit(state.copy(
      subPages: state.subPages.dropLast()
    ))
  }
}

extension Router {
  var previousTitle: String? {
    if state.subPages.count > 1 {
      return state.subPages.dropLast().last?.title
    } else {
      return state.rootPage.title
    }
  }
}
