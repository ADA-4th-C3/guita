//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation
import SwiftUI

final class CodeClassificationViewModel: BaseViewModel<CodeClassificationViewState> {
  let audioManager: AudioManager = .shared
  private let detector = CodeClassification() //기타코드 크로마 벡터 등등과 관련된 로직이 들어가있음
  
  /// UI에서 선택된 곡 이름
  @Published var selectedSong: String
  
  init() {
    // detector에 정의된 곡 목록의 첫 번째로 기본 설정
    let firstSong = detector.songCodeMap.keys.first ?? ""
    self.selectedSong = firstSong
    
    super.init(state: .init(
      recordPermissionState : audioManager.getRecordPermissionState(),
      code: "코드",
      confidence: 0.0,
      allMatches: []
    ))
  }
  
  private let bufferSize = 8192
  private func startRecording() {
    
    audioManager.start(bufferSize: bufferSize) { [weak self] buffer, _ in
      guard let self = self else { return }
      
      // buffer 단위로 감지하고, 결과가 없으면 리턴
      guard let rawResult = self.detector.detectCode(buffer: buffer) else {
        return
      }
      
      // 선택된 곡의 활성 코드만 필터링
      let active = self.detector.songCodeMap[self.selectedSong] ?? []
      let codeName = active.contains(rawResult.code) ? rawResult.code : ""
      let matches = rawResult.allMatches.filter { active.contains($0.code) }
      
      // UI 업데이트
      DispatchQueue.main.async {
        self.emit(self.state.copy(
          code: codeName,
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

