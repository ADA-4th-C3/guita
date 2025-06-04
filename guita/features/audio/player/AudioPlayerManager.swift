//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation

final class AudioPlayerManager: BaseViewModel<AudioPlayerManagerState>, AVAudioPlayerDelegate {
  static let shared = AudioPlayerManager()
  private let engine = AVAudioEngine()
  private let playerNode = AVAudioPlayerNode()
  private let timePitch = AVAudioUnitTimePitch()
  private var audioFile: AVAudioFile?
  private var continuation: CheckedContinuation<Void, Never>?

  // 속도 측정을 위한 상수
  private let minRate: Float = 0.5
  private let maxRate: Float = 2.0
  private let rateStep: Float = 0.25

  private init() {
    super.init(state: .init(
      isPlaying: false,
      currentTime: 0.0,
      totalDuration: 0.0
    ))
    engine.attach(playerNode)
    engine.attach(timePitch)
    engine.connect(playerNode, to: timePitch, format: nil)
    engine.connect(timePitch, to: engine.mainMixerNode, format: nil)
    try? engine.start()
  }

  func start(audioFile: AudioFile) async {
    stop()
    guard let url = audioFile.fileURL else {
      Logger.e("음원 파일을 찾을 수 없습니다: \(audioFile)")
      return
    }

    do {
      self.audioFile = try AVAudioFile(forReading: url)
      if let file = self.audioFile {
        await playerNode.scheduleFile(file, at: nil)
        playerNode.play()
        emit(state.copy(isPlaying: true))
      }
    } catch {
      Logger.e("AVAudioFile 생성 오류: \(error)")
    }
  }

  func pause() {
    playerNode.pause()
    emit(state.copy(isPlaying: false))
  }

  func stop() {
    playerNode.stop()
    emit(state.copy(isPlaying: false))
    continuation?.resume()
    continuation = nil
  }

  func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
    continuation?.resume()
    continuation = nil
    emit(state.copy(isPlaying: false))
  }

  /// 현재 재생 시간 반환
  func getCurrentTime() -> TimeInterval {
    return playerNode.lastRenderTime.flatMap { playerNode.playerTime(forNodeTime: $0)?.sampleTime }.map {
      Double($0) / (audioFile?.processingFormat.sampleRate ?? 1.0)
    } ?? 0
  }

  /// 총 길이 반환
  func getDuration() -> TimeInterval {
    guard let file = audioFile else { return 0 }
    return Double(file.length) / file.processingFormat.sampleRate
  }

  /// 재생 속도 설정 (0.5 ~ 2.0)
  func setPlaybackRate(_ rate: Float) {
    timePitch.rate = rate
  }

  /// 현재 재생 속도 반환
  func getCurrentRate() -> Float {
    return timePitch.rate
  }

  /// 재생 속도 증가
  func increasePlaybackRate() {
    let newRate = min(timePitch.rate + rateStep, maxRate)
    setPlaybackRate(newRate)
  }

  /// 재생 속도 감소
  func decreasePlaybackRate() {
    let newRate = max(timePitch.rate - rateStep, minRate)
    setPlaybackRate(newRate)
  }

  /// 현재 속도가 최대/최소인지 확인
  func isAtMaxRate() -> Bool {
    return timePitch.rate >= maxRate
  }

  func isAtMinRate() -> Bool {
    return timePitch.rate <= minRate
  }
}
