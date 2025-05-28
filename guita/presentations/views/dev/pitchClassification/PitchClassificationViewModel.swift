//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

final class PitchClassificationViewModel: BaseViewModel<PitchClassificationViewState> {
  let audioManager: AudioManager = .shared
  let pitchClassification: PitchClassification = .init()

  init() {
    super.init(state: .init(
      recordPermissionState: audioManager.getRecordPermissionState(),
      note: "",
      frequency: 0
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
    audioManager.start(bufferSize: pitchClassification.windowSize) { buffer, _ in
      guard let result = self.pitchClassification.run(buffer: buffer, sampleRate: self.audioManager.sampleRate) else {
        return
      }
      self.emit(self.state.copy(
        note: result.note,
        frequency: result.frequency
      ))
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
