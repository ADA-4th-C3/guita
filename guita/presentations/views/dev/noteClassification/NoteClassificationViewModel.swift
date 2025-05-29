//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

final class NoteClassificationViewModel: BaseViewModel<NoteClassificationViewState> {
  let audioManager: AudioManager = .shared
  let noteClassification: NoteClassification = .init()

  init() {
    super.init(state: .init(
      recordPermissionState: audioManager.getRecordPermissionState(),
      note: nil
    ))
  }

  func requestRecordPermission() {
    audioManager.requestRecordPermission { isGranted in
      self.emit(self.state.copy(
        recordPermissionState: isGranted ? .granted : .denied
      ))

      if isGranted {
        self.startRecording()
      }
    }
  }

  func startRecording() {
    audioManager.start() { buffer, _ in
      guard let note = self.noteClassification.run(
        buffer: buffer,
        sampleRate: self.audioManager.sampleRate,
        windowSize: self.audioManager.windowSize
      ) else {
        return
      }
      self.emit(self.state.copy(note: {note}))
    }
  }

  func openSettings() {
    if let url = URL(string: UIApplication.openSettingsURLString),
       UIApplication.shared.canOpenURL(url)
    {
      UIApplication.shared.open(url)
    }
  }

  override func dispose() {
    audioManager.stop()
  }
}
