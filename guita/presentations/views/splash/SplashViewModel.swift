//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class SplashViewModel: BaseViewModel<SplashViewState> {
  init() {
    super.init(state: .init(loaded: false))
  }

  func onLoaded() {
    emit(state.copy(loaded: true))
  }
}
