//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVKit
import CoreML
import Foundation
import SoundAnalysis
import Speech

final class VoiceControlViewModel: BaseViewModel<VoiceControlViewState> {
  var player: AVAudioPlayer?
  @Published var isPlaying = false
  @Published var totalTime: TimeInterval = 0.0
  @Published var currentTime: TimeInterval = 0.0
  @Published var isListening = false
  @Published var recognizedText = ""
  @Published var predictedLabel: String = ""
  @Published var confidence: Double = 0.0
  
  private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var recognitionTask: SFSpeechRecognitionTask?
  private let audioEngine = AVAudioEngine()
  
  // CoreML 관련 (나중에 사용)
  private let analysisQueue = DispatchQueue(label: "SoundAnalysisQueue")
  private var analyzer: SNAudioStreamAnalyzer?
  private var resultsObserver: SNResultsObserving?
  
  var timer: Timer?
  
  init() {
    super.init(state: VoiceControlViewState())
    guard let url = Bundle.main.url(forResource: "forStudyGuitar", withExtension: "mp3") else {
      Logger.e("Audio file not found")
      return
    }
    setupAudio(withURL: url)
    // setupSoundAnalyzer() // CoreML - 나중에 사용
    requestPermissions()
  }
  
  deinit {
    stopListening()
  }
  
  private func requestPermissions() {
    SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
      DispatchQueue.main.async {
        if authStatus == .authorized {
          AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
              if granted {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                  self?.startListening()
                }
              }
            }
          }
        }
      }
    }
  }
  
  func startListening() {
    guard !audioEngine.isRunning else { return }
    guard !isListening else { return }
    
    do {
      try startRecording()
      isListening = true
    } catch {
      Logger.e("Failed to start recording: \(error)")
      isListening = false
    }
  }
  
  func stopListening() {
    guard isListening else { return }
    
    DispatchQueue.main.async {
      self.isListening = false
      
      // 음성 인식 정리
      self.recognitionRequest?.endAudio()
      self.recognitionRequest = nil
      self.recognitionTask?.cancel()
      self.recognitionTask = nil
      
      // 오디오 엔진 정리
      if self.audioEngine.isRunning {
        self.audioEngine.stop()
        self.audioEngine.inputNode.removeTap(onBus: 0)
      }
    }
  }
  
  private func startRecording() throws {
    recognitionTask?.cancel()
    recognitionTask = nil
    
    let audioSession = AVAudioSession.sharedInstance()
    try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetooth])
    if audioSession.isInputGainSettable {
      try audioSession.setInputGain(1.0)
    }
    try audioSession.setActive(true)
    
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    
    let inputNode = audioEngine.inputNode
    guard let recognitionRequest = recognitionRequest else {
      throw NSError(domain: "SpeechRecognition", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to create recognition request"])
    }
    
    recognitionRequest.shouldReportPartialResults = true
    
    recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
      DispatchQueue.main.async {
        if let result = result {
          let recognizedText = result.bestTranscription.formattedString
          
          Logger.d("음성 인식 결과: '\(recognizedText)'")
          
          self?.recognizedText = recognizedText
          self?.processVoiceCommand(recognizedText)
        }
        
        if let error = error {
          Logger.e("음성 인식 에러: \(error)")
        }
        
        if error != nil || result?.isFinal == true {
          self?.restartListening()
        }
      }
    }
    
    let recordingFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 4096, format: recordingFormat) { [weak self] buffer, time in
      self?.recognitionRequest?.append(buffer)
      // self?.analyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime) // CoreML - 나중에 사용
    }
    
    audioEngine.prepare()
    try audioEngine.start()
  }
  
  private func processVoiceCommand(_ text: String) {
    let cleanText = text.lowercased()
    let words = cleanText.components(separatedBy: " ")
    
    Logger.d("전체 텍스트: '\(cleanText)'")
    
    // 메인 스레드에서 오디오 제어 실행
    DispatchQueue.main.async {
      if (words.contains("정지") || words.contains("멈춰라")) && self.isPlaying {
        Logger.d("정지 명령 감지")
        self.pause()
        self.resetSpeechRecognition()
        
      } else if (words.contains("재생") || words.contains("플레이")) && !self.isPlaying {
        Logger.d("재생 명령 감지")
        self.resetSpeechRecognition()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.play()
        }
      }
    }
  }
  
  private func resetSpeechRecognition() {
    Logger.d("음성 인식 버퍼 리셋")
    
    // 메인 스레드에서 실행
    DispatchQueue.main.async {
      self.recognitionRequest?.endAudio()
      self.recognitionTask?.cancel()
      
      self.recognizedText = ""
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        if self.isListening {
          self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
          
          guard let recognitionRequest = self.recognitionRequest else { return }
          recognitionRequest.shouldReportPartialResults = true
          
          self.recognitionTask = self.speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            DispatchQueue.main.async {
              if let result = result {
                let recognizedText = result.bestTranscription.formattedString
                Logger.d("새로운 음성 인식 결과: '\(recognizedText)'")
                self?.recognizedText = recognizedText
                self?.processVoiceCommand(recognizedText)
              }
              
              if error != nil || result?.isFinal == true {
                self?.restartListening()
              }
            }
          }
        }
      }
    }
  }
  
  func clearRecognizedText() {
    DispatchQueue.main.async {
      self.recognizedText = ""
    }
  }
  
  private func restartListening() {
    guard isListening else { return }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      if self.isListening {
        self.stopListening()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          self.startListening()
        }
      }
    }
  }
  
  private func setupAudio(withURL url: URL) {
    do {
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
      try audioSession.setActive(true)
      
      player = try AVAudioPlayer(contentsOf: url)
      player?.prepareToPlay()
      player?.volume = 1.0
      totalTime = player?.duration ?? 0.0
      
    } catch {
      Logger.e("Error loading audio: \(error)")
    }
  }
  
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
   */
  
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
  
  func play() {
    guard let player else { return }
    isPlaying = true
    player.play()
    startTimer()
  }
  
  func pause() {
    guard let player else { return }
    isPlaying = false
    player.pause()
    stopTimer()
  }
  
  private func startTimer() {
    stopTimer()
    timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
      self?.updateProgress()
    }
  }
  
  private func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
  
  private func updateProgress() {
    guard let player else { return }
    
    currentTime = player.currentTime
    
    if !player.isPlaying {
      pause()
      currentTime = 0
    }
  }
  
  override func dispose() {
    DispatchQueue.main.async {
      self.stopListening()
      self.stopTimer()
      
      // 오디오 플레이어 정리
      self.player?.stop()
      self.player = nil
    }
  }
}
