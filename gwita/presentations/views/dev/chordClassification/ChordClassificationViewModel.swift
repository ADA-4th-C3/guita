//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation
import SwiftUI

final class ChordClassificationViewModel: BaseViewModel<ChordClassificationViewState> {
  private let audioRecorderManager: AudioRecorderManager = .shared
  private let chordClassification = ChordClassification() // 기타코드 크로마 벡터 등등과 관련된 로직이 들어가있음

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
      guard let chord = self.chordClassification.detectCode(
        buffer: buffer,
        windowSize: self.audioRecorderManager.windowSize,
        activeChords: self.state.selectedCodes
      ) else {
        return
      }

      // UI 업데이트
      DispatchQueue.main.async {
        self.emit(self.state.copy(
          chord: { chord }
        ))
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
