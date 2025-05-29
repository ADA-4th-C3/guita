//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.
import AVKit
import Foundation
import Speech

final class VoiceControlViewModel: BaseViewModel<VoiceControlViewState> {
  
  /// 마이크 입력 처리를 위한 공유 오디오 매니저 (PitchClassification과 동일한 인스턴스 사용)
  private let audioManager = AudioManager.shared
  
  /// MP3 파일 재생을 위한 플레이어
  private var player: AVAudioPlayer?
  /// 재생 시간 업데이트를 위한 타이머
  private var timer: Timer?
  
  /// 한국어 음성 인식기
  private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
  /// 실시간 음성 인식 요청 객체
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  /// 음성 인식 작업 관리 객체
  private var recognitionTask: SFSpeechRecognitionTask?
  
  init() {
    super.init(state: VoiceControlViewState())
    setupAudio()
    checkPermissions()
  }
  
  // MARK: - Audio Setup
  /// MP3 파일을 로드하고 플레이어 초기화
  private func setupAudio() {
    guard let url = Bundle.main.url(forResource: "forStudyGuitar", withExtension: "mp3") else {
      Logger.e("Audio file not found")
      return
    }
    
    do {
      player = try AVAudioPlayer(contentsOf: url)
      player?.prepareToPlay()
      emit(state.copy(totalTime: player?.duration ?? 0.0))
    } catch {
      Logger.e("Error loading audio: \(error)")
    }
  }
  
  // MARK: - Permission Management
  /// 현재 녹음 권한 상태를 확인하고 상태 업데이트
  private func checkPermissions() {
    let recordPermission = audioManager.getRecordPermissionState()
    emit(state.copy(recordPermissionState: recordPermission))
    
    if recordPermission == .granted {
      requestSpeechPermission()
    }
  }
  
  /// 사용자에게 녹음 권한 요청 (View에서 호출)
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
  
  /// 음성 인식 권한 요청 (내부적으로 호출)
  private func requestSpeechPermission() {
    SFSpeechRecognizer.requestAuthorization { [weak self] status in
      DispatchQueue.main.async {
        if status == .authorized {
          self?.startListening()
        }
      }
    }
  }
  
  // MARK: - Voice Recognition Control
  /// 음성 인식 시작 (마이크 켜기)
  func startListening() {
    guard !state.isListening, speechRecognizer?.isAvailable == true else {
      Logger.d("음성 인식 시작 실패 - isListening: \(state.isListening), available: \(speechRecognizer?.isAvailable ?? false)")
      return
    }
    
    Logger.d("음성 인식 시작")
    setupRecognition()
    startAudioRecording()
    emit(state.copy(isListening: true))
  }
  
  /// 음성 인식 중지 (마이크 끄기)
  func stopListening() {
    guard state.isListening else {
      Logger.d("이미 음성 인식이 중단된 상태")
      return
    }
    
    Logger.d("음성 인식 중단")
    cleanupRecognition()
    audioManager.stop()
    emit(state.copy(isListening: false))
  }
  
  /// 음성 인식 설정 및 콜백 등록
  private func setupRecognition() {
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    recognitionRequest?.shouldReportPartialResults = true
    
    guard let recognitionRequest = recognitionRequest else { return }
    
    recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
      DispatchQueue.main.async {
        guard let self = self else { return }
        
        if let result = result {
          let text = result.bestTranscription.formattedString
          self.emit(self.state.copy(recognizedText: text))
          self.processVoiceCommand(text)
        }
      }
    }
  }
  
  /// AudioManager를 통해 마이크 입력 시작 및 음성 인식 버퍼에 연결
  private func startAudioRecording() {
    audioManager.start(bufferSize: 4096) { [weak self] buffer, _ in
      self?.recognitionRequest?.append(buffer)
    }
  }
  
  // MARK: - Voice Command Processing
  /// 인식된 음성 텍스트를 분석하여 재생/정지 명령 처리
  private func processVoiceCommand(_ text: String) {
    let words = text.lowercased().components(separatedBy: " ")
    Logger.d("음성 인식: '\(text)'")
    
    guard let command = words.compactMap({ VoiceCommand.commandMap[$0] }).first else {
      Logger.d("인식된 명령어 없음")
      return
    }
    
    executeCommand(command)
  }
  private func executeCommand(_ command: VoiceCommand) {
    temporarilyStopListening()
    
    switch command {
    case .play: if !state.isPlaying { delayedPlay() }
    case .pause: if state.isPlaying { pause() }
    case .next: nextTrack()
    case .previous: previousTrack()
    case .replay: replay()
    case .volumeUp: volumeUp()
    case .volumeDown: volumeDown()
    case .seekForward: seekForward()
    case .seekBackward: seekBackward()
    }
  }
  
  private func delayedPlay() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.play()
    }
  }
  
  private func temporarilyStopListening() {
    Logger.d("음성 인식 일시 중단 시작")
    
    // 현재 음성 인식 중단
    cleanupRecognition()
    audioManager.stop()
    
    // 텍스트 초기화
    emit(state.copy(recognizedText: ""))
    Logger.d("인식 텍스트 초기화 완료")
    
    // 1초 후 음성 인식 재시작 (버퍼 완전 초기화)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      Logger.d("음성 인식 재시작 시도 - 현재 listening 상태: \(self.state.isListening)")
      if self.state.isListening {
        self.setupRecognition()
        self.startAudioRecording()
        Logger.d("음성 인식 재시작 완료")
      }
    }
  }
  
  /// 음성 인식 객체들 정리 및 메모리 해제
  private func cleanupRecognition() {
    recognitionRequest?.endAudio()
    recognitionRequest = nil
    recognitionTask?.cancel()
    recognitionTask = nil
  }
  
  /// 인식된 텍스트 초기화 (휴지통 버튼)
  func clearRecognizedText() {
    emit(state.copy(recognizedText: ""))
  }
  
  // MARK: - Audio Player Controls
  /// MP3 파일 재생 시작
  func play() {
    player?.play()
    emit(state.copy(isPlaying: true))
    startTimer()
  }
  
  /// MP3 파일 재생 일시정지
  func pause() {
    player?.pause()
    emit(state.copy(isPlaying: false))
    stopTimer()
  }
  
  /// 특정 시간으로 재생 위치 이동 (슬라이더 조작 시)
  func seek(to time: TimeInterval) {
    player?.currentTime = time
    emit(state.copy(currentTime: time))
  }
  
  /// 재생 시간 업데이트용 타이머 시작
  private func startTimer() {
    stopTimer()
    timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
      self?.updateProgress()
    }
  }
  
  /// 타이머 정지 및 메모리 해제
  private func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
  
  /// 현재 재생 시간을 상태에 반영 (0.1초마다 호출)
  private func updateProgress() {
    guard let player = player else { return }
    
    let currentTime = player.currentTime
    emit(state.copy(currentTime: currentTime))
    
    // 재생이 끝나면 상태 초기화
    if !player.isPlaying && state.isPlaying {
      emit(state.copy(isPlaying: false, currentTime: 0))
      stopTimer()
    }
  }
  // MARK: - Extended Controls
  private func nextTrack() { seek(to: 0); if !state.isPlaying { play() }}
  private func previousTrack() { seek(to: 0); if !state.isPlaying { play() }}
  private func replay() { seek(to: 0); play() }
  private func volumeUp() { player?.volume = min((player?.volume ?? 0) + 0.1, 1.0) }
  private func volumeDown() { player?.volume = max((player?.volume ?? 0) - 0.1, 0.0) }
  private func seekForward() { guard let player = player else { return }; seek(to: min(player.currentTime + 10, player.duration)) }
  private func seekBackward() { guard let player = player else { return }; seek(to: max(player.currentTime - 10, 0)) }
  
  
  // MARK: - Utility Functions
  /// 설정 앱으로 이동 (권한 거부 시 사용)
  func openSettings() {
    if let url = URL(string: UIApplication.openSettingsURLString) {
      UIApplication.shared.open(url)
    }
  }
  
  /// 뷰가 사라질 때 리소스 정리
  override func dispose() {
    stopListening()
    stopTimer()
    player?.stop()
    player = nil
  }
}




// MARK: - CoreML 설정

// CoreML 관련 (나중에 사용)
//private let analysisQueue = DispatchQueue(label: "SoundAnalysisQueue")
//private var analyzer: SNAudioStreamAnalyzer?
//private var resultsObserver: SNResultsObserving?


// CoreML 설정 (나중에 사용)
/*
 private func setupSoundAnalyzer() {
 let inputFormat = audioEngine.inputNode.outputFormat(forBus: 0)
 analyzer = SNAudioStreamAnalyzer(format: inputFormat)
 resultsObserver = SoundResultObserver(viewModel: self)
 
 guard let model = try? SoundClassify(configuration: MLModelConfiguration()).model,
 let request = try? SNClassifySoundRequest(mlModel: model)
 else {
 Logger.e("CoreML 모델 로딩 실패")
 return
 }
 
 try? analyzer?.add(request, withObserver: resultsObserver!)
 }
 
 func updatePrediction(_ label: String, confidence: Double) {
 DispatchQueue.main.async {
 self.predictedLabel = label
 self.confidence = confidence
 if confidence > 0.5 {
 switch label {
 case "정지":
 if self.isPlaying {
 self.pause()
 }
 case "재생":
 if !self.isPlaying {
 self.play()
 }
 default:
 break
 }
 }
 }
 }
 */
