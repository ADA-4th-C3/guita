//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation
import SwiftUI

final class DevChordClassificationViewModel: BaseViewModel<DevChordClassificationViewState> {
  private let audioRecorderManager: AudioRecorderManager = .shared
  private let chordClassification = ChordClassificationWithSimilarity()
  private let throttleAggregator = ThrottleAggregator<Chord>(
    interval: ConfigManager.shared.state.chordThrottleInterval
  )

  init() {
    super.init(state: .init(
      recordPermissionState: audioRecorderManager.getRecordPermissionState(),
      chord: nil,
      confidence: 0.0,
      selectedCodes: Chord.allCases
    ))
  }

  private func startRecording() {
    audioRecorderManager.start { [weak self] buffer, _ in
      guard let self = self else { return }

      // buffer 단위로 감지하고, 결과가 없으면 리턴
      if let (chord, confidence) = self.chordClassification.run(
        buffer: buffer,
        windowSize: self.audioRecorderManager.windowSize,
        activeChords: self.state.selectedCodes
      ) {
        guard let chord = chord else { return }
        if let throttled = self.throttleAggregator.add(value: chord, confidence: confidence) {
          // UI 업데이트
          self.emit(self.state.copy(
            chord: { throttled.value },
            confidence: throttled.confidence
          ))
        }
      }
    }
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
