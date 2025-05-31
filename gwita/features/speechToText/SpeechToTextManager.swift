//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation
import Speech

final class SpeechToTextManager: BaseViewModel<SpeechToTextState> {
  static let shared = SpeechToTextManager()
  private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var recognitionTask: SFSpeechRecognitionTask?
  private let audioEngine = AVAudioEngine()

  private init() {
    super.init(state: SpeechToTextState(
      permission: .undetermined,
      isRecognizing: false
    ))

    emit(state.copy(
      permission: getSpeechPermissionState()
    ))
  }

  /// 음성 인식 권한 상태 확인
  func getSpeechPermissionState() -> PermissionResult {
    return switch SFSpeechRecognizer.authorizationStatus() {
    case .authorized: .granted
    case .denied: .denied
    case .notDetermined: .undetermined
    case .restricted: .denied
    @unknown default: .undetermined
    }
  }

  /// 음성 인식 권한 요청
  func requestSpeechPermission(completion: @escaping (Bool) -> Void) {
    SFSpeechRecognizer.requestAuthorization { status in
      let isGranted = status == .authorized
      completion(isGranted)
      self.emit(self.state.copy(permission: isGranted ? .granted : .denied))
    }
  }

  /// 글자 수가 [resetCount]를 넘으면 재시작
  func start(_ resetCount: Int = 500, handler: @escaping (String) -> Void) {
    if state.isRecognizing { return }

    let node = audioEngine.inputNode
    let recordingFormat = node.outputFormat(forBus: 0)
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    guard let recognitionRequest = recognitionRequest else { return }

    recognitionRequest.shouldReportPartialResults = true

    recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
      if let result = result {
        let transcription = result.bestTranscription.formattedString
        handler(transcription)
        if transcription.count > resetCount {
          self.stop()
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.start(handler: handler)
          }
        }
      }
      if error != nil || (result?.isFinal ?? false) {
        self.stop()
      }
    }

    node.installTap(onBus: 0, bufferSize: 8192, format: recordingFormat) { buffer, _ in
      recognitionRequest.append(buffer)
    }

    audioEngine.prepare()
    try? audioEngine.start()
    emit(state.copy(isRecognizing: true))
    Logger.d("🔈 SpeechToText Start")
  }

  func stop() {
    audioEngine.inputNode.removeTap(onBus: 0)
    audioEngine.stop()
    recognitionRequest?.endAudio()
    recognitionTask?.cancel()
    recognitionRequest = nil
    recognitionTask = nil

    emit(state.copy(isRecognizing: false))
    Logger.d("🔇 SpeechToText Stop")
  }
}
