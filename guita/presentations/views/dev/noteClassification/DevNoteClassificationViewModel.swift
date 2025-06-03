//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

final class DevNoteClassificationViewModel: BaseViewModel<DevNoteClassificationViewState> {
  private let audioRecorderManager: AudioRecorderManager = .shared
  private let noteClassification: NoteClassification = .init()
  private let throttleAggregator = ThrottleAggregator<Note>(interval: 2.0)
  
  init() {
    super.init(state: .init(
      recordPermissionState: audioRecorderManager.getRecordPermissionState(),
      note: nil,
      confidence: 0.0
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
      if let (note, confidence) = self.noteClassification.run(
        buffer: buffer,
        sampleRate: self.audioRecorderManager.sampleRate,
        windowSize: self.audioRecorderManager.windowSize
      ) {
        if let throttled = self.throttleAggregator.add(value: note, confidence: confidence) {
          self.emit(self.state.copy(
            note: { throttled.value },
            confidence: throttled.confidence
          ))
        }
      }
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
