//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

class BaseViewModel<State>: NSObject, ObservableObject {
  @Published private(set) var state: State

  init(state: State) {
    self.state = state
  }

  func emit(_ newState: State) {
    if Thread.isMainThread {
      state = newState
    } else {
      DispatchQueue.main.sync {
        self.state = newState
      }
    }
  }

  func dispose() {}
}
