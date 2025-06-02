//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.
import Foundation
import Speech
import UIKit


<<<<<<< HEAD:guita/presentations/views/dev/voiceControl/VoiceControlViewModel.swift
final class VoiceControlViewModel: BaseViewModel<VoiceControlViewState> {
  
  private let audioManager = AudioManager.shared
  private let voiceRecognitionManager = VoiceRecognitionManager.shared
  private let audioPlayer = AudioPlayer()
  private let voiceRecognition = VoiceRecognition()
  private var currentRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  
=======
final class LessonViewModel: BaseViewModel<LessonViewState> {
>>>>>>> 8690b84b1301a3c2d88814b9f221dd051c749701:guita/presentations/views/lesson/LessonViewModel.swift
  init() {
    super.init(state: VoiceControlViewState(
      recordPermissionState: .undetermined,
      isListening: false,
      recognizedText: "",
      isPlaying: false,
      currentTime: 0.0,
      totalTime: 0.0,
      volume: 1.0
    ))
    setupFeatures()
    checkPermissions()
  }
  
  private func setupFeatures() {
    // AudioPlayer 설정
    if audioPlayer.setupAudio(fileName: "forStudyGuitar", fileExtension: "mp3") {
      emit(state.copy(totalTime: audioPlayer.totalTime))
    }
    
    audioPlayer.setProgressHandler { [weak self] currentTime in
      guard let self = self else { return }
      self.emit(self.state.copy(currentTime: currentTime))
    }
    
    audioPlayer.setStateChangeHandler { [weak self] isPlaying in
      guard let self = self else { return }
      self.emit(self.state.copy(isPlaying: isPlaying))
    }
    
    // VoiceRecognition 설정
    voiceRecognition.setTextRecognitionHandler { [weak self] text in
      guard let self = self else { return }
      self.emit(self.state.copy(recognizedText: text))
    }
    
    voiceRecognition.setCommandHandler { [weak self] command in
      guard let self = self else { return }
      self.executeCommand(command)
    }
  }
  
  // MARK: - Permission Management
  private func checkPermissions() {
    let recordPermission = audioManager.getRecordPermissionState()
    emit(state.copy(recordPermissionState: recordPermission))
    
    if recordPermission == .granted {
      requestSpeechPermission()
    }
  }
  
  func requestRecordPermission() {
    audioManager.requestRecordPermission { [weak self] granted in
      guard let self = self else { return }
      let newState = granted ? PermissionState.granted : PermissionState.denied
      self.emit(self.state.copy(recordPermissionState: newState))
      if granted {
        self.requestSpeechPermission()
      }
    }
  }
  
  private func requestSpeechPermission() {
    voiceRecognitionManager.requestSpeechPermission { [weak self] authorized in
      if authorized {
        self?.startListening()
      }
    }
  }
  
  // MARK: - Voice Recognition Control
  func startListening() {
    guard !state.isListening, voiceRecognitionManager.isAvailable else {
      Logger.d("음성 인식 시작 실패 - isListening: \(state.isListening), available: \(voiceRecognitionManager.isAvailable)")
      return
    }
    
    Logger.d("음성 인식 시작")
    
    currentRecognitionRequest = voiceRecognitionManager.startRecognition { [weak self] text in
      guard let self = self else { return }
      self.voiceRecognition.processRecognizedText(text)
    }
    
    guard currentRecognitionRequest != nil else { return }
    
    audioManager.start { [weak self] buffer, _ in
      self?.currentRecognitionRequest?.append(buffer)
    }
    
    emit(state.copy(isListening: true))
  }
  
  func stopListening() {
    guard state.isListening else {
      Logger.d("이미 음성 인식이 중단된 상태")
      return
    }
    
    Logger.d("음성 인식 중단")
    voiceRecognitionManager.stopRecognition()
    currentRecognitionRequest = nil
    audioManager.stop()
    emit(state.copy(isListening: false))
  }
  
  func clearRecognizedText() {
    emit(state.copy(recognizedText: ""))
  }
  
  // MARK: - Voice Command Processing
  private func executeCommand(_ command: VoiceCommand) {
    temporarilyStopAndRestart()
    
    switch command {
    case .play: if !audioPlayer.isPlaying { delayedPlay() }
    case .pause: if audioPlayer.isPlaying { pause() }
    case .next: audioPlayer.nextTrack()
    case .previous: audioPlayer.previousTrack()
    case .replay: audioPlayer.replay()
    case .volumeUp: audioPlayer.volumeUp()
    case .volumeDown: audioPlayer.volumeDown()
    case .seekForward: audioPlayer.seekForward()
    case .seekBackward: audioPlayer.seekBackward()
    case .speedUp: handleSpeedIncrease()  // 새로 추가
    case .speedDown: handleSpeedDecrease()  // 새로 추가
    }
  }
  
  /// TTS 속도 증가 처리
  private func handleSpeedIncrease() {
      let tts = TextToSpeech.shared
      tts.increaseTTSSpeed()
  }

  /// TTS 속도 감소 처리
  private func handleSpeedDecrease() {
      let tts = TextToSpeech.shared
      tts.decreaseTTSSpeed()
  }
  
  private func temporarilyStopAndRestart() {
    Logger.d("음성 인식 일시 중단 시작")
    
    voiceRecognitionManager.stopRecognition()
    currentRecognitionRequest = nil
    audioManager.stop()
    
    emit(state.copy(recognizedText: ""))
    Logger.d("인식 텍스트 초기화 완료")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      Logger.d("음성 인식 재시작 시도 - 현재 listening 상태: \(self.state.isListening)")
      if self.state.isListening {
        self.currentRecognitionRequest = self.voiceRecognitionManager.startRecognition { [weak self] text in
          guard let self = self else { return }
          self.voiceRecognition.processRecognizedText(text)
        }
        
        if self.currentRecognitionRequest != nil {
          
          self.audioManager.start { [weak self] buffer, _ in
            self?.currentRecognitionRequest?.append(buffer)
          }
        }
        Logger.d("음성 인식 재시작 완료")
      }
    }
  }
  
  private func delayedPlay() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.audioPlayer.play()
    }
  }
  
  // MARK: - Audio Player Controls
  func play() {
    audioPlayer.play()
  }
  
  func pause() {
    audioPlayer.pause()
  }
  
  func seek(to time: TimeInterval) {
    audioPlayer.seek(to: time)
  }
  
  func openSettings() {
    if let url = URL(string: UIApplication.openSettingsURLString) {
      UIApplication.shared.open(url)
    }
  }
  
  override func dispose() {
    stopListening()
    audioPlayer.dispose()
  }
}
