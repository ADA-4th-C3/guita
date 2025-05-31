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
    // 기존 인식 완전히 정리
    stopRecognition()
    
    // 즉시 새로운 요청 생성 (지연 제거)
    guard speechRecognizer?.isAvailable == true else {
      Logger.e("음성인식기 사용 불가")
      return nil
    }
    
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    recognitionRequest?.shouldReportPartialResults = true
    
    guard let recognitionRequest = recognitionRequest else { return nil }
    
    recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
      DispatchQueue.main.async {
        if let error = error {
          Logger.e("음성인식 오류: \(error)")
          // 오류 발생시 재시작 시도 제거
          return
        }
        
        if let result = result {
          let text = result.bestTranscription.formattedString
          resultHandler(text)
        }
        
        if result?.isFinal == true {
          // final 결과에서는 중지하지 않고 계속 유지
          Logger.d("음성인식 final 결과 수신")
        }
      }
    }
    
    return recognitionRequest
  }
  
  /// 음성 인식 중지 - 안전한 정리
  func stopRecognition() {
    recognitionTask?.finish() // cancel 대신 finish 사용
    recognitionTask = nil
    
    recognitionRequest?.endAudio()
    recognitionRequest = nil
    
    Logger.d("음성인식 안전하게 정리 완료")
  }
}
