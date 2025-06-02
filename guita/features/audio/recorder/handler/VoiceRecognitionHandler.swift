//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import AVFoundation
import Speech

/// 음성인식 처리를 담당하는 핸들러
final class VoiceRecognitionHandler {
    
    // MARK: - Properties
    private let voiceRecognitionManager = VoiceRecognitionManager.shared
    private let audioManager = AudioManager.shared
    private weak var delegate: VoiceRecognitionDelegate?
    
    private var currentRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var isSetup = false
    private var isManuallyPaused = false  // TTS 재생 중 일시중단 상태 추가
    
    /// 음성인식 활성화 상태를 외부에서 확인할 수 있는 속성
    var isRecognitionActive: Bool {
        return currentRecognitionRequest != nil && !isManuallyPaused
    }
    
    // MARK: - Initialization
    init(delegate: VoiceRecognitionDelegate) {
        self.delegate = delegate
        setupNotificationObserver()
    }
    
    // MARK: - Setup
    func setupVoiceRecognition() {
        guard !isSetup else { return }
        isSetup = true
        startVoiceRecognition()
    }
    
    /// 음성인식 재시작 알림 옵저버 설정
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleVoiceRecognitionRestart(_:)),
            name: NSNotification.Name("VoiceRecognitionRestarted"),
            object: nil
        )
    }
    
    /// 음성인식 재시작 알림 처리
    @objc private func handleVoiceRecognitionRestart(_ notification: Notification) {
        if let newRequest = notification.object as? SFSpeechAudioBufferRecognitionRequest {
            currentRecognitionRequest = newRequest
            Logger.d("VoiceRecognitionHandler: 새로운 인식 요청으로 업데이트")
        }
    }
    
    // MARK: - Control (수정된 부분)
    func startVoiceRecognition() {
        guard voiceRecognitionManager.isAvailable else {
            Logger.e("음성인식 사용 불가")
            return
        }
        
        // 수동 일시중단 해제
        isManuallyPaused = false
        
        // 이미 실행 중이면 중복 시작 방지
        if currentRecognitionRequest != nil {
            Logger.d("음성인식이 이미 실행 중 - 기존 세션 유지")
            delegate?.voiceRecognitionDidStart()
            return
        }
        
        Logger.d("음성인식 시작 시도")
        
        currentRecognitionRequest = voiceRecognitionManager.startRecognition { [weak self] text in
            guard let self = self, !self.isManuallyPaused else { return }
            Logger.d("음성인식 텍스트 수신: \(text)")
            self.handleRecognizedText(text)
        }
        
        guard currentRecognitionRequest != nil else {
            Logger.e("음성인식 요청 생성 실패")
            return
        }
        
        // 오디오 매니저 시작
        startAudioManagerIfNeeded()
        
        delegate?.voiceRecognitionDidStart()
        Logger.d("음성인식 시작됨")
    }
    
    func stopVoiceRecognition() {
        isManuallyPaused = true  // 수동 중지 플래그 설정
        
        voiceRecognitionManager.stopRecognition()
        currentRecognitionRequest = nil
        audioManager.stop()
        delegate?.voiceRecognitionDidStop()
        Logger.d("음성인식 중지됨 (수동)")
    }
    
    /// 오디오 매니저를 필요한 경우에만 시작
    private func startAudioManagerIfNeeded() {
        audioManager.start { [weak self] buffer, _ in
            guard let self = self, !self.isManuallyPaused else { return }
            self.delegate?.didReceiveAudioBuffer(buffer)
            self.currentRecognitionRequest?.append(buffer)
        }
    }
    
    /// 음성인식이 실행 중인지 확인하고 필요시 재시작
    func checkAndRestartIfNeeded() {
        if !isRecognitionActive && isSetup && !isManuallyPaused {
            Logger.d("음성인식이 중단된 상태 - 재시작 시도")
            startVoiceRecognition()
        }
    }
    
    /// 인식된 텍스트 처리
    private func handleRecognizedText(_ text: String) {
        guard !isManuallyPaused else { return }
        
        // 텍스트 길이 제한
        if text.count > 100 {
            Logger.d("텍스트 길이 초과 - 텍스트 무시: \(text.count)자")
            return
        }
        
        delegate?.didRecognizeText(text)
    }
    
    // MARK: - Cleanup
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

/// VoiceRecognitionHandler의 델리게이트 프로토콜
protocol VoiceRecognitionDelegate: AnyObject {
    func didRecognizeText(_ text: String)
    func didReceiveAudioBuffer(_ buffer: AVAudioPCMBuffer)
    func voiceRecognitionDidStart()
    func voiceRecognitionDidStop()
}
