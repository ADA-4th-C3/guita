//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.
import SwiftUI

final class TechniqueLessonViewModel: BaseViewModel<TechniqueLessonViewState> {
  private let textToSpeechManager = TextToSpeechManager.shared
  private let voiceCommandManager = VoiceCommandManager.shared
  private var playTask: Task<Void, Error>? = nil

  init() {
    let steps: [TechniqueLessonStep] = [
      TechniqueLessonStep(
        step: 1,
        totalSteps: 7,
        description: NSLocalizedString("기타 주법과 스트로크에 대한 소개", comment: ""),
        imageName: "",
        subSteps: [TechniqueLessonSubStep(ttsText: NSLocalizedString("주법은 기타를 치는 방법을 말합니다. 피크나 손가락으로 줄을 위아래로 튕기는 주법인 스트로크를 배워봅시다.", comment: ""), audioFile: nil, delayAfter: nil, speechRate: nil)],
        featureDescription: NSLocalizedString("다음 학습으로 넘어가시려면 \"다음\"을, 다시 들으시려면 \"다시\"를 말씀해 주세요.", comment: "")
      ),
      TechniqueLessonStep(
        step: 2,
        totalSteps: 7,
        description: NSLocalizedString("기타의 사운드 홀에 대한 설명", comment: ""),
        imageName: "",
        subSteps: [TechniqueLessonSubStep(ttsText: NSLocalizedString("기타 몸통에 있는 구멍을 찾아보세요. 이 구멍을 사운드 홀이라고 부릅니다.", comment: ""), audioFile: nil, delayAfter: nil, speechRate: nil)],
        featureDescription: NSLocalizedString("이전 학습으로 넘어가시려면 \"이전\", 다음 학습으로 넘어가시려면 \"다음\"을, 다시 들으시려면 \"다시\"를 말씀해 주세요.", comment: "")
      ),
      TechniqueLessonStep(
        step: 3,
        totalSteps: 7,
        description: NSLocalizedString("주법의 업에 대한 설명", comment: ""),
        imageName: "",
        subSteps: [TechniqueLessonSubStep(ttsText: "사운드 홀에 오른쪽 손을 두고, 아래에서 위로 줄을 쓸어내려 보세요.", audioFile: .stroke_up, delayAfter: nil, speechRate: nil),
                   TechniqueLessonSubStep(ttsText: "이것을 업 스트로크라고 해요. 자유롭게 업 스트로크를 연주해보세요.", audioFile: nil, delayAfter: nil, speechRate: nil)],
        featureDescription: "이전 학습으로 넘어가시려면 \"이전\", 다음 학습으로 넘어가시려면 \"다음\"을, 다시 들으시려면 \"다시\"를 말씀해 주세요."
      ),
      TechniqueLessonStep(
        step: 4,
        totalSteps: 7,
        description: NSLocalizedString("주법의 다운에 대한 설명", comment: ""),
        imageName: "",
        subSteps: [TechniqueLessonSubStep(ttsText: "사운드 홀에 오른쪽 손을 두고, 위에서 아래로 줄을 쓸어내려 보세요.", audioFile: .stroke_down, delayAfter: nil, speechRate: nil),
                   TechniqueLessonSubStep(ttsText: "이것을 다운 스트로크라고 해요. 자유롭게 다운 스트로크를 연주해보세요.", audioFile: nil, delayAfter: nil, speechRate: nil)],
        featureDescription: "이전 학습으로 넘어가시려면 \"이전\", 다음 학습으로 넘어가시려면 \"다음\"을, 다시 들으시려면 \"다시\"를 말씀해 주세요."
      ),

      TechniqueLessonStep(
        step: 5,
        totalSteps: 7,
        description: NSLocalizedString("칼립소 주법에 리듬에 대한 설명", comment: ""),
        imageName: "audio-file",
        subSteps: [TechniqueLessonSubStep(ttsText: NSLocalizedString("가장 많이 사용하는 칼립소 주법을 알려줄게요.", comment: ""), audioFile: nil, delayAfter: nil, speechRate: nil),
                   TechniqueLessonSubStep(
                     ttsText: "다운",
                     audioFile: nil,
                     delayAfter: TechniqueLessonViewModel.calcDelay(for: "다운", speechRate: 0.3),
                     speechRate: 0.3
                   ),

                   // 다운업 (두번째 박자 빠르게 붙임)
                   TechniqueLessonSubStep(
                     ttsText: "다운업",
                     audioFile: nil,
                     delayAfter: TechniqueLessonViewModel.calcDelay(for: "다운업", speechRate: 0.3),
                     speechRate: 0.3
                   ),

                   // 업 (세번째 박자 빠르게)
                   TechniqueLessonSubStep(
                     ttsText: "업",
                     audioFile: nil,
                     delayAfter: TechniqueLessonViewModel.calcDelay(for: "업", speechRate: 0.3),
                     speechRate: 0.3
                   ),

                   // 다운업 (네번째 박자 빠르게 붙임)
                   TechniqueLessonSubStep(
                     ttsText: "다운업",
                     audioFile: nil,
                     delayAfter: TechniqueLessonViewModel.calcDelay(for: "다운업", speechRate: 0.3),
                     speechRate: 0.3
                   ),
                   TechniqueLessonSubStep(ttsText: NSLocalizedString("따라서 말해보며 리듬을 익혀보세요.", comment: ""), audioFile: nil, delayAfter: nil, speechRate: nil)],
        featureDescription: NSLocalizedString("이전 학습으로 넘어가시려면 \"이전\", 다음 학습으로 넘어가시려면 \"다음\"을, 다시 들으시려면 \"다시\"를 말씀해 주세요.", comment: "")
      ),
      TechniqueLessonStep(
        step: 6,
        totalSteps: 7,
        description: NSLocalizedString("칼립소 주법에 대한 설명", comment: ""),
        imageName: "audio-file",
        subSteps: [TechniqueLessonSubStep(ttsText: NSLocalizedString("칼립소 주법을 기타로 연주하면 ", comment: ""), audioFile: .stroke_calipso, delayAfter: nil, speechRate: nil),
                   TechniqueLessonSubStep(ttsText: NSLocalizedString("이렇게 들립니다. 반복해서 칼립소 주법을 연주해 보세요.", comment: ""), audioFile: nil, delayAfter: nil, speechRate: nil)],
        featureDescription: NSLocalizedString("이전 학습으로 넘어가시려면 \"이전\", 다음 학습으로 넘어가시려면 \"다음\"을, 다시 들으시려면 \"다시\"를 말씀해 주세요.", comment: "")
      ),
      TechniqueLessonStep(
        step: 7,
        totalSteps: 7,
        description: NSLocalizedString("주법 학습이 완료되었습니다.", comment: ""),
        imageName: "",
        subSteps: [TechniqueLessonSubStep(ttsText: NSLocalizedString("주법 학습이 완료되었습니다. ", comment: ""), audioFile: nil, delayAfter: nil, speechRate: nil)],
        featureDescription: NSLocalizedString("이전 학습으로 넘어가시려면 \"이전\", 다시 들으시려면 \"다시\"를 말씀해 주세요.", comment: "")
      ),
    ]
    super.init(state: TechniqueLessonViewState(currentStepIndex: 0, steps: steps))
  }

  private func cancelPlayTask() {
    playTask?.cancel()
  }

  func startVoiceCommand() {
    voiceCommandManager.start(
      commands: [
        VoiceCommand(keyword: .play, handler: { self.play() }),
        VoiceCommand(keyword: .retry, handler: { self.play(isRetry: true) }),
        VoiceCommand(keyword: .next, handler: nextStep),
        VoiceCommand(keyword: .previous, handler: previousStep),
        VoiceCommand(keyword: .stop, handler: dispose),
      ]
    )
  }

  func stopVoiceCommand() {
    voiceCommandManager.stop()
    textToSpeechManager.stop()
  }

  func play(isRetry: Bool = false) {
    cancelPlayTask()
    playTask = Task {
      do {
        try await Task.sleep(nanoseconds: 100_000_000)

        let currentStep = state.steps[state.currentStepIndex]
        let stepNumber = currentStep.step
        let totalSteps = currentStep.totalSteps

        await textToSpeechManager.speak("총 \(totalSteps) 단계 중 \(stepNumber) 단계")

//        for subStep in currentStep.subSteps {
//          try Task.checkCancellation()
//          if let ttsText = subStep.ttsText {
//            await textToSpeechManager.speak(ttsText)
//          }
//          try Task.checkCancellation()
//          if let audioFile = subStep.audioFile {
//            await AudioPlayerManager.shared.start(audioFile: audioFile)
//          }
//        }
        for subStep in currentStep.subSteps {
          try Task.checkCancellation()
          if let ttsText = subStep.ttsText {
            if let rate = subStep.speechRate {
              await textToSpeechManager.speak(ttsText, rate: rate)
            } else {
              await textToSpeechManager.speak(ttsText)
            }
            if let delay = subStep.delayAfter {
              try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
          }
          try Task.checkCancellation()
          if let audioFile = subStep.audioFile {
            await AudioPlayerManager.shared.start(audioFile: audioFile)
          }
        }
        if !isRetry {
          await textToSpeechManager.speak(currentStep.featureDescription)
        }
      } catch {
        textToSpeechManager.stop()
        AudioPlayerManager.shared.stop()
      }
    }
  }

  override func dispose() {
    cancelPlayTask()
    stopVoiceCommand()
    textToSpeechManager.stop()
  }

  func nextStep() {
    cancelPlayTask()
    guard state.currentStepIndex < state.steps.count - 1 else { return }

    let newIndex = state.currentStepIndex + 1
    emit(state.copy(currentStepIndex: newIndex))
    playStepChangeSound {
      self.play()
    }
  }

  func previousStep() {
    cancelPlayTask()
    guard state.currentStepIndex > 0 else { return }
    let newIndex = state.currentStepIndex - 1
    emit(state.copy(
      currentStepIndex: newIndex
    ))
    playStepChangeSound {
      self.play()
    }
  }

  private func playStepChangeSound(completion: (() -> Void)? = nil) {
    Task {
      await AudioPlayerManager.shared.start(audioFile: .next)
      try? await Task.sleep(nanoseconds: 200_000_000)
      completion?()
    }
  }

  func currentImage() -> Image? {
    guard let imageName = state.currentStep.imageName, !imageName.isEmpty
    else {
      return nil
    }
    return Image(imageName)
  }

  private static func calcDelay(for text: String, speechRate: Float, targetBeat: TimeInterval = 0.6) -> TimeInterval {
    let baseDuration = Double(text.count) * 0.065 / Double(speechRate)
    let delay = max(0.0, targetBeat - baseDuration)
    return delay
  }
}
