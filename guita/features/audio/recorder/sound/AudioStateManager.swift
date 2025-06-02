//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import AVFoundation

/// 오디오 상태 관리를 담당하는 매니저
final class AudioStateManager {
  
  // MARK: - Properties
  private weak var delegate: AudioStateManagerDelegate?
  
  private(set) var audioState: AudioState = .idle
  private(set) var lastContentTTS: String?
  
  // MARK: - Initialization
  init(delegate: AudioStateManagerDelegate) {
    self.delegate = delegate
  }
  
  // MARK: - State Management
  func updateAudioState(_ newState: AudioState, lastTTS: String? = nil) {
    audioState = newState
    if let tts = lastTTS {
      lastContentTTS = tts
    }
    delegate?.audioStateDidChange(newState, lastTTS: lastContentTTS)
  }
  
  func getCurrentState() -> (AudioState, String?) {
    return (audioState, lastContentTTS)
  }
}

/// AudioStateManager의 델리게이트 프로토콜
protocol AudioStateManagerDelegate: AnyObject {
  func audioStateDidChange(_ state: AudioState, lastTTS: String?)
}
