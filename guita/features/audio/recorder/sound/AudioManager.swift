//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation

final class AudioRecorderManager: BaseViewModel<AudioRecorderManagerState> {
  static let shared = AudioRecorderManager()
  private var audioEngine = AVAudioEngine()
  private var inputNode: AVAudioInputNode?
  private var inputFormat: AVAudioFormat?
  let sampleRate: Double = 48000
  let windowSize: Int = 8192

  private init() {
    super.init(state: AudioRecorderManagerState(
      permission: .undetermined,
      isRecording: false
    ))

    emit(state.copy(
      permission: getRecordPermissionState()
    ))
  }

  /// 마이크 접근 권한 상태 확인
  func getRecordPermissionState() -> PermissionResult {
    return switch AVAudioApplication.shared.recordPermission {
    case .denied: .denied
    case .granted: .granted
    case .undetermined: .undetermined
    @unknown default: .undetermined
    }
  }

  /// 마이크 접근 권한 요청
  func requestRecordPermission(completion: @escaping (_ isGranted: Bool) -> Void) {
    AVAudioApplication.requestRecordPermission { isGranted in
      completion(isGranted)
      self.emit(self.state.copy(permission: isGranted ? .granted : .denied))
    }
  }

  func start(handler: @escaping AVAudioNodeTapBlock) {
    if state.isRecording { return }

    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .mixWithOthers, .duckOthers])
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
<<<<<<<< HEAD:guita/features/audio/recorder/sound/AudioManager.swift
}
========
    emit(state.copy(isRecording: true))
  }
>>>>>>>> 8690b84b1301a3c2d88814b9f221dd051c749701:guita/features/audio/recorder/AudioRecorderManager.swift

  func stop() {
    inputNode?.removeTap(onBus: 0)
    audioEngine.stop()
    emit(state.copy(isRecording: false))
  }
}
