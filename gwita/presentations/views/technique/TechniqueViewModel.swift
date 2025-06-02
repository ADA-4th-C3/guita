//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.
import SwiftUI

final class TechniqueViewModel: BaseViewModel<TechniqueViewState> {
  private let textToSpeechManager = TextToSpeechManager.shared
  private let voiceCommandManager = VoiceCommandManager.shared
  private var playTask: Task<Void, Error>? = nil

  init() {
    let steps: [TechniqueStep] = [
      TechniqueStep(
        step: 1,
        totalSteps: 4,
        description: "기타 주법과 스트로크에 대한 소개",
        imageName: "",
        subSteps: [TechniqueSubStep(ttsText: "주법은 기타를 치는 방법을 말합니다. 피크나 손가락으로 줄을 위아래로 튕기는 주법인 스트로크를 배워봅시다.", audioFile: nil)],
        featureDescription: "다음 학습으로 넘어가시려면 \"다음\"을, 다시 들으시려면 \"다시\"를 말씀해 주세요."
      ),
      TechniqueStep(
        step: 2,
        totalSteps: 4,
        description: "기타의 사운드 홀과 주법의 업과 다운에 대한 설명",
        imageName: "",
        subSteps: [TechniqueSubStep(ttsText: "기타 몸통에 있는 구멍을 찾아보세요. 이 구멍을 사운드 홀이라고 부릅니다.위에서 아래로 줄을 쓸어내려 보세요.", audioFile: .strokeDown),
                   TechniqueSubStep(ttsText: "이것을 다운이라고 해요. 이제 반대로 아래에서 위로 쓸어올려 볼게요.", audioFile: .strokeUp),
                   TechniqueSubStep(ttsText: "이것을 업이라고 해요. 자유롭게 업 다운 스트로크를 연주해보세요.", audioFile: nil)],
        featureDescription: "이전 학습으로 넘어가시려면 \"이전\", 다음 학습으로 넘어가시려면 \"다음\"을, 다시 들으시려면 \"다시\"를 말씀해 주세요."
      ),

      TechniqueStep(
        step: 3,
        totalSteps: 4,
        description: "칼립소 주법에 대한 설명",
        imageName: "audio-file",
        subSteps: [TechniqueSubStep(ttsText: "가장 많이 사용하는 칼립소 주법을 알려줄게요. 칼립소 주법은 ", audioFile: .strokeCalypso),
                   TechniqueSubStep(ttsText: "순서대로 진행됩니다. 기타를 연주하면", audioFile: .strokeCalypso),
                   TechniqueSubStep(ttsText: "이렇게 들립니다. 반복해서 칼립소 주법을 연주해 보세요.", audioFile: nil)],
        featureDescription: "이전 학습으로 넘어가시려면 \"이전\", 다음 학습으로 넘어가시려면 \"다음\"을, 다시 들으시려면 \"다시\"를 말씀해 주세요."
      ),
      TechniqueStep(
        step: 4,
        totalSteps: 4,
        description: "주법 학습이 완료되었습니다.",
        imageName: "",
        subSteps: [TechniqueSubStep(ttsText: "주법 학습이 완료되었습니다. ", audioFile: nil)],
        featureDescription: "이전 학습으로 넘어가시려면 \"이전\", 다시 들으시려면 \"다시\"를 말씀해 주세요."
      ),
    ]
    super.init(state: TechniqueViewState(currentStepIndex: 0, steps: steps))
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

        await textToSpeechManager.speak("총 \(totalSteps) 단게 중 \(stepNumber) 단계")

        for subStep in currentStep.subSteps {
          try Task.checkCancellation()
          if let ttsText = subStep.ttsText {
            await textToSpeechManager.speak(ttsText)
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

    Task {
      await AudioPlayerManager.shared.start(audioFile: .nextPage)
        }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      let newIndex = self.state.currentStepIndex + 1
      self.emit(self.state.copy(currentStepIndex: newIndex))
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
    play()
  }

  func currentImage() -> Image? {
    guard let imageName = state.currentStep.imageName, !imageName.isEmpty
    else {
      return nil
    }
    return Image(imageName)
  }
}
