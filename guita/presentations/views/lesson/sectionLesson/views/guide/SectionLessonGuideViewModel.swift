//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

final class SectionLessonGuideViewModel: BaseViewModel<SectionLessonGuideViewState> {
  private let audioPlayerManager = AudioPlayerManager.shared

  init() {
    super.init(state: .init())
  }

  func playSound(_ audioFile: AudioFile) {
    Task {
      await audioPlayerManager.start(audioFile: audioFile)
    }
  }
}
