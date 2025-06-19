//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

final class ChordLessonGuideViewModel: BaseViewModel<ChordLessonGuideViewState> {
  private let audioPlayerManager = AudioPlayerManager.shared
  init() {
    super.init(state: .init())
  }

//  func playSound(_ audioFile: AudioFile, announcement: String) {
//    // 1. 보이스오버에게 읽어달라고 요청
//    UIAccessibility.post(notification: .announcement, argument: announcement)
//
//    // 2. 읽기 완료시 알림 받기
//    NotificationCenter.default.addObserver(forName: UIAccessibility.announcementDidFinishNotification, object: nil, queue: .main) { [weak self] notification in
//      // 읽기 완료 후 사운드 재생
//      Task {
//        await self?.audioPlayerManager.start(audioFile: audioFile)
//      }
//    }
//  }
  // }

  func playSound(_ audioFile: AudioFile) {
    Task {
      await audioPlayerManager.start(audioFile: audioFile)
    }
  }
}
