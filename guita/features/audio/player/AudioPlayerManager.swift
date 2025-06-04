//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation

final class Debouncer {
  private let delay: TimeInterval
  private var workItem: DispatchWorkItem?

  init(delay: TimeInterval) {
    self.delay = delay
  }

  func call(_ action: @escaping () -> Void) {
    workItem?.cancel()
    workItem = DispatchWorkItem(block: action)
    if let workItem = workItem {
      DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
  }

  func cancel() {
    workItem?.cancel()
  }
}

final class AudioPlayerManager: BaseViewModel<AudioPlayerManagerState> {
  static let shared = AudioPlayerManager()
  private let engine = AVAudioEngine()
  private let playerNode = AVAudioPlayerNode()
  private let timePitch = AVAudioUnitTimePitch()
  private var audioFile: AVAudioFile?
  private var continuation: CheckedContinuation<Void, Never>?
  private var playbackTimer: Timer?
  private let seekDebouncer = Debouncer(delay: 0.3)

  // 속도 측정을 위한 상수
  private let minRate: Float = 0.5
  private let maxRate: Float = 1.25
  private let rateStep: Float = 0.25

  private init() {
    super.init(state: .init(
      playerState: .stopped,
      initTime: 0.0,
      currentTime: 0.0,
      totalDuration: 0.0
    ))
    engine.attach(playerNode)
    engine.attach(timePitch)
    engine.connect(playerNode, to: timePitch, format: nil)
    engine.connect(timePitch, to: engine.mainMixerNode, format: nil)
    try? engine.start()
  }

  private func startPlaybackTimer() {
    stopPlaybackTimer()
    DispatchQueue.main.async { [weak self] in
      self?.playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
        guard let self = self else { return }
        let currentTime = min(self.state.initTime + self.getPlayDuration(), self.state.totalDuration)
        if currentTime == self.state.totalDuration {
          self.stopPlaybackTimer()
          self.stop()
          self.emit(self.state.copy(currentTime: 0))
        } else {
          self.emit(self.state.copy(currentTime: currentTime))
        }
      }
    }
  }

  private func stopPlaybackTimer() {
    playbackTimer?.invalidate()
    playbackTimer = nil
  }

  func initialize(_ audioFile: AudioFile) {
    do {
      guard let url = audioFile.fileURL else {
        Logger.e("음원 파일을 찾을 수 없습니다: \(audioFile)")
        return
      }

      self.audioFile = try AVAudioFile(forReading: url)
      emit(state.copy(
        playerState: .stopped,
        initTime: 0,
        currentTime: 0,
        totalDuration: getDuration()
      ))
    } catch {
      Logger.e("AVAudioFile 생성 오류: \(error)")
    }
  }

  func start(audioFile: AudioFile) async {
    stop()

    await withTaskCancellationHandler {
      initialize(audioFile)
      await withCheckedContinuation { continuation in
        self.continuation = continuation
        if let file = self.audioFile {
          self.playerNode.scheduleFile(file, at: nil) {
            // 재생 완료 콜백
            self.continuation?.resume()
            self.continuation = nil
            self.emit(self.state.copy(playerState: .stopped))
          }
          self.playerNode.play()
          self.startPlaybackTimer()
          self.emit(self.state.copy(
            playerState: .playing
          ))
        }
      }
    } onCancel: {
      stop()
    }
  }

  func pause() {
    playerNode.pause()
    stopPlaybackTimer()
    emit(state.copy(playerState: .paused))
  }

  func resume() {
    startPlaybackTimer()
    playerNode.play()
    emit(state.copy(playerState: .playing))
  }

  func setCurrentTime(_ time: Double) {
    stopPlaybackTimer()
    emit(state.copy(playerState: .playing, currentTime: time))
    seekDebouncer.call { [weak self] in
      guard let self = self, let audioFile = self.audioFile else { return }
      let isPlaying = self.state.playerState.isPlaying
      if isPlaying {
        self.playerNode.stop()
      }
      self.playerNode.reset()
      let sampleRate = audioFile.processingFormat.sampleRate
      let frameCount = AVAudioFramePosition(time * sampleRate)
      let length = audioFile.length
      let startFrame = max(0, min(frameCount, length - 1))

      self.playerNode.scheduleSegment(audioFile, startingFrame: startFrame, frameCount: AVAudioFrameCount(length - startFrame), at: nil) {}
      if isPlaying {
        self.playerNode.play()
      }
      self.emit(self.state.copy(playerState: .playing, initTime: time))
      self.startPlaybackTimer()
    }
  }

  func stop() {
    playerNode.stop()
    stopPlaybackTimer()
    emit(state.copy(playerState: .stopped))
    continuation?.resume()
    continuation = nil
  }

  /// 현재 음원 타임라인의 위치가 아니라 지금까지 재생된 시간 반환
  func getPlayDuration() -> TimeInterval {
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
