//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation

final class AudioPlayerManager: BaseViewModel<AudioPlayerManagerState>, AVAudioPlayerDelegate {
  static let shared = AudioPlayerManager()
  private var audioPlayer: AVAudioPlayer?
  private var continuation: CheckedContinuation<Void, Never>?
  
  private init() {
    super.init(state: .init(isPlaying: false))
  }
  
  func start(audioFile: AudioFile) async {
    stop()
    await withTaskCancellationHandler {
      guard let url = audioFile.fileURL else {
        Logger.e("음원 파일을 찾을 수 없습니다: \(audioFile)")
        return
      }
      await withCheckedContinuation { continuation in
        self.continuation = continuation
        do {
          self.audioPlayer = try AVAudioPlayer(contentsOf: url)
          self.audioPlayer?.delegate = self
          self.audioPlayer?.prepareToPlay()
          self.audioPlayer?.play()
          self.emit(self.state.copy(isPlaying: true))
        } catch {
          Logger.e("AVAudioPlayer 생성 오류: \(error)")
          continuation.resume()
          self.continuation = nil
        }
      }
    } onCancel: {
      stop()
    }
  }
  
  func stop() {
    audioPlayer?.stop()
    emit(state.copy(isPlaying: false))
    continuation?.resume()
    continuation = nil
  }
  
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    continuation?.resume()
    continuation = nil
    emit(state.copy(isPlaying: false))
  }
}
