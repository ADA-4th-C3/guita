//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation
import Speech

final class VoiceRecognitionManager {
  static let shared = VoiceRecognitionManager()
  
  private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var recognitionTask: SFSpeechRecognitionTask?
  
  private init() {}
  
  /// 음성 인식 권한 상태 확인
  func getSpeechPermissionState() -> PermissionState {
    switch SFSpeechRecognizer.authorizationStatus() {
    case .denied, .restricted: return .denied
    case .authorized: return .granted
    case .notDetermined: return .undetermined
    @unknown default: return .undetermined
    }
  }
  
  /// 음성 인식 권한 요청
  func requestSpeechPermission(completion: @escaping (Bool) -> Void) {
    SFSpeechRecognizer.requestAuthorization { status in
      DispatchQueue.main.async {
        completion(status == .authorized)
      }
    }
  }
  
  /// 음성 인식 사용 가능 여부
  var isAvailable: Bool {
    speechRecognizer?.isAvailable ?? false
  }
  
  /// 음성 인식 시작
  func startRecognition(resultHandler: @escaping (String) -> Void) -> SFSpeechAudioBufferRecognitionRequest? {
    stopRecognition()
    
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    recognitionRequest?.shouldReportPartialResults = true
    
    guard let recognitionRequest = recognitionRequest else { return nil }
    
    recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
      DispatchQueue.main.async {
        if let result = result {
          let text = result.bestTranscription.formattedString
          resultHandler(text)
        }
        
        if error != nil || result?.isFinal == true {
          self.stopRecognition()
        }
      }
    }
    
    return recognitionRequest
  }
  
  /// 음성 인식 중지
  func stopRecognition() {
    recognitionRequest?.endAudio()
    recognitionRequest = nil
    recognitionTask?.cancel()
    recognitionTask = nil
  }
}
