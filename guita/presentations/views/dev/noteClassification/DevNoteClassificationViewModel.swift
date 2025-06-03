//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

final class DevNoteClassificationViewModel: BaseViewModel<DevNoteClassificationViewState> {
  private let audioRecorderManager: AudioRecorderManager = .shared
  private let noteClassification: NoteClassification = .init()

  init() {
    super.init(state: .init(
      recordPermissionState: audioRecorderManager.getRecordPermissionState(),
      note: nil,
      confidence: nil
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
      guard let (note, confidence) = self.noteClassification.run(
        buffer: buffer,
        sampleRate: self.audioRecorderManager.sampleRate,
        windowSize: self.audioRecorderManager.windowSize
      ) else {
        return
      }
      self.emit(self.state.copy(note: { note }, confidence: { confidence }))
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
