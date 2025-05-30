//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation
import SwiftUI

final class ChordClassificationViewModel: BaseViewModel<ChordClassificationViewState> {
  private let audioManager: AudioManager = .shared
  private let chordClassification = ChordClassification() // 기타코드 크로마 벡터 등등과 관련된 로직이 들어가있음

  init() {
    super.init(state: .init(
      recordPermissionState: audioManager.getRecordPermissionState(),
      chord: nil,
      confidence: 0.0,
      selectedCodes: Chord.allCases,
      allMatches: []
    ))
  }

  private func startRecording() {
    audioManager.start { [weak self] buffer, _ in
      guard let self = self else { return }

      // buffer 단위로 감지하고, 결과가 없으면 리턴
      guard let rawResult = self.chordClassification.detectCode(buffer: buffer, windowSize: self.audioManager.windowSize) else {
        return
      }

      // 선택된 곡의 활성 코드만 필터링
      let active = self.state.selectedCodes
      if !active.contains(rawResult.chord) { return }
      let chord = rawResult.chord
      let matches = rawResult.allMatches.filter { active.contains($0.chord) }

      // UI 업데이트
      DispatchQueue.main.async {
        self.emit(self.state.copy(
          chord: { chord },
          allMatches: matches
        ))
      }
    }
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
