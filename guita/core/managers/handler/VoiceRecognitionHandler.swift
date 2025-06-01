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
    
    /// 음성인식 활성화 상태를 외부에서 확인할 수 있는 속성
    var isRecognitionActive: Bool {
        return currentRecognitionRequest != nil
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
    
    // MARK: - Control
    func startVoiceRecognition() {
        Logger.d("startVoiceRecognition 호출됨 - available: \(voiceRecognitionManager.isAvailable)")
        guard voiceRecognitionManager.isAvailable else {
            Logger.e("음성인식 사용 불가")
            return
        }
        
        // 이미 실행 중이면 중복 시작 방지
        if currentRecognitionRequest != nil {
            Logger.d("음성인식이 이미 실행 중 - 기존 세션 유지")
            return
        }
        
        currentRecognitionRequest = voiceRecognitionManager.startRecognition { [weak self] text in
            Logger.d("음성인식 텍스트 수신: \(text)")
            self?.handleRecognizedText(text)
        }
        
        guard currentRecognitionRequest != nil else {
            Logger.e("음성인식 요청 생성 실패")
            return
        }
        
        // 오디오 매니저 시작 (한 번만)
        startAudioManagerIfNeeded()
        
        delegate?.voiceRecognitionDidStart()
        Logger.d("음성인식 시작됨")
    }
    
    /// 오디오 매니저를 필요한 경우에만 시작
    private func startAudioManagerIfNeeded() {
        // 이미 실행 중인지 확인하는 플래그나 상태가 없으므로 항상 시작
        // AudioManager가 내부적으로 중복 시작을 방지해야 함
        audioManager.start { [weak self] buffer, _ in
            self?.delegate?.didReceiveAudioBuffer(buffer)
            self?.currentRecognitionRequest?.append(buffer)
        }
    }
    
    func stopVoiceRecognition() {
        voiceRecognitionManager.stopRecognition()
        currentRecognitionRequest = nil
        audioManager.stop()
        delegate?.voiceRecognitionDidStop()
        Logger.d("음성인식 중지됨")
    }
    
    /// 음성인식이 실행 중인지 확인하는 메서드
    func checkAndRestartIfNeeded() {
        if !isRecognitionActive && isSetup {
            Logger.d("음성인식이 중단된 상태 - 재시작 시도")
            startVoiceRecognition()
        }
    }
    
    /// 인식된 텍스트 처리
    private func handleRecognizedText(_ text: String) {
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
