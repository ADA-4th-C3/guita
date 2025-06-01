//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation

final class AudioManager {
  static let shared = AudioManager()
  private var audioEngine = AVAudioEngine()
  private var inputNode: AVAudioInputNode?
  var inputFormat: AVAudioFormat?
  let sampleRate: Double = 48000
  let windowSize: Int = 8192

  private init() {}

  /// 마이크 접근 권한 상태 확인
  func getRecordPermissionState() -> PermissionState {
    return switch AVAudioApplication.shared.recordPermission {
    case .denied: .denied
    case .granted: .granted
    case .undetermined: .undetermined
    @unknown default: .undetermined
    }
  }

  /// 마이크 접근 권한 요청
  func requestRecordPermission(completion: @escaping (_ isGranted: Bool) -> Void) {
    AVAudioApplication.requestRecordPermission(completionHandler: completion)
  }

  func start(handler: @escaping AVAudioNodeTapBlock) {
    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .mixWithOthers])
//      try session.setCategory(.record, mode: .default, options: [])
//      try session.setPreferredSampleRate(sampleRate)
      try session.setPreferredSampleRate(0.005)
      try session.setActive(true)
    } catch {
      Logger.e("AVAudioSession 설정 중 오류 발생: \(error)")
    }

    inputNode = audioEngine.inputNode
    inputFormat = inputNode!.outputFormat(forBus: 0)
    inputNode?.installTap(onBus: 0, bufferSize: AVAudioFrameCount(windowSize), format: inputFormat, block: handler)
    try? audioEngine.start()
}

  func stop() {
    inputNode?.removeTap(onBus: 0)
    audioEngine.stop()
  }
}
