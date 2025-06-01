//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation
import Speech

final class VoiceRecognitionManager {
  static let shared = VoiceRecognitionManager()
  
  private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var recognitionTask: SFSpeechRecognitionTask?
  private var resultHandler: ((String) -> Void)?
  private var isRecognitionActive = false
  
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
  
  /// 음성 인식 시작 - 지속적 인식을 위한 수정된 버전
  func startRecognition(resultHandler: @escaping (String) -> Void) -> SFSpeechAudioBufferRecognitionRequest? {
    // 기존 인식 완전히 정리
    stopRecognition()
    
    guard speechRecognizer?.isAvailable == true else {
      Logger.e("음성인식기 사용 불가")
      return nil
    }
    
    // 핸들러 저장
    self.resultHandler = resultHandler
    self.isRecognitionActive = true
    
    // 새로운 인식 세션 시작
    return startNewRecognitionSession()
  }
  
  /// 새로운 인식 세션을 시작하는 내부 메서드
  private func startNewRecognitionSession() -> SFSpeechAudioBufferRecognitionRequest? {
    guard isRecognitionActive, let resultHandler = self.resultHandler else { return nil }
    
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    recognitionRequest?.shouldReportPartialResults = true
    
    guard let recognitionRequest = recognitionRequest else { return nil }
    
    recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
      DispatchQueue.main.async {
        guard let self = self, self.isRecognitionActive else { return }
        
        if let error = error {
          let nsError = error as NSError
          
          // "No speech detected" 오류는 무시하고 계속 진행
          if nsError.domain == "kAFAssistantErrorDomain" && nsError.code == 1110 {
            Logger.d("음성인식: 음성 미감지 (정상) - 계속 대기")
            return
          }
          
          // 인식 세션이 종료된 경우 자동 재시작
          if nsError.code == 201 || nsError.code == 216 {
            Logger.d("음성인식 세션 종료 - 자동 재시작")
            self.restartRecognitionSession()
            return
          }
          
          Logger.e("음성인식 오류: \(error)")
          return
        }
        
        if let result = result {
          let text = result.bestTranscription.formattedString
          resultHandler(text)
          
          // final 결과가 나오면 새로운 세션 시작 (지속적 인식을 위해)
          if result.isFinal {
            Logger.d("음성인식 final 결과 수신 - 새로운 세션 시작")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              self.restartRecognitionSession()
            }
          }
        }
      }
    }
    
    Logger.d("새로운 음성인식 세션 시작")
    return recognitionRequest
  }
  
  /// 인식 세션을 재시작하는 메서드
  private func restartRecognitionSession() {
    guard isRecognitionActive else { return }
    
    // 기존 태스크 정리
    recognitionTask?.finish()
    recognitionTask = nil
    recognitionRequest?.endAudio()
    recognitionRequest = nil
    
    // 짧은 딜레이 후 새 세션 시작
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      guard self.isRecognitionActive else { return }
      
      if let newRequest = self.startNewRecognitionSession() {
        // 새로운 요청이 생성되면 VoiceRecognitionHandler에 알림
        NotificationCenter.default.post(
          name: NSNotification.Name("VoiceRecognitionRestarted"),
          object: newRequest
        )
      }
    }
  }
  
  /// 음성 인식 중지 - 안전한 정리
  func stopRecognition() {
    isRecognitionActive = false
    resultHandler = nil
    
    recognitionTask?.finish()
    recognitionTask = nil
    
    recognitionRequest?.endAudio()
    recognitionRequest = nil
    
    Logger.d("음성인식 완전히 정리 완료")
  }
}
