//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation
import AVFoundation

/// 오디오 기반 학습 화면들의 공통 기능을 제공하는 Base ViewModel (리팩토링됨)
class BaseAudioLearningViewModel<State>: BaseViewModel<State> {
  
  
  // MARK: - Handlers
  internal var audioStateManager: AudioStateManager!
  internal var voiceRecognitionHandler: VoiceRecognitionHandler!
  internal var ttsHandler: TTSHandler!
  internal var chordRecognitionHandler: ChordRecognitionHandler!
  internal var pitchRecognitionHandler: PitchRecognitionHandler!
  internal var soundEffectHandler: SoundEffectHandler!
  
  // MARK: - State
  internal var currentStepIndex = 0
  internal var isVoiceRecognitionSetup = false
  internal var recognitionMode: RecognitionMode = .chord
  
  
  // MARK: - Initialization
  override init(state: State) {
    super.init(state: state)
    setupHandlers()
  }
  
  private func setupHandlers() {
    audioStateManager = AudioStateManager(delegate: self)
    voiceRecognitionHandler = VoiceRecognitionHandler(delegate: self)
    ttsHandler = TTSHandler(delegate: self)
    chordRecognitionHandler = ChordRecognitionHandler(delegate: self)
    pitchRecognitionHandler = PitchRecognitionHandler(delegate: self)
    soundEffectHandler = SoundEffectHandler(delegate: self)
  }
  
  // MARK: - 서브클래스에서 구현해야 할 추상 메서드들
  func onNextCommand() {
    fatalError("Subclass must implement onNextCommand")
  }
  
  func onPreviousCommand() {
    fatalError("Subclass must implement onPreviousCommand")
  }
  
  func getCurrentLearningSteps() -> [LearningStep] {
    fatalError("Subclass must implement getCurrentLearningSteps")
  }
  
  func updateStateWithAudio(_ audioState: AudioState, lastTTS: String?) {
    fatalError("Subclass must implement updateStateWithAudio")
  }
  
  func updateRecognizedChord(_ chord: String) {
    Logger.d("인식된 코드 업데이트: \(chord)")
  }
  
  func updateRecognizedPitch(_ note: String, frequency: Double) {  // 새로 추가
    Logger.d("인식된 음정 업데이트: \(note) (\(frequency)Hz)")
  }
  
  func updateRecognizedVoiceText(_ text: String) {  // 새로 추가
    Logger.d("인식된 음성 텍스트 업데이트: \(text)")
  }
  
  // MARK: - Note Control
  func setRecognitionMode(_ mode: RecognitionMode) {
    recognitionMode = mode
    Logger.d("인식 모드 변경: \(mode)")
  }
  
  func setTargetNote(_ note: Note) {
    pitchRecognitionHandler.setTargetNote(note)
  }
  
  func clearTargetNote() {
    pitchRecognitionHandler.clearTargetNote()
  }
  
  func updateRecognizedNote(_ note: String, frequency: Double) {  // 수정됨
    Logger.d("인식된 노트 업데이트: \(note) (\(frequency)Hz)")
  }
  
  // MARK: - VoiceRecogition
  func setupVoiceRecognition() {
    guard !isVoiceRecognitionSetup else { return }
    isVoiceRecognitionSetup = true
    voiceRecognitionHandler.setupVoiceRecognition()
  }
  
  func startVoiceRecognition() {
    voiceRecognitionHandler.startVoiceRecognition()
  }
  
  func stopVoiceRecognition() {
    voiceRecognitionHandler.stopVoiceRecognition()
  }
  
  func playTTSSequence(contents: [TTSContent]) {
    ttsHandler.playTTSSequence(contents: contents)
  }
  
  func stopAllAudio() {
    ttsHandler.stop()
    soundEffectHandler.stop()
    audioStateManager.updateAudioState(.listeningVoice)
  }
  
  func setTargetChordFilter(_ chord: Chord) {
    chordRecognitionHandler.setTargetChord(chord)
  }
  
  func clearTargetChordFilter() {
    chordRecognitionHandler.clearTargetChord()
  }
  
  func playEffectSound(_ fileName: String, fileExtension: String = "mp3") {
    soundEffectHandler.playEffectSound(fileName, fileExtension: fileExtension)
  }
  
  // MARK: - Step Management
  func executeCurrentStep() {
    let steps = getCurrentLearningSteps()
    guard currentStepIndex < steps.count else { return }
    
    let step = steps[currentStepIndex]
    Logger.d("단계 실행: \(step.displayTitle)")
    
    playTTSSequence(contents: step.ttsContents)
    
    if !step.soundFiles.isEmpty {
      DispatchQueue.main.asyncAfter(deadline: .now() + calculateTTSDuration(step.ttsContents)) {
        self.playSoundFiles(step.soundFiles)
      }
    }
  }
  
  private func calculateTTSDuration(_ contents: [TTSContent]) -> TimeInterval {
    let totalCharacters = contents.reduce(0) { $0 + $1.text.count }
    let estimatedDuration = Double(totalCharacters) * 0.1
    let totalPauses = contents.reduce(0) { $0 + $1.pauseAfter }
    return estimatedDuration + totalPauses
  }
  
  private func playSoundFiles(_ soundFiles: [String]) {
    guard !soundFiles.isEmpty else { return }
    
    let fileName = soundFiles[0]
    let fileExtension = (fileName as NSString).pathExtension.isEmpty ? "mp3" : (fileName as NSString).pathExtension
    let baseName = (fileName as NSString).deletingPathExtension
    
    playEffectSound(baseName, fileExtension: fileExtension)
  }
  
  // MARK: - Cleanup
  override func dispose() {
    soundEffectHandler?.dispose()
    super.dispose()
  }
}

// MARK: - Delegate Implementations
extension BaseAudioLearningViewModel: AudioStateManagerDelegate {
  func audioStateDidChange(_ state: AudioState, lastTTS: String?) {
    updateStateWithAudio(state, lastTTS: lastTTS)
  }
  
  // MARK: - 음성 명령어 처리 메서드 추가
  private func processRecognizedText(_ text: String) {
    Logger.d("음성인식 결과: \(text)")
    
    // 음성 명령 확인
    let words = text.lowercased().components(separatedBy: " ")
    let commands = words.compactMap { VoiceCommand.commandMap[$0] }
    
    if let command = commands.first {
      Logger.d("음성 명령 인식됨: \(command)")
      handleVoiceCommand(command)
    }
  }
  
}

extension BaseAudioLearningViewModel: VoiceRecognitionDelegate {
  func didRecognizeText(_ text: String) {
    updateRecognizedVoiceText(text)  // 새로 추가
    processRecognizedText(text)
  }
  
  func didReceiveAudioBuffer(_ buffer: AVAudioPCMBuffer) {
    let currentState = audioStateManager.getCurrentState().0
    
    // 인식 모드에 따라 다른 핸들러 사용
    switch recognitionMode {
    case .note:
      pitchRecognitionHandler.processAudioBuffer(buffer, audioState: currentState)
    case .chord:
      chordRecognitionHandler.processAudioBuffer(buffer, audioState: currentState)
    }
    
  }
  
  
  
  func voiceRecognitionDidStart() {
    audioStateManager.updateAudioState(.listeningVoice)
  }
  
  func voiceRecognitionDidStop() {
    audioStateManager.updateAudioState(.idle)
  }
  
  /// 음성 명령 처리 - 수정된 버전 (음성인식 재시작 로직 제거)
  private func handleVoiceCommand(_ command: VoiceCommand) {
    Logger.d("음성 명령 처리: \(command)")
    
    
    switch command {
    case .play:
      if audioStateManager.getCurrentState().0 == .listeningVoice || audioStateManager.getCurrentState().0 == .idle {
        executeCurrentStep()
      }
      
    case .pause:
      stopAllAudio()
      
    case .next:
      playEffectSound("click1")
      onNextCommand()
      
    case .previous:
      playEffectSound("click1")
      onPreviousCommand()
      
    case .replay:
      replayLastContent()
      
    case .volumeUp:
      Logger.d("볼륨 업 명령")
      
    case .volumeDown:
      Logger.d("볼륨 다운 명령")
      
    case .seekForward:
      Logger.d("앞으로 이동 명령")
      
    case .seekBackward:
      Logger.d("뒤로 이동 명령")
    }
    
    updateRecognizedVoiceText("")

    // 명령 처리 후 초기화 (음성인식은 계속 유지)
//    DispatchQueue.main.asyncAfter(deadline: .now()) {
//      self.restartVoiceRecognitionAfterCommand()
//    }
  }
  
//  /// 명령어 처리 후 음성인식 재시작
//  private func restartVoiceRecognitionAfterCommand() {
//    Logger.d("음성인식 재시작 시작")
//    
//    // 음성인식 중지
//    voiceRecognitionHandler.stopVoiceRecognition()
//    
//    // 인식된 텍스트 초기화
//    updateRecognizedVoiceText("")
//    
//    // 짧은 딜레이 후 음성인식 재시작
//    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//      self.voiceRecognitionHandler.startVoiceRecognition()
//      Logger.d("음성인식 재시작 완료")
//    }
//  }
  
  /// 마지막 콘텐츠 TTS 다시 재생
  private func replayLastContent() {
    let (_, lastTTS) = audioStateManager.getCurrentState()
    
    guard let lastTTSText = lastTTS else {
      Logger.d("재생할 마지막 콘텐츠가 없음")
      return
    }
    
    let replayContent = TTSContent(
      text: lastTTSText,
      type: .content,
      canRepeat: true
    )
    
    playTTSSequence(contents: [replayContent])
    Logger.d("마지막 콘텐츠 재생: \(lastTTSText)")
  }
  
}

extension BaseAudioLearningViewModel: TTSHandlerDelegate {
  func ttsDidStart(_ text: String) {
    // TTS 시작 시 음성인식 일시중단
    voiceRecognitionHandler.stopVoiceRecognition()
    audioStateManager.updateAudioState(.playingTTS)
  }
  
  func ttsDidStop() {
    audioStateManager.updateAudioState(.listeningVoice)
    // 음성인식 즉시 재시작
    voiceRecognitionHandler.startVoiceRecognition()
  }
  
  func ttsContentDidPlay(_ text: String) {
    audioStateManager.updateAudioState(.playingTTS, lastTTS: text)
  }
  
  func ttsSequenceDidStart() {
    // TTS 시퀀스 시작 시 음성인식 일시중단
    voiceRecognitionHandler.stopVoiceRecognition()
    audioStateManager.updateAudioState(.playingTTS)
  }
  
  func ttsSequenceDidComplete() {
    // TTS 시퀀스 완료 후 음성인식 즉시 재시작
    audioStateManager.updateAudioState(.listeningVoice)
    voiceRecognitionHandler.startVoiceRecognition()
    Logger.d("TTS 완료 - 음성인식 즉시 재시작")
  }
}

// MARK: - PitchRecognitionDelegate Implementation
extension BaseAudioLearningViewModel: PitchRecognitionDelegate {
  func didRecognizeNote(_ note: String, frequency: Double) {
    updateRecognizedNote(note, frequency: frequency)
  }
  
  func didValidateNote(_ recognized: String, expected: Note, isCorrect: Bool) {
    // 노트 검증 결과 처리
    Logger.d("노트 검증: \(recognized) vs \(expected) = \(isCorrect)")
  }
}


extension BaseAudioLearningViewModel: ChordRecognitionDelegate {
  func didRecognizeChord(_ chord: String, confidence: Float) {
    updateRecognizedChord(chord)
  }
  
  func didValidateChord(_ recognized: String, expected: String, isCorrect: Bool) {
    // 코드 검증 결과 처리
  }
}

extension BaseAudioLearningViewModel: SoundEffectDelegate {
  func soundEffectWillStart() {
    audioStateManager.updateAudioState(.playingSound)
  }
  
  func soundEffectDidComplete() {
    audioStateManager.updateAudioState(.listeningVoice)
  }
  
  func soundEffectDidStop() {
    audioStateManager.updateAudioState(.listeningVoice)
  }
}
