//
//  HapticManager.swift
//  mazeLearner
//
//  Created on 4/21/25.
//

import UIKit
import CoreHaptics

class HapticManager {
    static let shared = HapticManager()
    
    // 햅틱 엔진 (고급 햅틱용)
    private var engine: CHHapticEngine?
    
    private init() {
        setupHapticEngine()
    }
    
    func setHaptic(){
        playHeavyImpact()
    }
    
    // MARK: - 기본 햅틱 피드백
    
    /// 경미한 햅틱 피드백 (버튼 탭 등 가벼운 상호작용)
    func playLightImpact() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// 중간 강도의 햅틱 피드백 (강조가 필요한 상호작용)
    func playMediumImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// 강한 햅틱 피드백 (중요한 이벤트)
    func playHeavyImpact() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// 단단한 햅틱 피드백 (iOS 13 이상)
    @available(iOS 13.0, *)
    func playRigidImpact() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// 부드러운 햅틱 피드백 (iOS 13 이상)
    @available(iOS 13.0, *)
    func playSoftImpact() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// 성공 알림 햅틱 피드백
    func playSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
    
    /// 경고 알림 햅틱 피드백
    func playWarning() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.warning)
    }
    
    /// 오류 알림 햅틱 피드백
    func playError() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
    }
    
    /// 선택 변경 햅틱 피드백
    func playSelectionChanged() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    // MARK: - 고급 햅틱 패턴 (iOS 13 이상)
    
    private func setupHapticEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            
            // 앱이 백그라운드로 갈 때 엔진을 정지
            engine?.stoppedHandler = { reason in
                print("The haptic engine stopped: \(reason)")
            }
            
            // 앱이 포그라운드로 돌아올 때 엔진을 재시작
            engine?.resetHandler = { [weak self] in
                print("Haptic engine needs reset")
                do {
                    try self?.engine?.start()
                } catch {
                    print("Failed to restart the haptic engine: \(error)")
                }
            }
        } catch {
            print("Failed to create and start haptic engine: \(error)")
        }
    }
    
    /// 버튼 누르는 느낌의 햅틱 패턴 (iOS 13 이상)
    @available(iOS 13.0, *)
    func playButtonPressPattern() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else { return }
        
        // 타임라인에 따라 강도와 샤프니스를 정의
        let intensityParameter = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpnessParameter = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        
        // 햅틱 이벤트 생성
        let buttonPressEvent = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensityParameter, sharpnessParameter],
            relativeTime: 0
        )
        
        do {
            let pattern = try CHHapticPattern(events: [buttonPressEvent], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to play haptic pattern: \(error)")
        }
    }
    
    /// 이중 탭 느낌의 햅틱 패턴 (iOS 13 이상)
    @available(iOS 13.0, *)
    func playDoubleTapPattern() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else { return }
        
        // 첫 번째 탭
        let intensity1 = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8)
        let sharpness1 = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
        
        // 두 번째 탭
        let intensity2 = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8)
        let sharpness2 = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
        
        // 이벤트 생성
        let event1 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensity1, sharpness1],
            relativeTime: 0
        )
        
        let event2 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensity2, sharpness2],
            relativeTime: 0.2
        )
        
        do {
            let pattern = try CHHapticPattern(events: [event1, event2], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to play double tap pattern: \(error)")
        }
    }
    
    /// 심장 박동 같은 리듬감 있는 햅틱 패턴 (iOS 13 이상)
    @available(iOS 13.0, *)
    func playHeartbeatPattern() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else { return }
        
        var events = [CHHapticEvent]()
        
        // 첫 번째 박동 (강함)
        let strongIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let strongSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        
        // 두 번째 박동 (약함)
        let weakIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6)
        let weakSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
        
        // 여러 번의 심장 박동 생성
        for i in 0...3 {
            let relativeTime = TimeInterval(i) * 0.8
            
            // 강한 박동
            let strongBeat = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [strongIntensity, strongSharpness],
                relativeTime: relativeTime
            )
            
            // 약한 박동 (0.2초 지연)
            let weakBeat = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [weakIntensity, weakSharpness],
                relativeTime: relativeTime + 0.2
            )
            
            events.append(strongBeat)
            events.append(weakBeat)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to play heartbeat pattern: \(error)")
        }
    }
    
    /// 진동 느낌의 지속적인 햅틱 패턴 (iOS 13 이상)
    @available(iOS 13.0, *)
    func playVibrationPattern(duration: TimeInterval = 1.0) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else { return }
        
        // 지속적인 이벤트를 위한 파라미터
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
        
        // 지속적인 이벤트 생성
        let continuousEvent = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [intensity, sharpness],
            relativeTime: 0,
            duration: duration
        )
        
        do {
            let pattern = try CHHapticPattern(events: [continuousEvent], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to play vibration pattern: \(error)")
        }
    }
}
