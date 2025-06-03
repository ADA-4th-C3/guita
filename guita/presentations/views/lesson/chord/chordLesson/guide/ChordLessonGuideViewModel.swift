//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class ChordLessonGuideViewModel: BaseViewModel<ChordLessonGuideViewState> {
  private let audioPlayerManager = AudioPlayerManager.shared
  init() {
    super.init(state: .init())
  }

  func playAnswerSound() {
    Task {
      await audioPlayerManager.start(audioFile: .answer)
    }
  }
}
