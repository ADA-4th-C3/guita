//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

final class NoteClassificationViewModel: BaseViewModel<NoteClassificationViewState> {
  let audioRecorderManager: AudioRecorderManager = .shared
  let noteClassification: NoteClassification = .init()

  init() {
    super.init(state: .init(
      recordPermissionState: audioRecorderManager.getRecordPermissionState(),
      note: nil
    ))
  }

  func requestRecordPermission() {
    audioRecorderManager.requestRecordPermission { isGranted in
      self.emit(self.state.copy(
        recordPermissionState: isGranted ? .granted : .denied
      ))

      if isGranted {
        self.startRecording()
      }
    }
  }

  func startRecording() {
    audioRecorderManager.start { buffer, _ in
      guard let note = self.noteClassification.run(
        buffer: buffer,
        sampleRate: self.audioRecorderManager.sampleRate,
        windowSize: self.audioRecorderManager.windowSize
      ) else {
        return
      }
      self.emit(self.state.copy(note: { note }))
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
    audioRecorderManager.stop()
  }
}
