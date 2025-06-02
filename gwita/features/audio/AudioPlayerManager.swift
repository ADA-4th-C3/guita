//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation

final class AudioPlayerManager: NSObject, AVAudioPlayerDelegate {
  static let shared = AudioPlayerManager()
  private var audioPlayer: AVAudioPlayer?
  private var continuation: CheckedContinuation<Void, Never>?


  func start(named name: String, withExtension ext: String = "m4a") async {
    print("재생 시도: \(name).\(ext)")
    guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
        print("사운드 파일을 찾을 수 없습니다: \(name).\(ext)")
        return
    }
    stop()
    await withTaskCancellationHandler {
      await withCheckedContinuation { continuation in
        self.continuation = continuation
        do {
          self.audioPlayer = try AVAudioPlayer(contentsOf: url)
          self.audioPlayer?.delegate = self
          self.audioPlayer?.volume = 1.0
          self.audioPlayer?.prepareToPlay()
          self.audioPlayer?.play()
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
    continuation?.resume()
    continuation = nil
  }

  func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
    continuation?.resume()
    continuation = nil
  }
}
 
